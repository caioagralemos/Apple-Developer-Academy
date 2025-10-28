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
            // Lock screen/banner UI - baseado no Frame 5 do Figma
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("📖 \(context.attributes.bookName) - \(context.attributes.bookAuthor)")
                            .font(.system(size: 8, weight: .regular))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                    }
                    .opacity(0.6)
                    
                    Text(formatTime(seconds: context.state.durationInSeconds))
                        .font(.system(size: 48, weight: .regular))
                        .foregroundColor(.primary)
                    
                }
                
                Spacer()
                
                Image(systemName: "pause.circle")
                    .font(.system(size: 32))
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.quaternary, lineWidth: 0.5)
            )
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 8) {
                        Image(systemName: "book.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(context.attributes.bookName)
                                .font(.system(size: 12, weight: .semibold))
                                .lineLimit(1)
                            Text(context.attributes.bookAuthor)
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(spacing: 4) {
                        Text(formatTime(seconds: context.state.durationInSeconds))
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                        
                        Image(systemName: "pause.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.primary)
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(value: 1.0 - context.state.progress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .tint(.blue)
                        .padding(.horizontal)
                }
                
            } compactLeading: {
                Image(systemName: "book.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                    
            } compactTrailing: {
                Text(formatTime(seconds: context.state.durationInSeconds))
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.primary)
                    .minimumScaleFactor(0.8)
                    
            } minimal: {
                Text(formatTime(seconds: context.state.durationInSeconds))
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.primary)
                    .minimumScaleFactor(0.8)
            }
        }
    }
    
    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

extension SessionAttributes {
    fileprivate static var preview: SessionAttributes {
        SessionAttributes(bookName: "O Alquimista", bookAuthor: "Paulo Coelho")
    }
}

extension SessionAttributes.ContentState {
    fileprivate static var sampleState: SessionAttributes.ContentState {
        SessionAttributes.ContentState(durationInSeconds: 1113, progress: 0.3) // 18:33
    }
     
    fileprivate static var finalState: SessionAttributes.ContentState {
        SessionAttributes.ContentState(durationInSeconds: 0, progress: 1.0)
    }
}

#Preview("Notification", as: .content, using: SessionAttributes.preview) {
   ReadingSessionActivityLiveActivity()
} contentStates: {
    SessionAttributes.ContentState.sampleState
    SessionAttributes.ContentState.finalState
}
