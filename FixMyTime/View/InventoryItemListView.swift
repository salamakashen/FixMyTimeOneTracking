import SwiftUI
import Foundation
import Combine

extension Color {
    static let accentBlue = Color(red: 0.1, green: 0.45, blue: 0.8)
    static let backgroundGray = Color(.systemGroupedBackground)
    static let cardBackground = Color(.systemBackground)
    static let fieldBackground = Color(.tertiarySystemFill)
    static let warningRed = Color(.systemRed)
    static let successGreen = Color(.systemGreen)
    static let brownColor = Color(red: 0.65, green: 0.16, blue: 0.16)
    static let purpleColor = Color(red: 0.5, green: 0.0, blue: 0.5)
    static let orangeColor = Color(red: 1.0, green: 0.6, blue: 0.0)
}

extension Font {
    static let cardTitle = Font.system(.headline, design: .rounded)
    static let cardSubtitle = Font.system(.subheadline, design: .default)
    static let detailLabel = Font.system(.caption, design: .monospaced)
    static let detailValue = Font.system(.body, design: .default)
}

@available(iOS 14.0, *)
struct InventoryItemAddFieldView: View {
    let title: String
    let iconName: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isRequired: Bool = false

    @State private var isFocused: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(isFocused || !text.isEmpty ? .accentBlue : .gray)
                    .font(isFocused || !text.isEmpty ? .caption : .body)
                    .offset(y: -24 )
                    .scaleEffect(0.9, anchor: .leading)
                    .padding(.horizontal, 8)
                    .padding(.top,10)

                HStack {
                    Image(systemName: iconName)
                        .foregroundColor(.gray)
                        .frame(width: 20)
                    
                    TextField("", text: $text, onEditingChanged: { focused in
                        withAnimation(.spring()) {
                            isFocused = focused
                        }
                    })
                    .keyboardType(keyboardType)
                    .foregroundColor(.primary)
                }
                .padding(.top, 16)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.fieldBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? Color.accentBlue : Color.clear, lineWidth: 2)
            )

            if isRequired && text.isEmpty && !isFocused {
                Text("Required")
                    .foregroundColor(.warningRed)
                    .font(.caption)
                    .padding(.leading, 8)
            }
        }
    }
}

@available(iOS 14.0, *)
struct InventoryItemAddPickerView: View {
    let title: String
    let iconName: String
    @Binding var selection: String
    let options: [String]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                    .frame(width: 20)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Picker(title, selection: $selection) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.accentBlue)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.fieldBackground)
            .cornerRadius(12)
        }
    }
}

@available(iOS 14.0, *)
struct InventoryItemAddDatePickerView: View {
    let title: String
    let iconName: String
    @Binding var date: Date
    var isOptional: Bool = false
    @State private var dateIsSet: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                    .frame(width: 20)

                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()

                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
                    .accentColor(.accentBlue)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.fieldBackground)
            .cornerRadius(12)
        }
    }
}

@available(iOS 14.0, *)
struct InventoryItemAddToggleView: View {
    let title: String
    let iconName: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .accentColor(.accentBlue)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.fieldBackground)
        .cornerRadius(12)
    }
}

@available(iOS 14.0, *)
struct InventoryItemAddSectionHeaderView: View {
    let title: String
    let iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.accentBlue)
            Text(title)
                .font(.cardTitle)
                .foregroundColor(.accentBlue)
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.leading, 4)
    }
}

