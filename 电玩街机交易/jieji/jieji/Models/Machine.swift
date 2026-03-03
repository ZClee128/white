import Foundation

struct Machine: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var description: String
    var price: Double
    var category: String
    var isTrending: Bool
    var coverColorHex: String
    var featureIcon: String
}

extension Machine {
    static let mockData: [Machine] = [
        Machine(name: "Neon Drift Racer", description: "Immersive 4D racing simulator with realistic force feedback and surround sound system.", price: 12500.0, category: "Racing", isTrending: true, coverColorHex: "FF3B30", featureIcon: "car.circle.fill"),
        Machine(name: "Galactic Defender Pro", description: "Classic twin-stick shooter updated with stunning 4K visuals and a 65-inch curved display.", price: 8900.0, category: "Shooter", isTrending: false, coverColorHex: "5856D6", featureIcon: "airplane.circle.fill"),
        Machine(name: "Street Brawler Alpha", description: "Competitive fighting cabinet featuring Sanwa Denshi parts and near-zero latency.", price: 6500.0, category: "Fighting", isTrending: true, coverColorHex: "FF9500", featureIcon: "figure.boxing"),
        Machine(name: "Rhythm Master Deluxe", description: "Top-tier music game with full floor pads and mesmerizing LED lighting arrays.", price: 14200.0, category: "Music", isTrending: true, coverColorHex: "FF2D55", featureIcon: "music.note"),
        Machine(name: "Sniper Elite VR Arcade", description: "Virtual Reality sniper setup with realistic replica rifle and haptic feedback vest.", price: 18000.0, category: "VR", isTrending: false, coverColorHex: "34C759", featureIcon: "scope"),
        Machine(name: "Retro Pac-Man Cabaret", description: "Original style cabaret cabinet restored and fitted with a modern LCD playing classic boards.", price: 3200.0, category: "Retro", isTrending: false, coverColorHex: "FFCC00", featureIcon: "gamecontroller.fill"),
        Machine(name: "Zombie Crisis 5", description: "Light-gun co-op shooter with force-feedback pistols and a massive 75-inch screen.", price: 15500.0, category: "Shooter", isTrending: true, coverColorHex: "8E8E93", featureIcon: "target"),
        Machine(name: "Hoop Fever Basketball", description: "Classic arcade basketball game with electronic scoring, moving hoop, and LED backboard.", price: 5800.0, category: "Sports", isTrending: false, coverColorHex: "FF9500", featureIcon: "basketball.fill"),
        Machine(name: "Air Hockey Infinity", description: "Professional grade air hockey table with glowing UV surface and digital scoreboard.", price: 4500.0, category: "Sports", isTrending: true, coverColorHex: "00C7BE", featureIcon: "sportscourt.fill"),
        Machine(name: "Claw Master 3000", description: "High-end crane machine with adjustable claw strength, LED strips, and secure prize chute.", price: 3800.0, category: "Prize", isTrending: false, coverColorHex: "AF52DE", featureIcon: "gift.fill"),
        Machine(name: "Pinball Wizard: Cosmos", description: "Custom cosmic-themed pinball table with multi-ball action, ramps, and reactive lighting.", price: 9000.0, category: "Pinball", isTrending: true, coverColorHex: "007AFF", featureIcon: "circle.circle.fill"),
        Machine(name: "Dance Dance Revolution A20", description: "The definitive dancing experience with dual stages and latest hit tracks.", price: 21000.0, category: "Music", isTrending: true, coverColorHex: "FF2D55", featureIcon: "figure.dance"),
        Machine(name: "Virtual Racing Simulator Triple", description: "Premium F1-style seating with triple monitors, direct drive wheel, and motion platform.", price: 35000.0, category: "Racing", isTrending: true, coverColorHex: "1C1C1E", featureIcon: "steeringwheel")
    ]
}
