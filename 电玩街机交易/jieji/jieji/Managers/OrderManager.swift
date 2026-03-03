import Foundation
import Combine

class OrderManager: ObservableObject {
    @Published var orders: [Order] = [] {
        didSet {
            save()
        }
    }
    
    private let key = "SavedOrders"
    
    init() {
        load()
    }
    
    func createOrder(items: [OrderItem], totalAmount: Double, address: Address, status: String = "Pending Payment") -> UUID {
        let order = Order(date: Date(), items: items, totalAmount: totalAmount, shippingAddress: address, status: status)
        orders.insert(order, at: 0)
        return order.id
    }
    
    func updateOrderStatus(id: UUID, newStatus: String) {
        if let index = orders.firstIndex(where: { $0.id == id }) {
            orders[index].status = newStatus
            save()
        }
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(orders) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode([Order].self, from: data) {
            orders = saved
        }
    }
}
