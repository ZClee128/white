import SwiftUI

struct MachineDetailView: View {
    let machine: Machine
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAddedToast = false
    @State private var offset: CGFloat = 0
    @State private var isDescriptionExpanded = true
    
    // Generate fake specs for UI complexity
    var specs: [(icon: String, title: String, value: String)] {
        [
            ("ruler.fill", "Dimensions", "78x34x42 in"),
            ("bolt.fill", "Power", "120V / 60Hz"),
            ("scalemass.fill", "Weight", "380 lbs"),
            ("display", "Screen", "4K HDR")
        ]
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // 1. Sticky Hero Header
                    GeometryReader { proxy in
                        let minY = proxy.frame(in: .global).minY
                        let height = proxy.size.height
                        
                        ZStack {
                            // Real Image Background
                            Image(machine.name)
                                .resizable()
                                .scaledToFill()
                                .frame(width: proxy.size.width, height: minY > 0 ? height + minY : height)
                                .clipped()
                                .scaleEffect(minY > 0 ? 1.0 + (minY / 500) : 1.0)
                                .offset(y: minY > 0 ? -minY / 2 : 0)
                                
                            // Light gradient overlay to ensure top navigation readability
                            LinearGradient(
                                gradient: Gradient(colors: [.black.opacity(0.4), .clear, .clear]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                        .frame(height: minY > 0 ? height + minY : height)
                        .offset(y: minY > 0 ? -minY : 0)
                    }
                    .frame(height: 350)
                    
                    // 2. Content Body
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Title & Badge
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(machine.category.uppercased())
                                    .font(Font.caption.weight(.black))
                                    .foregroundColor(Color(hex: machine.coverColorHex) ?? .accentColor)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background((Color(hex: machine.coverColorHex) ?? .accentColor).opacity(0.1))
                                    .cornerRadius(8)
                                
                                if machine.isTrending {
                                    HStack(spacing: 4) {
                                        Image(systemName: "flame.fill")
                                        Text("HOT")
                                    }
                                    .font(Font.caption.weight(.black))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.orange)
                                    .cornerRadius(8)
                                }
                            }
                            
                            Text(machine.name)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        Divider()
                        
                        // Fake Spec Grid for 4.3 Mitigation
                        Text("Specifications")
                            .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(specs, id: \.title) { spec in
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(.systemGray6))
                                            .frame(width: 40, height: 40)
                                        Image(systemName: spec.icon)
                                            .foregroundColor(.primary)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(spec.title)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(spec.value)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                    }
                                    Spacer()
                                }
                                .padding(10)
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                // Minimal shadow
                                .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                            }
                        }
                        
                        Divider()
                        
                        // Expandable Description
                        DisclosureGroup(
                            isExpanded: $isDescriptionExpanded,
                            content: {
                                Text(machine.description)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .lineSpacing(6)
                                    .padding(.top, 10)
                            },
                            label: {
                                Text("About Machine")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                        )
                        
                        // Padding at bottom to account for floating bar
                        Spacer(minLength: 120)
                    }
                    .padding(24)
                    .background(Color(.systemBackground))
                    // Rounded top corners overlapping the image
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .offset(y: -30)
                }
                .coordinateSpace(name: "scroll")
            }
            .edgesIgnoringSafeArea(.top)
            
            // 3. Floating Action Cart Bar
            VStack {
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Price")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Text(String(format: "$%.2f", machine.price))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        let haptic = UIImpactFeedbackGenerator(style: .medium)
                        haptic.impactOccurred()
                        
                        cartManager.addToCart(machine: machine)
                        withAnimation(.spring()) {
                            showAddedToast = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showAddedToast = false
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "cart.badge.plus")
                            Text("Add to Cart")
                        }
                        .font(.headline)
                        .foregroundColor(Color(hex: machine.coverColorHex) ?? .purple)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color(hex: machine.coverColorHex) ?? Color.black)
                .cornerRadius(24)
                .padding(.horizontal, 16)
                .padding(.bottom, 10) // Lifted slightly from home indicator
                .shadow(color: Color(hex: machine.coverColorHex)?.opacity(0.4) ?? .black.opacity(0.2), radius: 15, x: 0, y: 10)
            }
            
            // Toast Notification Overlay
            if showAddedToast {
                VStack {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Added to Cart")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    // Blur background
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.top, 60)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    
                    Spacer()
                }
                .zIndex(1)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - View Extension for selective corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
