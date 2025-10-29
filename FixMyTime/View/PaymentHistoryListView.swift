

import SwiftUI
import Combine


//extension Color {
//    static let customTeal = Color(red: 0.18, green: 0.80, blue: 0.80)
//    static let customBrown = Color(red: 0.65, green: 0.16, blue: 0.16)
//}

@available(iOS 14.0, *)
struct PaymentHistoryAddFieldView: View {
    let title: String
    @Binding var text: String
    let iconName: String
    let isNumeric: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack(alignment: .leading) {
              
                HStack {
                    Image(systemName: iconName)
                        .foregroundColor(.secondary)

                    if isNumeric {
                        TextField(title, text: $text)
                            .keyboardType(.decimalPad)
                            .foregroundColor(.primary)
                    } else {
                        TextField(title, text: $text)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.top, 10)

            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.systemGray4))
        }
    }
}

@available(iOS 14.0, *)
struct PaymentHistoryAddDatePickerView: View {
    let title: String
    @Binding var date: Date
    let iconName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.secondary)
                Text(title)
                    .font(.callout)
                    .foregroundColor(.primary)
                Spacer()
                DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.systemGray4))
        }
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct PaymentHistoryAddSectionHeaderView: View {
    let title: String
    let iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(.vertical, 8)
        .foregroundColor(.primary)
        .background(Color(.systemGray6))
    }
}

