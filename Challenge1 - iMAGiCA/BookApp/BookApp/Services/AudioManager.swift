//
//  AudioManager.swift
//  BookApp
//
//  Created by Alessandro Cacace on 21/10/25.
//

import Foundation
import AVFoundation
import Combine // Import Combine for ObservableObject

class AudioManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    @Published var isMuted: Bool = false {
        didSet {
            audioPlayer?.volume = isMuted ? 0 : 1
        }
    }
    // Track the currently loaded sound file name
    private var currentSoundFileName: String?

    init(soundFileName: String, soundFileType: String) {
        configureAudioSession()
        // Load the initial sound
        loadSound(fileName: soundFileName, fileType: soundFileType)
    }

    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            // It's generally better to activate the session right before playing
            // try audioSession.setActive(true)
            print("✅ Audio session configured for background playback")
        } catch {
            print("❌ Failed to configure audio session: \(error.localizedDescription)")
        }
    }

    // --- HELPER FUNCTION TO LOAD SOUND ---
    // This logic is now reusable
    private func loadSound(fileName: String, fileType: String) {
        // Avoid reloading if the sound is already loaded
        guard fileName != currentSoundFileName else {
            print("ℹ️ Sound '\(fileName)' already loaded.")
            return
        }

        guard let soundURL = Bundle.main.url(forResource: fileName, withExtension: fileType) else {
            print("❌ Error: Audio file '\(fileName).\(fileType)' not found in bundle.")
            // Stop playback if the new file isn't found
            audioPlayer?.stop()
            audioPlayer = nil
            currentSoundFileName = nil
            return
        }

        do {
            // Stop current playback before loading new sound
            audioPlayer?.stop()

            // Initialize the new audio player
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.prepareToPlay() // Prepare for playback
            audioPlayer?.volume = isMuted ? 0 : 1 // Apply current mute state
            currentSoundFileName = fileName // Update the tracking variable
            print("✅ Audio player loaded successfully for: \(fileName).\(fileType)")
        } catch {
            print("❌ Error loading audio file '\(fileName)': \(error.localizedDescription)")
            audioPlayer = nil
            currentSoundFileName = nil
        }
    }
    // --- END HELPER FUNCTION ---

    func play() {
        // Activate session right before playing
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("❌ Failed to activate audio session: \(error)")
            // Don't try to play if session activation failed
            return
        }

        if audioPlayer?.isPlaying == false {
            audioPlayer?.play()
            print("▶️ Audio playing '\(currentSoundFileName ?? "unknown")'...")
        }
    }

    func stop() {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0 // Rewind to start
            print("⏹️ Audio stopped.")
        }
        // Optionally deactivate the audio session when stopping
        // do {
        //     try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        // } catch {
        //     print("❌ Failed to deactivate audio session: \(error)")
        // }
    }

    func toggleMute() {
        isMuted.toggle()
        print(isMuted ? "🔇 Audio muted." : "🔊 Audio unmuted.")
    }

    // --- NEW PUBLIC FUNCTION ---
    /// Changes the currently playing sound file.
    /// - Parameters:
    ///   - newSoundFileName: The name of the new sound file (without extension).
    ///   - fileType: The file extension (e.g., "mp3", "wav"). Defaults to "mp3".
    func changeSound(newSoundFileName: String, fileType: String = "mp3") {
        print("🔄 Attempting to change sound to: \(newSoundFileName).\(fileType)")
        // Load the new sound using the helper function
        loadSound(fileName: newSoundFileName, fileType: fileType)
        // Automatically play the new sound if the player was successfully loaded
        if audioPlayer != nil {
            play()
        }
    }
    // --- END NEW FUNCTION ---
}
