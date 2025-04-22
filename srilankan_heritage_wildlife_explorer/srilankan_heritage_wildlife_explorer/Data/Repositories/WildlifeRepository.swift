////
////  WildlifeRepository.swift
////  srilankan_heritage_wildlife_explorer
////
////  Created by Janusha 023 on 2025-04-22.
////
//
//import Foundation
//import SwiftUI
//
//class WildlifeRepository {
//    // Singleton instance
//    static let shared = WildlifeRepository()
//    
//    // Sample data for wildlife species
//    func getAllWildlife() -> [Wildlife] {
//        return [
//            Wildlife(
//                name: "Sri Lankan Elephant",
//                scientificName: "Elephas maximus maximus",
//                category: "Mammals",
//                conservationStatus: "Endangered",
//                shortDescription: "The largest subspecies of Asian elephant native to Sri Lanka",
//                fullDescription: "The Sri Lankan elephant is one of three recognized subspecies of the Asian elephant and is native to Sri Lanka. Since 1986, the Asian elephant has been listed as endangered by IUCN as the population has declined by at least 50% over the last three generations. The species is primarily threatened by habitat loss, degradation, and fragmentation.",
//                imageName: "elephant",
//                thumbnailImage: "elephant_thumb",
//                images: ["elephant_1", "elephant_2", "elephant_3"],
//                location: "Throughout the island, particularly in protected areas",
//                coordinates: (latitude: 7.8731, longitude: 80.7718),
//                habitat: "Forests, grasslands, and scrublands",
//                diet: "Herbivore - grasses, leaves, bark, fruits, and roots",
//                lifespan: "60-70 years",
//                isFavorite: true,
//                hasARExperience: true
//            ),
//            Wildlife(
//                name: "Sri Lankan Leopard",
//                scientificName: "Panthera pardus kotiya",
//                category: "Mammals",
//                conservationStatus: "Endangered",
//                shortDescription: "Endemic subspecies of leopard found only in Sri Lanka",
//                fullDescription: "The Sri Lankan leopard is a leopard subspecies native to Sri Lanka. It is listed as Endangered on the IUCN Red List. The Sri Lankan leopard is a top predator in Sri Lanka and is the largest of the four wild cat species found on the island. It has been recognized as a distinct subspecies based on morphological characteristics.",
//                imageName: "leopard",
//                thumbnailImage: "leopard_thumb",
//                images: ["leopard_1", "leopard_2", "leopard_3"],
//                location: "Yala National Park, Wilpattu National Park",
//                coordinates: (latitude: 6.3728, longitude: 81.5157),
//                habitat: "Dry zone forests, rainforests, and open grasslands",
//                diet: "Carnivore - deer, wild boar, monkeys, and smaller mammals",
//                lifespan: "12-15 years in the wild",
//                isFavorite: false,
//                hasARExperience: true
//            )
//        ]
//    }
//    
//    func getFeaturedSpecies() -> Wildlife {
//        return getAllWildlife()[0]
//    }
//}
//
//
//////
//////  WildlifeRepository.swift
//////  srilankan_heritage_wildlife_explorer
//////
//////  Created by Janusha 023 on 2025-04-22.
//////
////
////import Foundation
////import Combine
////
/////// Repository responsible for providing access to wildlife data
////class WildlifeRepository: ObservableObject {
////    // MARK: - Properties
////    @Published private(set) var allWildlife: [Wildlife] = []
////    @Published private(set) var isLoading = false
////    @Published private(set) var error: Error?
////    
////    private var cancellables = Set<AnyCancellable>()
////    private let userDefaults = UserDefaults.standard
////    private let favoritesKey = "favoriteWildlifeIds"
////    
////    // MARK: - Initialization
////    init() {
////        loadWildlifeData()
////    }
////    
////    // MARK: - Public Methods
////    
////    /// Loads wildlife data from local source or remote API
////    func loadWildlifeData() {
////        isLoading = true
////        error = nil
////        
////        // In a real app, you might fetch this data from an API
////        // For now, we'll use sample data
////        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
////            guard let self = self else { return }
////            
////            self.allWildlife = Self.sampleWildlifeData
////            self.updateFavoritesFromUserDefaults()
////            self.isLoading = false
////        }
////    }
////    
////    /// Toggles favorite status for a wildlife species
////    func toggleFavorite(for wildlife: Wildlife) {
////        if let index = allWildlife.firstIndex(where: { $0.id == wildlife.id }) {
////            allWildlife[index].isFavorite.toggle()
////            saveFavoritesToUserDefaults()
////        }
////    }
////    
////    /// Gets wildlife filtered by category
////    func getWildlife(forCategory category: String) -> [Wildlife] {
////        if category == "All" {
////            return allWildlife
////        } else if category == "Endangered" {
////            return allWildlife.filter { $0.isEndangered }
////        } else {
////            return allWildlife.filter { $0.category.rawValue == category }
////        }
////    }
////    
////    /// Gets wildlife filtered by search text
////    func searchWildlife(searchText: String) -> [Wildlife] {
////        if searchText.isEmpty {
////            return allWildlife
////        } else {
////            return allWildlife.filter { wildlife in
////                wildlife.name.localizedCaseInsensitiveContains(searchText) ||
////                wildlife.scientificName.localizedCaseInsensitiveContains(searchText) ||
////                wildlife.shortDescription.localizedCaseInsensitiveContains(searchText)
////            }
////        }
////    }
////    
////    /// Gets featured wildlife species
////    func getFeaturedWildlife() -> Wildlife? {
////        return allWildlife.first
////    }
////    
////    /// Gets endangered wildlife species
////    func getEndangeredWildlife() -> [Wildlife] {
////        return allWildlife.filter { $0.isEndangered }
////    }
////    
////    /// Gets favorite wildlife species
////    func getFavoriteWildlife() -> [Wildlife] {
////        return allWildlife.filter { $0.isFavorite }
////    }
////    
////    // MARK: - Private Methods
////    
////    /// Updates favorite status from user defaults
////    private func updateFavoritesFromUserDefaults() {
////        let favoriteIds = userDefaults.array(forKey: favoritesKey) as? [String] ?? []
////        
////        for (index, wildlife) in allWildlife.enumerated() {
////            allWildlife[index].isFavorite = favoriteIds.contains(wildlife.id.uuidString)
////        }
////    }
////    
////    /// Saves favorites to user defaults
////    private func saveFavoritesToUserDefaults() {
////        let favoriteIds = allWildlife
////            .filter { $0.isFavorite }
////            .map { $0.id.uuidString }
////        
////        userDefaults.set(favoriteIds, forKey: favoritesKey)
////    }
////    
////    // MARK: - Sample Data
////    
////    /// Sample wildlife data for development and testing
////    static var sampleWildlifeData: [Wildlife] = [
////        Wildlife(
////            name: "Sri Lankan Elephant",
////            scientificName: "Elephas maximus maximus",
////            category: .mammals,
////            conservationStatus: .endangered,
////            shortDescription: "The largest subspecies of Asian elephant native to Sri Lanka",
////            fullDescription: """
////            The Sri Lankan elephant is the largest and darkest of the Asian elephant subspecies. It has been listed as endangered since 1986 as the population has declined by at least 50% over the last three generations. The species is largely restricted to increasingly fragmented areas of the country.
////
////            Adult males usually measure about 2.75 meters at the shoulder while females are smaller at around 2.3 meters. The Sri Lankan elephant has characteristic depigmentation patches on its skin, and smaller ears compared to the African elephant.
////            """,
////            habitat: "Sri Lankan elephants are found in various habitats including forests, scrublands, and grasslands. They are most commonly found in the dry zones of the north, east, and southeast of Sri Lanka, particularly in protected areas such as Yala National Park, Udawalawe National Park, and Minneriya National Park.",
////            conservationEfforts: "Conservation efforts include the establishment of protected areas, corridors between habitats, conflict mitigation strategies, and community-based conservation initiatives. The Department of Wildlife Conservation of Sri Lanka plays a key role in elephant conservation.",
////            dietType: "Herbivore - Grasses, leaves, bark, fruits",
////            lifespan: "60-70 years",
////            imageName: "elephant",
////            isFavorite: true,
////            galleryImageNames: ["elephant_1", "elephant_2", "elephant_3"],
////            locations: [
////                WildlifeLocation(
////                    name: "Yala National Park",
////                    description: "Sri Lanka's most visited wildlife reserve",
////                    latitude: 6.3596,
////                    longitude: 81.5040,
////                    bestTimeToVisit: "February to July"
////                ),
////                WildlifeLocation(
////                    name: "Udawalawe National Park",
////                    description: "Known for its large elephant population",
////                    latitude: 6.4389,
////                    longitude: 80.8903,
////                    bestTimeToVisit: "Year-round"
////                ),
////                WildlifeLocation(
////                    name: "Minneriya National Park",
////                    description: "Famous for 'The Gathering' of elephants",
////                    latitude: 8.0344,
////                    longitude: 80.8522,
////                    bestTimeToVisit: "August to September"
////                )
////            ],
////            funFacts: [
////                "Sri Lankan elephants can consume up to 150 kg of food daily",
////                "The 'Gathering' at Minneriya is the largest known meeting of Asian elephants in the world",
////                "Sri Lankan elephants have a unique social structure led by matriarchs"
////            ]
////        ),
////        Wildlife(
////            name: "Sri Lankan Leopard",
////            scientificName: "Panthera pardus kotiya",
////            category: .mammals,
////            conservationStatus: .endangered,
////            shortDescription: "Endemic subspecies of leopard found only in Sri Lanka",
////            fullDescription: """
////            The Sri Lankan leopard is a leopard subspecies native to Sri Lanka. It is one of the nine subspecies of leopard in the world and is the island's apex predator. The subspecies is considered endangered with an estimated population of 700-950 individuals remaining in the wild.
////
////            Sri Lankan leopards are larger than other subspecies, with males weighing between 56–77 kg and females between 29–43 kg. They have a distinctive rusty yellow coat with dark spots and rosettes, which provides excellent camouflage in Sri Lanka's diverse habitats.
////            """,
////            habitat: "Sri Lankan leopards are adaptable and can be found in various habitats including dense forests, open plains, and mountainous areas. They are commonly spotted in national parks such as Yala, Wilpattu, and Horton Plains.",
////            conservationEfforts: "Conservation efforts include habitat protection, anti-poaching measures, research, and monitoring programs. Organizations like the Wilderness & Wildlife Conservation Trust conduct research and conservation initiatives specifically focused on leopards.",
////            dietType: "Carnivore - Small to medium-sized mammals, birds",
////            lifespan: "12-17 years in the wild",
////            imageName: "leopard",
////            isFavorite: false,
////            galleryImageNames: ["leopard_1", "leopard_2", "leopard_3"],
////            locations: [
////                WildlifeLocation(
////                    name: "Yala National Park",
////                    description: "Highest density of leopards in the world",
////                    latitude: 6.3596,
////                    longitude: 81.5040,
////                    bestTimeToVisit: "February to July"
////                ),
////                WildlifeLocation(
////                    name: "Wilpattu National Park",
////                    description: "Second largest national park with leopard population",
////                    latitude: 8.4546,
////                    longitude: 80.0134,
////                    bestTimeToVisit: "March to October"
////                )
////            ],
////            funFacts: [
////                "Sri Lankan leopards have the highest population density among all leopard subspecies",
////                "They are excellent climbers and often drag their prey up into trees",
////                "Sri Lankan leopards can run at speeds of up to 58 km/h"
////            ]
////        ),
////        Wildlife(
////            name: "Purple-faced Langur",
////            scientificName: "Semnopithecus vetulus",
////            category: .mammals,
////            conservationStatus: .endangered,
////            shortDescription: "Endemic old world monkey with distinctive facial features",
////            fullDescription: """
////            The Purple-faced langur is an Old World monkey endemic to Sri Lanka. Named for the male's dark face and ruff, it's one of the most endangered primates in the world due to deforestation and habitat fragmentation.
////
////            There are four recognized subspecies, each with specific habitat requirements and conservation challenges. These primates are primarily leaf-eaters and play an important role in forest seed dispersal.
////            """,
////            habitat: "These primates inhabit primary and secondary tropical rainforests, montane forests, and semi-deciduous forests. Different subspecies are found in different regions of Sri Lanka, including the wet zone, highlands, and dry zone.",
////            conservationEfforts: "Conservation efforts include habitat protection, reforestation, and creating forest corridors. Organizations like the Primate Conservation Society of Sri Lanka work to protect these endangered monkeys.",
////            dietType: "Herbivore - Leaves, fruits, flowers",
////            lifespan: "15-20 years",
////            imageName: "langur",
////            isFavorite: true,
////            galleryImageNames: ["langur_1", "langur_2"],
////            locations: [
////                WildlifeLocation(
////                    name: "Sinharaja Forest Reserve",
////                    description: "UNESCO World Heritage Site with primate populations",
////                    latitude: 6.4055,
////                    longitude: 80.6298,
////                    bestTimeToVisit: "January to March"
////                )
////            ],
////            funFacts: [
////                "Purple-faced langurs have specialized stomachs to digest the tough cellulose in leaves",
////                "They communicate through a variety of vocalizations, including alarm calls",
////                "Some populations have adapted to live in urban gardens and parks"
////            ]
////        ),
////        Wildlife(
////            name: "Sri Lankan Junglefowl",
////            scientificName: "Gallus lafayettii",
////            category: .birds,
////            conservationStatus: .leastConcern,
////            shortDescription: "National bird of Sri Lanka related to domestic chickens",
////            fullDescription: """
////            The Sri Lankan Junglefowl is the national bird of Sri Lanka and one of four species of wild junglefowl. It's closely related to the red junglefowl from which domestic chickens are descended.
////
////            Males are much more colorful than females, with yellow, purple, red, and green plumage, a distinctive red comb with a yellow center, and red wattles. Females are more camouflaged with brown and black feathers.
////            """,
////            habitat: "Sri Lankan Junglefowl inhabit forests, scrublands, and forest edges throughout Sri Lanka. They are particularly common in the dry zone and can often be seen in national parks and forest reserves.",
////            conservationEfforts: "While not currently endangered, conservation efforts focus on habitat preservation and preventing hybridization with domestic chickens to maintain genetic purity.",
////            dietType: "Omnivore - Seeds, fruits, insects",
////            lifespan: "3-7 years",
////            imageName: "junglefowl",
////            isFavorite: false,
////            galleryImageNames: ["junglefowl_1", "junglefowl_2"],
////            locations: [
////                WildlifeLocation(
////                    name: "Bundala National Park",
////                    description: "Coastal park with diverse bird populations",
////                    latitude: 6.2152,
////                    longitude: 81.2333,
////                    bestTimeToVisit: "November to March"
////                )
////            ],
////            funFacts: [
////                "The Sri Lankan Junglefowl has been the national bird of Sri Lanka since 1986",
////                "Males perform elaborate dances during courtship",
////                "Unlike domestic chickens, they can fly strongly for short distances"
////            ]
////        ),
////        Wildlife(
////            name: "Saltwater Crocodile",
////            scientificName: "Crocodylus porosus",
////            category: .reptiles,
////            conservationStatus: .leastConcern,
////            shortDescription: "Largest living reptile found in Sri Lankan waterways",
////            fullDescription: """
////            The Saltwater Crocodile, also known as the estuarine crocodile, is the largest living reptile and crocodilian in the world. In Sri Lanka, they inhabit coastal wetlands, estuaries, and some inland lakes and rivers.
////
////            These massive predators can grow to lengths of over 6 meters and weigh more than 1,000 kg. Despite their name, they can live in freshwater environments as well as brackish and saltwater areas.
////            """,
////            habitat: "In Sri Lanka, saltwater crocodiles inhabit coastal wetlands, lagoons, estuaries, and some larger rivers. They can be seen in national parks like Yala and in the eastern coastal areas.",
////            conservationEfforts: "Conservation focuses on habitat protection, reducing human-crocodile conflict, and sustainable management of populations.",
////            dietType: "Carnivore - Fish, mammals, birds",
////            lifespan: "70-100 years",
////            imageName: "crocodile",
////            isFavorite: true,
////            galleryImageNames: ["crocodile_1", "crocodile_2"],
////            locations: [
////                WildlifeLocation(
////                    name: "Yala National Park",
////                    description: "Contains several lagoons with crocodile populations",
////                    latitude: 6.3596,
////                    longitude: 81.5040,
////                    bestTimeToVisit: "February to July"
////                )
////            ],
////            funFacts: [
////                "Saltwater crocodiles have the strongest bite force of any animal",
////                "They can remain submerged for over an hour when resting",
////                "These crocodiles can travel long distances through open ocean using ocean currents"
////            ]
////        )
////    ]
////}
