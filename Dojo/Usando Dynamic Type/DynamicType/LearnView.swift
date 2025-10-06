//
//  LearnView.swift
//  DynamicType
//
//  Created by Joel Davies on 1/2/24.
//
//  os26 version July 2025


import SwiftUI

struct LearnView: View {
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                Text("Learn Best Practices")
                    .font(.title)
                    .bold()
                
                Text("This screen has a series of best practices in place that you can practice on the practice screen. It's fine to copy and paste code from this screen to get started. I'll ask you to try some new things using these concepts on that screen.")
                    .niceParagraph()
                //MARK: what is a niceParagraph modifier? I made it to save time! check out CustomModifiers.swift to see how (and create your own to complete the Practice screen like a boss.
                
                Group {
                    
                    Text("The HStack of buttons below are going to gracefully change to a VStack when the text gets too large and breaks the layout. Peek at the code for how this is handled!")
                        .niceParagraph()
                    
                    //MARK: Just to keep some concepts visually separate, the code for the buttons is in ButtonArray.swift
                    
                    ButtonArray()
                }
                
                Divider()
                    .padding(.vertical, 20)
                
                Group{
                
                    Text("I made a card below to also gracefully support dynamic type using the same dynamicHStack view. This approach works with a ton of layout scenarios.")
                        .niceParagraph()
                    GracefulCardView()
                    
                }
                Divider()
                    .padding(.vertical, 20)
                Group {
                    Text("Sometimes you need elements to remain next to each other to retain meaning. Below is an example of using ViewThatFits() to support Dynamic Type")
                        .niceParagraph()
                    AirTravelView()
                    
                    
                }
                Divider()
                    .padding(.vertical, 20)
                Text("Finally, always conduct your testing in Simulator or on an actual device. The canvas in Xcode sometimes renders dynamic type inaccurately.")
                
                Spacer()
                    .padding(.vertical, 20)
            }.padding()
        }
    }
}

#Preview {
    LearnView()
}
