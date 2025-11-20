//
//  SoundManager.swift
//  Rabisco
//
//  Created by Caio on 17/11/25.
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private var backgroundMusicPlayer: AVAudioPlayer?
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func play(_ sound: Sound) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else {
            print("Sound file not found: \(sound.rawValue)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
            audioPlayers[sound.rawValue] = player
        } catch {
            print("Failed to play sound: \(error)")
        }
    }
    
    func playBackgroundMusic(volume: Float = 0.3) {
        guard backgroundMusicPlayer?.isPlaying != true else { return }
        
        guard let url = Bundle.main.url(forResource: "music", withExtension: "mp3") else {
            print("Background music file not found: music.mp3")
            return
        }
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.volume = volume
            backgroundMusicPlayer?.prepareToPlay()
            backgroundMusicPlayer?.play()
        } catch {
            print("Failed to play background music: \(error)")
        }
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
    
    func pauseBackgroundMusic() {
        backgroundMusicPlayer?.pause()
    }
    
    func resumeBackgroundMusic() {
        backgroundMusicPlayer?.play()
    }
    
    func setBackgroundMusicVolume(_ volume: Float) {
        backgroundMusicPlayer?.volume = min(max(volume, 0.0), 1.0)
    }
}

enum Sound: String {
    case click = "click"
    case close = "close"
    case open = "open"
    case tada = "tada"
    case timesup = "timesup"
}
