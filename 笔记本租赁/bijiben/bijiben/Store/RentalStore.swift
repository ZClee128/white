import Foundation
import Combine
import UIKit

@MainActor
final class RentalStore: ObservableObject {

    @Published var laptops: [Laptop] = Laptop.sampleData
    @Published var orders: [RentalOrder] = []
    
    private let ordersKey = "rental_orders_v1"

    init() {
        loadOrders()
    }

    // MARK: - Payment
    // Cash on Delivery: no external payment SDK required.

    // MARK: - Order Management
    func createOrder(
        laptop: Laptop,
        duration: RentalDuration,
        totalPrice: Double,
        contactName: String,
        contactPhone: String,
        deliveryAddress: String
    ) -> RentalOrder {
        let order = RentalOrder(
            laptopId: laptop.id,
            laptopName: laptop.name,
            laptopBrand: laptop.brand,
            duration: duration,
            totalPrice: totalPrice,
            contactName: contactName,
            contactPhone: contactPhone,
            deliveryAddress: deliveryAddress
        )
        orders.insert(order, at: 0)
        saveOrders()
        return order
    }

    func confirmPayment(for orderId: UUID) {
        if let index = orders.firstIndex(where: { $0.id == orderId }) {
            orders[index].status = .paid
            saveOrders()
        }
    }

    private func saveOrders() {
        if let encoded = try? JSONEncoder().encode(orders) {
            UserDefaults.standard.set(encoded, forKey: ordersKey)
        }
    }

    private func loadOrders() {
        if let data = UserDefaults.standard.data(forKey: ordersKey),
           let decoded = try? JSONDecoder().decode([RentalOrder].self, from: data) {
            orders = decoded
        }
    }
}