@available(iOS 14.0, *)
struct InventoryItemAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: WatchRepairDataManager

    @State private var partName: String = ""
    @State private var partNumber: String = ""
    @State private var category: String = "Seals"
    @State private var brand: String = ""
    @State private var quantityInStock: String = ""
    @State private var reorderLevel: String = ""
    @State private var costPrice: String = ""
    @State private var sellingPrice: String = ""
    @State private var supplierName: String = ""
    @State private var supplierContact: String = ""
    @State private var storageLocation: String = ""
    @State private var lastRestocked: Date = Date()
    @State private var expiryDate: Date? = nil
    @State private var condition: String = "New"
    @State private var compatibleModelsString: String = ""
    @State private var usageCount: String = ""
    @State private var notes: String = ""
    @State private var warrantyPeriodMonths: String = ""
    @State private var partOriginCountry: String = ""
    @State private var importDate: Date = Date()
    @State private var barcode: String = ""
    @State private var weightGrams: String = ""
    @State private var dimensions: String = ""
    @State private var color: String = ""
    @State private var tagsString: String = ""
    @State private var active: Bool = true

    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let categories = ["Seals", "Movement", "Straps", "Batteries", "Tools", "Other"]
    private let conditions = ["New", "Used", "Refurbished"]


    private func validateAndSave() {
        var errors: [String] = []

        if partName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Part Name is required.") }
        if partNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Part Number is required.") }
        if brand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Brand is required.") }
        if supplierName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Supplier Name is required.") }
        if storageLocation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Storage Location is required.") }
        if partOriginCountry.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Origin Country is required.") }
        if barcode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Barcode is required.") }
        if dimensions.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Dimensions are required.") }
        if color.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Color is required.") }

        if Int(quantityInStock) == nil { errors.append("Quantity In Stock must be a valid number.") }
        if Int(reorderLevel) == nil { errors.append("Reorder Level must be a valid number.") }
        if Double(costPrice) == nil { errors.append("Cost Price must be a valid number.") }
        if Double(sellingPrice) == nil { errors.append("Selling Price must be a valid number.") }
        if Int(usageCount) == nil { errors.append("Usage Count must be a valid number.") }
        if Int(warrantyPeriodMonths) == nil { errors.append("Warranty Period must be a valid number.") }
        if Double(weightGrams) == nil { errors.append("Weight (Grams) must be a valid number.") }

        if errors.isEmpty {
            let newItem = InventoryItem(
                id: UUID(),
                partName: partName,
                partNumber: partNumber,
                category: category,
                brand: brand,
                quantityInStock: Int(quantityInStock) ?? 0,
                reorderLevel: Int(reorderLevel) ?? 0,
                costPrice: Double(costPrice) ?? 0.0,
                sellingPrice: Double(sellingPrice) ?? 0.0,
                supplierName: supplierName,
                supplierContact: supplierContact,
                storageLocation: storageLocation,
                lastRestocked: lastRestocked,
                expiryDate: expiryDate,
                condition: condition,
                compatibleModels: compatibleModelsString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
                usageCount: Int(usageCount) ?? 0,
                notes: notes,
                warrantyPeriodMonths: Int(warrantyPeriodMonths) ?? 0,
                partOriginCountry: partOriginCountry,
                importDate: importDate,
                barcode: barcode,
                weightGrams: Double(weightGrams) ?? 0.0,
                dimensions: dimensions,
                color: color,
                tags: tagsString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
                active: active,
                lastUpdated: Date(),
                createdBy: "User"
            )

            dataManager.addInventoryItem(newItem)
            alertMessage = "✅ Success!\nInventory Item '\(newItem.partName)' added."
        } else {
            alertMessage = "❌ Errors:\n" + errors.joined(separator: "\n")
        }

        showAlert = true
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 15) {
                        InventoryItemAddSectionHeaderView(title: "Essential Details", iconName: "tag.fill")
                        
                        InventoryItemAddFieldView(title: "Part Name", iconName: "pencil.and.outline", text: $partName, isRequired: true)
                        InventoryItemAddFieldView(title: "Part Number", iconName: "number.square.fill", text: $partNumber, isRequired: true)
                        InventoryItemAddFieldView(title: "Brand", iconName: "app.badge.fill", text: $brand, isRequired: true)
                        InventoryItemAddPickerView(title: "Category", iconName: "folder.fill", selection: $category, options: categories)
                        InventoryItemAddFieldView(title: "Color", iconName: "paintpalette.fill", text: $color, isRequired: true)
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        InventoryItemAddSectionHeaderView(title: "Stock & Cost", iconName: "dollarsign.circle.fill")
                        
                        HStack {
                            InventoryItemAddFieldView(title: "Quantity In Stock", iconName: "chart.bar.fill", text: $quantityInStock, keyboardType: .numberPad, isRequired: true)
                            InventoryItemAddFieldView(title: "Reorder Level", iconName: "arrow.up.arrow.down", text: $reorderLevel, keyboardType: .numberPad, isRequired: true)
                        }
                        
                        HStack {
                            InventoryItemAddFieldView(title: "Cost Price", iconName: "banknote.fill", text: $costPrice, keyboardType: .decimalPad, isRequired: true)
                            InventoryItemAddFieldView(title: "Selling Price", iconName: "cart.fill", text: $sellingPrice, keyboardType: .decimalPad, isRequired: true)
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)

                    VStack(alignment: .leading, spacing: 15) {
                        InventoryItemAddSectionHeaderView(title: "Supplier & Location", iconName: "location.fill")
                        
                        InventoryItemAddFieldView(title: "Supplier Name", iconName: "person.3.fill", text: $supplierName, isRequired: true)
                        InventoryItemAddFieldView(title: "Supplier Contact", iconName: "phone.fill", text: $supplierContact, keyboardType: .phonePad)
                        InventoryItemAddFieldView(title: "Storage Location", iconName: "warehouse.fill", text: $storageLocation, isRequired: true)
                        
                        InventoryItemAddDatePickerView(title: "Last Restocked", iconName: "calendar.badge.plus", date: $lastRestocked)
                        InventoryItemAddDatePickerView(title: "Import Date", iconName: "flag.fill", date: $importDate)
                        
                        HStack {
                            InventoryItemAddFieldView(title: "Origin Country", iconName: "globe", text: $partOriginCountry, isRequired: true)
                            InventoryItemAddFieldView(title: "Barcode", iconName: "barcode", text: $barcode, isRequired: true)
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)

                    VStack(alignment: .leading, spacing: 15) {
                        InventoryItemAddSectionHeaderView(title: "Physical & Technical", iconName: "wrench.and.screwdriver.fill")
                        
                        InventoryItemAddPickerView(title: "Condition", iconName: "checkmark.seal.fill", selection: $condition, options: conditions)

                        InventoryItemAddFieldView(title: "Compatible Models (comma-separated)", iconName: "list.bullet.rectangle.fill", text: $compatibleModelsString)
                        
                        HStack {
                            InventoryItemAddFieldView(title: "Weight (g)", iconName: "scalemass.fill", text: $weightGrams, keyboardType: .decimalPad, isRequired: true)
                            InventoryItemAddFieldView(title: "Dimensions", iconName: "ruler.fill", text: $dimensions, isRequired: true)
                        }
                        
                        HStack {
                            InventoryItemAddFieldView(title: "Usage Count", iconName: "arrow.counterclockwise", text: $usageCount, keyboardType: .numberPad, isRequired: true)
                            InventoryItemAddFieldView(title: "Warranty Period", iconName: "clock.fill", text: $warrantyPeriodMonths, keyboardType: .numberPad, isRequired: true)
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)

                    VStack(alignment: .leading, spacing: 15) {
                        InventoryItemAddSectionHeaderView(title: "Notes & Status", iconName: "info.circle.fill")
                        
                        InventoryItemAddFieldView(title: "Notes", iconName: "note.text", text: $notes)
                        InventoryItemAddFieldView(title: "Tags (comma-separated)", iconName: "tag", text: $tagsString)
                        
                        InventoryItemAddToggleView(title: "Item is Active", iconName: "power", isOn: $active)
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)

                    Button(action: validateAndSave) {
                        Text("Add Inventory Item")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentBlue)
                            .cornerRadius(15)
                    }
                    .padding()
                }
                .padding(.horizontal)
            }
            .background(Color.backgroundGray.edgesIgnoringSafeArea(.all))
            .navigationTitle("New Inventory Part")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertMessage.contains("✅") ? "Submission Status" : "Validation Errors"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"), action: {
                        if alertMessage.contains("✅") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    })
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

