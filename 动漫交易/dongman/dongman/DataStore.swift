import Foundation
import SwiftUI
import Combine

class DataStore: ObservableObject {
    @Published var figures: [Figure] = []
    @Published var orders: [Order] = []
    @Published var flashSaleEndDate: Date = Date().addingTimeInterval(3600 * 6)

    // MARK: - Sellers
    private let sellers: [Seller] = [
        Seller(id: UUID(), name: "OtakuVault", avatarInitial: "O", rating: 4.9, totalSold: 234, location: "Tokyo, JP"),
        Seller(id: UUID(), name: "FigureNest", avatarInitial: "F", rating: 4.7, totalSold: 187, location: "Los Angeles, US"),
        Seller(id: UUID(), name: "AnimeRelics", avatarInitial: "A", rating: 4.8, totalSold: 312, location: "Seoul, KR"),
        Seller(id: UUID(), name: "MochiFigs", avatarInitial: "M", rating: 4.6, totalSold: 95, location: "Taipei, TW"),
        Seller(id: UUID(), name: "SakuraCollect", avatarInitial: "S", rating: 5.0, totalSold: 421, location: "Osaka, JP"),
        Seller(id: UUID(), name: "NeonFigures", avatarInitial: "N", rating: 4.5, totalSold: 78, location: "New York, US"),
        Seller(id: UUID(), name: "KawaiiDepot", avatarInitial: "K", rating: 4.8, totalSold: 265, location: "Hong Kong, HK"),
    ]

    init() {
        loadFigures()
        loadSampleOrders()
    }

