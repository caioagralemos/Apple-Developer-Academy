//
//  AddModalView.swift
//  BookApp
//
//  Created by Alessandro Cacace on 22/10/25.
//

import SwiftUI
// Assuming your BookModel and Genre enum are in a file accessible here

struct AddModalView: View {
    @Binding var book: Book?
    @Binding var isEditing: Bool
    @Binding var allSet: Bool

    // Local editable state
    @State private var bookTitle: String
    @State private var bookAuthor: String
    @State private var selectedGenre: Genre

    @Environment(\.dismiss) private var dismiss

    // Designated initializer
    init(
        book: Binding<Book?>,
        isEditing: Binding<Bool>,
        allSet: Binding<Bool>,
        bookTitle: String = "",
        bookAuthor: String = "",
        selectedGenre: Genre = .fiction
    ) {
        self._book = book
        self._isEditing = isEditing
        self._allSet = allSet

        if let existing = book.wrappedValue {
            self._bookTitle = State(initialValue: existing.title)
            self._bookAuthor = State(initialValue: existing.author)
            self._selectedGenre = State(initialValue: existing.genre)
        } else {
            self._bookTitle = State(initialValue: bookTitle)
            self._bookAuthor = State(initialValue: bookAuthor)
            self._selectedGenre = State(initialValue: selectedGenre)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                    VStack(alignment: .center, spacing: 16) {
                         Image("mark")
                             .resizable()
                             .aspectRatio(contentMode: .fit) // Use .fit to avoid distortion
                             .frame(width: 80, height: 80) // Adjust size as needed

                        Text(isEditing ? NSLocalizedString("addBook.editBookInfo", comment: "Edit your book's information") : NSLocalizedString("addBook.addBookInfo", comment: "Add your book's information"))
                             .font(.custom("EB Garamond", size: 20))
                             .foregroundStyle(.primary)
                             .multilineTextAlignment(.center)
                    }
                    .padding(.vertical) // Add padding around the top section
                 // Make this section background transparent

                // Section for book details
                Section() {
                    // Title Row
                    HStack {
                        Text(NSLocalizedString("addBook.title", comment: "Title"))
                            .font(.custom("EB Garamond", size: 18))
                        Spacer()
                        TextField(NSLocalizedString("addBook.enterTitle", comment: "Enter title"), text: $bookTitle)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.secondary)
                    }.padding(.horizontal,15)
                    Divider()
                        .padding(.horizontal)
                    
                    // Author Row
                    HStack {
                        Text(NSLocalizedString("addBook.author", comment: "Author"))
                            .font(.custom("EB Garamond", size: 18))
                        Spacer()
                        TextField(NSLocalizedString("addBook.enterAuthor", comment: "Enter author"), text: $bookAuthor)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.secondary)
                    }.padding(.horizontal,15)
                    
                    Divider()
                        .padding(.horizontal)
                    // Genre Row
                    HStack {
                        Text(NSLocalizedString("addBook.genre", comment: "Genre"))
                            .font(.custom("EB Garamond", size: 18))
                        Spacer()
                        Picker("", selection: $selectedGenre) {
                            ForEach(Genre.allCases, id: \.self) { genre in
                                Text(genre.localizedName).tag(genre)
                            }
                        }
                        .pickerStyle(.menu)
                    }.padding(.horizontal,15)
                }.padding(.horizontal)
            }
            .navigationTitle(isEditing ? NSLocalizedString("addBook.editBook", comment: "Edit Book") : NSLocalizedString("addBook.addBook", comment: "Add Book"))
            .navigationBarTitleDisplayMode(.inline)
            .padding(.bottom)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("addBook.cancel", comment: "Cancel")) {
                        dismiss()
                        self.book = nil
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        saveBook()
                        dismiss()
                        allSet = true
                    } label: {
                        Text(NSLocalizedString("addBook.save", comment: "Save"))
                    }
                    // Disable Save button if title or author is empty
                    .disabled(bookTitle.isEmpty || bookAuthor.isEmpty)
                }
            }
        }
    }

    // Function to handle saving the new book
    func saveBook() {
        let newBook = Book(
            title: bookTitle,
            author: bookAuthor,
            genre: selectedGenre
            // Add subtitle or other fields if needed
        )
        self.book = newBook
    }
}

// Preview Provider
struct AddModalView_Previews: PreviewProvider {
    static var previews: some View {
        //AddModalView(book: .constant(Book(title: "Hey", author: "Hey", genre: .comic)), isAdding: .constant(true))
    }
}
