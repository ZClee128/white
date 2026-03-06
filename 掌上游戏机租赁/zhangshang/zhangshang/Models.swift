import Foundation

struct Console: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let features: [String]
    let imageName: String // System image name or asset name
    let dailyPrice: Double
    let deposit: Double
}

enum OrderStatus: String, Codable {
    case renting = "Renting"
    case returned = "Returned"
}

struct Order: Identifiable, Codable {
    var id: UUID = UUID()
    let console: Console
    let startDate: Date
    let endDate: Date
    let totalPrice: Double
    var status: OrderStatus
    
    var daysDuration: Int {
        let components = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
        return max(1, components.day ?? 1)
    }
}

struct Promotion: Identifiable, Codable {
    let id: UUID
    let title: String
    let subtitle: String
    let discountTargetConsoleId: UUID
    let originalPrice: Double
    let discountedPrice: Double
    let endTime: Date
    let bannerColorStart: String // Hex
    let bannerColorEnd: String // Hex
}

struct Address: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var phoneNumber: String
    var region: String
    var detailAddress: String
    var isDefault: Bool
    
    var fullAddress: String {
        return "\(region) \(detailAddress)"
    }
}

// MARK: - Mock Data
struct MockData {
    static let consoles = [
        Console(
            id: UUID(),
            name: "OLED Handheld",
            description: "The premium handheld experience with a vibrant 7-inch OLED screen, enhanced audio, and an adjustable stand. Perfect for classic adventures.",
            features: ["7-inch OLED Screen", "Enhanced Audio", "Wide Adjustable Stand", "64GB Internal Storage"],
            imageName: "gamecontroller.fill",
            dailyPrice: 20.0,
            deposit: 1500.0
        ),
        Console(
            id: UUID(),
            name: "Pro PC Deck",
            description: "A powerful portable PC gaming device. Play your entire PC library anywhere with incredible performance and ergonomic controls.",
            features: ["Zen 2 + RDNA 2 Architecture", "16GB LPDDR5 RAM", "7-inch Touchscreen", "Trackpads"],
            imageName: "pc",
            dailyPrice: 35.0,
            deposit: 3000.0
        ),
        Console(
            id: UUID(),
            name: "Play Portable",
            description: "Access your home console library remotely. Stream your favorite next-gen games directly to this dedicated handheld with dual-sense features.",
            features: ["8-inch LCD Screen", "Haptic Feedback", "Adaptive Triggers", "1080p 60fps streaming"],
            imageName: "playstation.logo",
            dailyPrice: 25.0,
            deposit: 1200.0
        ),
        Console(
            id: UUID(),
            name: "Retro Boy",
            description: "Relive the classics. This pocket-sized console handles thousands of retro titles from the 8-bit and 16-bit eras with a stunning IPS display.",
            features: ["3.5-inch IPS Screen", "Supports 20+ Classic Systems", "Open Source Linux", "128GB MicroSD Included"],
            imageName: "dpad",
            dailyPrice: 10.0,
            deposit: 300.0
        ),
        Console(
            id: UUID(),
            name: "Ally X",
            description: "Top-tier PC gaming handheld with a 120Hz display and immense processing power. Uncompromised AAA gaming on the go.",
            features: ["Ryzen Z1 Extreme", "120Hz 1080p Display", "24GB LPDDR5X RAM", "Hall Effect Joysticks"],
            imageName: "display.2",
            dailyPrice: 40.0,
            deposit: 3500.0
        ),
        Console(
            id: UUID(),
            name: "Compact Handheld",
            description: "Compact, lightweight, and dedicated to handheld play. The perfect companion for gamers who are always on the move.",
            features: ["Integrated Controls", "5.5-inch Touch Screen", "Lightweight Design", "D-Pad Included"],
            imageName: "gamecontroller",
            dailyPrice: 15.0,
            deposit: 1000.0
        ),
        Console(
            id: UUID(),
            name: "Max Go",
            description: "A versatile PC gaming powerhouse featuring detachable controllers and a massive 8.8-inch QHD+ display.",
            features: ["8.8-inch QHD+ 144Hz Screen", "Detachable Controllers", "FPS Mode enabled", "Kickstand built-in"],
            imageName: "desktopcomputer",
            dailyPrice: 45.0,
            deposit: 4000.0
        ),
        Console(
            id: UUID(),
            name: "Pocket 4 Pro",
            description: "The ultimate Android-based retro gaming handheld. Powerful enough for classic 3D gaming flawlessly, while fitting comfortably in your pocket.",
            features: ["Dimensity 1100 Processor", "4.7-inch Touchscreen", "Active Cooling", "Android 13 OS"],
            imageName: "iphone.gen1",
            dailyPrice: 12.0,
            deposit: 800.0
        ),
        Console(
            id: UUID(),
            name: "Vita Classic",
            description: "The legacy OLED handheld from Sony. Play amazing exclusive titles with dual analog sticks and a beautiful rear touchpad.",
            features: ["5-inch OLED Screen", "Dual Analog Sticks", "Rear Touchpad", "Exclusive Library"],
            imageName: "apps.iphone",
            dailyPrice: 8.0,
            deposit: 500.0
        ),
        Console(
            id: UUID(),
            name: "SP Advance",
            description: "The iconic clamshell handheld. Fold it up and carry a massive library of 32-bit pixel art masterpieces wherever you go.",
            features: ["Clamshell Design", "Front-lit Screen", "Rechargeable Battery", "Extensive GBA Library"],
            imageName: "folder.fill",
            dailyPrice: 5.0,
            deposit: 200.0
        ),
        Console(
            id: UUID(),
            name: "Playdate",
            description: "A quirky, yellow indie handheld featuring a unique crank controller. Enjoy surprisingly fresh and creative black-and-white games.",
            features: ["Mechanical Crank", "Sharp Memory LCD", "Curated Season of Games", "Pocket-sized"],
            imageName: "dial.low",
            dailyPrice: 9.0,
            deposit: 600.0
        ),
        Console(
            id: UUID(),
            name: "G-Cloud",
            description: "Designed for cloud gaming. Stream Xbox Game Pass, GeForce Now, and more with a lightweight design and insane battery life.",
            features: ["12+ Hours Battery Life", "7-inch 1080p Screen", "Ergonomic Grips", "Cloud-focused Android"],
            imageName: "cloud.fill",
            dailyPrice: 18.0,
            deposit: 1500.0
        ),
        Console(
            id: UUID(),
            name: "Miyoo Mini+",
            description: "The aesthetic king of micro-consoles. Play classic 8-bit and 16-bit games on a device smaller than a deck of cards.",
            features: ["Ultra-compact", "3.5-inch IPS Screen", "OnionOS Compatible", "Vibration Motor"],
            imageName: "square.grid.3x3.square",
            dailyPrice: 4.0,
            deposit: 250.0
        ),
        Console(
            id: UUID(),
            name: "Ayn Odin 2",
            description: "The absolute pinnacle of Android handhelds. Featuring a Snapdragon 8 Gen 2, it handles everything including high-end portable gaming.",
            features: ["Snapdragon 8 Gen 2", "Massive 8000mAh Battery", "6-inch 1080p Screen", "Hall Effect Analytics"],
            imageName: "bolt.horizontal.fill",
            dailyPrice: 22.0,
            deposit: 2000.0
        ),
        Console(
            id: UUID(),
            name: "RG35XX H",
            description: "Horizontal form-factor retro mastery. Perfect for fighting games and SNES classics with a comfortable horizontal grip.",
            features: ["Horizontal Layout", "Dual Joysticks", "H700 CPU", "Bluetooth Controller Support"],
            imageName: "gamecontroller.fill",
            dailyPrice: 6.0,
            deposit: 350.0
        ),
        Console(
            id: UUID(),
            name: "DS Twin",
            description: "Experience the magic of dual screens. Play incredibly inventive touch-based games from the golden era of handhelds.",
            features: ["Dual Screens", "Touch Stylus Input", "Microphone", "Massive Game Library"],
            imageName: "macwindow.on.rectangle",
            dailyPrice: 7.0,
            deposit: 400.0
        ),
        Console(
            id: UUID(),
            name: "Win 4",
            description: "The slide-out keyboard PC handheld. A true pocket PC that looks like a PSP but runs full heavy-duty PC AAA games.",
            features: ["Slide-out Physical Keyboard", "6-inch Screen", "Optical Trackpoint", "Dual USB-C 40Gbps"],
            imageName: "keyboard",
            dailyPrice: 38.0,
            deposit: 3800.0
        )
    ]
    
