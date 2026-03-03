import Foundation
import Observation
import UIKit

@Observable
@MainActor
final class RentalStore {
    var laptops: [Laptop] = Laptop.sampleData
    var orders: [RentalOrder] = []
    
    private let ordersKey = "rental_orders_v1"

    init() {
        loadOrders()
    }

    // MARK: - WeChat Detection
    func isWeChatInstalled() -> Bool {
        guard let url = URL(string: "weixin://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    func openWeChat(amount: Double, orderNumber: String) {
        // Launch WeChat for payment (no SDK needed – compliant with App Store review)
        // In production, integrate proper WeChat Pay URL scheme with your merchant params
        if let url = URL(string: "weixin://") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func openWeChatAppStore() {
        // WeChat on App Store
        if let url = URL(string: "https://apps.apple.com/app/wechat/id414478124") {
            UIApplication.shared.open(url)
        }
    }

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
