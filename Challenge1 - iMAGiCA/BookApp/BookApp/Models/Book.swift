//
//  Book.swift
//  Tests
//
//  Created by Caio on 14/10/25.
//

import Foundation
import FoundationModels

@Generable(description: "A book's information")
struct Book: Codable, Identifiable {
    var id: String {
        "\(title)-\(author)"
    }
    
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
enum Genre: String, Codable, CaseIterable {
    case adventureAction = "Action / Adventure"
    case biography = "Biography"
    case comedy = "Comedy"
    case comic = "Comic"
    case drama = "Drama"
    case education = "Education"
    case fantasy = "Fantasy"
    case fiction = "Fiction"
    case historicalFiction = "Historical Fiction"
    case horror = "Horror"
    case kids = "Kids"
    case mysteryThriller = "Mystery / Thriller"
    case nonFiction = "Non-Fiction"
    case personalDevelopment = "Personal Development"
    case philosophySpiritual = "Philosophy / Spiritual"
    case poetry = "Poetry"
    case psychology = "Psychology"
    case romance = "Romance"
    case scienceFiction = "Sci-Fi"
    case travel = "Travel"
    
    var localizedName: String {
        switch self {
        case .adventureAction:
            return NSLocalizedString("genre.adventureAction", comment: "Action / Adventure genre")
        case .biography:
            return NSLocalizedString("genre.biography", comment: "Biography genre")
        case .comedy:
            return NSLocalizedString("genre.comedy", comment: "Comedy genre")
        case .comic:
            return NSLocalizedString("genre.comic", comment: "Comic genre")
        case .drama:
            return NSLocalizedString("genre.drama", comment: "Drama genre")
        case .education:
            return NSLocalizedString("genre.education", comment: "Education genre")
        case .fantasy:
            return NSLocalizedString("genre.fantasy", comment: "Fantasy genre")
        case .fiction:
            return NSLocalizedString("genre.fiction", comment: "Fiction genre")
        case .historicalFiction:
            return NSLocalizedString("genre.historicalFiction", comment: "Historical Fiction genre")
        case .horror:
            return NSLocalizedString("genre.horror", comment: "Horror genre")
        case .kids:
            return NSLocalizedString("genre.kids", comment: "Kids genre")
        case .mysteryThriller:
            return NSLocalizedString("genre.mysteryThriller", comment: "Mystery / Thriller genre")
        case .nonFiction:
            return NSLocalizedString("genre.nonFiction", comment: "Non-Fiction genre")
        case .personalDevelopment:
            return NSLocalizedString("genre.personalDevelopment", comment: "Personal Development genre")
        case .philosophySpiritual:
            return NSLocalizedString("genre.philosophySpiritual", comment: "Philosophy / Spiritual genre")
        case .poetry:
            return NSLocalizedString("genre.poetry", comment: "Poetry genre")
        case .psychology:
            return NSLocalizedString("genre.psychology", comment: "Psychology genre")
        case .romance:
            return NSLocalizedString("genre.romance", comment: "Romance genre")
        case .scienceFiction:
            return NSLocalizedString("genre.scienceFiction", comment: "Sci-Fi genre")
        case .travel:
            return NSLocalizedString("genre.travel", comment: "Travel genre")
        }
    }
    
    var fileName: String {
        return self.rawValue.replacingOccurrences(of: " / ", with: "-")
    }
}

extension Book {
    static let exampleBook = Book(title: "Diary of a Wimpy Kid", subtitle: "a novel in cartoons", author: "Jeff Kinney", genre: .kids)
}
