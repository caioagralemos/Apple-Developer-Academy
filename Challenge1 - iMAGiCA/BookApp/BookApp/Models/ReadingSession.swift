//
//  ReadingSession.swift
//  BookApp
//
//  Created by Caio on 22/10/25.
//

import Foundation

struct ReadingSession: Codable {
    let id: UUID
    let bookId: String // same to the Book one
    let createdAt: Date
    let focusTimeInSeconds: Int
    let completed: Bool
}
