import SwiftUI

struct DetailView: View {
    let figure: Figure
    @EnvironmentObject var store: StoreData
    
    @State private var showingAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Image
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [figure.color.opacity(0.4), figure.color.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                        .frame(height: 350)
                        .edgesIgnoringSafeArea(.top)
                    
                    Image(figure.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 10)
                }
                
                // Info Section
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(figure.name)
                            .font(.system(size: 28, weight: .bold, design: .serif))
                        
                        Spacer()
                        
                        Text(figure.characterRole)
                            .font(.headline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(figure.color.opacity(0.2))
                            .foregroundColor(figure.color)
                            .cornerRadius(10)
                    }
                    
                    Text(figure.playName)
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text(String(format: "¥%.2f", figure.price))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.red)
                    
                    // Service Banner
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 12) {
                            ServiceTag(icon: "checkmark.seal.fill", text: "Authentic Guarantee")
                            ServiceTag(icon: "arrow.uturn.backward.circle.fill", text: "7-Day Return")
                            ServiceTag(icon: "shippingbox.fill", text: "Fast Shipping")
                        }
                        HStack(spacing: 12) {
                            ServiceTag(icon: "shield.lefthalf.filled", text: "Damage Coverage", color: .orange)
                            ServiceTag(icon: "rosette", text: "After-Sales Support", color: .blue)
                        }
                    }
                    .padding(.vertical, 5)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    Text("Background")
                        .font(.headline)
                        .padding(.bottom, 2)
                    
                    Text(figure.description)
                        .font(.body)
                        .lineSpacing(6)
                        .foregroundColor(Color.primary.opacity(0.8))
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    Text("Purchase Notes & After-sales")
                        .font(.headline)
                        .padding(.bottom, 2)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        InfoRow(index: "1", text: "All Peking Opera figures are purely hand-painted and baked, using high-quality eco-friendly resin materials. Due to hand-painting, each piece may have very slight individual differences in detail, which is normal.")
                        InfoRow(index: "2", text: "We go through 3 strict quality inspection procedures before shipping. Upon receiving the goods, if there is obvious damage or breakage caused by logistics, please keep the shipping label and contact online customer service within 48 hours. We will replace it with a new piece for free.")
                        InfoRow(index: "3", text: "For non-quality problems (such as slight uneven coloring, subjective dislike) under the premise of not affecting secondary sales, we support a 7-day no-reason return. The buyer is responsible for round-trip shipping costs.")
                        InfoRow(index: "4", text: "Product maintenance advice: Keep away from direct sunlight and humid environments; when dusty, please use the included soft brush to gently dust off. Do not use water or chemical solvents to wipe, so as not to damage the paint coating.")
                    }
                }
                .padding()
                .padding(.bottom, 40) // padding for floating bar
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {

            // Action button anchored at the bottom with UltraThin blur
            VStack {
                Button(action: {
                    store.addToCart(figure)
                    showingAlert = true
                }) {
                    Text("Add to Cart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(25)
                        .shadow(color: Color.red.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            .background(.ultraThinMaterial)
        }
        .alert("Added to Cart", isPresented: $showingAlert) {
            Button("Continue Shopping", role: .cancel) { }
        }
    }
}

#Preview {
    DetailView(figure: StoreData().figures[0])
        .environmentObject(StoreData())
}

struct ServiceTag: View {
    let icon: String
    let text: String
    var color: Color = .green
    
    init(icon: String = "checkmark.circle.fill", text: String, color: Color = .green) {
        self.icon = icon
        self.text = text
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundColor(color)
            Text(text)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .cornerRadius(6)
    }
}

struct InfoRow: View {
    let index: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\(index).")
                .font(.subheadline)
                .foregroundColor(.red)
                .fontWeight(.bold)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
    }
}
