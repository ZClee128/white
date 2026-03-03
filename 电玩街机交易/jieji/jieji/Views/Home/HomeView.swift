import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @State private var selectedCategory: String = "All Categories"
    
    // Derived properties
    var allCategories: [String] {
        var categories = ["All Categories"]
        let uniqueCategories = Array(Set(Machine.mockData.map { $0.category })).sorted()
        categories.append(contentsOf: uniqueCategories)
        return categories
    }
    
    var trendingMachines: [Machine] {
        Machine.mockData.filter { $0.isTrending }
    }
    
    var filteredMachines: [Machine] {
        var result = Machine.mockData
        if selectedCategory != "All Categories" {
            result = result.filter { $0.category == selectedCategory }
        }
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        return result
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // 1. Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search machines...", text: $searchText)
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                    )
                    .padding(.horizontal)
                    
                    // 2. Hero Carousel (Trending)
                    if searchText.isEmpty && selectedCategory == "All Categories" {
                        VStack(alignment: .leading) {
                            Text("Trending Now")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            TabView {
                                ForEach(trendingMachines.prefix(5)) { machine in
                                    NavigationLink(destination: MachineDetailView(machine: machine)) {
                                        HeroCardView(machine: machine)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                            .frame(height: 220)
                        }
                    }
                    
                    // 3. Category Pills (Horizontal Scroll)
                    if searchText.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(allCategories, id: \.self) { category in
                                    CategoryPill(title: category, isSelected: selectedCategory == category) {
                                        withAnimation {
                                            selectedCategory = category
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // 4. Content List (Vertical)
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(selectedCategory == "All Categories" ? "New Arrivals" : selectedCategory)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text("\(filteredMachines.count) items")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        
                        ForEach(filteredMachines) { machine in
                            NavigationLink(destination: MachineDetailView(machine: machine)) {
                                StandardListCardView(machine: machine)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.top, 10)
            }
            .navigationTitle("Arcade Machines")
            .navigationBarTitleDisplayMode(.inline)
            // Hides the inline title while giving space, modern look
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Text("Arcadium")
//                        .font(.title)
//                        .fontWeight(.heavy)
//                        .foregroundStyle(
//                            LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing)
//                        )
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Image(systemName: "bell.badge.fill")
//                        .foregroundColor(.blue)
//                }
//            }
        }
    }
}

// MARK: - Subviews

struct HeroCardView: View {
    let machine: Machine
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            Image(machine.name)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            
            // Gradient Overlay for Text Readability
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Glassmorphism Content Box
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("HOT")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red)
                        .cornerRadius(8)
                    
                    Text(machine.category.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Text(machine.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(String(format: "$%.2f", machine.price))
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .padding(10)
        }
        .padding(.horizontal)
        .padding(.bottom, 40) // Space for paging dots
        .shadow(color: Color(hex: machine.coverColorHex)?.opacity(0.4) ?? .gray, radius: 10, x: 0, y: 5)
    }
}

struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .medium)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    isSelected ? 
                    AnyView(Capsule().fill(Color.accentColor)) : 
                    AnyView(Capsule().stroke(Color(.systemGray4), lineWidth: 1))
                )
        }
    }
}

struct StandardListCardView: View {
    let machine: Machine
    
    var body: some View {
        HStack(spacing: 16) {
            // Complex Image Container
            Image(machine.name)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Text Content
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(machine.category)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Spacer()
                    if machine.isTrending {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                }
                
                Text(machine.name)
                    .font(.headline)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                HStack {
                    Text(String(format: "$%.2f", machine.price))
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "cart.badge.plus")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                }
            }
            .padding(.vertical, 6)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    HomeView()
}
