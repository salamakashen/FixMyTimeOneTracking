
import SwiftUI
import Combine

@available(iOS 14.0, *)
struct CustomerAddFieldView: View {
    @Binding var text: String
    var titleKey: String
    var systemImage: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            HStack {
                Image(systemName: systemImage)
                    .foregroundColor(.accentColor)
                
                if isSecure {
                    SecureField(titleKey, text: $text)
                        .keyboardType(keyboardType)
                        .modifier(CustomerPlaceholderModifier(text: $text, placeholder: titleKey))
                } else {
                    TextField(titleKey, text: $text)
                        .keyboardType(keyboardType)
                        .modifier(CustomerPlaceholderModifier(text: $text, placeholder: titleKey))
                }
            }
            .padding(.bottom, 5)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(text.isEmpty ? Color(.systemGray5) : .accentColor)
        }
    }
}

@available(iOS 14.0, *)
struct CustomerPlaceholderModifier: ViewModifier {
    @Binding var text: String
    var placeholder: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
            }
            content
        }
    }
}

@available(iOS 14.0, *)
struct CustomerAddSectionHeaderView: View {
    var title: String
    var icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.white)
                .padding(8)
                .background(Color.accentColor)
                .clipShape(Circle())
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

@available(iOS 14.0, *)
struct CustomerAddDatePickerView: View {
    @Binding var date: Date
    var title: String
    var systemImage: String
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomerAddSectionHeaderView(title: title, icon: systemImage)
                .padding(.top, -10)
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 40)
        }
    }
}

@available(iOS 14.0, *)
struct CustomerAddOptionalDatePickerView: View {
    @Binding var date: Date?
    @State private var isEnabled: Bool
    var title: String
    var systemImage: String
    
    init(date: Binding<Date?>, title: String, systemImage: String) {
        _date = date
        self.title = title
        self.systemImage = systemImage
        _isEnabled = State(initialValue: date.wrappedValue != nil)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Toggle(isOn: $isEnabled.animation()) {
                    CustomerAddSectionHeaderView(title: title, icon: systemImage)
                        .padding(.top, -10)
                }
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                Spacer()
            }
            
            if isEnabled {
                DatePicker("", selection: Binding(get: { date ?? Date() }, set: { date = $0 }), displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 40)
                    .onAppear {
                        if date == nil { date = Date() }
                    }
                    .onDisappear {
                        if !isEnabled { date = nil }
                    }
            } else {
                Color.clear.frame(height: 0).onAppear {
                    date = nil
                }
            }
        }
    }
}



