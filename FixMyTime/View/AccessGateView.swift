
import SwiftUI

@available(iOS 14.0, *)
struct AccessGateView: View {
    
    @StateObject private var gateManager = GatekeeperManager()
    @State private var validLink: URL?
    @State private var isBusy = true
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(.all)
            if validLink == nil && !isBusy {
                WatchRepairDashboard()
                    .ignoresSafeArea()
            }
            
            if let link = validLink {
                SecureWebPortalView(portalLink: link, activeLoad: $isBusy)
                    .edgesIgnoringSafeArea(.all)
                    .statusBar(hidden: true)
            }
            
            if isBusy {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.8)
                    )
            }
        }
        .onReceive(gateManager.$gateState) { state in
            switch state {
            case .authenticating:
                isBusy = true
            case .approved(_, let link):
                validLink = link
                isBusy = false
            case .fallbackDisplay:
                validLink = nil
                isBusy = false
            case .idle:
                break
            }
        }
        .onAppear {
            isBusy = true
            gateManager.startProcess()
        }
    }
}
