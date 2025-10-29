

import Foundation
import Combine

final class WatchRepairDataManager: ObservableObject {
    
    @Published var technicians: [Technician] = [] { didSet { saveData() } }
    @Published var repairJobs: [RepairJob] = [] { didSet { saveData() } }
    @Published var customers: [Customer] = [] { didSet { saveData() } }
    @Published var inventoryItems: [InventoryItem] = [] { didSet { saveData() } }
    @Published var paymentHistory: [PaymentHistory] = [] { didSet { saveData() } }
    
    private let techKey = "technicians_data"
    private let jobKey = "repairJobs_data"
    private let custKey = "customers_data"
    private let invKey  = "inventoryItems_data"
    private let payKey  = "paymentHistory_data"
    
    init() {
        loadData()
        loadDummyData()
        
    }
    
    func addTechnician(_ tech: Technician) { technicians.append(tech) }
    func addRepairJob(_ job: RepairJob) { repairJobs.append(job) }
    func addCustomer(_ customer: Customer) { customers.append(customer) }
    func addInventoryItem(_ item: InventoryItem) { inventoryItems.append(item) }
    func addPaymentRecord(_ payment: PaymentHistory) { paymentHistory.append(payment) }
    
    func deleteTechnician(_ tech: Technician) { technicians.removeAll { $0.id == tech.id } }
    func deleteRepairJob(_ job: RepairJob) { repairJobs.removeAll { $0.id == job.id } }
    func deleteCustomer(_ cust: Customer) { customers.removeAll { $0.id == cust.id } }
    func deleteInventoryItem(_ item: InventoryItem) { inventoryItems.removeAll { $0.id == item.id } }
    func deletePaymentRecord(_ pay: PaymentHistory) { paymentHistory.removeAll { $0.id == pay.id } }
    
