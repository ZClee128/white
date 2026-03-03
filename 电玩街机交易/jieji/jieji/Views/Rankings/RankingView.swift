import SwiftUI

struct RankingView: View {
    @State private var selectedTab: Int = 0
    
    // Derived Data
    var trendingMachines: [Machine] {
        Machine.mockData.filter { $0.isTrending }.sorted { $0.price > $1.price }
    }
    
    var premiumMachines: [Machine] {
        Machine.mockData.sorted { $0.price > $1.price }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header Segment
                VStack(alignment: .leading, spacing: 16) {
                    Text("Rankings")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .padding(.horizontal)
                    
                    Picker("Rankings Type", selection: $selectedTab) {
                        Text("Trending Top 10").tag(0)
                        Text("Premium Value").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                .padding(.top, 10)
                .background(Color(.systemBackground))
                
                // Content List
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        let machinesToList = selectedTab == 0 ? trendingMachines : premiumMachines
                        
                        ForEach(Array(machinesToList.enumerated()), id: \.element.id) { index, machine in
                            NavigationLink(destination: MachineDetailView(machine: machine)) {
                                RankingCardView(machine: machine, rank: index + 1)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
            }
            .navigationBarHidden(true)
        }
    }
}

struct RankingCardView: View {
    let machine: Machine
    let rank: Int
    
    var crownColor: Color {
        switch rank {
        case 1: return Color.yellow     // Gold
        case 2: return Color.gray       // Silver
        case 3: return Color(hex: "#CD7F32") ?? .orange // Bronze
        default: return .clear
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            
            // Rank Display
            VStack {
                if rank <= 3 {
                    Image(systemName: "crown.fill")
                        .foregroundColor(crownColor)
                        .font(.headline)
                        .padding(.bottom, 2)
                }
                Text("\(rank)")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(rank <= 3 ? .primary : .secondary.opacity(0.5))
            }
            .frame(width: 40)
            
            // Image
            Image(machine.name)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Details
            VStack(alignment: .leading, spacing: 6) {
                Text(machine.name)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack {
                    Text(machine.category.uppercased())
                        .font(Font.caption.weight(.bold))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(String(format: "$%.2f", machine.price))
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    RankingView()
}
