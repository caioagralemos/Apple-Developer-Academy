//
//  ContentView.swift
//  Tests
//
//  Created by Caio on 14/10/25.
//

import SwiftUI
import FoundationModels
import VisionKit
import SceneKit

struct BookScanView: View {
    @State var currentBook: BookInfo?
    @State var bookScan: String = ""
    @State var showModal: Bool = false
    @State var bookGenerator: BookGenerator?
    @State var isGenerating: Bool = false
    @State var noFind: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Image("openbook")
                    .resizable()
                    .frame(width: 200, height: 100)
                    .padding()
                
                if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                    Button {
                        showModal.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.black)
                            .frame(width: 200, height: 50)
                            .overlay {
                                Group {
                                    if isGenerating {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Text("Open Camera")
                                            .font(.title2)
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                    }.disabled(isGenerating)
                } else {
                    Text("Book Scanning not supported.")
                }
    
            }.sheet(isPresented: $showModal) {
                PhotoTextScanner(text: $bookScan)
            }
            .task {
                let generator = BookGenerator(bookScan)
                self.bookGenerator = generator
                bookGenerator?.prewarmModel()
            }
            .onChange(of: bookScan) {
                withAnimation {
                    isGenerating = true
                }
                guard bookScan.isEmpty == false else { return }
                Task {
                    self.bookGenerator?.text = self.bookScan
                    await bookGenerator?.generateInfo()
                    if let book = bookGenerator?.book, book.title.isEmpty == false {
                        withAnimation {
                            self.currentBook = book
                        }
                    } else {
                        
                    }
                    isGenerating = false
                }
            }
            
            if let book = currentBook {
                Color.black
                    .background(.ultraThickMaterial)
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            currentBook = nil
                        }
                    }
                
                FoundBookModal(book: book)
            }
        }
    }
}

#Preview {
    BookScanView()
}

