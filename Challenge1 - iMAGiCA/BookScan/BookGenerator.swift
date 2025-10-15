//
//  BookGenerator.swift
//  Tests
//
//  Created by Caio on 14/10/25.
//

import FoundationModels
import Observation

@Observable
@MainActor
final class BookGenerator {
    
    var error: Error?
    var text: String
    private var session: LanguageModelSession
    
    private(set) var book: BookInfo?

    init(_ text: String) {
        self.text = text
        let instructions = Instructions {
            "I need you to extract a book's information from it's cover text. The prompt will feature the book's cover brute text extracted by a Photo Text Scanner. By those means, you can get the book's title, author, and genre.\nAn example of a response is: \(BookInfo.exampleBook)"
        }
        
        self.session = LanguageModelSession( instructions: instructions)
    }

    func generateInfo() async {
        do {
            // Ask the model to generate a Book from the provided text.
            let response = try await session.respond(
                to: self.text,
                generating: BookInfo.self,
                includeSchemaInPrompt: false,
                options: GenerationOptions(sampling: .greedy)
            )
            
            self.book = response.content
        } catch {
            self.error = error
        }
         
    }

    func prewarmModel() {
        session.prewarm()
    }
}