@available(iOS 14.0, *)
struct PaymentHistoryAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: WatchRepairDataManager

    @State private var customerName: String = ""
    @State private var paymentMethod: String = ""
    @State private var amount: String = ""
    @State private var currency: String = "PKR"
    @State private var transactionStatus: String = "Completed"
    @State private var discountApplied: String = "0.0"
    @State private var taxAmount: String = "0.0"
    @State private var totalAfterTax: String = "0.0"
    @State private var referenceNumber: String = ""
    @State private var invoiceNumber: String = ""
    @State private var isRefunded: Bool = false
    @State private var refundAmount: String = "0.0"
    @State private var refundReason: String = ""
    @State private var remarks: String = ""
    @State private var recordedBy: String = "Admin"
    @State private var jobReference: String = ""
    @State private var paymentCategory: String = "Repair"
    @State private var tags: String = ""
    @State private var location: String = ""
    @State private var approvedBy: String = "System"
    @State private var verificationStatus: String = "Verified"
    @State private var syncedOffline: Bool = false
    @State private var duplicateCheckHash: String = UUID().uuidString

    @State private var paymentID: String = "PAY-\(Int.random(in: 100...999))"
    @State private var createdBy: String = "User"

    @State private var paymentDate: Date = Date()
    @State private var createdDate: Date = Date()
    @State private var lastUpdated: Date = Date()


    @State private var showingAlert = false
    @State private var alertMessage = ""

    private func savePaymentHistory() {
        var errors: [String] = []

        if customerName.isEmpty { errors.append("Customer Name is required.") }
        if amount.isEmpty || (Double(amount) == nil) { errors.append("Valid Amount is required.") }
        if jobReference.isEmpty { errors.append("Job Reference is required.") }

        let numericFields: [String: String] = [
            "Amount": amount, "Discount": discountApplied, "Tax Amount": taxAmount,
            "Total After Tax": totalAfterTax, "Refund Amount": refundAmount
        ]
        for (name, value) in numericFields {
            if Double(value) == nil { errors.append("Invalid format for \(name).") }
        }

        if errors.isEmpty {
            if let finalAmount = Double(amount),
               let finalDiscount = Double(discountApplied),
               let finalTax = Double(taxAmount),
               let finalTotal = Double(totalAfterTax),
               let finalRefundAmount = Double(refundAmount) {

                let newPayment = PaymentHistory(
                    id: UUID(),
                    paymentID: paymentID,
                    customerName: customerName,
                    paymentDate: paymentDate,
                    paymentMethod: paymentMethod,
                    amount: finalAmount,
                    currency: currency,
                    transactionStatus: transactionStatus,
                    discountApplied: finalDiscount,
                    taxAmount: finalTax,
                    totalAfterTax: finalTotal,
                    referenceNumber: referenceNumber,
                    invoiceNumber: invoiceNumber,
                    isRefunded: isRefunded,
                    refundAmount: finalRefundAmount,
                    refundReason: isRefunded ? refundReason : "",
                    remarks: remarks,
                    recordedBy: recordedBy,
                    jobReference: jobReference,
                    paymentCategory: paymentCategory,
                    tags: tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                    location: location,
                    approvedBy: approvedBy,
                    createdBy: createdBy,
                    createdDate: createdDate,
                    lastUpdated: Date(),
                    verificationStatus: verificationStatus,
                    syncedOffline: syncedOffline,
                    duplicateCheckHash: duplicateCheckHash
                )

                dataManager.addPaymentRecord(newPayment)
                alertMessage = "✅ Success!\nPayment Record \(paymentID) for \(customerName) saved successfully."
            } else {
                alertMessage = "⚠️ Critical Error in numeric conversion."
            }

        } else {
            alertMessage = "⚠️ Validation Failed:\n" + errors.joined(separator: "\n")
        }

        showingAlert = true
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    VStack(alignment: .leading, spacing: 15) {
                        Text("New Payment Record")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)

                        HStack {
                            Text("ID: \(paymentID)")
                            Spacer()
                            Image(systemName: "creditcard.fill")
                        }
                        .font(.headline)
                        .foregroundColor(Color.white.opacity(0.8))
                    }
                    .padding(25)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal)

                    VStack(spacing: 30) {

                        PaymentHistoryAddSectionHeaderView(title: "Payment Information", iconName: "banknote.fill")

                        PaymentHistoryAddFieldView(title: "Customer Name", text: $customerName, iconName: "person.fill", isNumeric: false)
                        PaymentHistoryAddFieldView(title: "Job Reference", text: $jobReference, iconName: "doc.text.magnifyingglass", isNumeric: false)
                        PaymentHistoryAddFieldView(title: "Amount Paid", text: $amount, iconName: "dollarsign.circle.fill", isNumeric: true)
                        PaymentHistoryAddFieldView(title: "Payment Method", text: $paymentMethod, iconName: "creditcard", isNumeric: false)

                        PaymentHistoryAddDatePickerView(title: "Payment Date", date: $paymentDate, iconName: "calendar.badge.clock")

                        PaymentHistoryAddSectionHeaderView(title: "Financial Breakdown", iconName: "chart.bar.doc.horizontal.fill")

                        VStack {
                            PaymentHistoryAddFieldView(title: "Currency", text: $currency, iconName: "repeat.circle.fill", isNumeric: false)
                            PaymentHistoryAddFieldView(title: "Transaction Status", text: $transactionStatus, iconName: "checkmark.seal.fill", isNumeric: false)
                            PaymentHistoryAddFieldView(title: "Discount Applied", text: $discountApplied, iconName: "tag.fill", isNumeric: true)
                            PaymentHistoryAddFieldView(title: "Tax Amount", text: $taxAmount, iconName: "percent", isNumeric: true)
                            PaymentHistoryAddFieldView(title: "Total After Tax", text: $totalAfterTax, iconName: "sum", isNumeric: true)
                            PaymentHistoryAddFieldView(title: "Invoice Number", text: $invoiceNumber, iconName: "number.square.fill", isNumeric: false)
                        }

                        PaymentHistoryAddSectionHeaderView(title: "Admin & Logistics", iconName: "building.2.fill")

                        Toggle(isOn: $isRefunded) {
                            HStack {
                                Image(systemName: "arrow.uturn.backward.circle.fill")
                                Text("Is Refunded?")
                            }
                        }
                        .padding(.vertical, 8)

                        if isRefunded {
                            PaymentHistoryAddFieldView(title: "Refund Amount", text: $refundAmount, iconName: "return", isNumeric: true)
                            PaymentHistoryAddFieldView(title: "Refund Reason", text: $refundReason, iconName: "exclamationmark.triangle.fill", isNumeric: false)
                        }

                        PaymentHistoryAddFieldView(title: "Recorded By", text: $recordedBy, iconName: "pencil.and.outline", isNumeric: false)
                        PaymentHistoryAddFieldView(title: "Location", text: $location, iconName: "map.pin.circle.fill", isNumeric: false)
                        PaymentHistoryAddFieldView(title: "Approved By", text: $approvedBy, iconName: "hand.thumbsup.fill", isNumeric: false)
                        PaymentHistoryAddFieldView(title: "Verification Status", text: $verificationStatus, iconName: "shield.lefthalf.fill", isNumeric: false)


                        PaymentHistoryAddSectionHeaderView(title: "Notes & Metadata", iconName: "note.text")

                        PaymentHistoryAddFieldView(title: "Remarks", text: $remarks, iconName: "text.bubble", isNumeric: false)
                        PaymentHistoryAddFieldView(title: "Tags (comma-separated)", text: $tags, iconName: "bookmark.fill", isNumeric: false)

                        Group {
                            PaymentHistoryAddFieldView(title: "Reference Number", text: $referenceNumber, iconName: "number", isNumeric: false)
                            PaymentHistoryAddFieldView(title: "Payment Category", text: $paymentCategory, iconName: "folder.fill", isNumeric: false)

                            Toggle(isOn: $syncedOffline) {
                                HStack {
                                    Image(systemName: "cloud.fill")
                                    Text("Synced Offline?")
                                }
                            }
                            .padding(.vertical, 8)

                            PaymentHistoryAddFieldView(title: "Created By", text: $createdBy, iconName: "person.fill.badge.plus", isNumeric: false)
                            PaymentHistoryAddDatePickerView(title: "Created Date", date: $createdDate, iconName: "calendar.badge.plus")
                            
                            PaymentHistoryAddFieldView(title: "Duplicate Check Hash", text: $duplicateCheckHash, iconName: "key.fill", isNumeric: false)

                        }
                        .opacity(0.5)

                        Button(action: savePaymentHistory) {
                            Text("Add Payment Record")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(color: Color.blue.opacity(0.4), radius: 5, x: 0, y: 5)
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("New Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text(alertMessage.contains("✅") ? "Operation Complete" : "Validation Issue"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertMessage.contains("✅") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }
}

@available(iOS 14.0, *)
struct PaymentHistorySearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? .secondary : .accentColor)
                .padding(.leading, 8)
                .animation(.easeOut, value: searchText.isEmpty)

            TextField("Search by Customer, ID, or Method...", text: $searchText)
                .padding(.vertical, 10)
                .padding(.trailing, 8)
                .foregroundColor(.primary)

            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct PaymentHistoryListRowView: View {
    let payment: PaymentHistory

    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(payment.paymentID)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.gray)

                    Text(payment.customerName)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("\(String(format: "%.2f", payment.amount)) \(payment.currency)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.green)

                    Text(payment.transactionStatus)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(payment.transactionStatus == "Completed" ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                        .foregroundColor(payment.transactionStatus == "Completed" ? .green : .red)
                        .cornerRadius(6)
                }
            }
            .padding(.bottom, 5)

            Divider()
                .padding(.horizontal, -15)

            HStack {
                PaymentDetailIconText(icon: "briefcase.fill", text: payment.jobReference, color: .orange)
                Spacer()
                PaymentDetailIconText(icon: payment.paymentMethod.lowercased() == "cash" ? "banknote.fill" : "creditcard.fill", text: payment.paymentMethod, color: .purple)
                Spacer()
                PaymentDetailIconText(icon: "mappin.and.ellipse", text: payment.location, color: .gray)
            }

            PaymentDetailIconText(icon: "calendar", text: Self.shortDate.string(from: payment.paymentDate), color: .blue)

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    PaymentDetailIconText(icon: "sum", text: "Total After Tax: \(String(format: "%.2f", payment.totalAfterTax))", color: .green)
                    Spacer()
                    PaymentDetailIconText(icon: "tag.fill", text: "Discount: \(String(format: "%.2f", payment.discountApplied))", color: .pink)
                }
                HStack {
                    PaymentDetailIconText(icon: "number.square.fill", text: "Invoice: \(payment.invoiceNumber)", color: .gray)
                    Spacer()
                    PaymentDetailIconText(icon: "pencil.and.outline", text: "Recorded by: \(payment.recordedBy)", color: .customIndigo)
                }

                if payment.isRefunded {
                    HStack {
                        Image(systemName: "arrow.uturn.backward.circle.fill")
                            .foregroundColor(.red)
                        Text("Refunded: \(String(format: "%.2f", payment.refundAmount)) - \(payment.refundReason)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.top, 5)

            HStack(spacing: 4) {
                ForEach(payment.tags.prefix(3), id: \.self) { tag in
                    Text("#\(tag)")
                        .font(.system(size: 10))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.customTeal.opacity(0.1))
                        .foregroundColor(Color.customTeal)
                        .cornerRadius(4)
                }
                Spacer()
                PaymentDetailIconText(icon: "checkmark.seal.fill", text: payment.verificationStatus, color: .blue)
            }
            .padding(.top, 5)
        }
        .padding(15)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
        .padding(.horizontal, 5)
    }
}

