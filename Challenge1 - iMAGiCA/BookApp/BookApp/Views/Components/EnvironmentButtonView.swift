//
//  EnvironmentButtonView.swift
//  BookApp
//
//  Created by Alessandro Cacace on 22/10/25.
//

import SwiftUI

struct EnvironmentButtonView: View {
    
    var environment: EnvironmentModel
    var action: () -> Void
    
    private func localizedEnvironmentName(for name: Name) -> String {
        switch name {
        case .custom:
            return String(localized: "environment.custom")
        case .lofi:
            return String(localized: "environment.lofi")
        case .rainyday:
            return String(localized: "environment.rainyday")
        case .piano:
            return String(localized: "environment.piano")
        case .forest:
            return String(localized: "environment.forest")
        case .wind:
            return String(localized: "environment.wind")
        }
    }
    
    var body: some View {
        Button(action: action) {
            
        
            VStack(spacing: 8){
                Text(environment.emoji)
                    .font(.system(size: 36))
                Text(localizedEnvironmentName(for: environment.name))
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
                
            }
            .padding(16)
            .frame(width:180)
            .background( RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(environment.isSelected ? Color.accentColor : Color.clear)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.12), radius: 5, x: 0, y: 6))
            .overlay(
               
                RoundedRectangle(cornerRadius: 18, style: .continuous)
              
                    .stroke(
                   
                        environment.isSelected ? Color.accentColor : Color.clear,
                        lineWidth: 3
                    )
            )
            //
        } .buttonStyle(.plain)
           
            
    }
}

#Preview {
   // GenreButtonView(genre: GenreButtonModel(emoji: "🧙🏻‍♂️", name: "Fantasy"))
}