    // MARK: - 13 Figure Data Sources
    private func loadFigures() {
        let s = sellers
        figures = [
            // 1
            Figure(id: UUID(), name: "Gojo Satoru", series: "Jujutsu Kaisen", character: "Gojo Satoru",
                   scale: "Nendoroid #1847", manufacturer: "Good Smile Company", condition: .mint,
                   price: 68.99, originalPrice: 79.99, seller: s[0],
                   systemImageName: "Gojo Satoru", accentColorHex: "#6C5CE7",
                   description: "Includes Domain Expansion effect parts, sunglasses, and two face plates. Blindfold accessory included. Factory sealed.",
                   category: .nendoroid, stock: 3, isFlashSale: true),
            // 2
            Figure(id: UUID(), name: "Rem 1/7 Scale", series: "Re:Zero", character: "Rem",
                   scale: "1/7", manufacturer: "Kadokawa", condition: .excellent,
                   price: 129.99, originalPrice: 159.99, seller: s[1],
                   systemImageName: "Rem 1_7 Scale", accentColorHex: "#0984E3",
                   description: "Rem in maid outfit, dynamic pose on custom base. Minor box wear but figure is immaculate. A must-have for Re:Zero fans.",
                   category: .scale, stock: 1, isFlashSale: false),
            // 3
            Figure(id: UUID(), name: "Levi Ackerman", series: "Attack on Titan", character: "Levi",
                   scale: "Figma #213", manufacturer: "Max Factory", condition: .mint,
                   price: 95.00, originalPrice: 110.00, seller: s[2],
                   systemImageName: "Levi Ackerman", accentColorHex: "#636E72",
                   description: "Captain Levi with ODM gear, multiple interchangeable hands, and survey corps cloak. All accessories included.",
                   category: .figma, stock: 2, isFlashSale: false),
            // 4
            Figure(id: UUID(), name: "Zero Two", series: "Darling in the FranXX", character: "Zero Two",
                   scale: "Nendoroid #926", manufacturer: "Good Smile Company", condition: .mint,
                   price: 74.99, originalPrice: 84.99, seller: s[3],
                   systemImageName: "Zero Two", accentColorHex: "#D63031",
                   description: "Zero Two with candy prop, horns, and three expression face plates. Original packaging excellent.",
                   category: .nendoroid, stock: 1, isFlashSale: true),
            // 5
            Figure(id: UUID(), name: "Makima 1/7 Scale", series: "Chainsaw Man", character: "Makima",
                   scale: "1/7", manufacturer: "Alter", condition: .excellent,
                   price: 148.00, originalPrice: 175.00, seller: s[4],
                   systemImageName: "Makima 1_7 Scale", accentColorHex: "#E17055",
                   description: "Control Devil Makima in business attire. Hyper-realistic sculpt with detailed ring-patterned eyes. Box in great condition.",
                   category: .scale, stock: 1, isFlashSale: false),
            // 6
            Figure(id: UUID(), name: "Link – Breath of the Wild", series: "The Legend of Zelda", character: "Link",
                   scale: "Figma #320", manufacturer: "Max Factory", condition: .good,
                   price: 82.00, originalPrice: 105.00, seller: s[5],
                   systemImageName: "Link – Breath of the Wild", accentColorHex: "#00B894",
                   description: "Link with multiple weapons, poseable joints and cloth cape. Box has creasing but figure is display-ready.",
                   category: .figma, stock: 4, isFlashSale: false),
            // 7
            Figure(id: UUID(), name: "Nezuko Kamado", series: "Demon Slayer", character: "Nezuko",
                   scale: "Nendoroid #1309", manufacturer: "Good Smile Company", condition: .mint,
                   price: 59.99, originalPrice: 69.99, seller: s[6],
                   systemImageName: "Nezuko Kamado", accentColorHex: "#FD79A8",
                   description: "Nezuko in sleeping mode with bamboo muzzle and removable box prop. All parts present. Sealed bag still intact.",
                   category: .nendoroid, stock: 5, isFlashSale: false),
            // 8
            Figure(id: UUID(), name: "Asuka Langley 1/8", series: "Neon Genesis Evangelion", character: "Asuka",
                   scale: "1/8", manufacturer: "Kotobukiya", condition: .excellent,
                   price: 112.00, originalPrice: 130.00, seller: s[0],
                   systemImageName: "Asuka Langley 1_8", accentColorHex: "#E84393",
                   description: "Asuka in iconic plugsuit, dynamic battle pose on custom Eva Unit-02 pedestal. Professionally displayed, no damage.",
                   category: .scale, stock: 1, isFlashSale: false),
            // 9
            Figure(id: UUID(), name: "Naruto Uzumaki", series: "Naruto Shippuden", character: "Naruto",
                   scale: "Figma #404", manufacturer: "Max Factory", condition: .good,
                   price: 76.50, originalPrice: 98.00, seller: s[1],
                   systemImageName: "Naruto Uzumaki", accentColorHex: "#FDCB6E",
                   description: "Naruto in Sage Mode with Rasengan energy effect part. Headband missing but all other accessories complete.",
                   category: .figma, stock: 2, isFlashSale: true),
            // 10
            Figure(id: UUID(), name: "Hatsune Miku – Snow Ver.", series: "Vocaloid", character: "Hatsune Miku",
                   scale: "Nendoroid #380", manufacturer: "Good Smile Company", condition: .mint,
                   price: 88.00, originalPrice: 99.99, seller: s[2],
                   systemImageName: "Hatsune Miku – Snow Ver", accentColorHex: "#74B9FF",
                   description: "Snow Miku with winter outfit, leek accessory, and two snowflake effect parts. Winter festival exclusive. Pristine condition.",
                   category: .nendoroid, stock: 1, isFlashSale: false),
            // 11
            Figure(id: UUID(), name: "Yor Forger 1/7 Scale", series: "Spy x Family", character: "Yor Forger",
                   scale: "1/7", manufacturer: "Aniplex", condition: .mint,
                   price: 165.00, originalPrice: 195.00, seller: s[3],
                   systemImageName: "Yor Forger 1_7 Scale", accentColorHex: "#A29BFE",
                   description: "Thorn Princess Yor in cocktail dress with thrown daggers effect. Premium sculpt by Phat Company. Factory new.",
                   category: .scale, stock: 1, isFlashSale: false),
            // 12
            Figure(id: UUID(), name: "Mikasa Ackerman", series: "Attack on Titan", character: "Mikasa",
                   scale: "Figma #241", manufacturer: "Max Factory", condition: .excellent,
                   price: 88.00, originalPrice: 108.00, seller: s[4],
                   systemImageName: "Mikasa Ackerman", accentColorHex: "#B2BEC3",
                   description: "Mikasa with ODM gear, blades, and survey corps scarf. All joints smooth. Displayed in glass case previously.",
                   category: .figma, stock: 3, isFlashSale: false),
            // 13
            Figure(id: UUID(), name: "Monkey D. Luffy", series: "One Piece", character: "Luffy",
                   scale: "Nendoroid #1063", manufacturer: "Good Smile Company", condition: .mint,
                   price: 62.00, originalPrice: 72.99, seller: s[5],
                   systemImageName: "Monkey D. Luffy", accentColorHex: "#FDBE4B",
                   description: "Luffy with straw hat, meat accessory, and Gear 4 face plate. Pirate King vibes included. Box mint sealed.",
                   category: .nendoroid, stock: 6, isFlashSale: true),
        ]
    }

    // MARK: - Sample Orders
    private func loadSampleOrders() {
        // Will be populated dynamically; start with one delivered sample
    }

    // MARK: - Methods

    func purchaseFigure(_ figure: Figure) -> Order {
        let order = Order(
            id: UUID(),
            figure: figure,
            status: .confirmed,
            orderDate: Date(),
            quantity: 1,
            total: figure.price,
            orderNumber: "ANT-\(Int.random(in: 100000...999999))"
        )
        orders.insert(order, at: 0)

        // Reduce stock
        if let index = figures.firstIndex(where: { $0.id == figure.id }) {
            figures[index].stock = max(0, figures[index].stock - 1)
        }

        return order
    }


    func figures(for category: FigureCategory) -> [Figure] {
        if category == .all { return figures }
        return figures.filter { $0.category == category }
    }

    func searchFigures(query: String) -> [Figure] {
        guard !query.isEmpty else { return figures }
        let q = query.lowercased()
        return figures.filter {
            $0.name.lowercased().contains(q) ||
            $0.series.lowercased().contains(q) ||
            $0.character.lowercased().contains(q) ||
            $0.manufacturer.lowercased().contains(q)
        }
    }

    func flashSaleFigures() -> [Figure] {
        figures.filter { $0.isFlashSale }
    }
}
