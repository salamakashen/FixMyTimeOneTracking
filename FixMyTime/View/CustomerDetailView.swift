
import SwiftUI

@available(iOS 14.0, *)
struct CustomerDetailView: View {
    var customer: Customer
    
    private let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    private let fullCurrencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "PKR"
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                VStack {
                    HStack(alignment: .top) {
                        Image(systemName: customer.gender == "Male" ? "person.fill" : customer.gender == "Female" ? "person.fill.female" : "person.fill.questionmark")
                            .font(.system(size: 60))
                            .foregroundColor(customer.vipStatus ? .yellow : .accentColor)
                            .padding(.trailing, 10)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(customer.fullName)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                            
                            Text(customer.occupation.isEmpty ? "Customer" : customer.occupation)
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Text("VIP Status:")
                                    .font(.subheadline)
                                Text(customer.vipStatus ? "Active" : "Standard")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(customer.vipStatus ? .red : .green)
                            }
                        }
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        VStack {
                            Text(String(format: "%.1f", customer.averageRating))
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Rating")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)
                        
                        VStack {
                            Text("\(customer.totalRepairs)")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Repairs")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                        
                        VStack {
                            Text("\(customer.loyaltyPoints)")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Points")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                CustomerDetailBlockView(title: "Contact & Communication", icon: "phone.bubble.left.fill") {
                    VStack(spacing: 15) {
                        HStack(alignment: .top) {
                            CustomerDetailFieldRow(title: "Phone Number", value: customer.phoneNumber, icon: "phone.fill", isImportant: true)
                            CustomerDetailFieldRow(title: "Email", value: customer.email, icon: "envelope.fill")
                        }
                        
                        HStack(alignment: .top) {
                            CustomerDetailFieldRow(title: "Preferred Contact", value: customer.preferredContactMethod, icon: "hand.tap.fill")
                            CustomerDetailFieldRow(title: "Emergency Contact", value: customer.emergencyContact.isEmpty ? "N/A" : customer.emergencyContact, icon: "cross.case.fill")
                        }
                        
                        HStack(alignment: .top) {
                            CustomerDetailFieldRow(title: "Newsletter", value: customer.subscribedToNewsletter ? "Subscribed" : "Unsubscribed", icon: customer.subscribedToNewsletter ? "newspaper.fill" : "newspaper")
                            CustomerDetailFieldRow(title: "Notifications", value: customer.notificationEnabled ? "Enabled" : "Disabled", icon: customer.notificationEnabled ? "bell.fill" : "bell.slash.fill")
                        }
                    }
                }
                
                CustomerDetailBlockView(title: "Address Details", icon: "map.fill") {
                    VStack(spacing: 15) {
                        HStack(alignment: .top) {
                            CustomerDetailFieldRow(title: "Address Line 1", value: customer.addressLine1.isEmpty ? "N/A" : customer.addressLine1, icon: "house.fill")
                            CustomerDetailFieldRow(title: "Address Line 2", value: customer.addressLine2.isEmpty ? "N/A" : customer.addressLine2, icon: "building.2.fill")
                        }
                        
                        HStack(alignment: .top) {
                            CustomerDetailFieldRow(title: "City", value: customer.city, icon: "location.fill")
                            CustomerDetailFieldRow(title: "Postal Code", value: customer.postalCode, icon: "mail.fill")
                        }
                        
                        CustomerDetailFieldRow(title: "Country", value: customer.country, icon: "flag.fill")
                    }
                }
                
                CustomerDetailBlockView(title: "Financial & History", icon: "chart.bar.fill") {
                    VStack(spacing: 15) {
                        CustomerDetailFieldRow(title: "Total Spent", value: fullCurrencyFormatter.string(from: NSNumber(value: customer.totalSpent)) ?? "PKR 0.00", icon: "banknote.fill", isImportant: true)
                        
                        HStack(alignment: .top) {
                            CustomerDetailFieldRow(title: "Registration Date", value: fullDateFormatter.string(from: customer.registrationDate), icon: "calendar.badge.plus")
                            CustomerDetailFieldRow(title: "Last Visit Date", value: customer.lastVisitDate.map { fullDateFormatter.string(from: $0) } ?? "N/A", icon: "clock.fill")
                        }
                    }
                }
                
                CustomerDetailBlockView(title: "Personal & Administrative", icon: "gearshape.fill") {
                    VStack(spacing: 15) {
                        HStack(alignment: .top) {
                            CustomerDetailFieldRow(title: "Gender", value: customer.gender, icon: "person.crop.circle")
                            CustomerDetailFieldRow(title: "Birth Date", value: customer.birthDate.map { fullDateFormatter.string(from: $0) } ?? "N/A", icon: "gift.fill")
                        }
                        
                        HStack(alignment: .top) {
                            CustomerDetailFieldRow(title: "Occupation", value: customer.occupation.isEmpty ? "N/A" : customer.occupation, icon: "briefcase.fill")
                            CustomerDetailFieldRow(title: "Referred By", value: customer.referredBy.isEmpty ? "N/A" : customer.referredBy, icon: "person.2.fill")
                        }
                        
                        CustomerDetailFieldRow(title: "Remarks", value: customer.remarks.isEmpty ? "None" : customer.remarks, icon: "note.text.fill")
                        
                        CustomerDetailFieldRow(title: "Tags", value: customer.tags.joined(separator: ", ").isEmpty ? "None" : customer.tags.joined(separator: ", "), icon: "tag.fill")
                        
                        HStack(alignment: .top) {
                            CustomerDetailFieldRow(title: "Created By", value: customer.createdBy, icon: "hammer.fill")
                            CustomerDetailFieldRow(title: "Last Updated", value: fullDateFormatter.string(from: customer.lastUpdated), icon: "arrow.clockwise")
                        }
                    }
                }
            }
            .padding()
            .padding(.bottom, 20)
        }
        .navigationTitle("Customer Profile")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}
