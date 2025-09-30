//
//  ButtonViewThatFits.swift
//  DynamicType
//
//  Created by Joel Davies on 1/4/24.
//

import SwiftUI

struct ButtonViewThatFits: View {
    var body: some View {
        ViewThatFits(in: .vertical) {
            Text(terms)

            ScrollView {
            Text(terms)
                    }
        }
}

#Preview {
    ButtonViewThatFits()
}
