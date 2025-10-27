//
//  NameGuesser.swift
//  BookApp
//
//  Created by Caio on 21/10/25.
//

import FoundationModels
import Observation
import Foundation

@Observable
@MainActor
final class NameGuesser {
    var error: Error?
    var text: String
    private var session: LanguageModelSession
    
    var name: String?

    init(_ text: String) {
        let instructions = Instructions {
            """
            You will be prompted with a device's name. Extract the device owner first name from it.
            If no real person name exists (e.g. “iPhone (86)”, “Work iPad”), return “Reader”.
            Ignore brand words (iPhone, iPad, Galaxy, Phone, Pro, Plus), numbers, emojis, or serials.
            Remove possessives ('s, de, do, da, di, del, von, van, of, le, la, el).
            Return only the cleaned name as plain text — no quotes, punctuation, or extra words.
            Ex: Caio's iPhone should return Caio, and iPhone de Caio should return Caio
            """
        }
        
        self.session = LanguageModelSession(instructions: instructions)
        self.text = text
        self.name = nil
    }

    func generateInfo() async -> String {
        // First, try using the language model session if possible.
        do {
            let response = try await session.respond(
                to: self.text,
                options: GenerationOptions(sampling: .greedy)
            )
            let content = response.content.trimmingCharacters(in: .whitespacesAndNewlines)
            if !content.isEmpty {
                self.name = content
                return content
            }
        } catch {
            // If the model isn't available or fails, fall back to local parsing.
            self.error = error
        }

        // Secondary logic: extract text before "'s" (e.g., "Giulia's iPhone" -> "Giulia").
        if let extracted = fallbackName(from: self.text) {
            self.name = extracted
            return extracted
        }

        // If nothing could be extracted, default to Reader.
        self.name = "Reader"
        return "Reader"
    }

    /// Fallback parsing when language model/Foundation isn't available: extract text before "'s".
    /// Examples: "Giulia's iPhone" -> "Giulia". If not found, returns nil.
    private func fallbackName(from deviceName: String) -> String? {
        // Look for pattern "<name>'s ..."
        if let range = deviceName.range(of: "'s") {
            let before = deviceName[..<range.lowerBound]
            let trimmed = before.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : String(trimmed)
        }
        return nil
    }

    func prewarmModel() {
        session.prewarm()
    }
}
