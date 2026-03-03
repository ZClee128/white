import Foundation
import Combine

class CartManager: ObservableObject {
    @Published var items: [OrderItem] = [] {
        didSet {
            save()
        }
    }
    
    private let key = "SavedCart"
    
    init() {
        load()
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + ($1.machine.price * Double($1.quantity)) }
    }
    
    func addToCart(machine: Machine) {
        if let index = items.firstIndex(where: { $0.machine.id == machine.id }) {
            var updatedItem = items[index]
            updatedItem.quantity += 1
            items[index] = updatedItem
        } else {
            items.append(OrderItem(machine: machine, quantity: 1))
        }
    }
    
    func removeFromCart(machine: Machine) {
        if let index = items.firstIndex(where: { $0.machine.id == machine.id }) {
            if items[index].quantity > 1 {
                var updatedItem = items[index]
                updatedItem.quantity -= 1
                items[index] = updatedItem
            } else {
                items.remove(at: index)
            }
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode([OrderItem].self, from: data) {
            items = saved
        }
    }
}
