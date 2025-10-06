//
//  AvoidView.swift
//  DynamicType
//
//  Created by Joel Davies on 1/2/24.
//
//  os26 version July 2025


import SwiftUI

struct AvoidView: View {
    var body: some View {
       
        ScrollView() {
            VStack(alignment: .leading) {
                
                Text("Avoid Worst Practices")
                    .font(.system(size:27))
                //MARK: using hard-codeed sized fonts is really a worst practice. semantic text styles + limits to upper dynamic type sizes AND flexible layouts is the path to awesome accessibility support.
                    .lineSpacing(31)
                    .bold()
                    
                
                VStack(alignment: .leading) {
                    Text("This screen is full of Dynamic Type worst practices.")
                        .font(.system(size:17))
                        .padding(.bottom, 8)
                
                    Text("Don't get me wrong, software like Sketch is amazing. But not building a final prototype in Xcode leaves a lot of important questions unanswered:")
                        .font(.system(size:17))
                        .padding(.bottom, 8)
                    
                    Text("1: Does your App support Dynamic Type?")
                        .font(.system(size:17))
                        .bold()
                    
                    Text("Why? Every human on the planet will have their ability to read text diminished as they age. Additionally, younger users with low vision are increasingly common.")
                        .font(.system(size:17))
                        .padding(.bottom, 8)
                        
                    
                    Text("2: Is the support designed gracefully?")
                        .font(.system(size:17))
                        .bold()
                    
                    Text("It is vitally important to **rigorously test** your dynamic type support, so the designer(s) can make good decisions about how the layout adjusts to support dynamic type. Only an Xcode prototype allows you to fully consider designing an app for all users. Sketch, Figma, and the like are not capable of supporting Dynamic Type, Haptics, or Sound design.")
                        .font(.system(size:17))
                        .padding(.bottom, 8)
                    
                }
                VStack(alignment: .leading){
                    Text("Bad Dynamic Type Support")
                        .font(.system(size:17))
                        .bold()
                        .padding(.bottom, 8)
                       
                    Text("This VStack is a showcase of worst practices in Dynamic Type support.")
                        .font(.body)
                        .padding(.bottom, 8)
                    
                    Text("It mixes Dynamic with Fixed Type. Yuck. When this body text expands, the headline no longer maintains proper visual hierachy.")
                        .font(.body)
                        .padding(.bottom, 8)
                    
                    Text("The VStack has a fixed size, so the text is going to get cut off and trucated.")
                        .font(.body)
                    
                    
                }.padding(8)
                    .frame(height:240, alignment: .topLeading)
                    .background(.quaternary)
                    .cornerRadius(8)
                
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

#Preview {
    AvoidView()
}
