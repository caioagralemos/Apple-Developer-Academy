//
//  ReadingSessionActivity.swift
//  ReadingSessionActivity
//
//  Created by Caio on 27/10/25.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct ReadingSessionActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SessionAttributes.self) { context in
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image("book")
                            .resizable()
                            .frame(width: 8, height: 10)
                        Text("\(context.attributes.bookName) - \(context.attributes.bookAuthor)")
                            .font(.system(size: 8, weight: .regular))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                    }
                    .opacity(0.6)
                    
                    Text(context.state.endDate, style: .timer)
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundColor(.primary)
                        .padding(.top, -10)
                    
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            .background(.background, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.quaternary, lineWidth: 0.5)
            )
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    
                }
            } compactLeading: {
                Image(systemName: "book.fill")
            } compactTrailing: {
                Text(context.state.endDate, style: .timer)
                    .frame(width: 42, alignment: .center)
            } minimal: {
                Text(context.state.endDate, style: .timer)
                    .frame(width: 42, alignment: .center)
            }
        }
        .supplementalActivityFamilies([.small, .medium])
    }
}

extension SessionAttributes {
    fileprivate static var preview: SessionAttributes {
        SessionAttributes(bookName: "O Alquimista", bookAuthor: "Paulo Coelho")
    }
}

extension SessionAttributes.ContentState {
    fileprivate static var sampleState: SessionAttributes.ContentState {
        SessionAttributes.ContentState(endDate: Date.now.addingTimeInterval(800)) // 18:33
    }
     
    fileprivate static var finalState: SessionAttributes.ContentState {
        SessionAttributes.ContentState(endDate: Date.now.addingTimeInterval(800))
    }
}

#Preview("Notification", as: .content, using: SessionAttributes.preview) {
   ReadingSessionActivityLiveActivity()
} contentStates: {
    SessionAttributes.ContentState.sampleState
    SessionAttributes.ContentState.finalState
}
