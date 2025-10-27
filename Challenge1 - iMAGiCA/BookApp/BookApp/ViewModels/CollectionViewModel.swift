//
//  CollectionViewModel.swift
//  BookApp
//
//  Created by Alessandro Cacace on 17/10/25.
//

import SwiftUI
import Combine

class CollectionViewModel: ObservableObject {
    
    
    @Published var searchText: String = ""
        
    @Published var filteredBooks: [Book] = []
    
    @Published var allBooks: [Book] = [Book(title: "Atomic Habits", author: "James Clear", genre: .personalDevelopment),
                                            Book(title: "The Alchemist", author: "Paulo Coelho", genre: .adventureAction),
                                            Book(title: "Sapiens", author: "Yuval Noah Harari", genre: .scienceFiction),
                                            Book(title: "Dune", author: "Frank Herbert", genre: .scienceFiction),
                                            Book(title: "1984", author: "George Orwell", genre: .fiction),
                                            Book(title: "To Kill a Mockingbird", author: "Harper Lee", genre: .adventureAction),]
    
    private var cancellables = Set<AnyCancellable>()
    
  
    
        func setupSearch() {
           $searchText
               .debounce(for: .milliseconds(300), scheduler: RunLoop.main) // Attende un attimo prima di cercare
               .removeDuplicates() // Evita ricerche multiple per lo stesso testo
               .sink { [weak self] searchText in
                   self?.filterBooks(with: searchText)
               }
               .store(in: &cancellables)
       }
       
        func filterBooks(with query: String) {
           if query.isEmpty {
               filteredBooks = allBooks
           } else {
               filteredBooks = allBooks.filter { book in
                   // Cerca nel titolo o nell'autore, ignorando maiuscole/minuscole
                   book.title.localizedCaseInsensitiveContains(query) ||
                   book.author.localizedCaseInsensitiveContains(query)
               }
           }
       }
       
        func setupMockData() {
           // Aggiungi qui i tuoi libri. Assicurati di avere le immagini nel tuo Assets.xcassets
           self.allBooks = [Book(title: "Atomic Habits", author: "James Clear", genre: .personalDevelopment),
                            Book(title: "The Alchemist", author: "Paulo Coelho", genre: .adventureAction),
                            Book(title: "Sapiens", author: "Yuval Noah Harari", genre: .scienceFiction),
                            Book(title: "Dune", author: "Frank Herbert", genre: .scienceFiction),
                            Book(title: "1984", author: "George Orwell", genre: .fiction),
                            Book(title: "To Kill a Mockingbird", author: "Harper Lee", genre: .adventureAction),]
           
           // All'inizio, mostra tutti i libri
           self.filteredBooks = allBooks
       }
}