    static let promotions = [
        Promotion(
            id: UUID(),
            title: "Weekend Sale 🎮",
            subtitle: "OLED Handheld Best Price",
            discountTargetConsoleId: consoles[0].id, // OLED Handheld
            originalPrice: 20.0,
            discountedPrice: 9.9,
            endTime: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            bannerColorStart: "FF3A2D",
            bannerColorEnd: "FF8E53"
        ),
        Promotion(
            id: UUID(),
            title: "Hardcore Exclusives 🔥",
            subtitle: "Pro PC Deck Trial",
            discountTargetConsoleId: consoles[1].id, // Pro PC Deck
            originalPrice: 35.0,
            discountedPrice: 25.0,
            endTime: Calendar.current.date(byAdding: .hour, value: 5, to: Date())!,
            bannerColorStart: "1E1E1E",
            bannerColorEnd: "4A90E2"
        ),
        Promotion(
            id: UUID(),
            title: "Retro Flash Deals 👾",
            subtitle: "Miyoo Mini+ Must-Have",
            discountTargetConsoleId: consoles[12].id, // Miyoo
            originalPrice: 4.0,
            discountedPrice: 1.9,
            endTime: Calendar.current.date(byAdding: .hour, value: 12, to: Date())!,
            bannerColorStart: "8E2DE2",
            bannerColorEnd: "4A00E0"
        ),
        Promotion(
            id: UUID(),
            title: "PC Gaming Anywhere 💻",
            subtitle: "Ally X Discounted",
            discountTargetConsoleId: consoles[4].id, // Ally X
            originalPrice: 40.0,
            discountedPrice: 29.9,
            endTime: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            bannerColorStart: "11998E",
            bannerColorEnd: "38EF7D"
        )
    ]
}
