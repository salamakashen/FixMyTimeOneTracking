

import SwiftUI


extension Color {
    static let primaryAccent = Color(red: 0.1, green: 0.4, blue: 0.7) // Deep Blue
    static let secondaryAccent = Color(red: 0.9, green: 0.6, blue: 0.1) // Gold/Amber
    static let backgroundPrimary = Color(.systemGroupedBackground)
}

@available(iOS 14.0, *)
struct DashboardHeader: View {
    var title: String
    var iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.secondaryAccent)
                .padding(.trailing, 4)
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primaryAccent)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 20)
        .background(Color.clear)
    }
}




@available(iOS 14.0, *)
struct WatchRepairDashboard: View {
    @StateObject var dataManager = WatchRepairDataManager()
    
    var body: some View {
        TabView {
            NavigationView {
                VStack(spacing: 0) {
                    DashboardHeader(title: "Technicians", iconName: "person.3.fill")
                    TechnicianListView().padding(.top, -10)
                }
            }
            .tabItem {
                Label("Techs", systemImage: "person.2.circle.fill")
            }
            
            NavigationView {
                VStack(spacing: 0) {
                    DashboardHeader(title: "Repair Jobs", iconName: "wrench.and.screwdriver.fill")
                    RepairJobListRootView().padding(.top, -10)
                }
            }
            .tabItem {
                Label("Jobs", systemImage: "clock.fill")
            }
            
            NavigationView {
                VStack(spacing: 0) {
                    DashboardHeader(title: "Customers", iconName: "person.text.rectangle.fill")
                    CustomerListView().padding(.top, -10)
                }
            }
            .tabItem {
                Label("Customers", systemImage: "person.crop.circle.fill")
            }
            
            NavigationView {
                VStack(spacing: 0) {
                    DashboardHeader(title: "Inventory", iconName: "shippingbox.fill")
                    InventoryItemListView().padding(.top, -10)
                }
            }
            .tabItem {
                Label("Inventory", systemImage: "cube.box.fill")
            }
            
            NavigationView {
                VStack(spacing: 0) {
                    DashboardHeader(title: "Payments", iconName: "creditcard.fill")
                    PaymentHistoryListView().padding(.top, -10)
                }
            }
            .tabItem {
                Label("Payments", systemImage: "dollarsign.circle.fill")
            }
        }
        .accentColor(.primaryAccent)
        .environmentObject(dataManager)
    }
}
