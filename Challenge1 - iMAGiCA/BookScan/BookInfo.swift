//
//  Book.swift
//  Tests
//
//  Created by Caio on 14/10/25.
//

import Foundation
import FoundationModels

@Generable(description: "A book's information")
struct BookInfo {
    @Guide(description: "Book's title")
    var title: String

    @Guide(description: "A short subtitle for the book, if you can find. Otherwise, just leave null")
    var subtitle: String?
    
    @Guide(description: "The book's author")
    var author: String
    
  // @Guide(description: "Book cover's main color")
  // let color: String

    @Guide(description: "The (most likely) genre of the book")
    var genre: Genre
    
    var completed: Bool = false
}

@Generable
enum Genre: String {
    case scienceFiction = "Sci-fi"
    case romance = "Romance"
    case fantasy = "Fantasy"
    case history = "History"
    case thriller = "Thriller"
    case kids = "Kids"
}

extension BookInfo {
    static let exampleBook = BookInfo(title: "Diary of a Wimpy Kid", subtitle: "a novel in cartoons", author: "Jeff Kinney", genre: .kids)
}