    private func saveData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(technicians) {
            UserDefaults.standard.set(encoded, forKey: techKey)
        }
        if let encoded = try? encoder.encode(repairJobs) {
            UserDefaults.standard.set(encoded, forKey: jobKey)
        }
        if let encoded = try? encoder.encode(customers) {
            UserDefaults.standard.set(encoded, forKey: custKey)
        }
        if let encoded = try? encoder.encode(inventoryItems) {
            UserDefaults.standard.set(encoded, forKey: invKey)
        }
        if let encoded = try? encoder.encode(paymentHistory) {
            UserDefaults.standard.set(encoded, forKey: payKey)
        }
    }
    
    private func loadData() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: techKey),
           let decoded = try? decoder.decode([Technician].self, from: data) {
            technicians = decoded
        }
        if let data = UserDefaults.standard.data(forKey: jobKey),
           let decoded = try? decoder.decode([RepairJob].self, from: data) {
            repairJobs = decoded
        }
        if let data = UserDefaults.standard.data(forKey: custKey),
           let decoded = try? decoder.decode([Customer].self, from: data) {
            customers = decoded
        }
        if let data = UserDefaults.standard.data(forKey: invKey),
           let decoded = try? decoder.decode([InventoryItem].self, from: data) {
            inventoryItems = decoded
        }
        if let data = UserDefaults.standard.data(forKey: payKey),
           let decoded = try? decoder.decode([PaymentHistory].self, from: data) {
            paymentHistory = decoded
        }
    }
    
    func loadDummyData() {
        technicians = [
            Technician(id: UUID(), name: "Ali Khan", role: "Senior Watchmaker", experienceYears: 10,
                       phone: "03001234567", email: "ali@example.com", address: "Main Street 45",
                       city: "Layyah", country: "Pakistan", joiningDate: Date(),
                       skills: ["Rolex Repair", "Quartz Calibration"], availabilityStatus: "Available",
                       workingHours: "9am - 6pm", certification: "Swiss Certified", hourlyRate: 1200,
                       totalJobsCompleted: 320, notes: "Expert in luxury watches", rating: 4.9,
                       emergencyContact: "03211234567", preferredLanguage: "English", isOnLeave: false,
                       leaveStartDate: nil, leaveEndDate: nil, lastUpdated: Date(),
                       createdBy: "System", tags: ["Pro", "Lead"], active: true)
        ]
        
        repairJobs = [
            RepairJob(id: UUID(), jobNumber: "JOB-001", customerName: "Bilal Ahmed",
                      watchBrand: "Rolex", watchModel: "Submariner", serialNumber: "RX12345",
                      issueDescription: "Water damage", repairType: "Full Service",
                      partsUsed: ["Gasket", "Lubricant"], estimatedCost: 25000,
                      actualCost: 25500, depositPaid: 5000, repairStatus: "In Progress",
                      dateReceived: Date(), dateCompleted: nil, warrantyProvided: true,
                      warrantyDurationMonths: 6, technicianNote: "In progress",
                      customerFeedback: "", priorityLevel: "High",
                      estimatedCompletionDate: Date().addingTimeInterval(86400 * 3),
                      deliveryMethod: "Pickup", pickupLocation: "Main Branch", isFavorite: false,
                      lastUpdated: Date(), createdBy: "System", tags: ["Rolex", "WaterProof"],
                      internalRemarks: "Requires polishing")
        ]
        
        customers = [
            Customer(id: UUID(), fullName: "Bilal Ahmed", phoneNumber: "03123456789",
                     email: "bilal@example.com", addressLine1: "Street 7", addressLine2: "House 22",
                     city: "Layyah", postalCode: "31200", country: "Pakistan",
                     registrationDate: Date(), preferredContactMethod: "Phone", loyaltyPoints: 120,
                     totalSpent: 75000, totalRepairs: 5, averageRating: 4.8,
                     remarks: "Frequent customer", lastVisitDate: Date(), vipStatus: true,
                     occupation: "Engineer", birthDate: nil, gender: "Male", referredBy: "Friend",
                     emergencyContact: "03211234567", subscribedToNewsletter: false,
                     notificationEnabled: true, createdBy: "System", lastUpdated: Date(),
                     tags: ["VIP"])
        ]
        
        inventoryItems = [
            InventoryItem(id: UUID(), partName: "Watch Gasket", partNumber: "WG-01", category: "Seals",
                          brand: "Seiko", quantityInStock: 120, reorderLevel: 20, costPrice: 50,
                          sellingPrice: 150, supplierName: "TimeParts", supplierContact: "03451234567",
                          storageLocation: "Shelf A1", lastRestocked: Date(), expiryDate: nil,
                          condition: "New", compatibleModels: ["Seiko 5", "Citizen ProMaster"],
                          usageCount: 40, notes: "Water resistant gasket", warrantyPeriodMonths: 12,
                          partOriginCountry: "Japan", importDate: Date(), barcode: "1234567890",
                          weightGrams: 5.0, dimensions: "5x5mm", color: "Black", tags: ["Seal", "Gasket"],
                          active: true, lastUpdated: Date(), createdBy: "System")
        ]
        
        paymentHistory = [
            PaymentHistory(id: UUID(), paymentID: "PAY-001", customerName: "Bilal Ahmed",
                           paymentDate: Date(), paymentMethod: "Cash", amount: 5000, currency: "PKR",
                           transactionStatus: "Completed", discountApplied: 0, taxAmount: 0,
                           totalAfterTax: 5000, referenceNumber: "REF123", invoiceNumber: "INV001",
                           isRefunded: false, refundAmount: 0, refundReason: "", remarks: "Advance payment",
                           recordedBy: "Ali Khan", jobReference: "JOB-001", paymentCategory: "Deposit",
                           tags: ["Advance"], location: "Main Branch", approvedBy: "Admin",
                           createdBy: "System", createdDate: Date(), lastUpdated: Date(),
                           verificationStatus: "Verified", syncedOffline: true, duplicateCheckHash: "abc123")
        ]
        
        saveData()
    }
}

