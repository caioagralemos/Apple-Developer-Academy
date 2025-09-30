//
//  ButtonArray.swift
//  DynamicType
//
//  Created by Joel Davies on 1/2/24.
//
//  os26 version July 2025


import SwiftUI

struct ButtonArray: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        
        //MARK: the constants below create new dynamic custom views that change HStacks to VStacks and vice versa to create graceful support of dynamic type in the buttons. AnyLayout can also support ZStackLayout and GridLayout! try changing xLarge to other values to see what happens
        
        let dynamicHStack = dynamicTypeSize <= .xLarge ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
        
        let dynamicVStack = dynamicTypeSize <= .xLarge ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
        
        dynamicHStack{
            
            dynamicVStack{
                Image(systemName: "message.fill")
                    .font(.headline)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                //MARK: this modifier actually limits dynamic type size. be careful when using it. this allows type to be resized up to accessibility 1 size
                    .frame(minWidth: 0, maxWidth:60, minHeight:20)
                Text("message")
                    .font(.caption)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility3)
                //MARK: same modifier as above, but this allows the text to get a little bigger: accessibility 3 size
                Spacer().frame(maxHeight:0)
                //MARK: goofy and easy hack to force leading alignment when flipped to HStack
            }
            .dynaButtonBG()
            
            dynamicVStack{
                Image(systemName: "phone.fill")
                    .font(.headline)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                    .frame(minWidth: 0, maxWidth:60, minHeight:20)
                Text("call")
                    .font(.caption)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility3)
                Spacer().frame(height:0)
            }
            .dynaButtonBG()
            
            dynamicVStack{
                Image(systemName: "video.fill")
                    .font(.headline)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                    .frame(minWidth: 0, maxWidth:60, minHeight:20)
                Text("FaceTime")
                    .font(.caption)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility3)
                Spacer().frame(height:0)
            }
            .dynaButtonBG()
            
            
            dynamicVStack{
                Image(systemName: "envelope.fill")
                    .font(.headline)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                    .frame(minWidth: 0, maxWidth:60, minHeight:20)
                Text("mail")
                    .font(.caption)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility3)
                Spacer().frame(height:0)
            }
            
            .dynaButtonBG()
           
            
            dynamicVStack{
                Image(systemName: "creditcard.fill")
                    .font(.headline)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                    .frame(minWidth: 0, maxWidth:60, minHeight:20)
                Text("pay")
                    .font(.caption)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility3)
                Spacer().frame(height:0)
            }
            .dynaButtonBG()
            
            
            
        }
        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        //MARK: This is here to make the view look nice on the canvas. Comment it out and you'll see what I mean.
    }
}

#Preview {
    ButtonArray()
}
