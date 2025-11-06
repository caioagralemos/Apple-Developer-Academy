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
    var name: String?
    
    private let commonNames: Set<String> = [
        "Luigi", "Caio", "Giulia", "Maria", "João", "Ana", "Pedro", "Lucas",
        "Gabriel", "Rafael", "Bruno", "Carlos", "Diego", "Eduardo", "Felipe",
        "Alessandro", "Andrea", "Marco", "Luca", "Francesco", "Giuseppe",
        "John", "Michael", "David", "James", "Robert", "William", "Richard"
    ]

    init(_ text: String) {
        self.text = text
        self.name = nil
    }

    func generateInfo() async -> String {
        if let extracted = extractNameLocally(from: self.text) {
            self.name = extracted
            return extracted
        }
        
        if let modelName = await tryLanguageModel() {
            self.name = modelName
            return modelName
        }
        
        self.name = "Reader"
        return "Reader"
    }

    private func extractNameLocally(from deviceName: String) -> String? {
        let cleaned = deviceName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let name = extractPattern1(from: cleaned) {
            return name
        }
        
        if let name = extractPattern2(from: cleaned) {
            return name
        }
        
        if let name = extractPattern3(from: cleaned) {
            return name
        }
        
        if let name = extractPattern4(from: cleaned) {
            return name
        }
        
        return nil
    }
    
    private func extractPattern1(from text: String) -> String? {
        if let range = text.range(of: "'s", options: .caseInsensitive) {
            let before = text[..<range.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines)
            return validateName(before)
        }
        return nil
    }
    
    private func extractPattern2(from text: String) -> String? {
        let patterns = [" de ", " do ", " da ", " di ", " del ", " of ", " von ", " van "]
        for pattern in patterns {
            if let range = text.range(of: pattern, options: .caseInsensitive) {
                let after = text[range.upperBound...].trimmingCharacters(in: .whitespacesAndNewlines)
                let name = after.components(separatedBy: .whitespaces).first ?? ""
                return validateName(name)
            }
        }
        return nil
    }
    
    private func extractPattern3(from text: String) -> String? {
        return extractPattern2(from: text)
    }
    
    private func extractPattern4(from text: String) -> String? {
        let words = text.components(separatedBy: .whitespaces)
        guard words.count >= 2 else { return nil }
        
        let deviceWords = ["iPhone", "iPad", "iPod", "Mac", "MacBook", "Galaxy",
                          "Phone", "Tablet", "Pro", "Plus", "Air", "Mini"]
        
        let firstWord = words[0]
        if !deviceWords.contains(where: { firstWord.localizedCaseInsensitiveContains($0) }) {
            return validateName(firstWord)
        }
        
        return nil
    }
    
    private func validateName(_ candidate: String) -> String? {
        let cleaned = candidate.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard cleaned.count >= 2 else { return nil }
        
        if cleaned.rangeOfCharacter(from: .decimalDigits) != nil {
            return nil
        }
        
        let deviceWords = ["iPhone", "iPad", "iPod", "Mac", "Galaxy", "Phone",
                          "Tablet", "Pro", "Plus", "Air", "Mini", "Work", "Personal"]
        for device in deviceWords {
            if cleaned.localizedCaseInsensitiveCompare(device) == .orderedSame {
                return nil
            }
        }
        
        let capitalized = cleaned.prefix(1).uppercased() + cleaned.dropFirst().lowercased()
        
        if commonNames.contains(capitalized) {
            return capitalized
        }
        
        let isOnlyLetters = cleaned.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
        if isOnlyLetters && cleaned.count <= 15 {
            return capitalized
        }
        
        return nil
    }

    private func tryLanguageModel() async -> String? {
        do {
            let instructions = Instructions {
                """
                Extract ONLY the person's first name from this device name.
                
                Rules:
                - Return ONLY the first name, nothing else
                - Remove possessives ('s, de, do, da, di, del, von, van, of)
                - Ignore: iPhone, iPad, Galaxy, Phone, Mac, Pro, Plus, Air, Mini, numbers, emojis
                - If no real person name exists, return exactly: Reader
                
                Examples:
                "Luigi's iPhone" -> Luigi
                "iPhone de Caio" -> Caio
                "Giulia iPad Pro" -> Giulia
                "iPhone (86)" -> Reader
                "Work Phone" -> Reader
                """
            }
            
            let session = LanguageModelSession(instructions: instructions)
            
            let task = Task { @MainActor in
                let response = try await session.respond(
                    to: self.text,
                    options: GenerationOptions(sampling: .greedy)
                )
                return response.content.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            let timeout = Task {
                try await Task.sleep(for: .seconds(10))
                task.cancel()
            }
            
            let content = try await task.value
            timeout.cancel()
            
            if content.isEmpty || content.localizedCaseInsensitiveCompare("Reader") == .orderedSame {
                return nil
            }
            
            return validateName(content)
            
        } catch is CancellationError {
            return nil
        } catch {
            self.error = error
            return nil
        }
    }
}
