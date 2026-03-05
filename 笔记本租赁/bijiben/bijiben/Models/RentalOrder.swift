import Foundation

enum RentalDuration: Int, CaseIterable, Codable {
    case oneDay = 1
    case threeDays = 3
    case sevenDays = 7
    case fifteenDays = 15
    case thirtyDays = 30

    var label: String {
        switch self {
        case .oneDay: return "1 Day"
        case .threeDays: return "3 Days"
        case .sevenDays: return "1 Week"
        case .fifteenDays: return "15 Days"
        case .thirtyDays: return "1 Month"
        }
    }

    func totalPrice(daily: Double, weekly: Double, monthly: Double, isDiscounted: Bool = false) -> Double {
        let basePrice: Double
        switch self {
        case .oneDay: basePrice = daily
        case .threeDays: basePrice = daily * 3
        case .sevenDays: basePrice = weekly
        case .fifteenDays: basePrice = weekly * 2 + daily
        case .thirtyDays: basePrice = monthly
        }
        return isDiscounted ? basePrice * 0.7 : basePrice
    }
}

enum OrderStatus: String, Codable, CaseIterable, Hashable {
    case pending = "Order Placed"
    case paid = "Confirmed"
    case active = "Out for Delivery"
    case returned = "Returned"

    var color: String {
        switch self {
        case .pending: return "orange"
        case .paid: return "blue"
        case .active: return "green"
        case .returned: return "gray"
        }
    }

    var icon: String {
        switch self {
        case .pending: return "checkmark.circle.fill"
        case .paid: return "shippingbox.fill"
        case .active: return "box.truck.fill"
        case .returned: return "arrow.uturn.left.circle.fill"
        }
    }
}

struct RentalOrder: Identifiable, Codable, Hashable {
    let id: UUID
    let laptopId: String
    let laptopName: String
    let laptopBrand: String
    let duration: RentalDuration
    let totalPrice: Double
    let contactName: String
    let contactPhone: String
    let deliveryAddress: String
    let createdAt: Date
    var status: OrderStatus
    var orderNumber: String

    init(
        id: UUID = UUID(),
        laptopId: String,
        laptopName: String,
        laptopBrand: String,
        duration: RentalDuration,
        totalPrice: Double,
        contactName: String,
        contactPhone: String,
        deliveryAddress: String,
        createdAt: Date = Date(),
        status: OrderStatus = .pending
    ) {
        self.id = id
        self.laptopId = laptopId
        self.laptopName = laptopName
        self.laptopBrand = laptopBrand
        self.duration = duration
        self.totalPrice = totalPrice
        self.contactName = contactName
        self.contactPhone = contactPhone
        self.deliveryAddress = deliveryAddress
        self.createdAt = createdAt
        self.status = status
        self.orderNumber = "RNT\(Int(createdAt.timeIntervalSince1970) % 1000000)"
    }
}
