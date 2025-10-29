//
//  FocusView.swift
//  BookApp
//
//  Created by Alessandro Cacace on 21/10/25.
//

import SwiftUI
import FamilyControls
internal import AVFAudio

struct FocusView: View {
    let selectedTimeInSeconds: Int
    let currentBook: Book?
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var timerViewModel: TimerViewModel
    @StateObject var liveActivityViewModel: SessionActivityViewModel
    @StateObject private var focusManager = FocusManager()
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var environmentviewModel = EnvironmentViewModel()
    @StateObject private var audioManager: AudioManager
    
    
    @State private var showingSettings = false
    @State private var showingAppPicker = false
    @State private var currentSession: ReadingSession?
    @State private var currentEnvironment: EnvironmentModel = EnvironmentViewModel().environments.first ?? EnvironmentModel(emoji: "❓", name: .custom) 
    
    @Environment(\.scenePhase) private var scenePhase
    
    init(selectedTimeInSeconds: Int, currentBook: Book? = nil) {
        self.selectedTimeInSeconds = selectedTimeInSeconds
        self.currentBook = currentBook
        _timerViewModel = StateObject(wrappedValue: TimerViewModel(initialSeconds: selectedTimeInSeconds))
        _liveActivityViewModel = StateObject(wrappedValue: SessionActivityViewModel(durationInSeconds: selectedTimeInSeconds, bookName: currentBook?.title ?? "Title", bookAuthor: currentBook?.author ?? "Author"))

        let initialsoundFileName: String
        
        initialsoundFileName = currentBook?.genre.fileName ?? "default"
        
        _audioManager = StateObject(wrappedValue: AudioManager(soundFileName: initialsoundFileName, soundFileType: "mp3"))
            
        }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Layer 1: Looping Video Background
                LoopingVideoPlayerView(videoName: determineVideoName(), videoType: "mp4")
                    .id(determineVideoName())
                    .ignoresSafeArea() // Extend video to screen edges
                
                // Layer 2: Optional Dark Overlay
                Color.black.opacity(0.3) // Adjust opacity as needed
                    .ignoresSafeArea()
                
