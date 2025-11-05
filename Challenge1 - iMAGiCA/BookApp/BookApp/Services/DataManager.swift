//
//  DataManager.swift
//  BookApp
//
//  Created by Caio on 22/10/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class DataManager: ObservableObject {
    static let shared = DataManager()
    
    // Published properties for reactive UI
    @Published var myBooks: [Book] = []
    @Published var myReadingSessions: [ReadingSession] = []
    @Published var quote: String = "“Lorem ipsum dolor sit amet” - Pietro"
    @Published var name: String = "Reader"
    
    // UserDefaults keys
    private let booksKey = "myBooks"
    private let sessionsKey = "myReadingSessions"
    
    
    private init() {
        // Perform synchronous loads
        loadBooksFromUserDefaults()
        loadSessionsFromUserDefaults()
        
        if let code = Locale.current.language.languageCode?.identifier {
            let source: [String]
            switch code {
            case "fa":
                source = quotesPersian
            case "hi":
                source = quotesHindi
            case "it":
                source = citazioni
            case "pt":
                source = frases
            default:
                source = quotes
            }
            
            if let random = source.randomElement() {
                self.quote = random
            }
        }
        
        // Defer async work
        Task { [weak self] in
            await self?.checkName()
        }
    }
    
    // MARK: - Books Management
    
    /// Adds a new book to the collection if it doesn't already exist
    func addBook(_ book: Book) {
        // Check if book already exists by ID
        if !myBooks.contains(where: { $0.id.lowercased() == book.id.lowercased() }) {
            myBooks.append(book)
            saveBooksToUserDefaults()
            print("📚 Added new book: \(book.title) by \(book.author)")
        } else {
            print("📚 Book already exists: \(book.title)")
        }
    }
    
    /// Updates an existing book's completion status
    func updateBookCompletion(_ bookId: String, completed: Bool) {
        if let index = myBooks.firstIndex(where: { $0.id == bookId }) {
            myBooks[index].completed = completed
            saveBooksToUserDefaults()
            print("📚 Updated book completion: \(myBooks[index].title) - \(completed)")
        }
    }
    
    /// Removes a book from the collection
    func removeBook(_ bookId: String) {
        myBooks.removeAll { $0.id == bookId }
        saveBooksToUserDefaults()
        print("📚 Removed book with ID: \(bookId)")
    }
    
    /// Gets a book by its ID
    func getBook(by id: String) -> Book? {
        return myBooks.first { $0.id == id }
    }
    
    // MARK: - Reading Sessions Management
    
    /// Creates and saves a new reading session
    func createReadingSession(for book: Book, focusTimeInSeconds: Int, completed: Bool = false) -> ReadingSession {
        // First, add the book to the collection if it doesn't exist
        addBook(book)
        
        // Create new reading session
        let session = ReadingSession(
            id: UUID(),
            bookId: book.id,
            createdAt: Date(),
            focusTimeInSeconds: focusTimeInSeconds,
            completed: completed
        )
        
        myReadingSessions.append(session)
        saveSessionsToUserDefaults()
        
        print("📖 Created reading session for: \(book.title) - \(focusTimeInSeconds)s")
        return session
    }
    
    /// Updates a reading session's completion status
    func updateSessionCompletion(_ sessionId: UUID, completed: Bool) {
        if let index = myReadingSessions.firstIndex(where: { $0.id == sessionId }) {
            let updatedSession = ReadingSession(
                id: myReadingSessions[index].id,
                bookId: myReadingSessions[index].bookId,
                createdAt: myReadingSessions[index].createdAt,
                focusTimeInSeconds: myReadingSessions[index].focusTimeInSeconds,
                completed: completed
            )
            myReadingSessions[index] = updatedSession
            saveSessionsToUserDefaults()
            print("📖 Updated session completion: \(sessionId) - \(completed)")
        }
    }
    
    /// Gets all sessions for a specific book
    func getSessions(for bookId: String) -> [ReadingSession] {
        return myReadingSessions.filter { $0.bookId == bookId }
    }
    
    /// Gets the most recent session for a book
    func getLastSession(for bookId: String) -> ReadingSession? {
        return getSessions(for: bookId)
            .sorted { $0.createdAt > $1.createdAt }
            .first
    }
    
    /// Gets total reading time for a book
    func getTotalReadingTime(for bookId: String) -> Int {
        return getSessions(for: bookId)
            .reduce(0) { $0 + $1.focusTimeInSeconds }
    }
    
    /// Gets total reading time across all books
    func getTotalReadingTime() -> Int {
        return myReadingSessions.reduce(0) { $0 + $1.focusTimeInSeconds }
    }
    
    // MARK: - UserDefaults Persistence
    
    private func saveBooksToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(myBooks) {
            UserDefaults.standard.set(encoded, forKey: booksKey)
            print("💾 Saved \(myBooks.count) books to UserDefaults")
        } else {
            print("❌ Failed to encode books")
        }
    }
    
    private func loadBooksFromUserDefaults() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: booksKey),
           let books = try? decoder.decode([Book].self, from: data) {
            self.myBooks = books
            print("📂 Loaded \(books.count) books from UserDefaults")
        } else {
            print("📂 No books found in UserDefaults")
        }
    }
    
    private func saveSessionsToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(myReadingSessions) {
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
            print("💾 Saved \(myReadingSessions.count) sessions to UserDefaults")
        } else {
            print("❌ Failed to encode reading sessions")
        }
    }
    
    private func loadSessionsFromUserDefaults() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let sessions = try? decoder.decode([ReadingSession].self, from: data) {
            self.myReadingSessions = sessions
            print("📂 Loaded \(sessions.count) sessions from UserDefaults")
        } else {
            print("📂 No reading sessions found in UserDefaults")
        }
    }
    
    // MARK: - Analytics & Statistics
    
    /// Gets reading statistics
    func getReadingStats() -> ReadingStats {
        let totalTime = getTotalReadingTime()
        let completedSessions = myReadingSessions.filter { $0.completed }.count
        let uniqueBooksRead = Set(myReadingSessions.map { $0.bookId }).count
        let averageSessionTime = myReadingSessions.isEmpty ? 0 : totalTime / myReadingSessions.count
        
        return ReadingStats(
            totalReadingTime: totalTime,
            totalSessions: myReadingSessions.count,
            completedSessions: completedSessions,
            uniqueBooksRead: uniqueBooksRead,
            averageSessionTime: averageSessionTime
        )
    }
    
    /// Gets recent sessions (last 7 days)
    func getRecentSessions(days: Int = 7) -> [ReadingSession] {
        let calendar = Calendar.current
        let daysAgo = calendar.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        
        return myReadingSessions
            .filter { $0.createdAt >= daysAgo }
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    // MARK: - Debug Methods
    
    /// Clears all data (useful for testing)
    func clearAllData() {
        myBooks.removeAll()
        myReadingSessions.removeAll()
        UserDefaults.standard.removeObject(forKey: booksKey)
        UserDefaults.standard.removeObject(forKey: sessionsKey)
        print("🗑️ Cleared all data")
    }
    
    
    // MARK: Getting Name
    func checkName() async {
            let defaults = UserDefaults.standard
            if let existing = defaults.string(forKey: "name"), existing != "Reader" {
                print("Name found in defaults:", existing)
                self.name = existing
                return
            }
            let nameGuesser = NameGuesser(UIDevice.current.name)
            let value = await nameGuesser.generateInfo()
            print("Generated name:", value)
            defaults.set(value, forKey: "name")
            self.name = value
        }
}

// MARK: - Supporting Types

struct ReadingStats {
    let totalReadingTime: Int // in seconds
    let totalSessions: Int
    let completedSessions: Int
    let uniqueBooksRead: Int
    let averageSessionTime: Int // in seconds
    
    var formattedTotalTime: String {
        let hours = totalReadingTime / 3600
        let minutes = (totalReadingTime % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
    
    var formattedAverageTime: String {
        let minutes = averageSessionTime / 60
        return "\(minutes)m"
    }
}

// MARK: - Extension for easy formatting

extension ReadingSession {
    var formattedDuration: String {
        let hours = focusTimeInSeconds / 3600
        let minutes = (focusTimeInSeconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
}

