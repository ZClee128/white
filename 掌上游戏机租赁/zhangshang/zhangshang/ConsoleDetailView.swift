import SwiftUI

struct ConsoleDetailView: View {
    let console: Console
    var discountedPrice: Double? = nil
    @State private var showingCheckout = false
    
    var priceToShow: Double {
        discountedPrice ?? console.dailyPrice
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Hero Image
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [.purple.opacity(0.2), .blue.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(height: 250)
                    
                    Image(console.name)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .shadow(radius: 10)
                }
                .cornerRadius(20)
                .padding(.horizontal)
                
                // Details Info
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(console.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("¥\(String(format: "%.1f", priceToShow))/day")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                            
                            if discountedPrice != nil {
                                Text("¥\(String(format: "%.0f", console.dailyPrice))")
                                    .font(.caption)
                                    .strikethrough()
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Text("Deposit: ¥\(String(format: "%.0f", console.deposit)) (Refundable)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("About this device")
                        .font(.headline)
                    Text(console.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                    
                    Divider()
                    
                    Text("Features")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(console.features, id: \.self) { feature in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(feature)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer(minLength: 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button(action: {
                showingCheckout = true
            }) {
                Text("Rent Now")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(16)
                    .shadow(color: .purple.opacity(0.3), radius: 5, x: 0, y: 5)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 10)
            .background(Color(UIColor.systemBackground).opacity(0.95))
        }
        .sheet(isPresented: $showingCheckout) {
            CheckoutView(console: console, discountedPrice: discountedPrice)
        }
    }
}

#Preview {
    NavigationView {
        ConsoleDetailView(console: MockData.consoles[0])
    }
}
