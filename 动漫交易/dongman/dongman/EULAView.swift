import SwiftUI

struct EULAView: View {
    @AppStorage("hasAcceptedEULA") private var hasAcceptedEULA: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "hand.raised.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
                .padding(.top, 40)
            
            Text("End User License Agreement")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Welcome to Dongman Anime Trading!")
                        .font(.headline)
                    
                    Text("By using this app, you agree to the following terms regarding User-Generated Content (UGC):")
                    
                    Text("1. No Tolerance for Objectionable Content: You agree not to post, upload, or share any content that is offensive, abusive, defamatory, obscene, or otherwise objectionable.")
                        .fontWeight(.semibold)
                    
                    Text("2. No Tolerance for Abusive Users: Abusive behavior, harassment, and bullying will not be tolerated. Users found engaging in such behavior will have their accounts terminated.")
                        .fontWeight(.semibold)
                    
                    Text("3. Content Moderation: We reserve the right to review, filter, and remove any content that violates these terms at any time without prior notice.")
                    
                    Text("4. Reporting and Blocking: You can report objectionable content and block abusive users using the in-app features. We commit to acting on reports within 24 hours by removing the offending content and ejecting the responsible user.")
                    
                    Text("By tapping 'Agree', you confirm that you have read, understood, and agree to abide by these terms.")
                }
                .padding()
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Button(action: {
                hasAcceptedEULA = true
            }) {
                Text("I Agree")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .background(Color(.systemBackground).ignoresSafeArea())
    }
}

#Preview {
    EULAView()
}
