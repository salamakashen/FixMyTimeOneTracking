
import Foundation
import SwiftUI
import Combine


extension Color {
    static let customTeal = Color(red: 0.0, green: 0.5, blue: 0.5)
    static let customBrown = Color(red: 0.6, green: 0.4, blue: 0.2)
}


@available(iOS 14.0, *)
struct RepairJobAddView: View {
    @EnvironmentObject var dataManager: WatchRepairDataManager
    @Environment(\.presentationMode) var presentationMode

    @State var jobNumber: String = ""
    @State var customerName: String = ""
    @State var watchBrand: String = ""
    @State var watchModel: String = ""
    @State var serialNumber: String = ""
    @State var issueDescription: String = ""
    @State var repairType: String = ""
    @State var partsUsedString: String = ""
    @State var estimatedCost: String = ""
    @State var actualCost: String = ""
    @State var depositPaid: String = ""
    @State var repairStatus: String = "Received"
    @State var dateReceived: Date = Date()
    @State var dateCompleted: Date? = nil
    @State var warrantyProvided: Bool = true
    @State var warrantyDurationMonths: Int = 6
    @State var technicianNote: String = ""
    @State var customerFeedback: String = ""
    @State var priorityLevel: String = "Medium"
    @State var estimatedCompletionDate: Date = Date().addingTimeInterval(86400 * 3)
    @State var deliveryMethod: String = "Pickup"
    @State var pickupLocation: String = "Main Branch"
    @State var isFavorite: Bool = false
    @State var tagsString: String = ""
    @State var internalRemarks: String = ""

    let lastUpdated: Date = Date()
    let createdBy: String = "User"

    @State private var showingAlert = false
    @State private var alertMessage = ""

    let statusOptions = ["Received", "In Progress", "On Hold", "Completed", "Canceled"]
    let priorityOptions = ["Low", "Medium", "High", "Urgent"]
    let deliveryOptions = ["Pickup", "Shipping"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 15) {
                    RepairJobAddSectionHeaderView(title: "Job & Watch Details ⌚", iconName: "wrench.and.screwdriver.fill")

                    RepairJobAddFieldView(title: "Job Number", text: $jobNumber, iconName: "number.square.fill")
                    RepairJobAddFieldView(title: "Customer Name", text: $customerName, iconName: "person.fill")
                    
                    HStack {
                        RepairJobAddFieldView(title: "Watch Brand", text: $watchBrand, iconName: "tag.circle.fill")
                        RepairJobAddFieldView(title: "Watch Model", text: $watchModel, iconName: "magnifyingglass.circle.fill")
                    }
                    RepairJobAddFieldView(title: "Serial Number", text: $serialNumber, iconName: "barcode")
                    
                    RepairJobAddTextAreaView(title: "Issue Description", text: $issueDescription, iconName: "exclamationmark.bubble.fill")
                    RepairJobAddFieldView(title: "Repair Type", text: $repairType, iconName: "hammer.fill")
                    RepairJobAddFieldView(title: "Parts Used (comma-separated)", text: $partsUsedString, iconName: "puzzlepiece.fill")
                }
                .modifier(RepairJobAddSectionModifier())

                VStack(alignment: .leading, spacing: 15) {
                    RepairJobAddSectionHeaderView(title: "Financials & Status 💰", iconName: "dollarsign.circle.fill")
                    
                    
                    RepairJobAddFieldView(title: "Estimated Cost", text: $estimatedCost, iconName: "dollarsign.square.fill", keyboardType: .decimalPad)
                    RepairJobAddFieldView(title: "Actual Cost", text: $actualCost, iconName: "creditcard.fill", keyboardType: .decimalPad)
                    RepairJobAddFieldView(title: "Deposit Paid", text: $depositPaid, iconName: "banknote.fill", keyboardType: .decimalPad)
                    
                    
                    RepairJobAddPickerView(title: "Repair Status", selection: $repairStatus, options: statusOptions, iconName: "list.bullet.clipboard.fill")
                    RepairJobAddPickerView(title: "Priority Level", selection: $priorityLevel, options: priorityOptions, iconName: "flame.fill")
                }
                .modifier(RepairJobAddSectionModifier())
                
                VStack(alignment: .leading, spacing: 15) {
                    RepairJobAddSectionHeaderView(title: "Timeline & Warranty 📅", iconName: "clock.fill")
                    
                    RepairJobAddDatePickerView(title: "Date Received", date: $dateReceived, iconName: "calendar.badge.plus")
                    RepairJobAddDatePickerView(title: "Estimated Completion", date: $estimatedCompletionDate, iconName: "calendar.badge.clock")

                    Toggle(isOn: $warrantyProvided) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                                .foregroundColor(Color.orange)
                            Text("Warranty Provided")
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3)
                    
