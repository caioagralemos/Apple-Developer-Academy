//
//  FocusSetupView.swift
//  BookApp
//
//  Created by Alessandro Cacace on 21/10/25.
//

import SwiftUI
import VisionKit
import FamilyControls
import FoundationModels

struct FocusSetupView: View {
    
    @StateObject private var viewModel = FocusViewModel()
    @StateObject private var focusManager = FocusManager()
    
    
    @State private var dragAngle: Angle = .zero
    
    @State private var previousAngle: Angle = .zero
    
    @State var currentBook: Book?
    @State var bookScan: String = ""
    @State var showScanModal: Bool = false
    @State var showAddModal: Bool = false
    @State var bookGenerator: BookGenerator?
    @State var isGenerating: Bool = false
    @State var noFind: Bool = false
    @State var isScanning = false
    @State var isEditing = false
    @State var allSet = false
    @State var modelsAvailable: Bool = false
    
    let circleRadius: CGFloat = 150
    let knobRadius: CGFloat = 15
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if canUseScanFeature && currentBook == nil {
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    
                    ZStack {
                        
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                            .frame(width: circleRadius * 2.2, height: circleRadius * 2.2)
                        
                        
                        Circle()
                            .trim(from: 0, to: dragAngle.degrees / 360)
                            .stroke(.main, lineWidth: 8) // Progress color
                            .rotationEffect(.degrees(-90)) // Start from the top
                            .frame(width: circleRadius * 2.2, height: circleRadius * 2.2)
                        
                        
                        Text(viewModel.formattedTime)
                            .foregroundStyle(.main)
                            .font(.custom("EB Garamond", size: 75))
                            .fontWeight(.medium)
                            .padding(.bottom, 80)
                        
                        
                        HStack(spacing: 10) {
                            if let _ = currentBook {
                                Button {
                                    allSet = true
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundStyle(.main)
                                            .padding(.horizontal, 60)
                                            .padding(.vertical, 10)
                                            .frame(maxHeight: 80)
                                        
                                        Text("Start")
                                        .font(.custom("EB Garamond", size: 35))
                                        .fontWeight(.medium)
                                        .foregroundStyle(Color.second)
                                    }
                                }
                            } else if canUseScanFeature {
                                Button {
                                    isScanning = true
                                    showScanModal.toggle()
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundStyle(.main)
                                            .padding(.horizontal, 60)
                                            .padding(.vertical, 10)
                                            .frame(maxHeight: 80)
                                        
                                        if isScanning {
                                            ProgressView()
                                                .tint(.accentWhite)
                                        } else {
                                            Text("Scan")
                                            .font(.custom("EB Garamond", size: 35))
                                            .fontWeight(.medium)
                                            .foregroundStyle(Color.second)
                                        }
                                    }.opacity(isScanning ? 0.8 : 1)
                                }
                                .disabled(isScanning)
                            } else {
                                Button {
                                    showAddModal.toggle()
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundStyle(.main)
                                            .padding(.horizontal, 70)
                                            .padding(.vertical, 12)
                                            .frame(maxHeight: 80)
                                        
                                        Text("Add")
                                            .font(.custom("EB Garamond", size: 30))
                                            .fontWeight(.medium)
                                            .foregroundStyle(Color.second)
                                    }
                                }
                            }
                        }
                        .offset(y: 40)
                        
                        
                        
                        Circle()
                            .fill(.main)
                            .frame(width: knobRadius * 2.2, height: knobRadius * 2.2)
                        
                            .offset(x: circleRadius * 1.1 * cos(dragAngle.radians - .pi/2),
                                    y: circleRadius * 1.1 * sin(dragAngle.radians - .pi/2))
                        
                        
                        
                        Image("open_book")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 125*1.1)
                            .padding(.top, 300)
                        
                        

                        
                    }
                    .frame(width: circleRadius * 2.2, height: circleRadius * 2.2)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                
                                let vector = CGVector(dx: value.location.x - circleRadius,
                                                      dy: value.location.y - circleRadius)
                                let rawAngleRadians = atan2(vector.dy, vector.dx)
                                
                                var angleRadians = rawAngleRadians + CGFloat.pi/2
                                
                                if angleRadians < 0 {
                                    angleRadians += 2 * CGFloat.pi
                                }
                                
                                let currentAngle = Angle(radians: angleRadians)
                                
                                let delta = currentAngle.degrees - previousAngle.degrees
                                
                                if abs(delta) > 180 {
                                    
                                    if delta > 0 {
                                        dragAngle = Angle(degrees: 0)
                                    }
                                    
                                    else {
                                        dragAngle = Angle(degrees: 359.9)
                                    }
                                    
                                } else {
                                    dragAngle = currentAngle
                                }
                                
                                viewModel.updateTimeFromAngle(angle: dragAngle)
                                
                                
                                if abs(delta) <= 180 {
                                    previousAngle = currentAngle
                                }
                                
                            }
                            .onEnded { _ in
                                
                                previousAngle = dragAngle
                            }
                    )
                    
                    
                    .padding(.bottom, 100)
                    
                    if canUseScanFeature && currentBook == nil {
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    
                    if canUseScanFeature && currentBook == nil {
                        Button {
                            showAddModal = true
                            isEditing = false
                        } label: {
                            HStack {
                                Image(systemName: "book")
                                    .foregroundStyle(Color(.main))
                                    .fontWeight(.regular)
                                
                                Text("Add Manually")
                                    .foregroundStyle(Color(.main))
                                    .fontWeight(.regular)
                            }
                        }.padding(.bottom, 20)
                    }
                
                }.sheet(isPresented: $showScanModal, onDismiss: {
                    if bookScan.isEmpty {
                        isScanning = false
                    }
                }) {
                    PhotoTextScanner(text: $bookScan)
                }
                .sheet(isPresented: $showAddModal){
                    AddModalView(book: $currentBook, isEditing: $isEditing, allSet: $allSet)
                }
                .task {
                    let generator = BookGenerator(bookScan)
                    self.bookGenerator = generator
                    bookGenerator?.prewarmModel()
                    
                    focusManager.requestAuthorization()
                    
                    checkModelsAvailability()
                }
                
                .onChange(of: bookScan) {
                    withAnimation {
                        isGenerating = true
                    }
                    guard bookScan.isEmpty == false else { return }
                    Task {
                        self.bookGenerator?.text = self.bookScan
                        await bookGenerator?.generateInfo()
                        
                        if let error = bookGenerator?.error {
                            print("❌ BookGenerator error: \(error.localizedDescription)")
                            
                            modelsAvailable = false
                            
                            withAnimation {
                                isScanning = false
                                isGenerating = false
                            }
                        } else if let book = bookGenerator?.book, book.title.isEmpty == false {
                            withAnimation {
                                self.currentBook = book
                            }
                            isGenerating = false
                        } else {
                            print("⚠️ No book identified")
                            withAnimation {
                                isScanning = false
                                isGenerating = false
                            }
                        }
                    }
                }
                    .navigationDestination(isPresented: $allSet) {
                    FocusView(selectedTimeInSeconds: viewModel.timeInSeconds, currentBook: currentBook)
                }
               
                
                
                if currentBook != nil && isScanning {
                    Color.main
                        .background(.ultraThickMaterial)
                        .opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                isScanning = false
                                currentBook = nil
                            }
                        }
                    
                    FoundBookModal(book: currentBook!, isScanning: $isScanning, currentBook: $currentBook, allSet: $allSet, showAddModal: $showAddModal, isEditing: $isEditing)
                }
            }
        }
    }
    
    private var canUseScanFeature: Bool {
        guard DataScannerViewController.isSupported && 
              DataScannerViewController.isAvailable else {
            return false
        }
        
        guard #available(iOS 18.2, *) else {
            return false
        }
        
        return modelsAvailable
    }
    
    private func checkModelsAvailability() {
        guard #available(iOS 18.2, *) else {
            modelsAvailable = false
            print("❌ iOS < 18.2")
            return
        }
        
        let model = SystemLanguageModel.default
        modelsAvailable = model.isAvailable
        
        if modelsAvailable {
            print("✅ FoundationModels available")
        } else {
            print("❌ FoundationModels unavailable")
        }
    }
}
    


// Custom style for Scan/Add buttons
struct FocusButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("EB Garamond", size: 35))
            .fontWeight(.medium)
            .foregroundStyle(Color.accentWhite)
            .padding(.vertical, 5)
            .padding(.horizontal, 55)
            .background(Color.main)
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        
    }
}
    
    // Preview Provider
    struct FocusSetupView_Previews: PreviewProvider {
        static var previews: some View {
            FocusSetupView()
        }
    }
    
    

