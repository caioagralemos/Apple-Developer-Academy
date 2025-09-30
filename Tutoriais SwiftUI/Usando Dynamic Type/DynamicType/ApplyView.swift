//
//  ApplyView.swift
//  DynamicType
//
//  Created by Joel Davies on 1/2/24.
//
//  os26 version July 2025


import SwiftUI

struct ApplyView: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                
                Text("Think and Apply")
                    .font(.title)
                    .bold()
                
                Text("Now that you know how to implement Dynamic Type like a boss, you have no excuse not to always **design** great accessible apps.")
                    .niceParagraph()
                
                Text("Why are you still reading this? Go and refactor your projects to be awesome!")
                    .niceParagraph()
            }
        }
        .padding()
        
        
        
    }
}

#Preview {
    ApplyView()
}
