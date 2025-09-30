//
//  GracefulCardView.swift
//  DynamicType
//
//  Created by Joel Davies on 1/4/24.
//
//  os26 version July 2025


import SwiftUI


struct GracefulCardView: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        
        let dynamicHStack = dynamicTypeSize <= .xxLarge ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
        
        VStack {
            dynamicHStack {
                Image(systemName: "accessibility.fill")
                    .font(.system(size: 80))// sfSymbol used as graphic, so it's OK to not resize it
                    .foregroundColor(.secondary)
                VStack(alignment: .leading) {
                    Text("Real Accessibility")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("A tough marriage of form and function.")
                        .niceParagraph()
    
                        .fontWidth(.expanded)
                        .fontWeight(.light)
                    //expanded width and different weight helps reinforce hierarchy. Remember, you can use color, weight, and width to create a visual hierarchy of content
                    
                }
                .frame(maxWidth: .infinity)
                
                
            }.padding(8)
            
            Text("Basically, don't fall in love with your pixel perfect layout built in Sketch or Figma. Users can and SHOULD be able to break the layout so they can read it. Also, notice that really large text will max out size faster, so make sure you are using weight, width, or color to also design visual hierarchy.")
                
                .padding(.horizontal, 20)
            
        }
        
            .padding(.bottom, 16)
            .background(in:RoundedRectangle(cornerRadius: 16))
            .foregroundStyle(.primary)
            .backgroundStyle(.quinary)
    }
}

#Preview {
    GracefulCardView()
}