                    if warrantyProvided {
                        RepairJobAddStepperView(title: "Warranty Duration (Months)", value: $warrantyDurationMonths, range: 0...120, iconName: "goforward.10.ar")
                    }
                }
                .modifier(RepairJobAddSectionModifier())
                
                VStack(alignment: .leading, spacing: 15) {
                    RepairJobAddSectionHeaderView(title: "Notes & Delivery 📝", iconName: "note.text")
                    
                    RepairJobAddTextAreaView(title: "Technician Note", text: $technicianNote, iconName: "person.badge.shield.fill")
                    RepairJobAddTextAreaView(title: "Customer Feedback", text: $customerFeedback, iconName: "message.fill")
                    RepairJobAddTextAreaView(title: "Internal Remarks", text: $internalRemarks, iconName: "eye.slash.fill")
                    
                    RepairJobAddFieldView(title: "Tags (comma-separated)", text: $tagsString, iconName: "tag.fill")

                    RepairJobAddPickerView(title: "Delivery Method", selection: $deliveryMethod, options: deliveryOptions, iconName: "shippingbox.fill")
                    RepairJobAddFieldView(title: "Pickup Location", text: $pickupLocation, iconName: "mappin.and.ellipse")
                    
                    RepairJobAddOptionalDatePickerView(title: "Date Completed (Optional)", date: $dateCompleted, iconName: "checkmark.circle.fill")
                    
                    Toggle(isOn: $isFavorite) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(isFavorite ? Color.yellow : Color.gray)
                            Text("Mark as Favorite")
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 3)
                }
                .modifier(RepairJobAddSectionModifier())
                
                Button(action: saveRepairJob) {
                    Text("Save Repair Job")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("New Repair Job")
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Submission Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                if alertMessage.contains("Success") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }

    private func saveRepairJob() {
        var errors: [String] = []

        if jobNumber.isEmpty { errors.append("Job Number is required.") }
        if customerName.isEmpty { errors.append("Customer Name is required.") }
        if watchBrand.isEmpty { errors.append("Watch Brand is required.") }
        if watchModel.isEmpty { errors.append("Watch Model is required.") }
        if serialNumber.isEmpty { errors.append("Serial Number is required.") }
        if issueDescription.isEmpty { errors.append("Issue Description is required.") }
        if repairType.isEmpty { errors.append("Repair Type is required.") }
        if estimatedCost.isEmpty || Double(estimatedCost) == nil { errors.append("Valid Estimated Cost is required.") }
        if actualCost.isEmpty || Double(actualCost) == nil { errors.append("Valid Actual Cost is required.") }
        if depositPaid.isEmpty || Double(depositPaid) == nil { errors.append("Valid Deposit Paid is required.") }
        if pickupLocation.isEmpty { errors.append("Pickup Location is required.") }
        
        if errors.isEmpty {
            let newJob = RepairJob(
                id: UUID(),
                jobNumber: jobNumber,
                customerName: customerName,
                watchBrand: watchBrand,
                watchModel: watchModel,
                serialNumber: serialNumber,
                issueDescription: issueDescription,
                repairType: repairType,
                partsUsed: partsUsedString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty },
                estimatedCost: Double(estimatedCost) ?? 0.0,
                actualCost: Double(actualCost) ?? 0.0,
                depositPaid: Double(depositPaid) ?? 0.0,
                repairStatus: repairStatus,
                dateReceived: dateReceived,
                dateCompleted: dateCompleted,
                warrantyProvided: warrantyProvided,
                warrantyDurationMonths: warrantyDurationMonths,
                technicianNote: technicianNote,
                customerFeedback: customerFeedback,
                priorityLevel: priorityLevel,
                estimatedCompletionDate: estimatedCompletionDate,
                deliveryMethod: deliveryMethod,
                pickupLocation: pickupLocation,
                isFavorite: isFavorite,
                lastUpdated: lastUpdated,
                createdBy: createdBy,
                tags: tagsString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty },
                internalRemarks: internalRemarks
            )

            dataManager.addRepairJob(newJob)
            alertMessage = "Success! Repair Job \(newJob.jobNumber) has been added."
        } else {
            alertMessage = "Please correct the following errors:\n\n" + errors.joined(separator: "\n")
        }

        showingAlert = true
    }
}