@available(iOS 14.0, *)
struct InventoryItemListRowView: View {
    let item: InventoryItem

    private func formatCost(_ cost: Double) -> String {
        return String(format: "%.0f PKR", cost)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(item.partName)
                        .font(.cardTitle)
                        .foregroundColor(.accentBlue)
                    Text("\(item.partNumber) | \(item.brand)")
                        .font(.cardSubtitle)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(item.active ? "Active" : "Inactive")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(item.active ? Color.successGreen.opacity(0.15) : Color.warningRed.opacity(0.15))
                    .foregroundColor(item.active ? .successGreen : .warningRed)
                    .cornerRadius(6)
            }
            
            Divider().padding(.vertical, 2)
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    InventoryItemTagView(title: "Stock", value: "\(item.quantityInStock) in stock", icon: "cube.box.fill", color: .successGreen)
                    InventoryItemTagView(title: "Location", value: item.storageLocation, icon: "mappin.and.ellipse", color: .orangeColor)
                    InventoryItemTagView(title: "Category", value: item.category, icon: "folder.fill", color: .purpleColor)
                    InventoryItemTagView(title: "Condition", value: item.condition, icon: "checkmark.seal.fill", color: .brownColor)
                    InventoryItemTagView(title: "Origin", value: item.partOriginCountry, icon: "globe", color: .accentBlue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 5) {
                    InventoryItemTagView(title: "Sell", value: formatCost(item.sellingPrice), icon: "cart.fill", color: .accentBlue)
                    InventoryItemTagView(title: "Cost", value: formatCost(item.costPrice), icon: "banknote.fill", color: .gray)
                    InventoryItemTagView(title: "Reorder", value: "Level \(item.reorderLevel)", icon: "arrow.up.arrow.down", color: .warningRed)
                    InventoryItemTagView(title: "Warranty", value: "\(item.warrantyPeriodMonths)m", icon: "clock.fill", color: .successGreen)
                    InventoryItemTagView(title: "Usage", value: "\(item.usageCount) used", icon: "arrow.counterclockwise", color: .purpleColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack(spacing: 15) {
                Text("Supplier: **\(item.supplierName)**")
                    .font(.caption)
                Text("Dimensions: **\(item.dimensions)**")
                    .font(.caption)
                Text("Color: **\(item.color)**")
                    .font(.caption)
            }
            .padding(.top, 5)
            .lineLimit(1)
            .minimumScaleFactor(0.8)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(item.tags.prefix(3), id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 10, weight: .semibold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.accentBlue.opacity(0.1))
                            .foregroundColor(.accentBlue)
                            .cornerRadius(4)
                    }
                }
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

@available(iOS 14.0, *)
struct InventoryItemTagView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(color)
            Text("\(title):")
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}

