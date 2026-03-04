import Foundation
import Combine

struct Product: Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var brand: String
    var pricePerDay: Double
    var originalPrice: Double
    var description: String
    var imageURL: String
    var specifications: [String]
    var isFeatured: Bool = false
    var rating: Double = 4.8
    var reviewsCount: Int = 120
}

enum OrderStatus: String, Codable {
    case pendingPayment = "Pending Payment"
    case paid = "Paid"
    case shipped = "Shipped"
    case completed = "Completed"
    case canceled = "Canceled"
}

struct Order: Identifiable {
    var id: UUID = UUID()
    var orderNumber: String
    var product: Product
    var rentalDays: Int
    var status: OrderStatus
    var totalAmount: Double
    var date: Date
}

struct Address: Identifiable, Hashable {
    var id: UUID = UUID()
    var fullName: String
    var phoneNumber: String
    var streetAddress: String
    var city: String
    var state: String
    var zipCode: String
}

class AppState: ObservableObject {
    @Published var cart: [Product] = []
    @Published var orders: [Order] = []
    @Published var currentAddress: Address? = Address(fullName: "John Doe", phoneNumber: "+1 800-555-0199", streetAddress: "123 Innovation Drive", city: "San Francisco", state: "CA", zipCode: "94107")
    
    // Premium Dummy Data
    @Published var products: [Product] = [
        Product(name: "Vision Pro", brand: "Apple", pricePerDay: 49.99, originalPrice: 3499.00, description: "Experience spatial computing with the revolutionary Apple Vision Pro. Seamlessly blends digital content with your physical space for an unprecedented level of immersion.", imageURL: "https://images.unsplash.com/photo-1594833271765-b17b204910cf?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["Micro-OLED display", "Spatial Audio", "Eye tracking", "Hand tracking"], isFeatured: true, rating: 4.9, reviewsCount: 342),
        Product(name: "Quest 3", brand: "Meta", pricePerDay: 19.99, originalPrice: 499.99, description: "Dive into mixed reality with the most powerful Quest yet. Features breakthrough high-resolution color passthrough for a seamless blend of virtual and physical worlds.", imageURL: "https://images.unsplash.com/photo-1622979135225-d2ba269cf1ac?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["Snapdragon XR2 Gen 2", "Pancake lenses", "Touch Plus controllers", "Inside-out tracking"], isFeatured: true, rating: 4.8, reviewsCount: 856),
        Product(name: "PlayStation VR2", brand: "Sony", pricePerDay: 24.99, originalPrice: 549.99, description: "Next generation of virtual reality gaming on PS5. Feel a new real with incredible 4K HDR visuals and cutting-edge controller haptics.", imageURL: "https://images.unsplash.com/photo-1617802690992-15d93263d3a9?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["4K HDR OLED", "Eye tracking", "Sense controllers", "Headset feedback"], isFeatured: false, rating: 4.7, reviewsCount: 421),
        Product(name: "Vive Pro 2", brand: "HTC", pricePerDay: 29.99, originalPrice: 799.00, description: "Professional-grade PC-VR with 5K resolution. Designed for premium virtual reality experiences requiring the utmost visual fidelity.", imageURL: "https://images.unsplash.com/photo-1623348637785-5b410d540eb4?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["5K resolution", "120Hz refresh rate", "120 degree FOV", "SteamVR Tracking"], isFeatured: false, rating: 4.6, reviewsCount: 156)
    ]
}
