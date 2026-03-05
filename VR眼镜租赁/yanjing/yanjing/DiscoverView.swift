import SwiftUI

struct DiscoverItem: Identifiable {
    var id = UUID()
    var title: String
    var category: String
    var imageUrl: String
    var description: String
    var rating: Double
    var reviewsCount: Int
}

struct DiscoverView: View {
    @EnvironmentObject var appState: AppState
    
    let experiences: [DiscoverItem] = [
        DiscoverItem(title: "Half-Life: Alyx", category: "Action & Adventure", imageUrl: "https://images.unsplash.com/photo-1592478411213-6153e4ebc07d?auto=format&fit=crop&q=80&w=800&h=600", description: "Valve's VR exclusive masterpiece. Immerse yourself in deep environmental interactions, puzzle solving, world exploration, and visceral combat.", rating: 4.9, reviewsCount: 1542),
        DiscoverItem(title: "Beat Saber", category: "Rhythm & Music", imageUrl: "https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&q=80&w=800&h=600", description: "A unique VR rhythm game where your goal is to slash the beats (represented by small cubes) as they are coming at you.", rating: 4.8, reviewsCount: 3200),
        DiscoverItem(title: "VRChat", category: "Social VR", imageUrl: "https://images.unsplash.com/photo-1622979135225-d2ba269cf1ac?auto=format&fit=crop&q=80&w=800&h=600", description: "Interact with people from all over the world in user-created 3D worlds. Create your own avatars and build your own experiences.", rating: 4.5, reviewsCount: 2100),
        DiscoverItem(title: "Superhot VR", category: "Action", imageUrl: "https://images.unsplash.com/photo-1478416272538-5f7e51dc5400?auto=format&fit=crop&q=80&w=800&h=600", description: "Time moves only when you move. No regenerating health bars. No conveniently placed ammo drops. It's just you, outnumbered and outgunned.", rating: 4.7, reviewsCount: 1850),
        DiscoverItem(title: "The Elder Scrolls V: Skyrim VR", category: "RPG", imageUrl: "https://images.unsplash.com/photo-1605379399642-870262d3d051?auto=format&fit=crop&q=80&w=800&h=600", description: "A true, full-length open-world game for VR. Skyrim VR reimagines the complete epic fantasy masterpiece with an unparalleled sense of scale, depth, and immersion.", rating: 4.6, reviewsCount: 1980),
        DiscoverItem(title: "No Man's Sky VR", category: "Survival / Exploration", imageUrl: "https://images.unsplash.com/photo-1614729939124-032f0b56c9ce?auto=format&fit=crop&q=80&w=800&h=600", description: "Explore an infinite, procedurally generated universe in stunning virtual reality. Fly ships, explore planets, and build bases from a completely new perspective.", rating: 4.4, reviewsCount: 1250),
        DiscoverItem(title: "Resident Evil 4 VR", category: "Survival Horror", imageUrl: "https://images.unsplash.com/photo-1552820728-8b83bb6b773f?auto=format&fit=crop&q=80&w=800&h=600", description: "Step into the shoes of Leon S. Kennedy in this fully remastered VR adaptation of the legendary survival horror classic.", rating: 4.8, reviewsCount: 2200),
        DiscoverItem(title: "Astro Bot Rescue Mission", category: "Platformer", imageUrl: "https://images.unsplash.com/photo-1535223289827-42f1e9919769?auto=format&fit=crop&q=80&w=800&h=600", description: "Take control of Astro in a massive adventure to rescue his crew, where the PS VR headset puts you right in the thick of the action.", rating: 4.9, reviewsCount: 890),
        DiscoverItem(title: "Blade & Sorcery", category: "Action / Sandbox", imageUrl: "https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&q=80&w=800&h=600", description: "A built-for-VR medieval fantasy sandbox with full physics driven melee, ranged and magic combat. Become a powerful warrior, ranger or sorcerer.", rating: 4.5, reviewsCount: 1420),
        DiscoverItem(title: "Boneworks", category: "Action / Adventure", imageUrl: "https://images.unsplash.com/photo-1555680202-c86f0e12f086?auto=format&fit=crop&q=80&w=800&h=600", description: "An experimental physics action game. Use found weapons, tools, and objects to fight across dangerous playscapes and mysterious architecture.", rating: 4.6, reviewsCount: 1670),
        DiscoverItem(title: "Walkabout Mini Golf", category: "Sports / Casual", imageUrl: "https://images.unsplash.com/photo-1518605368461-1eb49c5e5953?auto=format&fit=crop&q=80&w=800&h=600", description: "Escape into a fun and beautiful world filled with the best mini golf courses you've never seen! Play by yourself, meet someone new, or challenge your friends.", rating: 4.8, reviewsCount: 2150),
        DiscoverItem(title: "Pistol Whip", category: "Rhythm / Shooter", imageUrl: "https://images.unsplash.com/photo-1511512578047-dfb367046420?auto=format&fit=crop&q=80&w=800&h=600", description: "An unstoppable VR action-rhythm shooter. Journey through a cinematic bullet hell powered by a breakneck soundtrack to become the ultimate action hero.", rating: 4.7, reviewsCount: 1340),
        DiscoverItem(title: "Moss: Book II", category: "Puzzle / Adventure", imageUrl: "https://images.unsplash.com/photo-1618365908648-e71bd5716cba?auto=format&fit=crop&q=80&w=800&h=600", description: "Quill is back—and she's being hunted. Face down new and dangerous enemies, solve challenging puzzles, and build an epic bond with a tiny hero.", rating: 4.8, reviewsCount: 780)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Featured Experiences")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(experiences) { exp in
                            NavigationLink(destination: DiscoverDetailView(experience: exp)) {
                                VStack(alignment: .leading) {
                                    AsyncImage(url: URL(string: exp.imageUrl)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Color.gray.opacity(0.3)
                                    }
                                    .frame(height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                    Text(exp.title)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                    
                                    Text(exp.category)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Discover VR")
        }
    }
}

struct DiscoverDetailView: View {
    var experience: DiscoverItem
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header Image
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: URL(string: experience.imageUrl)) { image in
                        image.resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(height: 350)
                    .clipped()
                }
                
                // Content
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(experience.category.uppercased())
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            Text(experience.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(String(format: "%.1f", experience.rating)) (\(experience.reviewsCount) reviews)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    Text("About This Experience")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(experience.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                    
                    Spacer(minLength: 50)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(30)
                .offset(y: -30)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
    }
}
