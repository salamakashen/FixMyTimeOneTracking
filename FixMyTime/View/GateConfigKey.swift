
import SwiftUI
import UIKit
import WebKit
import UniformTypeIdentifiers
import PhotosUI

enum GateConfigKey: String {
    case verifyCode, apiNode, authPass, storedURLRef, storedTokenRef
}

let GateSystemSettings: [GateConfigKey: Any] = [
    .verifyCode: "GJDFHDFHFDJGSDAGKGHK",
    .apiNode: "https://wallen-eatery.space/ios-st-13/server.php",
    .authPass: "Bs2675kDjkb5Ga",
    .storedURLRef: "storedTrustedURL",
    .storedTokenRef: "storedVerificationToken",
]

func getGateSetting<T>(_ key: GateConfigKey) -> T {
    return GateSystemSettings[key] as! T
}

enum SecureVaultError: Error {
    case keychainStatus(OSStatus)
    case noRecord
}

func storeInVault(key: String, value: String) throws {
    let data = Data(value.utf8)
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key
    ]
    let attributes: [String: Any] = [kSecValueData as String: data]
    
    let status = SecItemCopyMatching(query as CFDictionary, nil)
    if status == errSecSuccess {
        let updateStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard updateStatus == errSecSuccess else { throw SecureVaultError.keychainStatus(updateStatus) }
    } else if status == errSecItemNotFound {
        var newItem = query
        newItem[kSecValueData as String] = data
        let addStatus = SecItemAdd(newItem as CFDictionary, nil)
        guard addStatus == errSecSuccess else { throw SecureVaultError.keychainStatus(addStatus) }
    } else {
        throw SecureVaultError.keychainStatus(status)
    }
}

func fetchFromVault(key: String) throws -> String {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    if status == errSecSuccess {
        guard let data = result as? Data,
              let str = String(data: data, encoding: .utf8) else {
            throw SecureVaultError.keychainStatus(status)
        }
        return str
    } else if status == errSecItemNotFound {
        throw SecureVaultError.noRecord
    } else {
        throw SecureVaultError.keychainStatus(status)
    }
}

func systemDeviceDetails() -> String { "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)" }

func preferredLangCode() -> String {
    let code = Locale.preferredLanguages.first ?? "en"
    return code.components(separatedBy: "-").first?.lowercased() ?? "en"
}

func systemModelName() -> String {
    var sys = utsname()
    uname(&sys)
    let mirror = Mirror(reflecting: sys.machine)
    return mirror.children.reduce(into: "") { acc, element in
        if let value = element.value as? Int8, value != 0 {
            acc.append(Character(UnicodeScalar(UInt8(value))))
        }
    }
}

func currentRegionIdentifier() -> String? { Locale.current.regionCode }

func createAccessURL() -> URL? {
    var comps = URLComponents(string: getGateSetting(.apiNode) as String)
    comps?.queryItems = [
        URLQueryItem(name: "p", value: getGateSetting(.authPass) as String),
        URLQueryItem(name: "os", value: systemDeviceDetails()),
        URLQueryItem(name: "lng", value: preferredLangCode()),
        URLQueryItem(name: "devicemodel", value: systemModelName())
    ]
    if let country = currentRegionIdentifier() {
        comps?.queryItems?.append(URLQueryItem(name: "country", value: country))
    }
    return comps?.url
}

final class GatekeeperManager: ObservableObject {
    @MainActor @Published var gateState: Phase = .idle
    
    enum Phase {
        case idle, authenticating
        case approved(token: String, link: URL)
        case fallbackDisplay
    }
    
    func startProcess() {
        if let storedLink = UserDefaults.standard.string(forKey: getGateSetting(.storedURLRef)),
           let linkURL = URL(string: storedLink),
           let storedToken = try? fetchFromVault(key: getGateSetting(.storedTokenRef)),
           storedToken == (getGateSetting(.verifyCode) as String) {
            
            Task { @MainActor in
                gateState = .approved(token: storedToken, link: linkURL)
            }
            return
        }
        Task { await retrieveAccessData() }
    }
    
