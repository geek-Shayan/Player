//
//  ViewController.swift
//  Player
//
//  Created by SHAYANUL HAQ SADI on 11/29/23.
//

import UIKit
import AVKit
import AVFoundation
import AVPlayerViewControllerSubtitles


class ViewController: UIViewController {
    
    @IBOutlet private weak var nextButton: UIButton!
    
    @IBOutlet private weak var brightnessSlider: UISlider!
    @IBOutlet private weak var volumeSlider: UISlider!
    
    @IBOutlet private weak var playerView: UIView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    @IBOutlet private weak var seekBarSlider: UISlider!
    
    @IBOutlet private weak var ccButton: UIButton!
    @IBOutlet private weak var refreshButton: UIButton!
    @IBOutlet private weak var rewindButton: UIButton!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var fastForwardButton: UIButton!
    
    // MARK: Video URLs
//    private let videoURL = URL(string: "https://sample-videos.com/video123/mp4/480/big_buck_bunny_480p_20mb.mp4")
    private let videoURL = URL(string: "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_50mb.mp4")
    private let m3u8Url = URL(string: "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8")
    
    // MARK: Subtitle URLs
    private let subtitleRemoteUrl = URL(string: "https://raw.githubusercontent.com/furkanhatipoglu/AVPlayerViewController-Subtitles/master/Example/AVPlayerViewController-Subtitles/trailer_720p.srt")

    private var playerLayer = AVPlayerLayer()
    private var player = AVPlayer()
        
    private var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiatePlayerViewWithMP4()
        
//        initiatePlayerViewWithHLS()
        
        setupSeekBarSlider()
        
        initiateSubtitles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()

        brightnessSlider.value = Float(UIScreen.main.brightness)
        volumeSlider.value = AVAudioSession.sharedInstance().outputVolume
        
