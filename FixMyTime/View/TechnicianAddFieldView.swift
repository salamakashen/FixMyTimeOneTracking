
import SwiftUI
import Combine


@available(iOS 14.0, *)
extension Color {
    static let customIndigo = Color(red: 0.35, green: 0.34, blue: 0.84)
    static let customCyan = Color(red: 0.23, green: 0.85, blue: 0.75)
    static let customPink = Color(red: 1.00, green: 0.30, blue: 0.60)
}

@available(iOS 14.0, *)
struct TechnicianAddFieldView: View {
    let title: String
    @Binding var text: String
    let iconName: String
    var keyboardType: UIKeyboardType = .default
    
    @State private var isFocused: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(isFocused ? .blue : .gray)
                    .frame(width: 20)
                
                TextField(title, text: $text, onEditingChanged: { editing in
                    withAnimation {
                        isFocused = editing
                    }
                })
                .keyboardType(keyboardType)
                .padding(.vertical, 8)
                .foregroundColor(.primary)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? Color.blue : Color(.separator), lineWidth: 1)
            )
        }
    }
}


@available(iOS 14.0, *)
struct TechnicianAddDatePickerView: View {
    let title: String
    @Binding var date: Date
    let iconName: String
    var isOptional: Bool = false
    @Binding var isToggled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                    .frame(width: 20)
                
                Text(title)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if isOptional {
                    Toggle("", isOn: $isToggled)
                        .labelsHidden()
                        .accentColor(.blue)
                }
            }
            .padding(.horizontal)
            
            if !isOptional || isToggled {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(CompactDatePickerStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
}

@available(iOS 14.0, *)
struct TechnicianAddStepperView: View {
    let title: String
    @Binding var value: Int
    let iconName: String
    let range: ClosedRange<Int>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                    .frame(width: 20)
                
                Text(title)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Stepper(value: $value, in: range) {
                    Text("\(value)")
                        .fontWeight(.semibold)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
}

@available(iOS 14.0, *)
struct TechnicianAddDoubleStepperView: View {
    let title: String
    @Binding var value: Double
    let iconName: String
    let step: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.gray)
                    .frame(width: 20)
                
                Text(title)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Stepper(value: $value, in: 0...100.0, step: step) {
                    Text(String(format: "%.1f", value))
                        .fontWeight(.semibold)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
}

@available(iOS 14.0, *)
struct TechnicianAddToggleView: View {
    let title: String
    @Binding var isOn: Bool
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            Text(title)
                .foregroundColor(.gray)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .accentColor(.blue)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
}

@available(iOS 14.0, *)
struct TechnicianAddSectionHeaderView: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.leading,20)
    }
}

// MARK: - 1. TechnicianAddView