                // Layer 3: Main UI Content
                VStack {
                    Spacer()
                    Spacer() // Adjust spacing by adding/removing spacers
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()


                    VStack(spacing: 15) {
                        Text(timerViewModel.formattedTime)
                            .font(.system(size: 48, weight: .bold)) // Use monospaced design
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 50)
                    .background(.ultraThinMaterial, in: Capsule())
                    .shadow(radius: 10)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text(timerViewModel.timerState == .running ? "Stop" : "Resume")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                
                    Spacer()
                } // End Main VStack
            } // End ZStack
            .onAppear {
                // Start playing audio when the view appears
                audioManager.play()
                
                // Create reading session if book is available
                if let book = currentBook {
                    currentSession = dataManager.createReadingSession(
                        for: book,
                        focusTimeInSeconds: selectedTimeInSeconds,
                        completed: false
                    )
                    print("📖 Started reading session for: \(book.title)")
                }
                
                // Configure callback for when timer finishes
                timerViewModel.onTimerFinished = {
                    // Complete the reading session
                    if let sessionId = currentSession?.id {
                        dataManager.updateSessionCompletion(sessionId, completed: true)
                        print("✅ Reading session completed!")
                    }
                    
                    // Stop focus session if active
                    focusManager.stopFocusSession()
                    audioManager.stop()
                    
                    // Return to previous screen automatically
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        dismiss()
                    }
                }
                
                timerViewModel.startOrResume(viewModel: liveActivityViewModel)
                
                // Request authorization and load saved selection
                focusManager.requestAuthorization()
                
                // Wait a bit for selection to load, then start session
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let hasApps = !focusManager.activitySelection.applicationTokens.isEmpty
                    let hasCategories = !focusManager.activitySelection.categoryTokens.isEmpty
                    let hasWebDomains = !focusManager.activitySelection.webDomainTokens.isEmpty
                    
                    if hasApps || hasCategories || hasWebDomains {
                        let durationInMinutes = selectedTimeInSeconds / 60
                        focusManager.startFocusSession(durationInMinutes: durationInMinutes)
                    }
                }
            }
            .onAppear {
                audioManager.audioPlayer?.volume = 0.4
                liveActivityViewModel.startLiveActivity()
            }
            .onDisappear {
                // Stop playing audio when the view disappears
                audioManager.stop()
                timerViewModel.pause()

                // End/disable Live Activity when leaving FocusView
                // If the timer finished, mark the activity completed; otherwise, treat as canceled
                if timerViewModel.timerState == .finished {
                    liveActivityViewModel.endLiveActivity(success: true)
                } else {
                    liveActivityViewModel.endLiveActivity(success: false)
                }

                // Handle incomplete reading session
                if let _ = currentSession?.id, timerViewModel.timerState != .finished {
                    // Calculate actual time spent (initial time - remaining time)
                    let actualTimeSpent = selectedTimeInSeconds - timerViewModel.remainingSeconds

                    // Create a new session with the actual time spent
                    if let book = currentBook, actualTimeSpent > 0 {
                        let _ = dataManager.createReadingSession(
                            for: book,
                            focusTimeInSeconds: actualTimeSpent,
                            completed: false
                        )
                        print("📖 Saved partial reading session: \(actualTimeSpent)s")
                    }
                }

                // Stop focus session if active
                let hasApps = !focusManager.activitySelection.applicationTokens.isEmpty
                let hasCategories = !focusManager.activitySelection.categoryTokens.isEmpty
                let hasWebDomains = !focusManager.activitySelection.webDomainTokens.isEmpty

                if hasApps || hasCategories || hasWebDomains {
                    focusManager.stopFocusSession()
                }
            }
            // Present the SettingsView as a modal sheet
            .sheet(isPresented: $showingSettings) {
                // The content of the modal sheet
                EnvironmentSettingsView(viewModel: environmentviewModel,temporaryEnvironment: currentEnvironment, currentenvironment: $currentEnvironment)// Use a specific view for the modal content
            }
            .onChange(of: currentEnvironment) { oldValue, newValue in
                            audioManager.changeSound(newSoundFileName: determineVideoName())
                        }
            .familyActivityPicker(
                isPresented: $showingAppPicker,
                selection: $focusManager.activitySelection
            )
                        .onChange(of: focusManager.activitySelection) { oldValue, newValue in
                let hasApps = !newValue.applicationTokens.isEmpty
                let hasCategories = !newValue.categoryTokens.isEmpty
                let hasWebDomains = !newValue.webDomainTokens.isEmpty
                
                if hasApps || hasCategories || hasWebDomains {
                    let durationInMinutes = selectedTimeInSeconds / 60
                    focusManager.startFocusSession(durationInMinutes: durationInMinutes)
                }
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                switch newPhase {
                case .background:
                    print("📱 App went to background - timer and audio continue running")
                    // Timer and audio continue running automatically
                case .inactive:
                    print("📱 App became inactive")
                case .active:
                    print("📱 App became active")
                    // Reactivate audio session if necessary
                    if timerViewModel.timerState == .running && !audioManager.isMuted {
                        audioManager.play()
                    }
                @unknown default:
                    break
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    Button {
                        showingSettings = true // Set state to true to present the sheet
                    } label: {
                        Image(systemName: "gearshape.fill")
                        
                            .foregroundColor(.white)
                    }
                    
                }
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    
                    Button {
                        audioManager.toggleMute()
                    } label: {
                        Image(systemName: audioManager.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        
                            .foregroundColor(.white)
                    }
                    
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .statusBarHidden()
        }
    }
    
    private func determineVideoName() -> String {
           if currentEnvironment.name == .custom {
               return currentBook?.genre.fileName ?? "default"
           } else {
               return currentEnvironment.name.rawValue
           }
       }
}
    
    #Preview {
        FocusView(
            selectedTimeInSeconds: 5,
            currentBook: Book.exampleBook
        )
    }

