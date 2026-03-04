import SwiftUI

struct OrderSuccessView: View {
    @Binding var goHome: Bool
    @Environment(\.presentationMode) var presentationMode
    
    // We want to pop all the way to root when "Done" is pressed
    // A simple hack in SwiftUI without iOS 16 NavigationStack is to use root presentation mode or just rely on a binding.
    // For simplicity, since we are using presentationMode for NavLink, we can just use a full dismiss or App state change.
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color(hex: "#07C160").opacity(0.1))
                    .frame(width: 150, height: 150)
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(hex: "#07C160"))
            }
            
            VStack(spacing: 12) {
                Text("Order Placed!")
                    .font(.system(size: 28, weight: .bold))
                
                Text("Your Bouncy Castle rental is booked. Please wait for delivery and pay upon arrival (Cash on Delivery).")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            // Button to pop back to root
            Button(action: {
                goHome = false // This manually triggers the pop to root
            }) {
                Text("Back to Home")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .navigationBarHidden(true)
    }
}
