//
//  SessionAtributes.swift
//  BookApp
//
//  Created by Caio on 27/10/25.
//

import ActivityKit
import Foundation

struct SessionAttributes: ActivityAttributes {
    public typealias TimerStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        public let endDate: Date
    }
    
    public let bookName: String
    public let bookAuthor: String
}