@available(iOS 14.0, *)
struct CustomerSearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search customers by name, phone, or tags...", text: $searchText)
                .foregroundColor(.primary)
                .animation(.easeInOut(duration: 0.2), value: searchText)
            
            if !searchText.isEmpty {
                Button(action: { self.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                .transition(.opacity)
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct CustomerListRowView: View {
    var customer: Customer
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "PKR"
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(customer.fullName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentColor)
                    
                    HStack(spacing: 5) {
                        Image(systemName: "envelope.fill")
                            .font(.caption)
                        Text(customer.email)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                    Text(String(format: "%.1f", customer.averageRating))
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding(4)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(5)
                
                if customer.vipStatus {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                        .font(.title3)
                }
            }
            .padding([.top, .horizontal])
            
            Divider().padding(.horizontal)
            
            VStack(spacing: 8) {
                HStack {
                    CustomerMetricView(icon: "banknote.fill", title: "Spent", value: currencyFormatter.string(from: NSNumber(value: customer.totalSpent)) ?? "N/A", color: .green)
                    
                    Spacer()
                    
                    CustomerMetricView(icon: "wrench.and.screwdriver.fill", title: "Repairs", value: "\(customer.totalRepairs)", color: .blue)
                                        
                }
                
                Divider()
                HStack{
                    
                    CustomerMetricView(icon: "bolt.fill", title: "Points", value: "\(customer.loyaltyPoints)", color: .red)
                    
                    Spacer()
                    
                    CustomerMetricView(icon: "phone.fill", title: "Contact", value: customer.preferredContactMethod, color: Color(UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0))) // Teal
                    
                }
                Divider()
                
                HStack {
                    CustomerMetricView(icon: "calendar", title: "Joined", value: dateFormatter.string(from: customer.registrationDate), color: .purple)
                    
                    Spacer()
                    
                    CustomerMetricView(icon: "clock.fill", title: "Last Visit", value: customer.lastVisitDate.map { dateFormatter.string(from: $0) } ?? "Never", color: .gray)
                }
                
                Divider()
                
                VStack(spacing: 15) {
                    HStack(alignment: .top) {
                        CustomerDetailFieldRow(title: "Phone Number", value: customer.phoneNumber, icon: "phone.fill", isImportant: true)
                        CustomerDetailFieldRow(title: "Email", value: customer.email, icon: "envelope.fill")
                    }
                    
                    Divider()
                    
                    HStack(alignment: .top) {
                        CustomerDetailFieldRow(title: "Preferred Contact", value: customer.preferredContactMethod, icon: "hand.tap.fill")
                        CustomerDetailFieldRow(title: "Emergency Contact", value: customer.emergencyContact.isEmpty ? "N/A" : customer.emergencyContact, icon: "cross.case.fill")
                    }
                    Divider()
                    
                    HStack(alignment: .top) {
                        CustomerDetailFieldRow(title: "Newsletter", value: customer.subscribedToNewsletter ? "Subscribed" : "Unsubscribed", icon: customer.subscribedToNewsletter ? "newspaper.fill" : "newspaper")
                        CustomerDetailFieldRow(title: "Notifications", value: customer.notificationEnabled ? "Enabled" : "Disabled", icon: customer.notificationEnabled ? "bell.fill" : "bell.slash.fill")
                    }
                    
                    Divider()
                }
            }
            .padding([.horizontal, .bottom])
            
            HStack {
                Image(systemName: "tag.fill")
                    .foregroundColor(.secondary)
                
                Text(customer.tags.prefix(3).joined(separator: ", "))
                    .font(.caption)
                    .lineLimit(1)
                
                Spacer()
                
                CustomerMetricView(icon: "mappin.circle.fill", title: "City", value: customer.city, color: .orange)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .background(Color(.white))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 2)
    }
}

@available(iOS 14.0, *)
struct CustomerMetricView: View {
    var icon: String
    var title: String
    var value: String
    var color: Color
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
        }
    }
}

@available(iOS 14.0, *)
struct CustomerNoDataView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            Text("No Customers Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Try refining your search or add a new customer record to get started.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 50)
    }
}

@available(iOS 14.0, *)
struct CustomerListView: View {
    @EnvironmentObject var dataManager: WatchRepairDataManager
    @State private var searchText: String = ""
    @State private var showingAddCustomerView = false
    
    var filteredCustomers: [Customer] {
        if searchText.isEmpty {
            return dataManager.customers
        } else {
            return dataManager.customers.filter { customer in
                customer.fullName.localizedCaseInsensitiveContains(searchText) ||
                customer.phoneNumber.localizedCaseInsensitiveContains(searchText) ||
                customer.tags.joined(separator: " ").localizedCaseInsensitiveContains(searchText) ||
                customer.email.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack {
                CustomerSearchBarView(searchText: $searchText)
                    .padding(.top, 5)
                
                if filteredCustomers.isEmpty {
                    CustomerNoDataView()
                    Spacer()
                } else {
                    List {
                        ForEach(filteredCustomers) { customer in
                            NavigationLink(destination: CustomerDetailView(customer: customer)) {
                                CustomerListRowView(customer: customer)
                                    .listRowInsets(EdgeInsets())
                                    .padding(.vertical, 5)
                            }
                            
                        }.onDelete { indexSet in
                            for index in indexSet {
                                let customerToDelete = filteredCustomers[index]
                                dataManager.deleteCustomer(customerToDelete)
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarItems(trailing:
                Button(action: { showingAddCustomerView = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                }
            )
            .sheet(isPresented: $showingAddCustomerView) {
                CustomerAddView()
                    .environmentObject(dataManager)
            }
        
    }
}

@available(iOS 14.0, *)
struct CustomerDetailFieldRow: View {
    var title: String
    var value: String
    var icon: String
    var isImportant: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(isImportant ? .red : .accentColor)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            Text(value)
                .font(.body)
                .fontWeight(isImportant ? .bold : .regular)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct CustomerDetailBlockView<Content: View>: View {
    var title: String
    var icon: String
    var content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.accentColor)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 5)
            
            content
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

