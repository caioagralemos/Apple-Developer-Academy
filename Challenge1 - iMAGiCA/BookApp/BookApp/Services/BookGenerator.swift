//
//  BookGenerator.swift
//  Tests
//
//  Created by Caio on 14/10/25.
//

import Foundation
import FoundationModels
import Observation

@Observable
@MainActor
final class BookGenerator {
    var error: Error?
    var text: String
    private var session: LanguageModelSession
    
    private(set) var book: Book?

    init(_ text: String) {
        self.text = text
        let instructions = Instructions {
            "I need you to extract a book's information from it's cover text. The prompt will feature the book's cover brute text extracted by a Photo Text Scanner. By those means, you can get the book's title, author, and genre.\nAn example of a response is: \(Book.exampleBook)"
        }
        
        self.session = LanguageModelSession( instructions: instructions)
    }

    func generateInfo() async {
        let task = Task { @MainActor in
            let response = try await self.session.respond(
                to: self.text,
                generating: Book.self,
                includeSchemaInPrompt: false,
                options: GenerationOptions(sampling: .greedy)
            )
            return response.content
        }
        
        let timeout = Task {
            try await Task.sleep(for: .seconds(15))
            task.cancel()
        }
        
        do {
            self.book = try await task.value
            timeout.cancel()
        } catch is CancellationError {
            self.error = NSError(domain: "BookGenerator", code: -1,
                               userInfo: [NSLocalizedDescriptionKey: "Request timeout"])
        } catch {
            timeout.cancel()
            self.error = error
        }
    }

    func prewarmModel() {
        session.prewarm()
    }
}

