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
    case pending = "Pending (Cash on Delivery)"
    case confirmed = "Confirmed"
    case active = "Active"
    case completed = "Completed"
    case cancelled = "Cancelled"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self)
        if rawString == "Pending" || rawString == "Pending Payment" {
            self = .pending
        } else if let validStatus = OrderStatus(rawValue: rawString) {
            self = validStatus
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot initialize OrderStatus from invalid String value \(rawString)")
        }
    }
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
