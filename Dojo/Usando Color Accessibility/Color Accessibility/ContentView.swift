//
//  ContentView.swift
//  Color Accessibility
//
//  Created by Joel Davies on 4/19/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            
        ZStack {
            Color.customBackground
                .ignoresSafeArea()
                .accessibility(hidden: true)
        
        
            ScrollView {
                
                VStack(alignment: .leading) {
                    
                    Text("Color Accessibility")
                        .fontWeight(.bold)
                        .padding(0)
                        .font(.title)
                        .foregroundColor(.primary)
                
                    Text("Color Accessibility is about making sure your colors support all users, both fully sighted and colorblind people. Using a combination of contrast and color, you can make sure all users can see the UI and experience the app without difficulty or confusion.")
                        .font(.body)
                        .padding(.top, 06)
                        .foregroundStyle(.mycolor)
                    
// SIM DALTONISM LINK : https://apps.apple.com/us/app/sim-daltonism/id693112260?mt=12
                    
                    Text("Download Sim Daltonism from the Mac App Store to check your colors. The point is for users to be able to see a clear contrast between the colors, not to see the colors exactly as you see them.")
                        .font(.body)
                        .padding(.top, 6)
                    
                    Text("A really great color palette will include light and dark variations, as well as high / increased contrast variations of all colors. Instead of white and black, use .background and .primary whenever possible. Never hard-code a color when you can use a full color set.")
                        .font(.body)
                        .padding(.top, 6)
                    
                    Text("This screen uses a custom color background to demonstrate creating accessible colors using high / increased contrast variations. Test them using the \u{201C}Environment Overrides\u{201D} in the Simulator.")
                        .font(.body)
                        .padding(.top, 6)
                    
                    Text("Make sure you understand how to create, name, and implement custom colors.")
                        .font(.body)
                        .padding(.top, 6)
                    
                    Spacer()
                    
                    
                }
                .padding()
                .frame(
                      minWidth: 0,
                      maxWidth: .infinity,
                      minHeight: 0,
                      maxHeight: .infinity,
                      alignment: .topLeading
                    )
              
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