@available(iOS 14.0, *)
fileprivate struct PaymentDetailIconText: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.caption)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

@available(iOS 14.0, *)
struct PaymentHistoryNoDataView: View {
    let message: String

    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "doc.text.magnifyingglass")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)

            Text("Nothing to See Here")
                .font(.title2)
                .fontWeight(.bold)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .padding(.top, 50)
    }
}

@available(iOS 14.0, *)
struct PaymentHistoryListView: View {
    @EnvironmentObject var dataManager: WatchRepairDataManager
    @State private var searchText: String = ""
    @State private var isAddingNewPayment = false

    var filteredPayments: [PaymentHistory] {
        if searchText.isEmpty {
            return dataManager.paymentHistory
        } else {
            return dataManager.paymentHistory.filter { payment in
                payment.customerName.localizedCaseInsensitiveContains(searchText) ||
                payment.paymentID.localizedCaseInsensitiveContains(searchText) ||
                payment.paymentMethod.localizedCaseInsensitiveContains(searchText) ||
                payment.jobReference.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        let paymentsToDelete = offsets.map { filteredPayments[$0] }
        for payment in paymentsToDelete {
            dataManager.deletePaymentRecord(payment)
        }
    }

    var body: some View {
            VStack {
                PaymentHistorySearchBarView(searchText: $searchText)
                    .padding(.top, 8)

                if filteredPayments.isEmpty && !searchText.isEmpty {
                    PaymentHistoryNoDataView(message: "No payment records match your search criteria: \"\(searchText)\".")
                    Spacer()
                } else if filteredPayments.isEmpty {
                    PaymentHistoryNoDataView(message: "There are no payment records. Tap the '+' button to add one.")
                    Spacer()
                } else {
                    List {
                        ForEach(filteredPayments) { payment in
                            ZStack {
                                NavigationLink(destination: PaymentHistoryDetailView(payment: payment)) {
                                    EmptyView()
                                }
                                .opacity(0)

                                PaymentHistoryListRowView(payment: payment)
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(GroupedListStyle())
                }
            }
            .navigationBarItems(trailing:
                Button(action: {
                    isAddingNewPayment = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
            )
            .sheet(isPresented: $isAddingNewPayment) {
                PaymentHistoryAddView()
                    .environmentObject(dataManager)
            }
        
    }
}

@available(iOS 14.0, *)
struct PaymentHistoryDetailFieldRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
                .padding(.top, 2)

            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct PaymentHistoryDetailView: View {
    let payment: PaymentHistory

    private static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }()

    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {

                VStack(alignment: .center, spacing: 5) {
                    Text(payment.customerName)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)

                    Text(payment.paymentID)
                        .font(.headline)
                        .foregroundColor(Color.white.opacity(0.7))

                    Text("\(payment.currency) \(String(format: "%.2f", payment.amount))")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 10)

                    Text(payment.transactionStatus)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 5)

                }
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )

                VStack(spacing: 15) {

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Core Transaction Details")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)

                        PaymentHistoryDetailFieldRow(label: "Job Reference", value: payment.jobReference, icon: "doc.text.fill", color: .orange)
                        PaymentHistoryDetailFieldRow(label: "Payment Date", value: Self.fullDateFormatter.string(from: payment.paymentDate), icon: "calendar", color: .red)
                        PaymentHistoryDetailFieldRow(label: "Payment Method", value: payment.paymentMethod, icon: "creditcard.fill", color: .purple)
                        PaymentHistoryDetailFieldRow(label: "Payment Category", value: payment.paymentCategory, icon: "folder.fill", color: .customTeal)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Financial Breakdown")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)

                        PaymentHistoryDetailFieldRow(label: "Total After Tax", value: "\(payment.currency) \(String(format: "%.2f", payment.totalAfterTax))", icon: "sum", color: .green)
                        PaymentHistoryDetailFieldRow(label: "Discount Applied", value: "\(payment.currency) \(String(format: "%.2f", payment.discountApplied))", icon: "tag.fill", color: .pink)
                        PaymentHistoryDetailFieldRow(label: "Tax Amount", value: "\(payment.currency) \(String(format: "%.2f", payment.taxAmount))", icon: "percent", color: .blue)

                        PaymentHistoryDetailFieldRow(label: "Invoice Number", value: payment.invoiceNumber, icon: "number.square.fill", color: .gray)
                        PaymentHistoryDetailFieldRow(label: "Reference Number", value: payment.referenceNumber, icon: "number", color: .gray)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 2)

                    if payment.isRefunded {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Refund Details")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                                .padding(.bottom, 5)

                            PaymentHistoryDetailFieldRow(label: "Refund Status", value: payment.isRefunded ? "YES" : "NO", icon: "arrow.uturn.backward", color: .red)
                            PaymentHistoryDetailFieldRow(label: "Refund Amount", value: "\(payment.currency) \(String(format: "%.2f", payment.refundAmount))", icon: "return", color: .red)
                            PaymentHistoryDetailFieldRow(label: "Refund Reason", value: payment.refundReason.isEmpty ? "N/A" : payment.refundReason, icon: "exclamationmark.triangle.fill", color: .red)
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(15)
                    }

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Administrative Log")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)

                        PaymentHistoryDetailFieldRow(label: "Recorded By", value: payment.recordedBy, icon: "person.badge.shield.fill", color: .customIndigo)
                        PaymentHistoryDetailFieldRow(label: "Approved By", value: payment.approvedBy, icon: "hand.thumbsup.fill", color: .green)
                        PaymentHistoryDetailFieldRow(label: "Location", value: payment.location, icon: "mappin.and.ellipse", color: .customBrown)
                        PaymentHistoryDetailFieldRow(label: "Verification Status", value: payment.verificationStatus, icon: "shield.lefthalf.fill", color: .blue)
                        PaymentHistoryDetailFieldRow(label: "Synced Offline", value: payment.syncedOffline ? "Yes" : "No", icon: "cloud.fill", color: .customCyan)
                        PaymentHistoryDetailFieldRow(label: "Duplicate Check Hash", value: payment.duplicateCheckHash, icon: "key.fill", color: .gray)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Remarks")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(payment.remarks.isEmpty ? "No additional remarks." : payment.remarks)
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .padding(.leading, 5)

                        Text("Tags: \(payment.tags.joined(separator: ", "))")
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .padding(.leading, 5)
                            .padding(.top, 5)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 2)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Audit Trail")
                            .font(.title3)
                            .fontWeight(.bold)

                        PaymentHistoryDetailFieldRow(label: "Created By", value: payment.createdBy, icon: "person.circle", color: .gray)
                        PaymentHistoryDetailFieldRow(label: "Created Date", value: Self.fullDateFormatter.string(from: payment.createdDate), icon: "plus.circle", color: .gray)
                        PaymentHistoryDetailFieldRow(label: "Last Updated", value: Self.fullDateFormatter.string(from: payment.lastUpdated), icon: "arrow.clockwise", color: .gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)

                }
                .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
        .navigationTitle("Transaction Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

