import SwiftUI

struct DetailView: View {
    let castle: BouncyCastle
    @Binding var goHome: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddress = false
    @State private var rentalDays = 1
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header Image Area
                    ZStack(alignment: .topLeading) {
                        Color(hex: castle.themeColorHex)
                            .frame(height: 350) // Reduced height slightly to show content sooner
                        
                        Image(castle.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 350)
                            .clipped()
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                                .padding(16)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                        }
                        .padding(.top, 50)
                        .padding(.leading, 20)
                    }
                    
                    // Content Area
                    VStack(alignment: .leading, spacing: 24) {
                        // Title Block
                        VStack(alignment: .leading, spacing: 8) {
                            Text(castle.name)
                                .font(.system(size: 32, weight: .bold, design: .serif))
                            
                            HStack {
                                ForEach(castle.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.system(size: 10, weight: .bold))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.black.opacity(0.05))
                                        .cornerRadius(6)
                                }
                            }
                        }
                        
                        // Key Specs
                        HStack(spacing: 12) {
                            SpecItem(icon: "person.2.fill", title: "Capacity", value: "\(castle.capacity) Kids")
                            SpecItem(icon: "ruler.fill", title: "Size", value: castle.dimensions)
                            SpecItem(icon: "star.fill", title: "Rating", value: "4.9/5.0")
                        }
                        
                        Divider()
                        
                        // Description Module
                        VStack(alignment: .leading, spacing: 12) {
                            Text("About This Rental")
                                .font(.system(size: 20, weight: .bold))
                            
                            Text(castle.description)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.black.opacity(0.7))
                                .lineSpacing(6)
                        }
                        
                        // Included Items Module
                        VStack(alignment: .leading, spacing: 16) {
                            Text("What's Included")
                                .font(.system(size: 20, weight: .bold))
                            
                            VStack(spacing: 12) {
                                IncludedItem(icon: "wind", text: "Heavy-duty electric blower")
                                IncludedItem(icon: "hammer.fill", text: "Stakes and securing straps")
                                IncludedItem(icon: "shield.fill", text: "Tarp and safety mats")
                                IncludedItem(icon: "truck.box.fill", text: "Free delivery & setup")
                            }
                        }
                        .padding()
                        .background(Color(hex: "#FAFAFA"))
                        .cornerRadius(16)
                        
                        // Safety Rules Module
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Safety Rules")
                                .font(.system(size: 20, weight: .bold))
                            
                            VStack(alignment: .leading, spacing: 10) {
                                RuleText(text: "adult supervision required at all times.")
                                RuleText(text: "No shoes, glasses, or jewelry.")
                                RuleText(text: "No food, drinks, or silly string.")
                                RuleText(text: "Do not use in high winds or rain.")
                            }
                        }
                        
                        Spacer().frame(height: 120) // Padding for sticky bottom bar
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .offset(y: -30)
                }
            }
            .edgesIgnoringSafeArea(.top)
            
            // Sticky Bottom Bar
            VStack {
                Divider()
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Total Amount")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        Text("$\(String(format: "%.0f", castle.pricePerDay * Double(rentalDays)))")
                            .font(.system(size: 24, weight: .black))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    // Custom Duration Stepper
                    HStack(spacing: 8) {
                        Button(action: {
                            if rentalDays > 1 { rentalDays -= 1 }
                        }) {
                            Image(systemName: "minus")
                                .font(.system(size: 14, weight: .bold))
                                .frame(width: 28, height: 28)
                                .foregroundColor(rentalDays > 1 ? .black : .gray)
                                .background(Color.black.opacity(0.05))
                                .clipShape(Circle())
                        }
                        
                        Text("\(rentalDays) \(rentalDays == 1 ? "Day" : "Days")")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                            .frame(minWidth: 45, alignment: .center)
                        
                        Button(action: {
                            if rentalDays < 7 { rentalDays += 1 }
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .bold))
                                .frame(width: 28, height: 28)
                                .foregroundColor(rentalDays < 7 ? .black : .gray)
                                .background(Color.black.opacity(0.05))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.trailing, 8)
                    
                    NavigationLink(destination: AddressView(castle: castle, rentalDays: rentalDays, goHome: $goHome), isActive: $showingAddress) {
                        Text("Rent Now")
                            .font(.system(size: 16, weight: .bold))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(Color.black)
                            .cornerRadius(25)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 36) // Safe area
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
    }
}

struct IncludedItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.black)
                .font(.system(size: 18))
                .frame(width: 24, height: 24)
            Text(text)
                .font(.system(size: 15))
            Spacer()
        }
    }
}

struct RuleText: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(Color.black)
                .frame(width: 6, height: 6)
                .padding(.top, 8)
            Text(text.capitalized)
                .font(.system(size: 15))
                .foregroundColor(.black.opacity(0.8))
                .lineLimit(nil)
        }
    }
}

// Keeping SpecItem and RoundedCorner extensions that were here previously
struct SpecItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.black)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.04))
        .cornerRadius(12)
    }
}

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