    private func retrieveAccessData() async {
        await MainActor.run { gateState = .authenticating }
        guard let url = createAccessURL() else {
            await MainActor.run { gateState = .fallbackDisplay }
            return
        }
        var attempt = 0
        while true {
            attempt += 1
            do {
                let content = try await downloadServerText(from: url)
                let parts = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "#")
                
                if parts.count == 2,
                   parts[0] == (getGateSetting(.verifyCode) as String),
                   let validURL = URL(string: parts[1]) {
                    
                    UserDefaults.standard.set(validURL.absoluteString, forKey: getGateSetting(.storedURLRef))
                    try? storeInVault(key: getGateSetting(.storedTokenRef), value: parts[0])
                    
                    await MainActor.run {
                        gateState = .approved(token: parts[0], link: validURL)
                    }
                    return
                } else {
                    await MainActor.run { gateState = .fallbackDisplay }
                    return
                }
            } catch {
                let delay = min(pow(2.0, Double(min(attempt, 6))), 30.0)
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
    }
    
    private func downloadServerText(from url: URL) async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(decoding: data, as: UTF8.self)
    }
}

@available(iOS 14.0, *)
final class SecureWebPortalVC: UIViewController, WKUIDelegate, WKNavigationDelegate, UIDocumentPickerDelegate, PHPickerViewControllerDelegate {
    
    var onWebLoad: ((Bool) -> Void)?
    private var portalView: WKWebView!
    private var initialLink: URL
    private var dimLayer: UIView?
    fileprivate var completionHandler: (([URL]?) -> Void)?
    
    init(initialLink: URL) {
        self.initialLink = initialLink
        super.init(nibName: nil, bundle: nil)
        configureWebView()
    }
    required init?(coder: NSCoder) { fatalError() }
    override var prefersStatusBarHidden: Bool { true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(portalView)
        portalView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            portalView.insetsLayoutMarginsFromSafeArea = false
            portalView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        NSLayoutConstraint.activate([
            portalView.topAnchor.constraint(equalTo: view.topAnchor),
            portalView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            portalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            portalView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        onWebLoad?(true)
        portalView.load(URLRequest(url: initialLink))
    }
    
    private func configureWebView() {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.websiteDataStore = .default()
        
        portalView = WKWebView(frame: .zero, configuration: config)
        portalView.uiDelegate = self
        portalView.navigationDelegate = self
        
        portalView.scrollView.bounces = false
        portalView.scrollView.minimumZoomScale = 1.0
        portalView.scrollView.maximumZoomScale = 1.0
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        onWebLoad?(false)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        onWebLoad?(false)
    }
}

@available(iOS 14.0, *)
extension SecureWebPortalVC {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        completionHandler?(urls)
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        completionHandler?(nil)
    }
    
    @available(iOS 18.4, *)
    func webView(_ webView: WKWebView,
                 runOpenPanelWith parameters: WKOpenPanelParameters,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping ([URL]?) -> Void) {
        self.completionHandler = completionHandler
        
        let alert = UIAlertController(title: "Choose File", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo/Video", style: .default) { _ in
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = 1
            config.filter = .any(of: [.images, .videos])
            
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            self.present(picker, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Files", style: .default) { _ in
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
            picker.delegate = self
            picker.allowsMultipleSelection = false
            self.present(picker, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionHandler(nil)
        })
        
        present(alert, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for provider in results.map({ $0.itemProvider }) {
            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                provider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, _ in
                    if let url = url {
                        DispatchQueue.main.async {
                            self.completionHandler?([url])
                        }
                    }
                }
            }
        }
    }
}

@available(iOS 14.0, *)
struct SecureWebPortalView: UIViewControllerRepresentable {
    let portalLink: URL
    @Binding var activeLoad: Bool
    
    func makeUIViewController(context: Context) -> SecureWebPortalVC {
        let vc = SecureWebPortalVC(initialLink: portalLink)
        vc.onWebLoad = { active in
            DispatchQueue.main.async {
                activeLoad = active
            }
        }
        return vc
    }
    
    func updateUIViewController(_ vc: SecureWebPortalVC, context: Context) {}
}
