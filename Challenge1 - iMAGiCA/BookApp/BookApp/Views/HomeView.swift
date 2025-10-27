import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Happy reading,\n\(dataManager.name)")
                            .font(.custom("EB Garamond", size: 36))
                            .fontWeight(.regular)
                        
                        Text(dataManager.quote)
                            .font(.headline)
                            .fontWeight(.light)
                            .padding(.top, 4)
                    }
                    .foregroundStyle(.main)
                    .padding()
                    
                    Spacer()
                }
                
                if let currentBook = viewModel.currentBook {
                    NavigationLink {
                        FocusSetupView(currentBook: currentBook)
                    } label: {
                        VStack {
                            HStack{
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(currentBook.title)
                                        .font(.custom("EB Garamond", size: 16))
                                        .foregroundStyle(.main)
                                        .padding(.trailing)
                                        .multilineTextAlignment(.leading)
                                    Text(currentBook.author)
                                        .foregroundStyle(.autorcolor)
                                        .font(.system(size: 12))
                                        .foregroundStyle(.main)
                                        .padding(.bottom)
                                        .padding(.top, -2)
                                    
                                    HStack {
                                        Text("Resume reading")
                                            .foregroundStyle(.main)
                                        Image(systemName: "arrow.forward")
                                            .foregroundStyle(.main)
                                    }
                                    .font(Font.system(size: 10).bold())
                                }
                                
                                Spacer()
                                
                                Image("bookcover")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                
                            }
                            .padding(.vertical, 15)
                            
                            
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 30)
                        .background(
                            RoundedRectangle(cornerRadius: 26)
                                .fill(.accentWhite)
                                .shadow(color: .black.opacity(0.12), radius: 1, x: 0, y: 2)
                        )
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 15)
                    
                    if viewModel.sortedBooks.isEmpty {
                        Spacer()
                        NavigationLink {
                            FocusSetupView()
                        } label: {
                            VStack {
                                Image(systemName: "books.vertical.fill")
                                    .font(.system(size: 100))
                                    .foregroundStyle(.main)
                                    .fontWeight(.ultraLight)
                                    .opacity(0.3)
                                    .padding(.bottom, 1)
                                
                                Text("Add a new book to see your bookshelf to life! Tap here to add")
                                    .fontWeight(.regular)
                                    .foregroundStyle(.main)
                                    .opacity(0.4)
                            }
                            .padding(.horizontal, 50)
                        }
                        Spacer()
                        Spacer()
                    } else {
                        ScrollView {
                            ForEach(viewModel.sortedBooks) { book in
                                NavigationLink(destination: FocusSetupView(currentBook: book)) {
                                    VStack {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(book.title)
                                                    .font(.headline)
                                                Text(book.author)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                        }
                                        .padding(.horizontal, 25)
                                        .padding(.vertical, 8)
                                        
                                        Divider()
                                            .padding(.horizontal)
                                    }
                                }
                                .foregroundStyle(.main)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .padding(.bottom, 20)
                    }
                } else {
                    Spacer()
                    NavigationLink {
                        FocusSetupView()
                    } label: {
                        VStack {
                            Image(systemName: "books.vertical.fill")
                                .font(.system(size: 100))
                                .foregroundStyle(.main)
                                .fontWeight(.ultraLight)
                                .opacity(0.3)
                                .padding(.bottom, 1)
                            
                            Text("Your bookshelf is empty!")
                                .fontWeight(.medium)
                                .foregroundStyle(.main)
                                .opacity(0.4)
                            
                            Text("Start reading to see the app come to life! Tap here to add a new book")
                                .fontWeight(.regular)
                                .foregroundStyle(.main)
                                .opacity(0.4)
                        }
                        .padding(.horizontal, 30)
                    }
                    Spacer()
                    Spacer()
                }
            }
            .padding()
            .padding(.top, -20)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                            .foregroundStyle(.foreground)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        FocusSetupView()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.foreground)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

