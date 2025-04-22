//////  WildlifeExploreCard.swift
//////  srilankan_heritage_wildlife_explorer
//////
//////  Created by Janusha 023 on 2025-04-22.
//////
////
////import SwiftUI
////
/////// Card component for displaying wildlife in the explorer view
////struct WildlifeExploreCard: View {
////    // MARK: - Properties
////    let wildlife: Wildlife
////    let width: CGFloat
////    let height: CGFloat
////    let onTap: () -> Void
////    let onToggleFavorite: () -> Void
////    
////    @State private var isFavorite: Bool
////    @State private var isPressed: Bool = false
////    @Environment(\.colorScheme) private var colorScheme
////    
////    // MARK: - Initialization
////    init(
////        wildlife: Wildlife,
////        width: CGFloat = 160,
////        height: CGFloat = 220,
////        onTap: @escaping () -> Void,
////        onToggleFavorite: @escaping () -> Void
////    ) {
////        self.wildlife = wildlife
////        self.width = width
////        self.height = height
////        self.onTap = onTap
////        self.onToggleFavorite = onToggleFavorite
////        _isFavorite = State(initialValue: wildlife.isFavorite)
////    }
////    
////    // MARK: - Body
////    var body: some View {
////        Button(action: {
////            withAnimation(.easeInOut(duration: 0.1)) {
////                isPressed = true
////            }
////            
////            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
////                withAnimation(.easeInOut(duration: 0.1)) {
////                    isPressed = false
////                }
////                onTap()
////            }
////        }) {
////            VStack(alignment: .leading, spacing: 8) {
////                // Image section
////                imageSection
////                
////                // Content section
////                contentSection
////            }
////            .frame(width: width)
////            .background(Color(UIColor.systemBackground))
////            .cornerRadius(12)
////            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1),
////                   radius: 4, x: 0, y: 2)
////            .scaleEffect(isPressed ? 0.97 : 1.0)
////        }
////        .buttonStyle(PlainButtonStyle())
////    }
////    
////    // MARK: - UI Components
////    
////    /// Image section of the card
////    private var imageSection: some View {
////        ZStack(alignment: .topTrailing) {
////            Image(wildlife.imageName)
////                .resizable()
////                .aspectRatio(contentMode: .fill)
////                .frame(width: width, height: height * 0.55)
////                .clipped()
////                .cornerRadius(12, corners: [.topLeft, .topRight])
////            
////            // Favorite button
////            Button(action: {
////                isFavorite.toggle()
////                onToggleFavorite()
////            }) {
////                Image(systemName: isFavorite ? "heart.fill" : "heart")
////                    .foregroundColor(isFavorite ? .red : .white)
////                    .font(.system(size: 18))
////                    .padding(8)
////                    .background(Color.black.opacity(0.3))
////                    .clipShape(Circle())
////            }
////            .padding(8)
////        }
////    }
////    
////    /// Content section of the card
////    private var contentSection: some View {
////        VStack(alignment: .leading, spacing: 6) {
////            // Species name
////            VStack(alignment: .leading, spacing: 2) {
////                Text(wildlife.name)
////                    .font(.headline)
////                    .fontWeight(.semibold)
////                    .foregroundColor(.primary)
////                    .lineLimit(1)
////                
////                Text(wildlife.scientificName)
////                    .font(.caption)
////                    .fontStyle(.italic)
////                    .foregroundColor(.secondary)
////                    .lineLimit(1)
////            }
////            
////            // Conservation status and category
////            HStack {
////                Text(wildlife.conservationStatus.rawValue)
////                    .font(.caption)
////                    .fontWeight(.medium)
////                    .foregroundColor(.white)
////                    .padding(.horizontal, 8)
////                    .padding(.vertical, 2)
////                    .background(statusColor)
////                    .cornerRadius(10)
////                
////                Spacer()
////                
////                Text(wildlife.category.rawValue)
////                    .font(.caption)
////                    .foregroundColor(.secondary)
////            }
////            
////            // Short description
////            Text(wildlife.shortDescription)
////                .font(.caption)
////                .foregroundColor(.secondary)
////                .lineLimit(2)
////                .frame(width: width - 16, alignment: .leading)
////        }
////        .padding(.horizontal, 8)
////        .padding(.bottom, 8)
////    }
////    
////    // MARK: - Helper Properties
////    
////    /// Color for the conservation status tag
////    private var statusColor: Color {
////        switch wildlife.conservationStatus {
////        case .extinct, .extirpated:
////            return Color.black
////        case .criticallyEndangered:
////            return Color.red.opacity(0.9)
////        case .endangered:
////            return Color.red.opacity(0.7)
////        case .vulnerable, .threatened:
////            return Color.orange
////        case .nearThreatened:
////            return Color.yellow
////        case .leastConcern:
////            return Color.green
////        case .dataDeficient:
////            return Color.gray
////        }
////    }
////}
////
////// MARK: - Helper Extensions
////
/////// Extension to apply rounded corners to specific corners
////extension View {
////    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
////        clipShape(RoundedCorner(radius: radius, corners: corners))
////    }
////}
////
/////// Shape for custom corner rounding
////struct RoundedCorner: Shape {
////    var radius: CGFloat = .infinity
////    var corners: UIRectCorner = .allCorners
////
////    func path(in rect: CGRect) -> Path {
////        let path = UIBezierPath(
////            roundedRect: rect,
////            byRoundingCorners: corners,
////            cornerRadii: CGSize(width: radius, height: radius)
////        )
////        return Path(path.cgPath)
////    }
////}
////
////// MARK: - Preview
////struct WildlifeExploreCard_Previews: PreviewProvider {
////    static var previews: some View {
////        Group {
////            // Light mode preview
////            WildlifeExploreCard(
////                wildlife: WildlifeRepository.sampleWildlifeData[0],
////                onTap: {},
////                onToggleFavorite: {}
////            )
////            .previewLayout(.sizeThatFits)
////            .padding()
////            .background(Color(.systemBackground))
////            .environment(\.colorScheme, .light)
////            
////            // Dark mode preview
////            WildlifeExploreCard(
////                wildlife: WildlifeRepository.sampleWildlifeData[1],
////                onTap: {},
////                onToggleFavorite: {}
////            )
////            .previewLayout(.sizeThatFits)
////            .padding()
////            .background(Color(.systemBackground))
////            .environment(\.colorScheme, .dark)
////        }
////    }
////}
////
////  WildlifeExploreCard.swift
////  srilankan_heritage_wildlife_explorer
////
////  Created by Janusha 023 on 2025-04-22.
////
//
//import SwiftUI
//
///// Card component for displaying wildlife in the explorer view
//struct WildlifeExploreCard: View {
//    // MARK: - Properties
//    let wildlife: Wildlife
//    let width: CGFloat
//    let height: CGFloat
//    let onTap: () -> Void
//    let onToggleFavorite: () -> Void
//
//    @State private var isFavorite: Bool
//    @State private var isPressed: Bool = false
//    @Environment(\.colorScheme) private var colorScheme
//
//    // MARK: - Initialization
//    init(
//        wildlife: Wildlife,
//        width: CGFloat = 160,
//        height: CGFloat = 220,
//        onTap: @escaping () -> Void,
//        onToggleFavorite: @escaping () -> Void
//    ) {
//        self.wildlife = wildlife
//        self.width = width
//        self.height = height
//        self.onTap = onTap
//        self.onToggleFavorite = onToggleFavorite
//        _isFavorite = State(initialValue: wildlife.isFavorite)
//    }
//
//    // MARK: - Body
//    var body: some View {
//        Button(action: {
//            withAnimation(.easeInOut(duration: 0.1)) {
//                isPressed = true
//            }
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                withAnimation(.easeInOut(duration: 0.1)) {
//                    isPressed = false
//                }
//                onTap()
//            }
//        }) {
//            VStack(alignment: .leading, spacing: 8) {
//                // Image section
//                imageSection
//
//                // Content section
//                contentSection
//            }
//            .frame(width: width)
//            .background(Color(UIColor.systemBackground))
//            .cornerRadius(12)
//            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1),
//                    radius: 4, x: 0, y: 2)
//            .scaleEffect(isPressed ? 0.97 : 1.0)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//
//    // MARK: - UI Components
//
//    private var imageSection: some View {
//        ZStack(alignment: .topTrailing) {
//            Image(wildlife.imageName)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: width, height: height * 0.55)
//                .clipped()
//                .cornerRadius(12, corners: [.topLeft, .topRight])
//
//            Button(action: {
//                isFavorite.toggle()
//                onToggleFavorite()
//            }) {
//                Image(systemName: isFavorite ? "heart.fill" : "heart")
//                    .foregroundColor(isFavorite ? .red : .white)
//                    .font(.system(size: 18))
//                    .padding(8)
//                    .background(Color.black.opacity(0.3))
//                    .clipShape(Circle())
//            }
//            .padding(8)
//        }
//    }
//
//    private var contentSection: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            VStack(alignment: .leading, spacing: 2) {
//                Text(wildlife.name)
//                    .font(.headline)
//                    .fontWeight(.semibold)
//                    .foregroundColor(.primary)
//                    .lineLimit(1)
//
//                Text(wildlife.scientificName)
//                    .font(.caption)
//                    .italic()
//                    .foregroundColor(.secondary)
//                    .lineLimit(1)
//            }
//
//            HStack {
//                Text(wildlife.conservationStatus)
//                    .font(.caption)
//                    .fontWeight(.medium)
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 2)
//                    .background(statusColor)
//                    .cornerRadius(10)
//
//                Spacer()
//
//                Text(wildlife.category)
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//
//            Text(wildlife.shortDescription)
//                .font(.caption)
//                .foregroundColor(.secondary)
//                .lineLimit(2)
//                .frame(width: width - 16, alignment: .leading)
//        }
//        .padding(.horizontal, 8)
//        .padding(.bottom, 8)
//    }
//
//    // MARK: - Helper Properties
//
//    private var statusColor: Color {
//        switch wildlife.conservationStatus {
//        case .extinct, .extirpated:
//            return Color.black
//        case .criticallyEndangered:
//            return Color.red.opacity(0.9)
//        case .endangered:
//            return Color.red.opacity(0.7)
//        case .vulnerable, .threatened:
//            return Color.orange
//        case .nearThreatened:
//            return Color.yellow
//        case .leastConcern:
//            return Color.green
//        case .dataDeficient:
//            return Color.gray
//        }
//    }
//}
//
//// MARK: - Helper Extensions
//
//extension View {
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape(RoundedCorner(radius: radius, corners: corners))
//    }
//}
//
//struct RoundedCorner: Shape {
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(
//            roundedRect: rect,
//            byRoundingCorners: corners,
//            cornerRadii: CGSize(width: radius, height: radius)
//        )
//        return Path(path.cgPath)
//    }
//}
//
//// MARK: - Preview
//
//struct WildlifeExploreCard_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            WildlifeExploreCard(
//                wildlife: WildlifeRepository.sampleWildlifeData[0],
//                onTap: {},
//                onToggleFavorite: {}
//            )
//            .previewLayout(.sizeThatFits)
//            .padding()
//            .background(Color(.systemBackground))
//            .environment(\.colorScheme, .light)
//
//            WildlifeExploreCard(
//                wildlife: WildlifeRepository.sampleWildlifeData[1],
//                onTap: {},
//                onToggleFavorite: {}
//            )
//            .previewLayout(.sizeThatFits)
//            .padding()
//            .background(Color(.systemBackground))
//            .environment(\.colorScheme, .dark)
//        }
//    }
//}
