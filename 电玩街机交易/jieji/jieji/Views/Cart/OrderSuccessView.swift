import SwiftUI

struct OrderSuccessView: View {
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.presentationMode) var presentationMode
    
    // We want to pop straight to root. Using a notification is one way in older SwiftUI,
    // or we can use presentationMode recursively although it's messy.
    // For simplicity, we just provide a button that takes users to the Orders tab.
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 150, height: 150)
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green)
            }
            
            VStack(spacing: 12) {
                Text("Payment Successful!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Your arcade machines are being prepared for shipping.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            // To properly go back to root without complex navigation state parsing in this simple app,
            // we will provide a message. The user can navigate using Tab bar.
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    // Pop to root could be tricky in pure NavigationView without a binding.
                    // Instead we can instruct users to tap the Orders tab, or we can use a hack.
                    // For a simple app, we can just allow them to dismiss it or we reset state.
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: MainTabView()
                            .environmentObject(CartManager())
                            .environmentObject(AddressManager())
                            .environmentObject(OrderManager())
                        )
                        window.makeKeyAndVisible()
                    }
                }
            }
        }
    }
}