@available(iOS 14.0, *)
struct TechnicianAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: WatchRepairDataManager
    
    @State private var name: String = ""
    @State private var role: String = ""
    @State private var experienceYears: Int = 0
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var address: String = ""
    @State private var city: String = ""
    @State private var country: String = ""
    @State private var joiningDate: Date = Date()
    @State private var skills: String = ""
    @State private var availabilityStatus: String = "Available"
    @State private var workingHours: String = ""
    @State private var certification: String = ""
    @State private var hourlyRate: Double = 0.0
    @State private var totalJobsCompleted: Int = 0
    @State private var notes: String = ""
    @State private var rating: Double = 5.0
    @State private var emergencyContact: String = ""
    @State private var preferredLanguage: String = "English"
    @State private var isOnLeave: Bool = false
    @State private var leaveStartDate: Date = Date()
    @State private var leaveEndDate: Date = Date()
    @State private var isLeaveStartDateToggled: Bool = false
    @State private var isLeaveEndDateToggled: Bool = false
    @State private var createdBy: String = "User"
    @State private var tags: String = ""
    @State private var active: Bool = true
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let statusOptions = ["Available", "Busy", "On Job", "Unavailable"]
    
    private func validateAndSave() {
        var errors: [String] = []
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Name is required.") }
        if role.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Role is required.") }
        if experienceYears < 0 { errors.append("Experience Years must be non-negative.") }
        if phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Phone is required.") }
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !email.contains("@") { errors.append("Valid Email is required.") }
        if hourlyRate <= 0.0 { errors.append("Hourly Rate must be positive.") }
        if workingHours.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { errors.append("Working Hours are required.") }
        
        if errors.isEmpty {
            let newTechnician = Technician(
                id: UUID(),
                name: name,
                role: role,
                experienceYears: experienceYears,
                phone: phone,
                email: email,
                address: address,
                city: city,
                country: country,
                joiningDate: joiningDate,
                skills: skills.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
                availabilityStatus: availabilityStatus,
                workingHours: workingHours,
                certification: certification,
                hourlyRate: hourlyRate,
                totalJobsCompleted: totalJobsCompleted,
                notes: notes,
                rating: rating,
                emergencyContact: emergencyContact,
                preferredLanguage: preferredLanguage,
                isOnLeave: isOnLeave,
                leaveStartDate: isLeaveStartDateToggled && isOnLeave ? leaveStartDate : nil,
                leaveEndDate: isLeaveEndDateToggled && isOnLeave ? leaveEndDate : nil,
                lastUpdated: Date(),
                createdBy: createdBy,
                tags: tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
                active: active
            )
            
            dataManager.addTechnician(newTechnician)
            alertMessage = "✅ Technician **\(name)** added successfully!"
            showingAlert = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                presentationMode.wrappedValue.dismiss()
            }
        } else {
            alertMessage = "🚫 **Validation Errors**:\n" + errors.joined(separator: "\n")
            showingAlert = true
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                TechnicianAddSectionHeaderView(title: "Personal Details", iconName: "person.text.rectangle")
                
                VStack(spacing: 15) {
                    TechnicianAddFieldView(title: "Full Name", text: $name, iconName: "person.fill")
                    TechnicianAddFieldView(title: "Role", text: $role, iconName: "briefcase.fill")
                    TechnicianAddFieldView(title: "Email", text: $email, iconName: "envelope.fill", keyboardType: .emailAddress)
                    HStack(spacing: 15) {
                        TechnicianAddFieldView(title: "Phone", text: $phone, iconName: "phone.fill", keyboardType: .phonePad)
                        TechnicianAddFieldView(title: "Emergency Contact", text: $emergencyContact, iconName: "exclamationmark.triangle.fill", keyboardType: .phonePad)
                    }
                }
                .padding(.horizontal)
                
                TechnicianAddSectionHeaderView(title: "Location Info", iconName: "map.fill")
                
                VStack(spacing: 15) {
                    TechnicianAddFieldView(title: "Address", text: $address, iconName: "house.fill")
                    HStack(spacing: 15) {
                        TechnicianAddFieldView(title: "City", text: $city, iconName: "building.2.fill")
                        TechnicianAddFieldView(title: "Country", text: $country, iconName: "globe")
                    }
                }
                .padding(.horizontal)
                
                TechnicianAddSectionHeaderView(title: "Professional Metrics", iconName: "chart.bar.fill")
                
                VStack(spacing: 15) {
                    
                    TechnicianAddStepperView(title: "Experience (Years)", value: $experienceYears, iconName: "clock.fill", range: 0...50)
                    TechnicianAddDoubleStepperView(title: "Rating (5.0 Max)", value: $rating, iconName: "star.fill", step: 0.1)
                    
                    TechnicianAddDoubleStepperView(title: "Hourly Rate", value: $hourlyRate, iconName: "dollarsign.circle.fill", step: 100.0)
                    TechnicianAddStepperView(title: "Total Jobs Completed", value: $totalJobsCompleted, iconName: "checkmark.seal.fill", range: 0...1000)
                    
                    TechnicianAddDatePickerView(title: "Joining Date", date: $joiningDate, iconName: "calendar", isToggled: .constant(false))
                    TechnicianAddFieldView(title: "Working Hours", text: $workingHours, iconName: "timer")
                }
                .padding(.horizontal)
                
                TechnicianAddSectionHeaderView(title: "Status & Details", iconName: "list.bullet.clipboard.fill")
                
                VStack(spacing: 15) {
                    TechnicianAddFieldView(title: "Skills (Comma separated)", text: $skills, iconName: "wrench.and.screwdriver.fill")
                    TechnicianAddFieldView(title: "Certification", text: $certification, iconName: "medal.fill")
                    TechnicianAddFieldView(title: "Preferred Language", text: $preferredLanguage, iconName: "message.fill")
                    TechnicianAddFieldView(title: "Notes", text: $notes, iconName: "note.text")
                    TechnicianAddFieldView(title: "Tags (Comma separated)", text: $tags, iconName: "tag.fill")
                    TechnicianAddFieldView(title: "Created By", text: $createdBy, iconName: "person.circle.fill")
                    
                    HStack(spacing: 15) {
                        TechnicianAddToggleView(title: "Active", isOn: $active, iconName: "power")
                        
                        Picker(selection: $availabilityStatus, label: Text("Status")) {
                            ForEach(statusOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.separator), lineWidth: 1))
                    }
                }
                .padding(.horizontal)
                
                TechnicianAddSectionHeaderView(title: "Leave Management", iconName: "bed.double.fill")
                
                VStack(spacing: 15) {
                    TechnicianAddToggleView(title: "On Leave", isOn: $isOnLeave, iconName: "figure.walk")
                    
                    TechnicianAddDatePickerView(title: "Leave Start Date (Optional)", date: $leaveStartDate, iconName: "arrow.right.to.line.compact", isOptional: true, isToggled: $isLeaveStartDateToggled)
                        .opacity(isOnLeave ? 1 : 0.5)
                        .disabled(!isOnLeave)
                    
                    TechnicianAddDatePickerView(title: "Leave End Date (Optional)", date: $leaveEndDate, iconName: "arrow.left.to.line.compact", isOptional: true, isToggled: $isLeaveEndDateToggled)
                        .opacity(isOnLeave ? 1 : 0.5)
                        .disabled(!isOnLeave)
                }
                .padding(.horizontal)
                
                Button(action: validateAndSave) {
                    Text("Add Technician")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("New Technician Onboarding")
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text(alertMessage.contains("✅") ? "Success" : "Error"),
                message: Text(alertMessage).foregroundColor(alertMessage.contains("✅") ? .green : .red),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// MARK: - 2. TechnicianListView

@available(iOS 14.0, *)
struct TechnicianSearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search by name, role, or skills...", text: $searchText)
                .padding(.vertical, 10)
                .foregroundColor(.primary)
            
            if !searchText.isEmpty {
                Button(action: {
                    withAnimation {
                        searchText = ""
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

@available(iOS 14.0, *)
struct TechnicianNoDataView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
                .font(.system(size: 80))
                .foregroundColor(.orange)
            
            Text("No Technicians Found")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Try adjusting your search filters or add a new technician to the system.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .padding(.top, 50)
    }
}

@available(iOS 14.0, *)
struct TechnicianListRowView: View {
    let technician: Technician
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(technician.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text(technician.role)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(technician.availabilityStatus)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(5)
                        .background(technician.active ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                        .foregroundColor(technician.active ? .green : .red)
                        .cornerRadius(8)
                    
                    Text(String(format: "%.1f ★", technician.rating))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                }
            }
            
            Divider()
            
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    DetailRowItem(icon: "phone.fill", label: "Contact", value: technician.phone)
                    DetailRowItem(icon: "map.fill", label: "Location", value: "\(technician.city), \(technician.country)")
                    DetailRowItem(icon: "calendar.badge.clock", label: "Joined", value: DateFormatter.localizedString(from: technician.joiningDate, dateStyle: .short, timeStyle: .none))
                    DetailRowItem(icon: "dollarsign.circle.fill", label: "Rate", value: "PKR \(String(format: "%.0f", technician.hourlyRate))")
                    DetailRowItem(icon: "briefcase.fill", label: "Working", value: technician.workingHours)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    DetailRowItem(icon: "wrench.and.screwdriver.fill", label: "Skills", value: technician.skills.joined(separator: ", "))
                    DetailRowItem(icon: "checkmark.seal.fill", label: "Jobs Done", value: "\(technician.totalJobsCompleted)")
                    DetailRowItem(icon: "medal.fill", label: "Certification", value: technician.certification)
                    DetailRowItem(icon: "clock.fill", label: "Experience", value: "\(technician.experienceYears) Yrs")
                    DetailRowItem(icon: "tag.fill", label: "Tags", value: technician.tags.joined(separator: ", "))
                }
            }
            .font(.caption)
            
            if technician.isOnLeave {
                Text("On Leave: \(technician.leaveStartDate != nil ? DateFormatter.localizedString(from: technician.leaveStartDate!, dateStyle: .short, timeStyle: .none) : "") - \(technician.leaveEndDate != nil ? DateFormatter.localizedString(from: technician.leaveEndDate!, dateStyle: .short, timeStyle: .none) : "")")
                    .font(.caption2)
                    .foregroundColor(.red)
                    .padding(4)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 10)
    }
}

