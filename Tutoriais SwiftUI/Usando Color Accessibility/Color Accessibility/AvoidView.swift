//
//  AvoidView.swift
//  Colorize
//
//  Created by Joel Davies on 4/25/22.
//

import SwiftUI

struct AvoidView: View {
    var body: some View {
        
       ZStack {
           Color(uiColor: UIColor.systemGray5)
               .ignoresSafeArea()
       
           ScrollView {
           
           VStack(alignment: .leading) {
               Text("Colors to Avoid")
                   .fontWeight(.bold)
                   .padding(0)
                   .font(.title)
                   .foregroundColor(.primary)
               Text("Some color combinations should always be avoided in order to make elements plainly visible to color blind users. Test the color combinations below using Sim Daltonism for all color blindness types.")
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
               
               Text("red and green")
                   .padding()
                   .font(.title2)
                   .foregroundColor(.red)
                   .frame(minWidth: 0, maxWidth: .infinity)
                   .background(Color.avoidGreen)
               
               Text("pink and yellow")
                   .padding()
                   .font(.title2)
                   .foregroundColor(.avoidPink)
                   .frame(minWidth: 0, maxWidth: .infinity)
                   .background(Color.yellow)
               
               Text("green and orange")
                   .padding()
                   .font(.title2)
                   .foregroundColor(.green)
                   .frame(minWidth: 0, maxWidth: .infinity)
                   .background(Color.orange)
               
               Text("purple and blue")
                   .padding()
                   .font(.title2)
                   .foregroundColor(.blue)
                   .frame(minWidth: 0, maxWidth: .infinity)
                   .background(Color.purple)
               
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
                Text("Contrast FTW")
                    .fontWeight(.bold)
                    .padding(0)
                    .font(.title)
                    .foregroundColor(.primary)
                Text("I know some of you are thinking - \u{201C}Hey Joel, those all have terrible contrast!\u{201D} Following AAA Contrast Guidelines will help with some of these color combinations. However, it's best to choose colors that are easily distinguished by all sighted users. Also, your corrected color sets should still have AAA contrast levels, even when viewed through Sim Daltonism.")
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

struct AvoidView_Previews: PreviewProvider {
    static var previews: some View {
        AvoidView()
    }
}
