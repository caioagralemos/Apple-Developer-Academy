//
//  SessionAtributes.swift
//  BookApp
//
//  Created by Caio on 27/10/25.
//

import ActivityKit
import Foundation

struct SessionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var durationInSeconds: Int
        public var progress: Double
    }
    
    public let bookName: String
    public let bookAuthor: String
}
