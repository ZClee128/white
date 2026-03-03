import SwiftUI

struct ProductDetailView: View {
    @Environment(RentalStore.self) var store
    let laptop: Laptop
    @State private var selectedDuration: RentalDuration = .sevenDays
    @State private var showRentalForm = false

    var totalPrice: Double {
        selectedDuration.totalPrice(
            daily: laptop.dailyPrice,
            weekly: laptop.weeklyPrice,
            monthly: laptop.monthlyPrice,
            isDiscounted: laptop.isDiscounted
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Device Hero
                deviceHero

                // Specs
                specsSection

                // Duration Picker
                durationSection

                // Price Summary + CTA
                priceCTA
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(laptop.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showRentalForm) {
            RentalFormView(laptop: laptop, selectedDuration: selectedDuration)
        }
    }

    // MARK: Device Hero
    private var deviceHero: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 260)

            VStack(spacing: 16) {
                Image(laptop.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 240, maxHeight: 150)

                VStack(spacing: 4) {
                    Text(laptop.brand)
                        .font(.caption.bold())
                        .foregroundColor(Color(hex: "e94560"))
                        .tracking(2)

                    Text(laptop.name)
                        .font(.title2.bold())
                        .foregroundColor(.white)

                    if !laptop.isAvailable {
                        Text("Currently Unavailable")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(Color.red.opacity(0.7)))
                    }
                }
            }
        }
    }

    // MARK: Specs
    private var specsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Specifications")
                .font(.headline)
                .padding(.horizontal, 20)
                .padding(.top, 20)

            VStack(spacing: 1) {
                SpecRow(icon: "cpu", label: "Processor", value: laptop.processor)
                SpecRow(icon: "memorychip", label: "Memory", value: laptop.ram)
                SpecRow(icon: "internaldrive", label: "Storage", value: laptop.storage)
                SpecRow(icon: "display", label: "Display", value: laptop.display)
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal, 16)

            // Description
            Text(laptop.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)
                .padding(.top, 4)
        }
    }

    // MARK: Duration Picker
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rental Duration")
                .font(.headline)
                .padding(.horizontal, 20)
                .padding(.top, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(RentalDuration.allCases, id: \.self) { duration in
                        DurationOption(
                            duration: duration,
                            laptop: laptop,
                            isSelected: selectedDuration == duration
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                selectedDuration = duration
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: Price CTA
    private var priceCTA: some View {
        VStack(spacing: 0) {
            Divider()
                .padding(.top, 24)

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Total Price")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    HStack(alignment: .lastTextBaseline, spacing: 6) {
                        Text("$\(String(format: "%.0f", totalPrice))")
                            .font(.title.bold())
                            .foregroundColor(laptop.isDiscounted ? Color(hex: "e94560") : Color(hex: "0f3460"))

                        if laptop.isDiscounted {
                            let originalPrice = selectedDuration.totalPrice(daily: laptop.dailyPrice, weekly: laptop.weeklyPrice, monthly: laptop.monthlyPrice, isDiscounted: false)
                            Text("$\(String(format: "%.0f", originalPrice))")
                                .font(.subheadline)
                                .strikethrough()
                                .foregroundColor(.secondary)
                        }

                        Text("for \(selectedDuration.label)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Button {
                    if laptop.isAvailable {
                        showRentalForm = true
                    }
                } label: {
                    Text("Rent Now")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 130, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(laptop.isAvailable ? Color(hex: "0f3460") : Color.gray)
                        )
                }
                .disabled(!laptop.isAvailable)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
        }
    }
}

// MARK: - Spec Row
struct SpecRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundColor(Color(hex: "0f3460"))
                .font(.subheadline)

            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background(Color(.systemBackground))
        Divider().padding(.leading, 50)
    }
}

// MARK: - Duration Option
struct DurationOption: View {
    let duration: RentalDuration
    let laptop: Laptop
    let isSelected: Bool
    let action: () -> Void

    var price: Double {
        duration.totalPrice(daily: laptop.dailyPrice, weekly: laptop.weeklyPrice, monthly: laptop.monthlyPrice, isDiscounted: laptop.isDiscounted)
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(duration.label)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(isSelected ? .white : .primary)

                Text("$\(Int(price))")
                    .font(.caption.bold())
                    .foregroundColor(isSelected ? .white.opacity(0.85) : Color(hex: "0f3460"))
            }
            .frame(width: 90, height: 62)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color(hex: "0f3460") : Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.clear : Color(.separator), lineWidth: 1)
            )
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(laptop: Laptop.sampleData[0])
            .environment(RentalStore())
    }
}
