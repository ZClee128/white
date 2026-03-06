import Foundation

struct Laptop: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let brand: String
    let processor: String
    let ram: String
    let storage: String
    let display: String
    let imageName: String
    let dailyPrice: Double
    let weeklyPrice: Double
    let monthlyPrice: Double
    var isAvailable: Bool
    var isDiscounted: Bool
    let description: String

    init(
        id: String,
        name: String,
        brand: String,
        processor: String,
        ram: String,
        storage: String,
        display: String,
        imageName: String,
        dailyPrice: Double,
        weeklyPrice: Double,
        monthlyPrice: Double,
        isAvailable: Bool = true,
        isDiscounted: Bool = false,
        description: String
    ) {
        self.id = id
        self.name = name
        self.brand = brand
        self.processor = processor
        self.ram = ram
        self.storage = storage
        self.display = display
        self.imageName = imageName
        self.dailyPrice = dailyPrice
        self.weeklyPrice = weeklyPrice
        self.monthlyPrice = monthlyPrice
        self.isAvailable = isAvailable
        self.isDiscounted = isDiscounted
        self.description = description
    }
}

// MARK: - Sample Data
extension Laptop {
    static let sampleData: [Laptop] = [
        Laptop(
            id: "laptop_alienware_m18",
            name: "Alienware m18",
            brand: "Alienware",
            processor: "Intel Core i9-13980HX",
            ram: "64GB DDR5",
            storage: "2TB SSD",
            display: "18\" QHD+ 165Hz",
            imageName: "Alienware m18",
            dailyPrice: 150,
            weeklyPrice: 700,
            monthlyPrice: 2000,
            description: "Enthusiast gaming laptop with desktop-level performance. The massive 18-inch screen delivers an ultimate immersive gaming experience."
        ),
        Laptop(
            id: "laptop_rog_strix_scar_18",
            name: "ROG Strix SCAR 18",
            brand: "ASUS",
            processor: "Intel Core i9-14900HX",
            ram: "64GB DDR5",
            storage: "2TB PCIe 4.0 SSD",
            display: "18\" Nebula Display 240Hz",
            imageName: "ROG Strix SCAR 18",
            dailyPrice: 160,
            weeklyPrice: 750,
            monthlyPrice: 2200,
            description: "Max-performance output with top-tier cooling. A performance beast built specifically for hardcore esports gamers."
        ),
        Laptop(
            id: "laptop_legion_y9000p",
            name: "Legion Pro 7i",
            brand: "Lenovo",
            processor: "Intel Core i9-14900HX",
            ram: "32GB DDR5",
            storage: "1TB SSD",
            display: "16\" WQXGA 240Hz",
            imageName: "Legion Pro 7i",
            dailyPrice: 100,
            weeklyPrice: 500,
            monthlyPrice: 1500,
            description: "Professional esports laptop featuring the ColdFront cooling system. Delivers strong performance and a fully maximized gaming experience."
        ),
        Laptop(
            id: "laptop_razer_blade_16",
            name: "Razer Blade 16",
            brand: "Razer",
            processor: "Intel Core i9-13950HX",
            ram: "32GB DDR5",
            storage: "1TB NVMe SSD",
            display: "16\" Dual-Mode Mini-LED",
            imageName: "Razer Blade 16",
            dailyPrice: 140,
            weeklyPrice: 650,
            monthlyPrice: 1900,
            description: "The perfect combination of extreme portability and powerful performance. Features the first-ever dual-mode Mini-LED screen. The top choice for high-end gamers."
        ),
        Laptop(
            id: "laptop_msi_titan_18",
            name: "MSI Titan 18 Ultra",
            brand: "MSI",
            processor: "Intel Core i9-14900HX",
            ram: "128GB DDR5",
            storage: "4TB SSD",
            display: "18\" 4K 120Hz Mini-LED",
            imageName: "MSI Titan 18 Ultra",
            dailyPrice: 200,
            weeklyPrice: 900,
            monthlyPrice: 2800,
            description: "The ultimate flagship king. Unrivaled hardware configuration fulfilling all your fantasies for extreme graphics and frame rates."
        ),
        Laptop(
            id: "laptop_omen_9",
            name: "OMEN 16",
            brand: "HP",
            processor: "Intel Core i7-13700HX",
            ram: "16GB DDR5",
            storage: "1TB SSD",
            display: "16.1\" QHD 240Hz",
            imageName: "OMEN 16",
            dailyPrice: 80,
            weeklyPrice: 400,
            monthlyPrice: 1200,
            description: "Mainstream esports weapon with a completely new chassis design and fully upgraded cooling. Smoothly play all kinds of demanding games."
        ),
        Laptop(
            id: "laptop_predator_helios",
            name: "Predator Helios 18",
            brand: "Acer",
            processor: "Intel Core i9-13900HX",
            ram: "32GB DDR5",
            storage: "1TB PCIe SSD",
            display: "18\" WQXGA 240Hz",
            imageName: "Predator Helios 18",
            dailyPrice: 110,
            weeklyPrice: 550,
            monthlyPrice: 1600,
            description: "Liquid metal cooling with top-tier specs. Features custom 5th-gen AeroBlade 3D fans for sustained, tear-free combat."
        ),
        Laptop(
            id: "laptop_aorus_17x",
            name: "AORUS 17X",
            brand: "Gigabyte",
            processor: "Intel Core i9-13980HX",
            ram: "32GB DDR5",
            storage: "1TB NVMe SSD",
            display: "17.3\" QHD 240Hz",
            imageName: "AORUS 17X",
            dailyPrice: 120,
            weeklyPrice: 600,
            monthlyPrice: 1700,
            description: "WINDFORCE Infinity cooling technology with a large vapor chamber. Unleashes the extreme potential of gaming."
        )
    ]
}
