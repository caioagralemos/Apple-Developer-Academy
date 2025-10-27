import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var currentBook: Book?
    @Published var sortedBooks: [Book] = []
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupObservers()
        loadAndSortBooks()
    }
    
    private func setupObservers() {
        dataManager.$myReadingSessions
            .sink { [weak self] _ in
                self?.loadAndSortBooks()
            }
            .store(in: &cancellables)
        
        dataManager.$myBooks
            .sink { [weak self] _ in
                self?.loadAndSortBooks()
            }
            .store(in: &cancellables)
    }
    
    func loadAndSortBooks() {
        let mostRecentSession = dataManager.myReadingSessions
            .sorted { $0.createdAt > $1.createdAt }
            .first
        
        if let session = mostRecentSession {
            currentBook = dataManager.getBook(by: session.bookId)
        } else {
            currentBook = nil
        }
        
        let booksWithLastSession = dataManager.myBooks.compactMap { book -> (Book, Date)? in
            if book.id == currentBook?.id {
                return nil
            }
            
            let lastSession = dataManager.myReadingSessions
                .filter { $0.bookId == book.id }
                .max { $0.createdAt < $1.createdAt }
            
            if let session = lastSession {
                return (book, session.createdAt)
            } else {
                return (book, Date.distantPast)
            }
        }
        
        sortedBooks = booksWithLastSession
            .sorted { $0.1 > $1.1 }
            .map { $0.0 }
    }
}