struct Technician: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var role: String
    var experienceYears: Int
    var phone: String
    var email: String
    var address: String
    var city: String
    var country: String
    var joiningDate: Date
    var skills: [String]
    var availabilityStatus: String
    var workingHours: String
    var certification: String
    var hourlyRate: Double
    var totalJobsCompleted: Int
    var notes: String
    var rating: Double
    var emergencyContact: String
    var preferredLanguage: String
    var isOnLeave: Bool
    var leaveStartDate: Date?
    var leaveEndDate: Date?
    var lastUpdated: Date
    var createdBy: String
    var tags: [String]
    var active: Bool
}


struct RepairJob: Identifiable, Codable, Hashable {
    var id: UUID
    var jobNumber: String
    var customerName: String
    var watchBrand: String
    var watchModel: String
    var serialNumber: String
    var issueDescription: String
    var repairType: String
    var partsUsed: [String]
    var estimatedCost: Double
    var actualCost: Double
    var depositPaid: Double
    var repairStatus: String
    var dateReceived: Date
    var dateCompleted: Date?
    var warrantyProvided: Bool
    var warrantyDurationMonths: Int
    var technicianNote: String
    var customerFeedback: String
    var priorityLevel: String
    var estimatedCompletionDate: Date
    var deliveryMethod: String
    var pickupLocation: String
    var isFavorite: Bool
    var lastUpdated: Date
    var createdBy: String
    var tags: [String]
    var internalRemarks: String
}

struct Customer: Identifiable, Codable, Hashable {
    var id: UUID
    var fullName: String
    var phoneNumber: String
    var email: String
    var addressLine1: String
    var addressLine2: String
    var city: String
    var postalCode: String
    var country: String
    var registrationDate: Date
    var preferredContactMethod: String
    var loyaltyPoints: Int
    var totalSpent: Double
    var totalRepairs: Int
    var averageRating: Double
    var remarks: String
    var lastVisitDate: Date?
    var vipStatus: Bool
    var occupation: String
    var birthDate: Date?
    var gender: String
    var referredBy: String
    var emergencyContact: String
    var subscribedToNewsletter: Bool
    var notificationEnabled: Bool
    var createdBy: String
    var lastUpdated: Date
    var tags: [String]
}


struct InventoryItem: Identifiable, Codable, Hashable {
    var id: UUID
    var partName: String
    var partNumber: String
    var category: String
    var brand: String
    var quantityInStock: Int
    var reorderLevel: Int
    var costPrice: Double
    var sellingPrice: Double
    var supplierName: String
    var supplierContact: String
    var storageLocation: String
    var lastRestocked: Date
    var expiryDate: Date?
    var condition: String
    var compatibleModels: [String]
    var usageCount: Int
    var notes: String
    var warrantyPeriodMonths: Int
    var partOriginCountry: String
    var importDate: Date?
    var barcode: String
    var weightGrams: Double
    var dimensions: String
    var color: String
    var tags: [String]
    var active: Bool
    var lastUpdated: Date
    var createdBy: String
}


struct PaymentHistory: Identifiable, Codable, Hashable {
    var id: UUID
    var paymentID: String
    var customerName: String
    var paymentDate: Date
    var paymentMethod: String
    var amount: Double
    var currency: String
    var transactionStatus: String
    var discountApplied: Double
    var taxAmount: Double
    var totalAfterTax: Double
    var referenceNumber: String
    var invoiceNumber: String
    var isRefunded: Bool
    var refundAmount: Double
    var refundReason: String
    var remarks: String
    var recordedBy: String
    var jobReference: String
    var paymentCategory: String
    var tags: [String]
    var location: String
    var approvedBy: String
    var createdBy: String
    var createdDate: Date
    var lastUpdated: Date
    var verificationStatus: String
    var syncedOffline: Bool
    var duplicateCheckHash: String
}
