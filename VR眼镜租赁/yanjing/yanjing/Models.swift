import Foundation
import Combine

struct Product: Identifiable, Hashable, Codable {
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
    case cashOnDelivery = "Cash on Delivery"
    case paid = "Paid"
    case shipped = "Shipped"
    case completed = "Completed"
    case canceled = "Canceled"
}

struct Order: Identifiable, Codable {
    var id: UUID = UUID()
    var orderNumber: String
    var product: Product
    var rentalDays: Int
    var status: OrderStatus
    var totalAmount: Double
    var date: Date
}

struct Address: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var fullName: String
    var phoneNumber: String
    var streetAddress: String
    var city: String
    var state: String
    var zipCode: String
}

class AppState: ObservableObject {
    @Published var cart: [Product] = [] {
        didSet {
            saveCart()
        }
    }
    @Published var orders: [Order] = [] {
        didSet {
            saveOrders()
        }
    }
    @Published var currentAddress: Address? = Address(fullName: "John Doe", phoneNumber: "+1 800-555-0199", streetAddress: "123 Innovation Drive", city: "San Francisco", state: "CA", zipCode: "94107")
    
    // Premium Dummy Data
    @Published var products: [Product] = [
        Product(name: "Vision Pro", brand: "Apple", pricePerDay: 49.99, originalPrice: 3499.00, description: "Experience spatial computing with the revolutionary Apple Vision Pro. Seamlessly blends digital content with your physical space for an unprecedented level of immersion.", imageURL: "https://images.unsplash.com/photo-1594833271765-b17b204910cf?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["Micro-OLED display", "Spatial Audio", "Eye tracking", "Hand tracking"], isFeatured: true, rating: 4.9, reviewsCount: 342),
        Product(name: "Quest 3", brand: "Meta", pricePerDay: 19.99, originalPrice: 499.99, description: "Dive into mixed reality with the most powerful Quest yet. Features breakthrough high-resolution color passthrough for a seamless blend of virtual and physical worlds.", imageURL: "https://images.unsplash.com/photo-1622979135225-d2ba269cf1ac?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["Snapdragon XR2 Gen 2", "Pancake lenses", "Touch Plus controllers", "Inside-out tracking"], isFeatured: true, rating: 4.8, reviewsCount: 856),
        Product(name: "PlayStation VR2", brand: "Sony", pricePerDay: 24.99, originalPrice: 549.99, description: "Next generation of virtual reality gaming on PS5. Feel a new real with incredible 4K HDR visuals and cutting-edge controller haptics.", imageURL: "https://images.unsplash.com/photo-1617802690992-15d93263d3a9?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["4K HDR OLED", "Eye tracking", "Sense controllers", "Headset feedback"], isFeatured: false, rating: 4.7, reviewsCount: 421),
        Product(name: "Vive Pro 2", brand: "HTC", pricePerDay: 29.99, originalPrice: 799.00, description: "Professional-grade PC-VR with 5K resolution. Designed for premium virtual reality experiences requiring the utmost visual fidelity.", imageURL: "https://images.unsplash.com/photo-1623348637785-5b410d540eb4?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["5K resolution", "120Hz refresh rate", "120 degree FOV", "SteamVR Tracking"], isFeatured: false, rating: 4.6, reviewsCount: 156),
        Product(name: "Valve Index", brand: "Valve", pricePerDay: 27.99, originalPrice: 999.00, description: "High-fidelity virtual reality for PC. Features industry-leading tracking, incredibly comfortable controllers, and dual 1440x1600 RGB LCDs.", imageURL: "https://images.unsplash.com/photo-1588658688487-1b03332463e2?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["144Hz refresh rate", "Knuckles controllers", "Base station tracking", "Off-ear audio"], isFeatured: true, rating: 4.9, reviewsCount: 650),
        Product(name: "Quest Pro", brand: "Meta", pricePerDay: 34.99, originalPrice: 999.99, description: "Advanced mixed reality headset for productivity and high-end gaming. Features sleek design and face/eye tracking.", imageURL: "https://images.unsplash.com/photo-1535223289827-42f1e9919769?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["Pancake optics", "Eye & Face tracking", "Self-tracking controllers", "Color Passthrough"], isFeatured: false, rating: 4.5, reviewsCount: 231),
        Product(name: "Pico 4", brand: "Pico", pricePerDay: 15.99, originalPrice: 429.00, description: "Lightweight, comfortable all-in-one VR headset with crisp pancake lenses and balanced weight distribution.", imageURL: "https://images.unsplash.com/photo-1592478411213-6153e4ebc07d?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["4K+ resolution", "Pancake lenses", "Motorized IPD", "Color Passthrough"], isFeatured: false, rating: 4.4, reviewsCount: 198),
        Product(name: "Reverb G2", brand: "HP", pricePerDay: 22.99, originalPrice: 599.00, description: "Developed in collaboration with Valve and Microsoft. Exceptional visual clarity and amazing audio for PC VR.", imageURL: "https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["2160x2160 per eye", "Valve speakers", "4-camera tracking", "Comfortable design"], isFeatured: false, rating: 4.6, reviewsCount: 310),
        Product(name: "Vive XR Elite", brand: "HTC", pricePerDay: 39.99, originalPrice: 1099.00, description: "A powerful, convertible, and lightweight headset that goes from all-in-one XR to a pair of portable VR glasses.", imageURL: "https://images.unsplash.com/photo-1614729939124-032f0b56c9ce?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["Convertible design", "Full color passthrough", "Hot-swappable battery", "Diopter dials"], isFeatured: true, rating: 4.7, reviewsCount: 142),
        Product(name: "Pimax Vision 8K X", brand: "Pimax", pricePerDay: 45.99, originalPrice: 1299.00, description: "Ultra-wide field of view VR headset with dual native 4K displays. Designed for hardcore enthusiasts and sim racers.", imageURL: "https://images.unsplash.com/photo-1552820728-8b83bb6b773f?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["Dual 4K panels", "200 degree FOV", "Requires high-end PC", "Modular design"], isFeatured: false, rating: 4.3, reviewsCount: 88),
        Product(name: "Quest 2", brand: "Meta", pricePerDay: 9.99, originalPrice: 299.99, description: "The most popular all-in-one VR headset. Great for beginners, packed with games and extremely easy to set up and use.", imageURL: "https://images.unsplash.com/photo-1605379399642-870262d3d051?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["Snapdragon XR2", "LCD display", "Wireless PC VR", "Extensive library"], isFeatured: false, rating: 4.8, reviewsCount: 5410),
        Product(name: "Varjo Aero", brand: "Varjo", pricePerDay: 55.99, originalPrice: 1990.00, description: "Professional-grade VR with edge-to-edge clarity and advanced eye tracking. The ultimate choice for flight and racing simulators.", imageURL: "https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["Mini-LED displays", "Aspheric lenses", "200hz eye tracking", "Auto IPD"], isFeatured: true, rating: 4.9, reviewsCount: 45),
        Product(name: "Vive Cosmos Elite", brand: "HTC", pricePerDay: 18.99, originalPrice: 899.00, description: "PC-powered VR with external tracking precision. Features a convenient flip-up design to easily jump between reality and VR.", imageURL: "https://images.unsplash.com/photo-1518605368461-1eb49c5e5953?auto=format&fit=crop&q=80&w=800&h=600", specifications: ["Flip-up halo design", "SteamVR Tracking", "Modular faceplates", "LCD panels"], isFeatured: false, rating: 4.2, reviewsCount: 220)
    ]
    
    init() {
        loadData()
    }
    
    // UserDefaults Keys
    private let cartKey = "savedCart"
    private let ordersKey = "savedOrders"
    
    private func saveCart() {
        if let encoded = try? JSONEncoder().encode(cart) {
            UserDefaults.standard.set(encoded, forKey: cartKey)
        }
    }
    
    private func saveOrders() {
        if let encoded = try? JSONEncoder().encode(orders) {
            UserDefaults.standard.set(encoded, forKey: ordersKey)
        }
    }
    
    private func loadData() {
        if let cartData = UserDefaults.standard.data(forKey: cartKey),
           let decodedCart = try? JSONDecoder().decode([Product].self, from: cartData) {
            self.cart = decodedCart
        }
        
        if let ordersData = UserDefaults.standard.data(forKey: ordersKey),
           let decodedOrders = try? JSONDecoder().decode([Order].self, from: ordersData) {
            self.orders = decodedOrders
        }
    }
}
