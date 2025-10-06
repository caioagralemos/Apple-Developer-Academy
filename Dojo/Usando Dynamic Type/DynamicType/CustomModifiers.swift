//
//  CustomModifiers.swift
//  DynamicType
//
//  Created by Joel Davies on 1/4/24.
//
//  os26 version July 2025


import SwiftUI


//MARK: Why type all these modifiers on every single button when I can do it just once?
struct DynamicButtonBG: ViewModifier {

    func body(content: Content) -> some View {
        content
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(.primary)
            .backgroundStyle(.secondary)
            .background(.thickMaterial) //compatible with Vision & iPhone
            .background(in:RoundedRectangle(cornerRadius: 8))
            
        
    }
}
//MARK: And I want code completion when I use the modifier! Lazy or efficient? WHO CARES, IT'S AWESOME.
extension View {
    func dynaButtonBG() -> some View {
        modifier(DynamicButtonBG())
    }
    
}

struct NiceParagraph: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .padding(.bottom, 7)
    }
}

extension View {
    func niceParagraph() -> some View {
        modifier(NiceParagraph())
    }
}
