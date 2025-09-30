/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A Playground for testing Foundation Models framework features.
*/

import FoundationModels
import Playgrounds

#Playground {
    let landmark = ModelData.landmarks[0]
    let pointOfInterestTool = FindPointsOfInterestTool(landmark: landmark)
    
    let instructions = Instructions {
        "Your job is to create an itinerary for the user."
        "For each day, you must suggest one hotel and one restaurant."
        "Always use the 'findPointsOfInterest' tool to find hotels and restaurant in \(landmark.name)"
    }
    
    let session = LanguageModelSession(
        tools: [pointOfInterestTool],
        instructions: instructions
    )
    
    let prompt = Prompt {
        "Generate a 3-day itinerary to \(landmark.name)."
        "Give it a fun title and description."
    }
    
    let response = try await session.respond(to: prompt,
                                             generating: Itinerary.self,
                                             options: GenerationOptions(sampling: .greedy))
    
    let inspectSession = session
}

#Playground {
    let instructions = """
        Your job is to create an itinerary for the user.
        """
    
    let kidFriendly = true
    
    let session = LanguageModelSession(instructions: instructions)
    
    let response = try? await session.respond(to: "What is the capital of Alagoas?\(kidFriendly ? " This response must be kid-friendly." : "") Here is an example of the desired format, but don't copy its content: \(Itinerary.exampleTripToJapan)")
    
    let response2 = try? await session.respond(to: "Generate a 3-day itinerary for Italy. \(kidFriendly ? " This response must be kid-friendly." : "")", generating: Itinerary.self)
}

#Playground {
    let model = SystemLanguageModel.default
    switch model.availability {
    case .available:
        print("Foundation models available!")
    case .unavailable(.deviceNotEligible):
        print("Not available on this device.")
    case .unavailable(.appleIntelligenceNotEnabled):
        print("Apple Inteligence is not enabled.")
    case .unavailable(.modelNotReady):
        print("The model is not ready yet. Please try again later.")
    case .unavailable(let other):
        print("The model is unavailable for an unknown reason.")
    }
}