@available(iOS 14.0, *)
private struct DetailRowItem: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 15)
            Text("\(label):")
                .fontWeight(.medium)
            
            Spacer()
            Text(value)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
    }
}

@available(iOS 14.0, *)
struct TechnicianListView: View {
    @EnvironmentObject var dataManager: WatchRepairDataManager
    @State private var searchText: String = ""
    @State private var showingAddView = false
    
    var filteredTechnicians: [Technician] {
        if searchText.isEmpty {
            return dataManager.technicians
        } else {
            return dataManager.technicians.filter { tech in
                tech.name.localizedCaseInsensitiveContains(searchText) ||
                tech.role.localizedCaseInsensitiveContains(searchText) ||
                tech.skills.joined(separator: " ").localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                
                TechnicianSearchBarView(searchText: $searchText)
                    .padding([.horizontal, .top])
                
                if filteredTechnicians.isEmpty {
                    TechnicianNoDataView()
                    Spacer()
                } else {
                    List {
                        ForEach(filteredTechnicians) { technician in
                            NavigationLink(destination: TechnicianDetailView(technician: technician)) {
                                TechnicianListRowView(technician: technician)
                                    .padding(.vertical, 5)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteTechnician)
                    }
                    .listStyle(PlainListStyle())
                    .padding(.top, 10)
                }
            }
            .sheet(isPresented: $showingAddView) {
                NavigationView {
                    TechnicianAddView()
                        .environmentObject(dataManager)
                }
            }
            .navigationBarItems(trailing:
                Button(action: { showingAddView = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            )
        
    }
    
    private func deleteTechnician(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredTechnicians[$0] }.forEach(dataManager.deleteTechnician)
        }
    }
}


// MARK: - 3. TechnicianDetailView

@available(iOS 14.0, *)
struct TechnicianDetailFieldRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.caption)
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.leading, 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}

