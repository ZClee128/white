import Foundation
import Combine

class DataStore: ObservableObject {
    @Published var bouncyCastles: [BouncyCastle] = []
    @Published var orders: [Order] = []
    
    private let ordersKey = "saved_orders"
    
    init() {
        loadMockData()
        loadOrders()
    }
    
    private func loadMockData() {
        bouncyCastles = [
            BouncyCastle(id: UUID(uuidString: "A1B2C3D4-0001-0001-0001-000000000001")!, name: "Magical Unicorn Realm", headline: "A Fairytale Adventure", description: "Step into a magical realm with this spectacular unicorn-themed bouncy castle. Features a double slide, a wide bouncing area, and enchanting pastel colors that will make any party unforgettable.", imageName: "Magical Unicorn Realm", pricePerDay: 199.0, dimensions: "15' x 15' x 12'", capacity: 8, themeColorHex: "#FCE4EC", tags: ["Unicorn", "Magic", "Slide"]),
            BouncyCastle(id: UUID(uuidString: "A1B2C3D4-0001-0001-0001-000000000002")!, name: "Pirate's Cove Adventure", headline: "Ahoy, Mateys!", description: "Set sail on the high seas with this pirate ship bouncy castle. Includes a captain's wheel, climbing wall, and a slide that plunges into an imaginary ocean. Perfect for adventurous scallywags.", imageName: "Pirate's Cove Adventure", pricePerDay: 225.0, dimensions: "20' x 12' x 14'", capacity: 10, themeColorHex: "#EFEBE9", tags: ["Pirate", "Adventure", "Ship"]),
            BouncyCastle(id: UUID(uuidString: "A1B2C3D4-0001-0001-0001-000000000003")!, name: "Galactic Space Station", headline: "Out of this World Fun", description: "Blast off into fun with our Space Station bounce house. Featuring striking neon colors, alien pop-ups inside, and an enclosed jumping zone to simulate low gravity fun.", imageName: "Galactic Space Station", pricePerDay: 210.0, dimensions: "16' x 16' x 15'", capacity: 8, themeColorHex: "#EDE7F6", tags: ["Space", "Alien", "Sci-Fi"]),
            BouncyCastle(id: UUID(uuidString: "A1B2C3D4-0001-0001-0001-000000000004")!, name: "Jungle Safari Excursion", headline: "Welcome to the Jungle", description: "Explore the wild with this jungle-themed inflatable. Decorated with palm trees, monkeys, and lions, it offers a large bouncing floor and a small obstacle course for young explorers.", imageName: "Jungle Safari Excursion", pricePerDay: 185.0, dimensions: "14' x 14' x 11'", capacity: 7, themeColorHex: "#E8F5E9", tags: ["Jungle", "Animals", "Obstacles"]),
            BouncyCastle(id: UUID(uuidString: "A1B2C3D4-0001-0001-0001-000000000005")!, name: "Princess Royal Palace", headline: "Fit for Royalty", description: "A beautifully designed pink and purple palace with towering turrets. The spacious interior allows plenty of room for royal balls and grand celebrations.", imageName: "Princess Royal Palace", pricePerDay: 190.0, dimensions: "15' x 13' x 13'", capacity: 8, themeColorHex: "#F3E5F5", tags: ["Princess", "Castle", "Pink"]),
            BouncyCastle(id: UUID(uuidString: "A1B2C3D4-0001-0001-0001-000000000006")!, name: "Dino World Rampage", headline: "Prehistoric Excitement", description: "Roar into action with our T-Rex themed bounce house. Features large 3D dinosaur heads, a volcanic slide, and a durable floor for stomping around like giant reptiles.", imageName: "Dino World Rampage", pricePerDay: 240.0, dimensions: "18' x 15' x 14'", capacity: 10, themeColorHex: "#F1F8E9", tags: ["Dinosaur", "T-Rex", "Action"]),
            BouncyCastle(id: UUID(uuidString: "A1B2C3D4-0001-0001-0001-000000000007")!, name: "Superhero Training Camp", headline: "Unleash Your Powers", description: "Test your skills in this action-packed obstacle course and bounce combo. Crawl through tunnels, navigate pylons, and slide to victory in this comic book inspired inflatable.", imageName: "Superhero Training Camp", pricePerDay: 250.0, dimensions: "25' x 10' x 12'", capacity: 12, themeColorHex: "#E3F2FD", tags: ["Superhero", "Obstacles", "Comic"]),
            BouncyCastle(id: UUID(uuidString: "A1B2C3D4-0001-0001-0001-000000000008")!, name: "Under the Sea Bubble", headline: "Deep Ocean Dive", description: "Dive deep with this vibrant aquatic bounce house. Surrounded by friendly sea creatures and coral reefs, it includes a splash pad area (water optional) for summer days.", imageName: "Under the Sea Bubble", pricePerDay: 205.0, dimensions: "15' x 15' x 10'", capacity: 8, themeColorHex: "#E0F7FA", tags: ["Ocean", "Water", "Fish"]),
            BouncyCastle(id: UUID(uuidString: "A1B2C3D4-0001-0001-0001-000000000009")!, name: "Neon Glow Party Arena", headline: "Light up the Night", description: "Perfect for evening events! This inflatable features internal LED lighting pockets and UV-reactive materials. Bring your glow sticks for an unforgettable dance/bounce party.", imageName: "Neon Glow Party Arena", pricePerDay: 280.0, dimensions: "16' x 16' x 14'", capacity: 10, themeColorHex: "#212121", tags: ["Night", "Party", "Glow"]),
            BouncyCastle(id: UUID(uuidString: "A1B2C3D4-0001-0001-0001-000000000010")!, name: "Monster Truck Madness", headline: "Start Your Engines", description: "Huge, impressive, and rugged! This bounce house is shaped like a giant monster truck with massive inflatable tires. A huge hit for vehicle lovers and adrenaline junkies.", imageName: "Monster Truck Madness", pricePerDay: 235.0, dimensions: "18' x 14' x 13'", capacity: 9, themeColorHex: "#FFEBEE", tags: ["Trucks", "Racing", "Cars"]),
            BouncyCastle(id: UUID(uuidString: "A1B2C3D4-0001-0001-0001-000000000011")!, name: "Candy Land Express", headline: "Sweet Bouncing Treats", description: "A deliciously vibrant inflatable covered in lollipops, gumdrops, and candy canes. It's an eye-catching centerpiece that brings sugar-free joy and endless energy burning.", imageName: "Candy Land Express", pricePerDay: 195.0, dimensions: "14' x 14' x 12'", capacity: 8, themeColorHex: "#FFF3E0", tags: ["Candy", "Sweet", "Colorful"]),
            BouncyCastle(id: UUID(uuidString: "A1B2C3D4-0001-0001-0001-000000000012")!, name: "Medieval Fortress", headline: "Defend the Realm", description: "A classic bouncy castle styled like a tough stone fortress. High walls, battlements, and a spacious enclosed interior make it a safe and classic choice for any backyard.", imageName: "Medieval Fortress", pricePerDay: 180.0, dimensions: "13' x 13' x 10'", capacity: 6, themeColorHex: "#FAFAFA", tags: ["Classic", "Fortress", "Knights"]),
            BouncyCastle(id: UUID(uuidString: "A1B2C3D4-0001-0001-0001-000000000013")!, name: "Tropical Lua Oasis", headline: "Island Vibes", description: "Bring the beach to your backyard. This tropical-themed bounce house features palm trees and a vibrant sunset background. Kick off your shoes and relax on island time.", imageName: "Tropical Lua Oasis", pricePerDay: 200.0, dimensions: "15' x 15' x 12'", capacity: 8, themeColorHex: "#FFFDE7", tags: ["Tropical", "Beach", "Summer"])
        ]
    }
    
    func saveOrder(_ order: Order) {
        orders.insert(order, at: 0)
        saveOrdersToDisk()
    }
    
    func updateOrder(_ updatedOrder: Order) {
        if let index = orders.firstIndex(where: { $0.id == updatedOrder.id }) {
            orders[index] = updatedOrder
            saveOrdersToDisk()
        }
    }
    
    private func saveOrdersToDisk() {
        do {
            let encoded = try JSONEncoder().encode(orders)
            UserDefaults.standard.set(encoded, forKey: ordersKey)
            print("Successfully saved \(orders.count) orders.")
        } catch {
            print("Failed to encode orders: \(error)")
        }
    }
    
    private func loadOrders() {
        if let data = UserDefaults.standard.data(forKey: ordersKey) {
            do {
                let decoded = try JSONDecoder().decode([Order].self, from: data)
                self.orders = decoded
                print("Successfully loaded \(decoded.count) orders.")
            } catch {
                print("Failed to decode orders: \(error)")
            }
        } else {
            print("No orders found in UserDefaults.")
        }
    }
}
