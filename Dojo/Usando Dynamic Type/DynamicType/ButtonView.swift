//
//  ButtonView.swift
//  DynamicType
//
//  Created by Joel Davies on 1/3/24.
//

import SwiftUI
import Foundation

struct ButtonView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        
        
        for buttonIcon in buttonIcons {

            print("My favorite song is \(buttonIcons)")
        }
        
        
       
       
            Image(systemName: "\(buttonIcons)")
                .font(.headline)
            Text("buttonLabelText")
                .font(.caption)
            Spacer()
                .frame(minWidth:0, maxHeight:0) // goofy and easy hack to force leading alignment
        }
        
    
}

#Preview {
    ButtonView()
}
