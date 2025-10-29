
import SwiftUI

@available(iOS 14.0, *)
struct CustomerAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: WatchRepairDataManager
    
    @State private var fullName: String = ""
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var addressLine1: String = ""
    @State private var addressLine2: String = ""
    @State private var city: String = ""
    @State private var postalCode: String = ""
    @State private var country: String = ""
    @State private var registrationDate: Date = Date()
    @State private var preferredContactMethod: String = "Email"
    @State private var loyaltyPoints: String = "0"
    @State private var totalSpent: String = "0.0"
    @State private var totalRepairs: String = "0"
    @State private var averageRating: String = "5.0"
    @State private var remarks: String = ""
    @State private var lastVisitDate: Date? = nil
    @State private var vipStatus: Bool = false
    @State private var occupation: String = ""
    @State private var birthDate: Date? = nil
    @State private var gender: String = "Male"
    @State private var referredBy: String = ""
    @State private var emergencyContact: String = ""
    @State private var subscribedToNewsletter: Bool = true
    @State private var notificationEnabled: Bool = true
    @State private var createdBy: String = "User"
    @State private var tagsString: String = "New"
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let contactMethods = ["Phone", "Email", "SMS"]
    let genders = ["Male", "Female", "Other"]
    
    private func validateAndSave() {
        var errors: [String] = []
        
        if fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Full Name is required.") }
        if phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Phone Number is required.") }
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Email is required.") }
        if city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("City is required.") }
        if !Customer.isEmailValid(email) { errors.append("Email is invalid.") }
        
        if Double(totalSpent) == nil { errors.append("Total Spent must be a valid number.") }
        if Int(loyaltyPoints) == nil { errors.append("Loyalty Points must be a valid integer.") }
        if Int(totalRepairs) == nil { errors.append("Total Repairs must be a valid integer.") }
        if Double(averageRating) == nil || Double(averageRating)! < 0.0 || Double(averageRating)! > 5.0 { errors.append("Average Rating must be between 0.0 and 5.0.") }
        
        if errors.isEmpty {
            let newCustomer = Customer(
                id: UUID(),
                fullName: fullName,
                phoneNumber: phoneNumber,
                email: email,
                addressLine1: addressLine1,
                addressLine2: addressLine2,
                city: city,
                postalCode: postalCode,
                country: country,
                registrationDate: registrationDate,
                preferredContactMethod: preferredContactMethod,
                loyaltyPoints: Int(loyaltyPoints) ?? 0,
                totalSpent: Double(totalSpent) ?? 0.0,
                totalRepairs: Int(totalRepairs) ?? 0,
                averageRating: Double(averageRating) ?? 5.0,
                remarks: remarks,
                lastVisitDate: lastVisitDate,
                vipStatus: vipStatus,
                occupation: occupation,
                birthDate: birthDate,
                gender: gender,
                referredBy: referredBy,
                emergencyContact: emergencyContact,
                subscribedToNewsletter: subscribedToNewsletter,
                notificationEnabled: notificationEnabled,
                createdBy: createdBy,
                lastUpdated: Date(),
                tags: tagsString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            )
            
            dataManager.addCustomer(newCustomer)
            alertMessage = "Customer **\(fullName)** successfully added!"
            presentationMode.wrappedValue.dismiss()
        } else {
            alertMessage = "Please correct the following errors:\n\n" + errors.map { "• \($0)" }.joined(separator: "\n")
        }
        showingAlert = true
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 25) {
                    
                    VStack(alignment: .leading, spacing: 15) {
                        CustomerAddSectionHeaderView(title: "Contact Information", icon: "person.text.rectangle")
                        
                        CustomerAddFieldView(text: $fullName, titleKey: "Full Name *", systemImage: "person.fill")
                        CustomerAddFieldView(text: $phoneNumber, titleKey: "Phone Number *", systemImage: "phone.fill", keyboardType: .phonePad)
                        CustomerAddFieldView(text: $email, titleKey: "Email *", systemImage: "envelope.fill", keyboardType: .emailAddress)
                        CustomerAddFieldView(text: $emergencyContact, titleKey: "Emergency Contact", systemImage: "phone.bubble.left.fill", keyboardType: .phonePad)

                        Picker("Preferred Contact", selection: $preferredContactMethod) {
                            ForEach(contactMethods, id: \.self) { method in
                                Text(method)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 5)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        CustomerAddSectionHeaderView(title: "Address Details", icon: "map.fill")
                        
                        CustomerAddFieldView(text: $addressLine1, titleKey: "Address Line 1", systemImage: "house.fill")
                        CustomerAddFieldView(text: $addressLine2, titleKey: "Address Line 2 (Optional)", systemImage: "building.fill")
                        
                        HStack(spacing: 15) {
                            CustomerAddFieldView(text: $city, titleKey: "City *", systemImage: "mappin.circle.fill")
                            CustomerAddFieldView(text: $postalCode, titleKey: "Postal Code", systemImage: "envelope.badge.fill")
                        }
                        
                        CustomerAddFieldView(text: $country, titleKey: "Country", systemImage: "globe")
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        CustomerAddSectionHeaderView(title: "Metrics & History", icon: "chart.bar.fill")
                        
                        HStack {
                            CustomerAddFieldView(text: $totalSpent, titleKey: "Total Spent (PKR)", systemImage: "banknote.fill", keyboardType: .decimalPad)
                            CustomerAddFieldView(text: $loyaltyPoints, titleKey: "Loyalty Points", systemImage: "star.fill", keyboardType: .numberPad)
                        }
                        
                        HStack {
                            CustomerAddFieldView(text: $totalRepairs, titleKey: "Total Repairs", systemImage: "wrench.and.screwdriver.fill", keyboardType: .numberPad)
                            CustomerAddFieldView(text: $averageRating, titleKey: "Avg Rating (0-5)", systemImage: "hand.thumbsup.fill", keyboardType: .decimalPad)
                        }
                        
                        CustomerAddDatePickerView(date: $registrationDate, title: "Registration Date", systemImage: "calendar")
                        
                        CustomerAddOptionalDatePickerView(date: $lastVisitDate, title: "Last Visit Date", systemImage: "clock.fill")
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        CustomerAddSectionHeaderView(title: "Personal & Admin", icon: "gearshape.2.fill")
                        
                        HStack(spacing: 15) {
                            CustomerAddFieldView(text: $occupation, titleKey: "Occupation", systemImage: "briefcase.fill")
                            
                            Picker("Gender", selection: $gender) {
                                ForEach(genders, id: \.self) { g in
                                    Text(g)
                                }
                            }
                        }
                        
                        CustomerAddOptionalDatePickerView(date: $birthDate, title: "Birth Date", systemImage: "gift.fill")
                        
                        CustomerAddFieldView(text: $referredBy, titleKey: "Referred By", systemImage: "link")
                        
                        CustomerAddFieldView(text: $remarks, titleKey: "Remarks", systemImage: "note.text")
                        
                        CustomerAddFieldView(text: $tagsString, titleKey: "Tags (Comma Separated)", systemImage: "tag.fill")
                        
                        Toggle(isOn: $vipStatus) {
                            Text("VIP Status")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                        .padding(.leading, 5)
                        
                        Toggle(isOn: $subscribedToNewsletter) {
                            Text("Subscribed to Newsletter")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                        .padding(.leading, 5)
                        
                        Toggle(isOn: $notificationEnabled) {
                            Text("Notification Enabled")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                        .padding(.leading, 5)
                        
                        CustomerAddFieldView(text: $createdBy, titleKey: "Created By", systemImage: "hammer.fill")
                        
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    Button(action: validateAndSave) {
                        Text("Save New Customer")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)
                    
                }
                .padding()
            }
            .navigationTitle("New Customer Record")
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Customer Record Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

extension Customer {
    static func isEmailValid(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