@available(iOS 14.0, *)
struct InventoryItemSearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search parts or brands...", text: $searchText)
                .padding(.vertical, 8)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 10)
        .background(Color.fieldBackground)
        .cornerRadius(10)
        .padding(.horizontal)
        .transition(.slide)
    }
}

@available(iOS 14.0, *)
struct InventoryItemNoDataView: View {
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "archivebox.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray.opacity(0.5))
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(50)
        .background(Color.cardBackground)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10)
        .padding()
    }
}

@available(iOS 14.0, *)
struct InventoryItemListView: View {
    @EnvironmentObject var dataManager: WatchRepairDataManager
    @State private var searchText: String = ""
    @State private var isShowingAddView: Bool = false

    var filteredItems: [InventoryItem] {
        if searchText.isEmpty {
            return dataManager.inventoryItems
        } else {
            return dataManager.inventoryItems.filter { item in
                item.partName.localizedCaseInsensitiveContains(searchText) ||
                item.brand.localizedCaseInsensitiveContains(searchText) ||
                item.partNumber.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    private func deleteItem(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { filteredItems[$0] }
        for item in itemsToDelete {
            dataManager.deleteInventoryItem(item)
        }
    }
    
    var body: some View {
            VStack {
                InventoryItemSearchBarView(searchText: $searchText)
                    .padding(.top, 8)
                
                if filteredItems.isEmpty && searchText.isEmpty {
                    Spacer()
                    InventoryItemNoDataView(
                        title: "No Inventory Found 📦",
                        message: "It looks like your parts inventory is empty. Tap the '+' button to add your first item."
                    )
                    Spacer()
                } else if filteredItems.isEmpty {
                    Spacer()
                    InventoryItemNoDataView(
                        title: "No Results for \"\(searchText)\"",
                        message: "Try searching for a different part name, brand, or number."
                    )
                    Spacer()
                } else {
                    List {
                        ForEach(filteredItems) { item in
                            NavigationLink(destination: InventoryItemDetailView(item: item)) {
                                InventoryItemListRowView(item: item)
                                    .padding(.vertical, 4)
                            }
                        }
                        .onDelete(perform: deleteItem)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarItems(trailing:
                Button(action: {
                    isShowingAddView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.accentBlue)
                }
            )
            .sheet(isPresented: $isShowingAddView) {
                InventoryItemAddView()
                    .environmentObject(dataManager)
            }

    }
}

@available(iOS 14.0, *)
struct InventoryItemDetailFieldRow: View {
    let label: String
    let value: String
    let iconName: String?
    let valueColor: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let icon = iconName {
                Image(systemName: icon)
                    .font(.callout)
                    .foregroundColor(.accentBlue)
                    .frame(width: 20)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.detailLabel)
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.detailValue)
                    .fontWeight(.medium)
                    .foregroundColor(valueColor)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct InventoryItemDetailBlockView<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.accentBlue)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.accentBlue)
            }
            .padding(.bottom, 5)
            
            content
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.accentBlue.opacity(0.2), lineWidth: 1)
        )
    }
}

