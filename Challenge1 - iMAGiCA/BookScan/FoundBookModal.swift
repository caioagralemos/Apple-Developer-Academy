//
//  FoundBookModal.swift
//  Tests
//
//  Created by Caio on 15/10/25.
//

import SwiftUI

struct FoundBookModal: View {
    var book: BookInfo
    var body: some View {
        VStack(spacing: 30) {
            VStack {
                Book3D(size: 45)
                
                Text("Looks like we found your book!")
                    .font(.custom("EB Garamond", size: 20))
                    .fontWeight(.medium)
            }
            
            VStack (spacing: 20) {
                HStack {
                    Text("Title")
                        .font(.custom("EB Garamond", size: 18))
                        .opacity(0.8)
                    Spacer()
                    Text(book.title)
                }
                
                Divider()
                
                HStack {
                    Text("Author")
                        .font(.custom("EB Garamond", size: 18))
                        .opacity(0.8)
                    Spacer()
                    Text(book.author)
                }
                
                Divider()
                
                HStack {
                    Text("Genre")
                        .font(.custom("EB Garamond", size: 18))
                        .opacity(0.8)
                    Spacer()
                    Text(book.genre.rawValue)
                }
            }
            
            HStack {
                Button {
                    //
                } label: {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 12)
                                .padding(5)
                                .overlay(
                                    Text("Edit")
                                        .foregroundStyle(.black)
                                        .font(.title2.bold())
                                )
                        )
                }
                
                Button {
                    //
                } label: {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.black)
                        .overlay(
                            Text("That's it!")
                                .foregroundStyle(Color.white)
                                .font(.title2.bold())
                        )
                }
            }.frame(height: 75)
        }
        .padding(30)                                   // espaço interno
                .frame(width: 350, height: 450)
                .background(                                   // fundo arredondado
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.background)
                )
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

    }
}

#Preview {
    FoundBookModal(book: BookInfo.self.exampleBook)
}
