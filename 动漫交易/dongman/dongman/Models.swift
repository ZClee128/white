import Foundation
import SwiftUI

// MARK: - Enums

enum FigureCondition: String, CaseIterable, Codable {
    case mint = "Mint"
    case excellent = "Excellent"
    case good = "Good"
    case fair = "Fair"

    var color: Color {
        switch self {
        case .mint: return Color(red: 0.0, green: 0.78, blue: 0.55)
        case .excellent: return Color(red: 0.2, green: 0.6, blue: 1.0)
        case .good: return Color(red: 1.0, green: 0.75, blue: 0.0)
        case .fair: return Color(red: 1.0, green: 0.4, blue: 0.2)
        }
    }
}

enum FigureCategory: String, CaseIterable, Codable {
    case all = "All"
    case nendoroid = "Nendoroid"
    case scale = "Scale"
    case figma = "Figma"
    case prize = "Prize"
    case garageKit = "Garage Kit"

    var icon: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .nendoroid: return "person.crop.circle"
        case .scale: return "star.circle"
        case .figma: return "figure.stand"
        case .prize: return "gift"
        case .garageKit: return "wrench.and.screwdriver"
        }
    }
}

enum OrderStatus: String, CaseIterable, Codable {
    case pending = "Pending"
    case confirmed = "Confirmed"
    case shipped = "Shipped"
    case delivered = "Delivered"

    var color: Color {
        switch self {
        case .pending: return .orange
        case .confirmed: return .blue
        case .shipped: return Color(red: 0.2, green: 0.6, blue: 1.0)
        case .delivered: return Color(red: 0.0, green: 0.78, blue: 0.55)
        }
    }

    var icon: String {
        switch self {
        case .pending: return "clock"
        case .confirmed: return "checkmark.circle"
        case .shipped: return "shippingbox"
        case .delivered: return "checkmark.seal.fill"
        }
    }
}

// MARK: - Models



struct Seller: Identifiable, Codable {
    let id: UUID
    var name: String
    var avatarInitial: String
    var rating: Double
    var totalSold: Int
    var location: String
}

struct Figure: Identifiable, Codable {
    let id: UUID
    var name: String
    var series: String
    var character: String
    var scale: String
    var manufacturer: String
    var condition: FigureCondition
    var price: Double
    var originalPrice: Double
    var seller: Seller
    var systemImageName: String
    var accentColorHex: String
    var description: String
    var category: FigureCategory
    var stock: Int
    var isFlashSale: Bool

    var discountPercent: Int {
        guard originalPrice > 0 else { return 0 }
        return Int(((originalPrice - price) / originalPrice) * 100)
    }
}

struct Order: Identifiable, Codable {
    let id: UUID
    var figure: Figure
    var status: OrderStatus
    var orderDate: Date
    var quantity: Int
    var total: Double
    var orderNumber: String

    var estimatedDelivery: Date {
        orderDate.addingTimeInterval(60 * 60 * 24 * 7)
    }
}



struct ChatMessage: Identifiable {
    let id: UUID
    var senderName: String
    var content: String
    var timestamp: Date
    var isFromCurrentUser: Bool
}