@available(iOS 14.0, *)
struct TechnicianDetailView: View {
    let technician: Technician
    
    private func formatLeaveDates() -> String {
        guard technician.isOnLeave else { return "N/A" }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        var dateString = ""
        if let start = technician.leaveStartDate {
            dateString += "Start: \(formatter.string(from: start))"
        }
        if let end = technician.leaveEndDate {
            dateString += dateString.isEmpty ? "" : " | "
            dateString += "End: \(formatter.string(from: end))"
        }
        
        return dateString.isEmpty ? "Dates Pending" : dateString
    }
    
    private let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy" // 🔹 Example: "14 Oct 2025"
        return formatter
    }()

    private let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy, h:mm a" // Example: "14 Oct 2025, 10:45 AM"
        return formatter
    }()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                VStack(alignment: .center, spacing: 10) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                    
                    Text(technician.name)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    
                    HStack {
                        Image(systemName: "briefcase.fill")
                        Text(technician.role)
                            .font(.title2)
                    }
                    .foregroundColor(.gray)
                    
                    Text(technician.availabilityStatus)
                        .font(.headline)
                        .padding(5)
                        .padding(.horizontal, 10)
                        .background(technician.active ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                        .foregroundColor(technician.active ? .green : .red)
                        .cornerRadius(10)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Contact Information")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 15) {
                        HStack {
                            TechnicianDetailFieldRow(icon: "phone.fill", label: "Primary Phone", value: technician.phone, color: .green)
                            TechnicianDetailFieldRow(icon: "exclamationmark.triangle.fill", label: "Emergency Contact", value: technician.emergencyContact, color: .orange)
                        }
                        HStack {
                            TechnicianDetailFieldRow(icon: "envelope.fill", label: "Email Address", value: technician.email, color: .blue)
                            TechnicianDetailFieldRow(icon: "map.fill", label: "City / Country", value: "\(technician.city), \(technician.country)", color: .customIndigo)
                        }
                        TechnicianDetailFieldRow(icon: "house.fill", label: "Full Address", value: technician.address, color: .purple)
                        TechnicianDetailFieldRow(icon: "message.fill", label: "Preferred Language", value: technician.preferredLanguage, color: .gray)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Work & Performance")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 15) {
                        HStack {
                            TechnicianDetailFieldRow(icon: "star.fill", label: "Average Rating", value: String(format: "%.2f", technician.rating), color: .yellow)
                            TechnicianDetailFieldRow(icon: "checkmark.seal.fill", label: "Jobs Completed", value: "\(technician.totalJobsCompleted)", color: .green)
                        }
                        HStack {
                            TechnicianDetailFieldRow(icon: "dollarsign.circle.fill", label: "Hourly Rate", value: "PKR \(String(format: "%.0f", technician.hourlyRate))", color: .red)
                            TechnicianDetailFieldRow(icon: "clock.fill", label: "Experience (Years)", value: "\(technician.experienceYears)", color: .gray)
                        }
                        HStack {
                            TechnicianDetailFieldRow(
                                icon: "calendar",
                                label: "Joining Date",
                                value: shortDateFormatter.string(from: technician.joiningDate),
                                color: .orange
                            )
                            TechnicianDetailFieldRow(icon: "timer", label: "Working Hours", value: technician.workingHours, color: .customIndigo)
                        }
                        TechnicianDetailFieldRow(icon: "gearshape.fill", label: "Skills", value: technician.skills.joined(separator: ", "), color: .customCyan)
                        TechnicianDetailFieldRow(icon: "note.text.fill", label: "Notes", value: technician.notes, color: .customPink)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("System & Leave")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 15) {
                        HStack {
                            TechnicianDetailFieldRow(icon: "leaf.fill", label: "On Leave", value: technician.isOnLeave ? "YES" : "NO", color: technician.isOnLeave ? .red : .green)
                            TechnicianDetailFieldRow(icon: "calendar.badge.minus", label: "Leave Dates", value: formatLeaveDates(), color: .red)
                        }
                        HStack {
                            TechnicianDetailFieldRow(icon: "list.bullet.rectangle.fill", label: "Certification", value: technician.certification, color: .yellow)
                            TechnicianDetailFieldRow(icon: "power", label: "Active Status", value: technician.active ? "Active" : "Inactive", color: technician.active ? .green : .red)
                        }
                        TechnicianDetailFieldRow(icon: "tag.circle.fill", label: "Tags", value: technician.tags.joined(separator: ", "), color: .customTeal)
                        TechnicianDetailFieldRow(icon: "hammer.fill", label: "Created By", value: technician.createdBy, color: .customBrown)
                        TechnicianDetailFieldRow(
                            icon: "clock.arrow.circlepath",
                            label: "Last Updated",
                            value: dateTimeFormatter.string(from: technician.lastUpdated),
                            color: .gray
                        )

 
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                }
                
            }
            .padding()
        }
        .navigationTitle(technician.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
