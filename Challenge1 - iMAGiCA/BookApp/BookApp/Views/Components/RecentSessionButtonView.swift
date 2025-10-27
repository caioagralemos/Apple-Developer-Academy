//
//  RecentSessionView.swift
//  BookApp
//
//  Created by Alessandro Cacace on 16/10/25.
//

import SwiftUI

struct RecentSessionButtonView: View {
    let emoji: String
    let title: String
    let subtitle: String
    var body: some View {
        Button() {
            
            
        } label: {
            VStack(alignment: .leading, spacing: 8){
                Text(emoji)
                    .font(.system(size: 36))
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                
                
            }
            .padding(16)
            .frame(width:180, alignment: .leading)
            .background( RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThickMaterial)
                .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 6))
            
        }
        .buttonStyle(.plain)
    }
}