@available(iOS 14.0, *)
struct InventoryItemDetailView: View {
    let item: InventoryItem
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        return dateFormatter.string(from: date)
    }
    
    private func formatCost(_ cost: Double) -> String {
        return String(format: "%.2f PKR", cost)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                VStack(spacing: 5) {
                    Text(item.partName)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.accentBlue)
                    
                    Text(item.partNumber)
                        .font(.title3)
                        .foregroundColor(.gray)
                    
                    Text(item.active ? "Currently Active" : "Deactivated")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .background(item.active ? Color.successGreen.opacity(0.2) : Color.warningRed.opacity(0.2))
                        .foregroundColor(item.active ? .successGreen : .warningRed)
                        .cornerRadius(10)
                }
                .padding(.top)

                InventoryItemDetailBlockView(title: "Inventory & Pricing", icon: "dollarsign.square.fill") {
                    VStack(spacing: 15) {
                        HStack(alignment: .top) {
                            InventoryItemDetailFieldRow(label: "Quantity in Stock", value: "\(item.quantityInStock)", iconName: "cube.box.fill", valueColor: item.quantityInStock <= item.reorderLevel ? .warningRed : .successGreen)
                            Spacer()
                            InventoryItemDetailFieldRow(label: "Reorder Level", value: "\(item.reorderLevel)", iconName: "arrow.up.arrow.down.circle.fill", valueColor: .primary)
                        }
                        
                        HStack(alignment: .top) {
                            InventoryItemDetailFieldRow(label: "Cost Price", value: formatCost(item.costPrice), iconName: "banknote.fill", valueColor: .gray)
                            Spacer()
                            InventoryItemDetailFieldRow(label: "Selling Price", value: formatCost(item.sellingPrice), iconName: "cart.fill", valueColor: .accentBlue)
                        }
                    }
                }
                .padding(.horizontal)
                
                InventoryItemDetailBlockView(title: "Logistics & Supplier", icon: "truck.box.fill") {
                    VStack(spacing: 15) {
                        InventoryItemDetailFieldRow(label: "Supplier Name", value: item.supplierName, iconName: "person.3.fill", valueColor: .primary)
                        InventoryItemDetailFieldRow(label: "Supplier Contact", value: item.supplierContact, iconName: "phone.fill", valueColor: .primary)
                        InventoryItemDetailFieldRow(label: "Storage Location", value: item.storageLocation, iconName: "mappin.and.ellipse", valueColor: .primary)
                        
                        HStack(alignment: .top) {
                            InventoryItemDetailFieldRow(label: "Last Restocked", value: formatDate(item.lastRestocked), iconName: "calendar", valueColor: .primary)
                            Spacer()
                            InventoryItemDetailFieldRow(label: "Import Date", value: formatDate(item.importDate), iconName: "flag.fill", valueColor: .primary)
                        }
                        
                        InventoryItemDetailFieldRow(label: "Expiry Date", value: formatDate(item.expiryDate), iconName: "calendar.badge.xmark", valueColor: item.expiryDate == nil ? .gray : .warningRed)

                        
                    }
                }
                .padding(.horizontal)

                InventoryItemDetailBlockView(title: "Physical & Usage Specs", icon: "wrench.and.screwdriver.fill") {
                    VStack(spacing: 15) {
                        HStack(alignment: .top) {
                            InventoryItemDetailFieldRow(label: "Brand", value: item.brand, iconName: "app.badge.fill", valueColor: .primary)
                            Spacer()
                            InventoryItemDetailFieldRow(label: "Category", value: item.category, iconName: "folder.fill", valueColor: .primary)
                        }
                        
                        HStack(alignment: .top) {
                            InventoryItemDetailFieldRow(label: "Condition", value: item.condition, iconName: "checkmark.seal.fill", valueColor: .primary)
                            Spacer()
                            InventoryItemDetailFieldRow(label: "Part Origin Country", value: item.partOriginCountry, iconName: "globe", valueColor: .primary)
                        }

                        HStack(alignment: .top) {
                            InventoryItemDetailFieldRow(label: "Weight (g)", value: "\(item.weightGrams)", iconName: "scalemass.fill", valueColor: .primary)
                            Spacer()
                            InventoryItemDetailFieldRow(label: "Dimensions", value: item.dimensions, iconName: "ruler.fill", valueColor: .primary)
                        }
                        
                        InventoryItemDetailFieldRow(label: "Compatible Models", value: item.compatibleModels.joined(separator: ", "), iconName: "list.bullet.rectangle.fill", valueColor: .primary)
                        
                        HStack(alignment: .top) {
                            InventoryItemDetailFieldRow(label: "Usage Count", value: "\(item.usageCount)", iconName: "arrow.counterclockwise", valueColor: .primary)
                            Spacer()
                            InventoryItemDetailFieldRow(label: "Warranty (Months)", value: "\(item.warrantyPeriodMonths)", iconName: "clock.fill", valueColor: .primary)
                        }
                        
                        InventoryItemDetailFieldRow(label: "Color", value: item.color, iconName: "paintpalette.fill", valueColor: .primary)
                    }
                }
                .padding(.horizontal)

                InventoryItemDetailBlockView(title: "Notes & Metadata", icon: "note.text.fill") {
                    VStack(alignment: .leading, spacing: 15) {
                        InventoryItemDetailFieldRow(label: "Notes", value: item.notes.isEmpty ? "None" : item.notes, iconName: "doc.text.fill", valueColor: .primary)
                        
                        InventoryItemDetailFieldRow(label: "Barcode", value: item.barcode, iconName: "barcode.viewfinder", valueColor: .primary)

                        HStack(alignment: .top) {
                            InventoryItemDetailFieldRow(label: "Created By", value: item.createdBy, iconName: "person.circle.fill", valueColor: .primary)
                            Spacer()
                            InventoryItemDetailFieldRow(label: "Last Updated", value: formatDate(item.lastUpdated), iconName: "square.and.pencil", valueColor: .primary)
                        }
                        
                        Text("Tags:")
                            .font(.detailLabel)
                            .foregroundColor(.gray)
                        HStack(spacing: 8) {
                            ForEach(item.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.system(size: 11, weight: .bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.gray.opacity(0.1))
                                    .foregroundColor(.gray)
                                    .cornerRadius(6)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
            }
            .padding(.bottom, 30)
        }
        .background(Color.backgroundGray.edgesIgnoringSafeArea(.all))
        .navigationTitle("Part Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
