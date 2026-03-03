import Foundation

struct BouncyCastle: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let headline: String
    let description: String
    let imageName: String
    let pricePerDay: Double
    let dimensions: String
    let capacity: Int
    let themeColorHex: String // To make the UI dynamic and "not spammy"
    let tags: [String]
}

struct Address: Codable, Hashable {
    var fullName: String
    var phoneNumber: String
    var streetAddress: String
    var city: String
    var state: String
    var zipCode: String
}

enum OrderStatus: String, Codable {
    case pending = "Pending Payment"
    case confirmed = "Confirmed"
    case active = "Active"
    case completed = "Completed"
    case cancelled = "Cancelled"
}

struct Order: Identifiable, Codable, Hashable {
    let id: UUID
    let bouncyCastleId: UUID
    let address: Address
    let totalAmount: Double
    let orderDate: Date
    var status: OrderStatus
    var wechatTransactionId: String? // Simulated
}

let address = Address(fullName: "Test", phoneNumber: "123", streetAddress: "123", city: "City", state: "State", zipCode: "12345")
let order = Order(id: UUID(), bouncyCastleId: UUID(), address: address, totalAmount: 100, orderDate: Date(), status: .pending, wechatTransactionId: nil)

do {
    let encoded = try JSONEncoder().encode([order])
    print(String(data: encoded, encoding: .utf8)!)
    let decoded = try JSONDecoder().decode([Order].self, from: encoded)
    print("Success: \(decoded.count)")
} catch {
    print("Error: \(error)")
}
