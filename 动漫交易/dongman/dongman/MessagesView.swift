import SwiftUI

struct MessagesView: View {
    let sellerName: String
    @Environment(\.dismiss) var dismiss
    @State private var inputText: String = ""
    @State private var messages: [ChatMessage] = []
    @FocusState private var focused: Bool

    private let initials: [ChatMessage] = []  // populated in onAppear

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.07, blue: 0.12).ignoresSafeArea()

                VStack(spacing: 0) {
                    // Seller header
                    sellerHeader

                    Divider().background(Color.white.opacity(0.08))

                    // Messages
                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 10) {
                                ForEach(messages) { msg in
                                    MessageBubble(message: msg)
                                        .id(msg.id)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                        }
                        .onChange(of: messages.count) { _ in
                            if let last = messages.last {
                                withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                            }
                        }
                    }

                    // Input bar
                    inputBar
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                setupInitialMessages()
            }
        }
    }

    private var sellerHeader: some View {
        HStack(spacing: 12) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }

            ZStack {
                Circle()
                    .fill(Color(red: 0.42, green: 0.36, blue: 0.91).opacity(0.3))
                    .frame(width: 40, height: 40)
                Text(String(sellerName.prefix(1)))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(sellerName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color(red: 0.0, green: 0.78, blue: 0.55))
                        .frame(width: 6, height: 6)
                    Text("Online")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(red: 0.09, green: 0.09, blue: 0.14))
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Message...", text: $inputText)
                .foregroundColor(.white)
                .tint(Color(red: 0.42, green: 0.36, blue: 0.91))
                .focused($focused)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.08))
                .cornerRadius(22)

            Button {
                sendMessage()
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(colors: [Color(red: 0.42, green: 0.36, blue: 0.91), Color(red: 0.6, green: 0.1, blue: 0.8)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(Circle())
            }
            .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color(red: 0.09, green: 0.09, blue: 0.14))
    }

    private func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        let msg = ChatMessage(id: UUID(), senderName: "Me", content: trimmed, timestamp: Date(), isFromCurrentUser: true)
        messages.append(msg)
        inputText = ""

        // Auto-reply after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            let replies = [
                "Sure, it's in great condition!",
                "I can ship within 2 business days.",
                "Thanks for your interest! 😊",
                "Yes, all accessories are included.",
                "I accept PayPal and bank transfer too.",
            ]
            let reply = ChatMessage(id: UUID(), senderName: sellerName,
                                    content: replies.randomElement()!, timestamp: Date(),
                                    isFromCurrentUser: false)
            messages.append(reply)
        }
    }

    private func setupInitialMessages() {
        messages = [
            ChatMessage(id: UUID(), senderName: sellerName,
                        content: "Hi! Thanks for checking out my listing. Feel free to ask anything! 🎌",
                        timestamp: Date().addingTimeInterval(-120), isFromCurrentUser: false),
        ]
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isFromCurrentUser { Spacer(minLength: 60) }

            VStack(alignment: message.isFromCurrentUser ? .trailing : .leading, spacing: 2) {
                Text(message.content)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        message.isFromCurrentUser ?
                        LinearGradient(colors: [Color(red: 0.42, green: 0.36, blue: 0.91), Color(red: 0.6, green: 0.1, blue: 0.8)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [Color(red: 0.14, green: 0.14, blue: 0.2), Color(red: 0.14, green: 0.14, blue: 0.2)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(18)
                Text(timeStr(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }

            if !message.isFromCurrentUser { Spacer(minLength: 60) }
        }
    }

    private func timeStr(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.timeStyle = .short
        return fmt.string(from: date)
    }
}
