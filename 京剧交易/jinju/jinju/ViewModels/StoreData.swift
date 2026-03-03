import SwiftUI
import Combine

class StoreData: ObservableObject {
    @Published var figures: [Figure] = []
    
    @Published var cart: [Figure] = [] {
        didSet { saveUserData() }
    }
    @Published var orders: [Order] = [] {
        didSet { saveUserData() }
    }
    @Published var addresses: [Address] = [] {
        didSet { saveUserData() }
    }
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("currentUserPhone") var currentUserPhone: String = ""
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadData()
        if isLoggedIn && !currentUserPhone.isEmpty {
            restoreUserData()
        }
    }
    
    func loadData() {
        figures = [
            Figure(name: "Mei Lanfang", imageName: "mei_lan_fang", characterRole: "Dan (Qingyi)", playName: "Mu Guiying Takes Command", price: 599.0, description: "Masterpiece of the Mei school, depicting the heroic image of Mu Guiying defending the country.", colorName: "pink"),
            Figure(name: "Cheng Yanqiu", imageName: "cheng_yan_qiu", characterRole: "Dan (Qingyi)", playName: "The Suolin Purse", price: 699.0, description: "Classic of the Cheng school, Xue Xiangling's figure, elegant and beautiful.", colorName: "purple"),
            Figure(name: "Shang Xiaoyun", imageName: "shang_xiao_yun", characterRole: "Dan (Daomadan)", playName: "Zhaojun Departs the Frontier", price: 659.0, description: "Masterpiece of the Shang school, Wang Zhaojun marrying far away, vigorous and graceful.", colorName: "red"),
            Figure(name: "Xun Huisheng", imageName: "xun_hui_sheng", characterRole: "Dan (Huadan)", playName: "The Matchmaker", price: 499.0, description: "Classic of the Xun school, lively Hongniang figure, showing innocent charm.", colorName: "mint"),
            Figure(name: "Ma Lianliang", imageName: "ma_lian_liang", characterRole: "Laosheng", playName: "Borrowing the East Wind", price: 799.0, description: "Masterpiece of the Ma school, Zhuge Liang with feather fan, free and easy.", colorName: "blue"),
            Figure(name: "Tan Xinpei", imageName: "tan_xin_pei", characterRole: "Laosheng", playName: "Mount Dingjun", price: 899.0, description: "Masterpiece of the Tan school, classic look of Huang Zhong in his old age.", colorName: "orange"),
            Figure(name: "Qiu Shengrong", imageName: "qiu_sheng_rong", characterRole: "Jing (Hualian)", playName: "The Execution of Chen Shimei", price: 550.0, description: "Bao Zheng from the Qiu school, majestic and imposing.", colorName: "black"),
            Figure(name: "Yuan Shihai", imageName: "yuan_shi_hai", characterRole: "Jing (Jiazihua)", playName: "Gathering of Heroes", price: 620.0, description: "Cao Cao from the Yuan school, extraordinary bearing.", colorName: "gray"),
            Figure(name: "Ye Shenglan", imageName: "ye_sheng_lan", characterRole: "Xiaosheng", playName: "Luo Cheng Writes a Letter", price: 580.0, description: "Classic Wu Xiaosheng from the Ye school, Luo Cheng in silver armor.", colorName: "cyan"),
            Figure(name: "Li Duokui", imageName: "li_duo_kui", characterRole: "Laodan", playName: "Fishing for the Golden Turtle", price: 450.0, description: "Madam Kang from the Li school, showing the vigorous charm of Laodan.", colorName: "brown"),
            Figure(name: "Xiao Changhua", imageName: "xiao_chang_hua", characterRole: "Chou", playName: "Gathering of Heroes", price: 420.0, description: "Classic Jiang Gan figure from the famous clown.", colorName: "yellow"),
            Figure(name: "Gai Jiaotian", imageName: "gai_jiao_tian", characterRole: "Wusheng", playName: "Crossroads", price: 880.0, description: "Classic Wu Song from the Gai school, full of action tension.", colorName: "indigo"),
            Figure(name: "Farewell My Concubine", imageName: "farewell_my_concubine", characterRole: "Jing & Dan", playName: "Farewell My Concubine", price: 1299.0, description: "Limited edition dual figure, perfectly blending Xiang Yu's tragedy and Consort Yu's beauty.", colorName: "primary")
        ]
    }
    
    // MARK: - Local Database Persistence
    
    private var cartKey: String { "cart_\(currentUserPhone)" }
    private var ordersKey: String { "orders_\(currentUserPhone)" }
    private var addressesKey: String { "addresses_\(currentUserPhone)" }
    
    private func saveUserData() {
        guard isLoggedIn, !currentUserPhone.isEmpty else { return }
        if let encodedCart = try? JSONEncoder().encode(cart) { userDefaults.set(encodedCart, forKey: cartKey) }
        if let encodedOrders = try? JSONEncoder().encode(orders) { userDefaults.set(encodedOrders, forKey: ordersKey) }
        if let encodedAddresses = try? JSONEncoder().encode(addresses) { userDefaults.set(encodedAddresses, forKey: addressesKey) }
    }
    
    private func restoreUserData() {
        if let cartData = userDefaults.data(forKey: cartKey), let decodedCart = try? JSONDecoder().decode([Figure].self, from: cartData) {
            cart = decodedCart
        } else { cart = [] }
        
        if let ordersData = userDefaults.data(forKey: ordersKey), let decodedOrders = try? JSONDecoder().decode([Order].self, from: ordersData) {
            orders = decodedOrders
        } else { orders = [] }
        
        if let addressData = userDefaults.data(forKey: addressesKey), let decodedAddress = try? JSONDecoder().decode([Address].self, from: addressData) {
            addresses = decodedAddress
        } else { addresses = [] }
    }
    
    // MARK: - Actions
    
    func login(phone: String) {
        currentUserPhone = phone
        isLoggedIn = true
        restoreUserData() // Fetch this user's persistent data
    }
    
    // Soft logout: memory cleared, but persistent data remains
    func logout() {
        isLoggedIn = false
        currentUserPhone = ""
        cart.removeAll()
        orders.removeAll()
        addresses.removeAll()
    }
    
    // Hard delete: remove permanent data
    func deleteAccount() {
        userDefaults.removeObject(forKey: cartKey)
        userDefaults.removeObject(forKey: ordersKey)
        userDefaults.removeObject(forKey: addressesKey)
        logout()
    }
    
    func addAddress(_ address: Address) {
        if address.isDefault {
            for i in 0..<addresses.count {
                addresses[i].isDefault = false
            }
        }
        var newAddress = address
        if addresses.isEmpty {
            newAddress.isDefault = true
        }
        addresses.append(newAddress)
    }
    
    func addToCart(_ figure: Figure) {
        cart.append(figure)
    }
    
    func removeFromCart(at offsets: IndexSet) {
        cart.remove(atOffsets: offsets)
    }
    
    var cartTotal: Double {
        cart.reduce(0) { $0 + $1.price }
    }
    
    func checkout(address: Address, paymentMethod: String) {
        guard !cart.isEmpty else { return }
        let order = Order(items: cart, total: cartTotal, date: Date(), address: address, paymentMethod: paymentMethod)
        orders.insert(order, at: 0) // Newest first
        cart.removeAll()
    }
}

struct Order: Identifiable, Codable, Equatable {
    var id = UUID()
    let items: [Figure]
    let total: Double
    let date: Date
    let address: Address
    let paymentMethod: String
}
