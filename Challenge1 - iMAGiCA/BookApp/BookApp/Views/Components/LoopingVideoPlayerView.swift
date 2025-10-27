//
//  LoopingVideoPlayerView.swift
//  BookApp
//
//  Created by Alessandro Cacace on 21/10/25.
//

import SwiftUI
import AVKit // Import AVKit for video playback

struct LoopingVideoPlayerView: UIViewRepresentable {
    let videoName: String
    let videoType: String

    // Creates the underlying UIKit view
    func makeUIView(context: Context) -> UIView {
        // Use a helper class for cleaner implementation
        return LoopingPlayerUIView(videoName: videoName, videoType: videoType, frame: .zero)
    }

    // Updates the view if SwiftUI state changes (not needed here)
    func updateUIView(_ uiView: UIView, context: Context) {
        // No updates needed for this simple looping player
    }
}

// Helper UIKit View to manage the AVPlayerLooper
class LoopingPlayerUIView: UIView {
    private var playerLooper: AVPlayerLooper?
    private var playerLayer = AVPlayerLayer()
    private var queuePlayer: AVQueuePlayer? // Store the player

    init(videoName: String, videoType: String, frame: CGRect) {
        super.init(frame: frame)

        // Find the URL for the video file in the app bundle
        guard let fileUrl = Bundle.main.url(forResource: videoName, withExtension: videoType) else {
            print("❌ Error: Video file '\(videoName).\(videoType)' not found in bundle.")
            return
        }

        // Setup player item and queue player
        let asset = AVURLAsset(url: fileUrl)
        let item = AVPlayerItem(asset: asset)
        let player = AVQueuePlayer(playerItem: item) // Use AVQueuePlayer

        // Store the player instance
        self.queuePlayer = player

        // Configure the player layer
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill // Cover the entire view area
        layer.addSublayer(playerLayer)

        // Create the looper object
        playerLooper = AVPlayerLooper(player: player, templateItem: item)

        // Mute the video to prevent interfering with background audio
        player.isMuted = true
        
        // Start playback
        player.play()
        print("✅ Video player initialized and playing: \(videoName).\(videoType)")
    }

    // Required initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Ensure the video layer resizes with the view
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
