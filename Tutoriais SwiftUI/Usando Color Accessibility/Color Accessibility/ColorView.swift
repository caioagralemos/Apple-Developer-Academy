//
//  ColorView.swift
//  Color Accessibility
//
//  Created by Joel Davies on 4/19/22.
//

import SwiftUI

struct ColorView: View {
    var body: some View {
        ZStack {
            Color(uiColor: UIColor.systemGray5)
                .ignoresSafeArea()
        
            ScrollView {
            
            VStack(alignment: .leading) {
                Text("Color Exercise")
                    .fontWeight(.bold)
                    .padding(0)
                    .font(.title)
                    .foregroundColor(.primary)
                Text("Test the colors below with Sim Daltonism and create new custom colors in Assets and CustomColors to build a more accessible palette. Use the Environment Overrides for the Simulator to test that every color on the screen is distinct and readable. The more colors you have, the harder it gets...")
                    .font(.body)
                    .padding(.top, 1)
            }
            .padding()
            .frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  minHeight: 0,
                  maxHeight: .infinity,
                  alignment: .topLeading
                )
                
            VStack {
                
                Text("can")
                    .padding()
                    .font(.title)
                    .foregroundColor(.primary)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.green)
         
                
                Text("you")
                    .padding()
                    .font(.title)
                    .foregroundColor(.primary)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.yellow)
                
                Text("make")
                    .padding()
                    .font(.title)
                    .foregroundColor(.primary)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.orange)
                
                Text("six")
                    .padding()
                    .font(.title)
                    .foregroundColor(.primary)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.red)
                
                Text("colors")
                    .padding()
                    .font(.title)
                    .foregroundColor(.primary)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.purple)
                
                Text("work?")
                    .padding()
                    .font(.title)
                    .foregroundColor(.primary)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.blue)
                
                
                
            }
            .padding()
            .frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  minHeight: 0,
                  maxHeight: .infinity,
                  alignment: .topLeading
                )
                
        VStack(alignment: .leading) {
                Text("Reality Check")
                    .fontWeight(.bold)
                    .padding(0)
                    .font(.title)
                    .foregroundColor(.primary)
                Text("It's almost impossible to choose six colors that are truly distinct from each other for colorblind users. Two or three is fairly simple. If you find yourself needing a large color palette, go for contrast between the different foreground colors and stick with a neutral background. Remember, a best practice is to always use labels and/or glyphs in addition to color to convey meaning.")
                    .font(.body)
                    .padding(.top, 1)
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

struct ColorView_Previews: PreviewProvider {
    static var previews: some View {
        ColorView()
    }
}
