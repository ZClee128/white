import SwiftUI

struct SearchView: View {
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    @State private var query: String = ""
    @FocusState private var focused: Bool

    var results: [Figure] {
        store.searchFigures(query: query)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.07, blue: 0.12).ignoresSafeArea()

                VStack(spacing: 0) {
                    // Search bar
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search figures, series, character...", text: $query)
                            .foregroundColor(.white)
                            .tint(Color(red: 0.42, green: 0.36, blue: 0.91))
                            .focused($focused)
                        if !query.isEmpty {
                            Button {
                                query = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(14)
                    .background(Color(red: 0.12, green: 0.12, blue: 0.18))
                    .cornerRadius(14)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    if query.isEmpty {
                        emptyState
                    } else if results.isEmpty {
                        noResults
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 8) {
                                Text("\(results.count) results for \"\(query)\"")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 4)

                                LazyVStack(spacing: 10) {
                                    ForEach(results) { figure in
                                        NavigationLink(destination: ProductDetailView(figure: figure).environmentObject(store)) {
                                            MarketRow(figure: figure)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 30)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Color(red: 0.42, green: 0.36, blue: 0.91))
                }
            }
            .onAppear { focused = true }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.4))
            Text("Search for figures")
                .font(.headline)
                .foregroundColor(.gray)
            Text("Try searching by name, series, or character")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.6))
                .multilineTextAlignment(.center)
            // Quick tags
            VStack(alignment: .leading, spacing: 8) {
                Text("Popular searches")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(["Gojo", "Rem", "Miku", "Levi", "Luffy"], id: \.self) { tag in
                            Button {
                                query = tag
                            } label: {
                                Text(tag)
                                    .font(.subheadline)
                                    .foregroundColor(Color(red: 0.42, green: 0.36, blue: 0.91))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Color(red: 0.42, green: 0.36, blue: 0.91).opacity(0.12))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            Spacer()
        }
        .padding()
    }

    private var noResults: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.4))
            Text("No results for \"\(query)\"")
                .font(.headline)
                .foregroundColor(.gray)
            Text("Try a different keyword")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.6))
            Spacer()
        }
    }
}
