import Foundation

struct OrderItem: Identifiable, Codable, Hashable {
    var id = UUID()
    var machine: Machine
    var quantity: Int
}

struct Order: Identifiable, Codable, Hashable {
    var id = UUID()
    var date: Date
    var items: [OrderItem]
    var totalAmount: Double
    var shippingAddress: Address
    var status: String
}
