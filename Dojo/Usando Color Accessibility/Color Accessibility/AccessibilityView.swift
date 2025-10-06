//
//  AccessibilityView.swift
//  Colorize
//
//  Created by Joel Davies on 3/23/23.
//

import SwiftUI

struct AccessibilityView: View {
    // this line below must be added to make "differentiate without color" setting work!
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    var body: some View {
        ZStack{
            Color(uiColor: UIColor.systemGray5)
                .ignoresSafeArea()
        
            ScrollView {
            
            VStack(alignment: .leading) {
                Text("Go All-In For The Win!")
                    .fontWeight(.bold)
                    .padding(0)
                    .font(.title)
                    .foregroundColor(.primary)
                Text("Getting six colors to work is brutal, but another option is to use a final accessibility setting: Differentiate without Color. Turn that setting on in the simulator and watch the magic happen! Sample code to make this work is below on the 'make' view. I also threw an extra image to play with in Assets. Use it to differentiate another view as practice.")
                /*
                 differentiate without color allows you to include icons, patterns, images, whatever you need to make your app more accessible.
                 https://developer.apple.com/design/human-interface-guidelines/accessibility#Color-and-effects
                 */
                
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
                
                Text(differentiateWithoutColor ? "can (green)" : "can")
                    .padding()
                    .font(.title)
                    .foregroundColor(.primary)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(differentiateWithoutColor ? Color.gray : Color.green)
         
                
                Text(differentiateWithoutColor ? "you (yellow)" : "you")
                    .padding()
                    .font(.title)
                    .foregroundColor(.primary)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(differentiateWithoutColor ? Color.gray : Color.yellow)
                
                //Welcome! hey, there are two backgrounds! yep, remember swiftui stacks modifiers!
                //Also, don't forget to include the @Environment property wrapper to listen for the setting to be enabled...
                
                //the first string is the differentiated state, and both states need to match (be strings) in order for this to work
                Text(differentiateWithoutColor ? "make (orange)" : "make")
                //why a fencer you ask? WHY NOT, I SAY. You can change icons to make it easier to see a difference without color.
                    .padding()
                    .font(.title)
                    .foregroundColor(.primary)
                    .frame(minWidth: 0, maxWidth: .infinity)
                //the top background is an Image, and both states need to match (be images) in order for this to work - the second image is a blank transparent PNG
                    .background(differentiateWithoutColor ? Color.gray : Color.orange)
                
                Text(differentiateWithoutColor ? "six (red)" : "six")
                    .padding()
                    .font(.title)
                    .foregroundColor(.primary)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    
                    .background(differentiateWithoutColor ? Color.gray : Color.red)
                
                Text(differentiateWithoutColor ? "colors (purple)" : "colors")
                    .padding()
                    .font(.title)
                    .foregroundColor(.primary)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(differentiateWithoutColor ? Color.gray : Color.purple)
                
                Text(differentiateWithoutColor ? "work? (blue)" :"work?")
                    .padding()
                    .font(.title)
                    .foregroundColor(.primary)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(differentiateWithoutColor ? Color.gray : Color.blue)
                
                
                
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
                Text("Another Reality Check")
                    .fontWeight(.bold)
                    .padding(0)
                    .font(.title)
                    .foregroundColor(.primary)
                Text("Adding pattern as another way to differentiate colors for people can cause high-contrast readability issues. Think about how you could make the differentiation clear, without losing readability. HINT: I made this not the most readable example on purpose. Not to be opaque about it, but one solution might become a little more clear with time spent thinking about it. All puns intended.")
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

struct AccessibilityView_Previews: PreviewProvider {
    static var previews: some View {
        AccessibilityView()
    }
}
