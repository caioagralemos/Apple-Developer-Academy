/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A tool to use alongside the models to find points of interest for a landmark.
*/

import FoundationModels
import SwiftUI

@Observable
final class FindPointsOfInterestTool: Tool {
        let name = "findPointsOfInterest"
    let description = "Finds points of interest for a landmark."
    
    let landmark: Landmark
    init(landmark: Landmark) {
        self.landmark = landmark
    }

    @Generable
    struct Arguments {
        // MARK: - [CODE-ALONG] Chapter 5.1.3: Define tool arguments
        @Guide(description: "This is the type of business to look up for.")
        let pointOfInterest: Category
    }
    
    func call(arguments: Arguments) async throws -> String {
        // MARK: - [CODE-ALONG] Chapter 5.1.4: Implement the tool's call logic
        let results = await getSuggestions(category: arguments.pointOfInterest, landmark: landmark.name)
        return """
        There are these \(arguments.pointOfInterest) in \(landmark.name): 
        \(results.joined(separator: ", "))
        """
    }
    
}

@Generable
enum Category: String, CaseIterable {
    case hotel, restaurant, park, museum, zoo
}

func getSuggestions(category: Category, landmark: String) -> [String] {
    /// aqui é onde usariamos uma api
    switch category {
    case .restaurant: return ["The Swift Diner", "Sushi Central"]
    case .hotel: return ["The Swift Hotel", "Grand Swift Inn"]
    case .park: return ["Swift Park", "Greenfield Park"]
    case .museum: return ["Swift Museum", "Wildlife Wonders"]
    case .zoo: return ["Swift Safari", "Marine Wonders"]
    }
}
