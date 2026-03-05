import Foundation
import Combine

class OrderManager: ObservableObject {
    @Published var orders: [Order] = []
    
    private let ordersKey = "zhangshang_orders_key"
    
    init() {
        loadOrders()
    }
    
    func loadOrders() {
        guard let data = UserDefaults.standard.data(forKey: ordersKey) else { return }
        do {
            let decoder = JSONDecoder()
            orders = try decoder.decode([Order].self, from: data)
        } catch {
            print("Failed to load orders: \(error)")
        }
    }
    
    func saveOrders() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(orders)
            UserDefaults.standard.set(data, forKey: ordersKey)
        } catch {
            print("Failed to save orders: \(error)")
        }
    }
    
    func createOrder(console: Console, days: Int, activePrice: Double? = nil) {
        let priceToUse = activePrice ?? console.dailyPrice
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: days, to: startDate)!
        let total = priceToUse * Double(days) + console.deposit
        
        let newOrder = Order(
            console: console,
            startDate: startDate,
            endDate: endDate,
            totalPrice: total,
            status: .renting
        )
        
        orders.insert(newOrder, at: 0) // Newest first
        saveOrders()
    }
    
    func returnOrder(orderId: UUID) {
        if let index = orders.firstIndex(where: { $0.id == orderId }) {
            orders[index].status = .returned
            saveOrders()
        }
    }
    
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "CNY"
        formatter.currencySymbol = "$"
        return formatter.string(from: NSNumber(value: amount)) ?? "$\(String(format: "%.2f", amount))"
    }
}