        print("volumeSlider   ", volumeSlider.value, "brightnessSlider  ", brightnessSlider.value)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = self.playerView.bounds
        playerView.layoutSublayers(of: playerLayer)
    }
    
    private func setupUI() {
        subtitleLabel.isHidden = true
        loader.startAnimating()
        timerLabel.text = ""
    }

    private func initiatePlayerViewWithMP4() {
        
        player = AVPlayer(url: videoURL!)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.playerView.bounds
        playerLayer.videoGravity = .resizeAspectFill

        self.playerView.layer.addSublayer(playerLayer)
        
        // Start observing the player's time periodically
        addPeriodicTimeObserver()
        
        loader.stopAnimating()
    }
    
    private func addPeriodicTimeObserver() {
        // Add observer to track player's current time
//        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 100), queue: DispatchQueue.main) { [self] time in
//            // Update UI with the current time
//            let currentTime = Int(CMTimeGetSeconds(time))
//            print("Current Time: \(currentTime) seconds")
//            seekBarSlider.value = Float(currentTime)
//
////            let subtitles = parser.searchSubtitles(at: 2.0) // Search subtitle at 2.0 seconds
//        }
        
        
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: Double(1), preferredTimescale: 2), queue: DispatchQueue.main) { [weak self] (sec) in
            guard let self = self else { return }
            let seconds = CMTimeGetSeconds(sec)
//            print("seconds  ", seconds)

            let (hours, minutes, second) = self.getHoursMinutesSecondsFrom(seconds: seconds)
            self.timerLabel.text = "\(hours):\(minutes):\(second)"
            self.seekBarSlider.value = Float(seconds)
        }
    }
    
    private func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        let secs = Int(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        return (hours, minutes, seconds)
    }
    
    private func initiatePlayerViewWithHLS() {
        
        if let url = m3u8Url {

//            let asset = AVAsset(url: url)
//            let playerItem = AVPlayerItem(asset: asset)
//
//            for characteristic in asset.availableMediaCharacteristicsWithMediaSelectionOptions {
//                if let group = asset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.audible) {
//                    if let option = group.options.first {
//                        playerItem.select(option, in: group)
//                    }
//                }
//            }

            let asset = AVAsset(url: url)
//            let asset = AVURLAsset(url: url, options: nil)
//            let duration = asset.durationx
            let playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: playerItem)

            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.playerView.bounds
            playerLayer.videoGravity = .resizeAspectFill
            self.playerView.layer.addSublayer(playerLayer)

            isPlaying = true
            player.playImmediately(atRate: 1)
//            player.play()
            
        }
    }

    private func setupSeekBarSlider() {
        seekBarSlider.value = 0.0
//        seekBarSlider.minimumValue = 0.0
//        seekBarSlider.maximumValue = 90.0
//        seekBarSlider.maximumValue = player.currentItem?.duration
//        let duration  = player.currentItem?.duration.seconds
//        seekBarSlider.maximumValue = Float(duration)

//        print("duration  ", duration)
        
//        if videoPlayer = player {
            seekBarSlider.minimumValue = 0.0
            if let duration = player.currentItem?.asset.duration {
                let seconds = CMTimeGetSeconds(duration)
                print(seconds,"  duration  ", duration)
                seekBarSlider.maximumValue = Float(seconds)
//                seekBarSlider.isHidden = false
            }
//        } else {
//            seekBarSlider.isHidden = true
//        }
    }
    
    private func initiateSubtitles() {
        // MARK: Subtitle from separate .srt
        
        let playerTimeline = player.currentTime().value
        
        do {
            let parser = try Subtitles(file: subtitleRemoteUrl!, encoding: .utf8)
            // Do something with result
            let subtitles = parser.searchSubtitles(at: 2.0) // Search subtitle at 2.0 seconds
            
//            print("subtitles  ",subtitles)
            print("playerTimeline  ",playerTimeline)
            print("TimeInterval  ",TimeInterval(playerTimeline))
            subtitleLabel.text = subtitles
        }
        catch {
            print("error")
            subtitleLabel.text = "subtitles error ..."
        }
    }
    
    @IBAction func adjustBrightness(_ sender: Any) {
        print("adjustBrightness")
        UIScreen.main.brightness = CGFloat(brightnessSlider.value)
    }
    
    @IBAction func adjustVolume(_ sender: Any) {
        print("adjustVolume")
        player.volume = volumeSlider.value
    }
    
    @IBAction func seekBarMoved(_ sender: Any) {
        print("seekBarMoved")
        
//        if isPlaying {
//            player.pause()
//        }

        let selectedTime: CMTime = CMTimeMake(value: Int64(seekBarSlider.value) * 1000, timescale: 1000)
        
        player.seek(to: selectedTime)
        
//        if isPlaying {
//            player.play()
//        }
    }
    
    @IBAction func subtitlesPressed(_ sender: Any) {
        print("subtitlesPressed")
        subtitleLabel.isHidden = !subtitleLabel.isHidden
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        print("refreshPressed")
        player.seek(to: .zero)
    }
    
    @IBAction func rewindPressed(_ sender: Any) {
        print("rewindPressed")
        
        let moveBackword: Float64 = 5
        
        let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
        print("playerCurrentTime  ", playerCurrentTime)
        
        var newTime = playerCurrentTime - moveBackword
        if newTime < 0 {
            newTime = 0
        }
        
//        player.pause()
        
        let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        
        player.seek(to: selectedTime)
        
        print("selectedTime  ", selectedTime)
        
//        player.play()
    }
    
    @IBAction func pausePressed(_ sender: Any) {
        print("pausePressed")
        if isPlaying {
            player.pause()
            isPlaying = !isPlaying
            playButton.isEnabled = true
            pauseButton.isEnabled = false
        }
    }
    
    @IBAction func playPressed(_ sender: Any) {
        print("playPressed")
        if !isPlaying {
            player.play()
            isPlaying = !isPlaying
            pauseButton.isEnabled = true
            playButton.isEnabled = false
        }
    }
    
    @IBAction func fastForwardPressed(_ sender: Any) {
        print("fastForwardPressed")
        
        let moveForword : Float64 = 5
        
        if let duration  = player.currentItem?.duration {
            let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
            print("playerCurrentTime  ", playerCurrentTime)

            let newTime = playerCurrentTime + moveForword
            if newTime < CMTimeGetSeconds(duration)
            {
                let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
                player.seek(to: selectedTime)
                print("selectedTime  ", selectedTime)

            }
//            player.pause()
//            player.play()
        }

    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        print("nextButtonPressed")
        
        if isPlaying {
            player.pause()
            isPlaying = !isPlaying
            playButton.isEnabled = true
            pauseButton.isEnabled = false
        }
        
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController4") as? ViewController4 {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController2") as? ViewController2 {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController3") as? ViewController3 {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