@available(iOS 14.0, *)
struct RepairJobAddFieldView: View {
    let title: String
    @Binding var text: String
    let iconName: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                TextField(title, text: $text)
                    .keyboardType(keyboardType)
            }
            .padding(.top, 10)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(text.isEmpty ? Color.clear : Color.blue, lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct RepairJobAddTextAreaView: View {
    let title: String
    @Binding var text: String
    let iconName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            TextEditor(text: $text)
                .frame(height: 100)
                .padding(4)
                .background(Color.white)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct RepairJobAddDatePickerView: View {
    let title: String
    @Binding var date: Date
    let iconName: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.caption)
                Spacer()
            }
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct RepairJobAddOptionalDatePickerView: View {
    let title: String
    @Binding var date: Date?
    let iconName: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: date == nil ? "square" : iconName)
                    .foregroundColor(date == nil ? .gray : .customTeal)
                Text(title)
                    .font(.caption)
                Spacer()
                
                if date != nil {
                    DatePicker("", selection: Binding($date)!, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                } else {
                    Button("Set Date") {
                        date = Date()
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if date == nil {
                    date = Date()
                } else {
                    date = nil
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct RepairJobAddPickerView: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    let iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.blue)
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct RepairJobAddStepperView: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let iconName: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.caption)
                Spacer()
            }
            Stepper("\(value) \(title.contains("Months") ? "months" : "")", value: $value, in: range)
                .padding(.top, 5)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct RepairJobAddSectionHeaderView: View {
    let title: String
    let iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(.blue)
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(.horizontal, 25)
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct RepairJobAddSectionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.bottom, 20)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
            .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct RepairJobListRootView: View {
    @EnvironmentObject var dataManager: WatchRepairDataManager
    @State private var searchText: String = ""
    @State private var showingAddView: Bool = false

    var filteredJobs: [RepairJob] {
        if searchText.isEmpty {
            return dataManager.repairJobs
        } else {
            return dataManager.repairJobs.filter { job in
                job.jobNumber.localizedCaseInsensitiveContains(searchText) ||
                job.customerName.localizedCaseInsensitiveContains(searchText) ||
                job.watchBrand.localizedCaseInsensitiveContains(searchText) ||
                job.repairStatus.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        VStack {
            RepairJobSearchBarView(searchText: $searchText)
                .padding(.horizontal)

            if filteredJobs.isEmpty {
                RepairJobNoDataView()
            } else {
                List {
                    ForEach(filteredJobs) { job in
                        NavigationLink(destination: RepairJobDetailView(job: job)) {
                            RepairJobListRowView(job: job)
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: deleteJob)
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationBarItems(trailing:
            Button(action: {
                showingAddView = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            .sheet(isPresented: $showingAddView) {
                NavigationView {
                    RepairJobAddView()
                        .environmentObject(dataManager)
                }
            }
        )
    }

    private func deleteJob(offsets: IndexSet) {
        offsets.map { filteredJobs[$0] }.forEach(dataManager.deleteRepairJob)
    }
}

@available(iOS 14.0, *)
struct RepairJobListRowView: View {
    let job: RepairJob
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var statusColor: Color {
        switch job.repairStatus {
        case "Completed": return .green
        case "In Progress": return .orange
        case "On Hold": return .yellow
        case "Canceled": return .red
        case "Received": return .customTeal
        default: return .blue
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(job.jobNumber)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                    
                    Text("\(job.watchBrand) \(job.watchModel)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(job.priorityLevel)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(job.priorityLevel == "High" || job.priorityLevel == "Urgent" ? Color.red.opacity(0.1) : Color.gray.opacity(0.1))
                        .foregroundColor(job.priorityLevel == "High" || job.priorityLevel == "Urgent" ? .red : .gray)
                        .cornerRadius(5)
                    
                    Image(systemName: job.isFavorite ? "star.fill" : "star")
                        .foregroundColor(job.isFavorite ? .yellow : .gray)
                }
            }
            .padding([.top, .horizontal])

            HStack(spacing: 15) {
                Text(job.repairStatus)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .clipShape(Capsule())
                
                HStack(spacing: 4) {
                    Image(systemName: "person.circle.fill").foregroundColor(.gray)
                    Text(job.customerName).font(.caption).lineLimit(1)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "barcode.viewfinder").foregroundColor(.gray)
                    Text(job.serialNumber).font(.caption).lineLimit(1)
                }
            }
            .padding(.horizontal)
            
            Divider().padding(.horizontal)

            HStack {
                VStack(alignment: .leading) {
                    Text("Est. Cost").font(.caption).foregroundColor(.gray)
                    Text("PKR \(String(format: "%.0f", job.estimatedCost))").font(.subheadline).fontWeight(.semibold)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Actual Cost").font(.caption).foregroundColor(.gray)
                    Text("PKR \(String(format: "%.0f", job.actualCost))").font(.subheadline).fontWeight(.semibold)
                }
                
            }
            .padding(.horizontal)
            
            HStack{
                VStack(alignment: .leading) {
                    Text("Date In").font(.caption).foregroundColor(.gray)
                    Text(dateFormatter.string(from: job.dateReceived)).font(.subheadline).fontWeight(.semibold)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Est. Out").font(.caption).foregroundColor(.gray)
                    Text(dateFormatter.string(from: job.estimatedCompletionDate)).font(.subheadline).fontWeight(.semibold)
                }
            }.padding(.horizontal)

            
            Divider().padding(.horizontal)
            
            HStack(spacing: 20) {
                HStack(spacing: 4) {
                    Image(systemName: job.warrantyProvided ? "shield.lefthalf.fill" : "nosign").foregroundColor(job.warrantyProvided ? .green : .red)
                    Text(job.warrantyProvided ? "\(job.warrantyDurationMonths)M Warranty" : "No Warranty").font(.caption)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "gear.circle.fill").foregroundColor(.purple)
                    Text(job.repairType).font(.caption).lineLimit(1)
                }
            }
            .padding([.horizontal, .bottom])
            
            HStack{
                HStack(spacing: 4) {
                    Image(systemName: "shippingbox.fill").foregroundColor(.customIndigo)
                    Text(job.deliveryMethod).font(.caption).lineLimit(1)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "pin.fill").foregroundColor(.customBrown)
                    Text(job.pickupLocation).font(.caption).lineLimit(1)
                }
            }.padding([.horizontal, .bottom])

            if !job.tags.isEmpty {
                HStack {
                    ForEach(job.tags.prefix(3), id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 10))
                            .fontWeight(.medium)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(4)
                    }
                    if job.tags.count > 3 {
                        Text("+\(job.tags.count - 3) more")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: statusColor.opacity(0.3), radius: 5, x: 0, y: 5)
        .padding(.horizontal, 10)
    }
}

@available(iOS 14.0, *)
struct RepairJobSearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search jobs, brands, customers...", text: $searchText)
                    .disableAutocorrection(true)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .animation(.default, value: searchText)
        }
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct RepairJobNoDataView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
            
            Text("No Repair Jobs Found")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Try searching for something else or tap the '+' button to add a new repair job.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@available(iOS 14.0, *)
struct RepairJobDetailView: View {
    let job: RepairJob
    
    private let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    private func currencyString(_ amount: Double) -> String {
        return String(format: "PKR %.2f", amount)
    }
    
    var statusColor: Color {
        switch job.repairStatus {
        case "Completed": return .green
        case "In Progress": return .orange
        case "On Hold": return .yellow
        case "Canceled": return .red
        case "Received": return .customTeal
        default: return .blue
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                VStack(spacing: 8) {
                    HStack {
                        Text(job.jobNumber)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: job.isFavorite ? "star.circle.fill" : "timer")
                            .font(.largeTitle)
                            .foregroundColor(job.isFavorite ? .yellow : statusColor)
                    }
                    
                    Text("\(job.watchBrand) \(job.watchModel) - \(job.serialNumber)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(job.repairStatus)
                        .font(.callout)
                        .fontWeight(.bold)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .background(statusColor.opacity(0.2))
                        .foregroundColor(statusColor)
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                RepairJobDetailContentBlock(title: "Customer & Watch Details", icon: "person.text.rectangle.fill") {
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            RepairJobDetailFieldRow(label: "Customer", value: job.customerName, icon: "person.fill")
                            RepairJobDetailFieldRow(label: "Brand", value: job.watchBrand, icon: "tag.circle.fill")
                            RepairJobDetailFieldRow(label: "Model", value: job.watchModel, icon: "magnifyingglass")
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            RepairJobDetailFieldRow(label: "Serial Number", value: job.serialNumber, icon: "barcode")
                            RepairJobDetailFieldRow(label: "Priority Level", value: job.priorityLevel, icon: "flame.fill", accentColor: .red)
                            RepairJobDetailFieldRow(label: "Repair Type", value: job.repairType, icon: "hammer.fill")
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                RepairJobDetailContentBlock(title: "Financial Overview", icon: "banknote.fill") {
                    VStack(spacing: 10) {
                        RepairJobDetailFieldRow(label: "Estimated Cost", value: currencyString(job.estimatedCost), icon: "dollarsign.circle", accentColor: .orange)
                        RepairJobDetailFieldRow(label: "Actual Cost", value: currencyString(job.actualCost), icon: "creditcard.fill", accentColor: .green)
                        RepairJobDetailFieldRow(label: "Deposit Paid", value: currencyString(job.depositPaid), icon: "banknote", accentColor: .blue)
                        RepairJobDetailFieldRow(label: "Balance Due", value: currencyString(job.actualCost - job.depositPaid), icon: "chart.pie.fill", accentColor: .customIndigo)
                    }
                }
                
                RepairJobDetailContentBlock(title: "Timeline & Delivery", icon: "calendar.badge.clock.fill") {
                    VStack(spacing: 10) {
                        RepairJobDetailFieldRow(label: "Date Received", value: fullDateFormatter.string(from: job.dateReceived), icon: "calendar.badge.plus")
                        RepairJobDetailFieldRow(label: "Est. Completion Date", value: fullDateFormatter.string(from: job.estimatedCompletionDate), icon: "hourglass.badge.fill")
                        
                        if let dateCompleted = job.dateCompleted {
                            RepairJobDetailFieldRow(label: "Date Completed", value: fullDateFormatter.string(from: dateCompleted), icon: "checkmark.circle.fill", accentColor: .green)
                        } else {
                            RepairJobDetailFieldRow(label: "Date Completed", value: "Not Yet Completed", icon: "xmark.circle.fill", accentColor: .gray)
                        }
                        
                        RepairJobDetailFieldRow(label: "Delivery Method", value: job.deliveryMethod, icon: "shippingbox.fill")
                        RepairJobDetailFieldRow(label: "Pickup Location", value: job.pickupLocation, icon: "mappin.and.ellipse")
                    }
                }
                
                RepairJobDetailContentBlock(title: "Issue, Notes & Parts", icon: "note.text.fill") {
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading) {
                            Text("Issue Description").font(.caption).foregroundColor(.gray)
                            Text(job.issueDescription).font(.body)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            Text("Technician Note").font(.caption).foregroundColor(.gray)
                            Text(job.technicianNote.isEmpty ? "N/A" : job.technicianNote).font(.body)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            Text("Customer Feedback").font(.caption).foregroundColor(.gray)
                            Text(job.customerFeedback.isEmpty ? "None Provided" : job.customerFeedback).font(.body)
                        }
                        
                        Divider()

                        VStack(alignment: .leading) {
                            Text("Parts Used").font(.caption).foregroundColor(.gray)
                            Text(job.partsUsed.isEmpty ? "No Parts Used" : job.partsUsed.joined(separator: ", ")).font(.body)
                        }
                    }
                }

                RepairJobDetailContentBlock(title: "Warranty & Metadata", icon: "list.bullet.rectangle.fill") {
                    VStack(spacing: 10) {
                        RepairJobDetailFieldRow(label: "Warranty Provided", value: job.warrantyProvided ? "Yes" : "No", icon: job.warrantyProvided ? "hand.raised.fill" : "nosign", accentColor: job.warrantyProvided ? .green : .red)
                        if job.warrantyProvided {
                            RepairJobDetailFieldRow(label: "Warranty Duration", value: "\(job.warrantyDurationMonths) Months", icon: "goforward.10.ar", accentColor: .blue)
                        }
                        RepairJobDetailFieldRow(label: "Internal Remarks", value: job.internalRemarks.isEmpty ? "None" : job.internalRemarks, icon: "eye.slash.fill", accentColor: .customBrown)

                        VStack(alignment: .leading) {
                            Text("Tags").font(.caption).foregroundColor(.gray)
                            HStack {
                                ForEach(job.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.system(size: 11))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 3)
                                        .background(Color.customTeal.opacity(0.1))
                                        .foregroundColor(.customTeal)
                                        .cornerRadius(4)
                                }
                            }
                        }
                        .padding(.top, 5)

                        HStack(spacing: 20) {
                            RepairJobDetailFieldRow(label: "Created By", value: job.createdBy, icon: "person.badge.plus", accentColor: .gray)
                            RepairJobDetailFieldRow(label: "Last Updated", value: fullDateFormatter.string(from: job.lastUpdated), icon: "arrow.clockwise", accentColor: .gray)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

@available(iOS 14.0, *)
struct RepairJobDetailContentBlock<Content: View>: View {
    let title: String
    let icon: String
    let content: Content

    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.title3)
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.bottom, 5)

            content
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        .padding(.horizontal)
    }
}

@available(iOS 14.0, *)
struct RepairJobDetailFieldRow: View {
    let label: String
    let value: String
    let icon: String
    var accentColor: Color = .blue

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(accentColor)
                .frame(width: 20)
            
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            Spacer()
        }
    }
}
