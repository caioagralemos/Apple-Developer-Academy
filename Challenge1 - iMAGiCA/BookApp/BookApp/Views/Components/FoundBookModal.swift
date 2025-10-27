//
//  FoundBookModal.swift
//  Tests
//
//  Created by Caio on 15/10/25.
//

import SwiftUI

struct FoundBookModal: View {

    var book: Book
    @Binding var isScanning: Bool
    @Binding var currentBook: Book?
    @Binding var allSet: Bool
    @Binding var showAddModal: Bool
    @Binding var isEditing: Bool
   
    var body: some View {
        VStack(spacing: 30) {
            VStack {
                Book3D(size: 45)
                
                Text("Looks like we found your book!")
                    .font(.custom("EB Garamond", size: 20))
                    .fontWeight(.medium)
                    .foregroundStyle(.main)
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
                    Text(book.genre.localizedName)
                }
            }
            .foregroundStyle(.main)
            
            HStack {
                Button {
                    isEditing = true
                    isScanning = false
                    showAddModal = true
                } label: {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.second)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.main, lineWidth: 12)
                                .padding(5)
                                .overlay(
                                    Text("Edit")
                                        .foregroundStyle(.main)
                                        .font(.title2.bold())
                                )
                        )
                }
                
                Button {
                    isScanning = false
                    currentBook = book
                    allSet = true
                } label: {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.main)
                        .overlay(
                            Text("That's it!")
                                .foregroundStyle(.second)
                                .font(.title2.bold())
                        )
                }
            }.frame(height: 75)
        }
        .padding(30)                                   // internal spacing
                .frame(width: 350, height: 450)
                .background(                                   // rounded background
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.second)
                )
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

    }
}

#Preview {
    //FoundBookModal(book: Book.self.exampleBook, isScanning: .constant(true), currentBook: .constant(nil))
}
