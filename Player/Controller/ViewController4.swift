//
//  ViewController4.swift
//  Player
//
//  Created by SHAYANUL HAQ SADI on 12/4/23.
//

import UIKit
import AVFoundation
import AVKit

class ViewController4: UIViewController {
    
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
        
//    private let m3u8Url =  "https://iptv-isp.nexdecade.com/vod/shorts/clip/1.mp4/playlist.m3u8"
//    private let m3u8Url =  "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"

    private let m3u8Url =  "https://bitmovin-a.akamaihd.net/content/sintel/hls/playlist.m3u8" //4
//    private let m3u8Url =  "https://res.cloudinary.com/triggerz-eu-cld/raw/upload/v1613557055/HabitDrivers_for_Teams-subtitile-test.m3u8" //1
//    private let m3u8Url =  "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8" //0
//    private let m3u8Url =  "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8" //0

    private let subtitleRemoteUrl = URL(string: "https://raw.githubusercontent.com/furkanhatipoglu/AVPlayerViewController-Subtitles/master/Example/AVPlayerViewController-Subtitles/trailer_720p.srt")
    
    private let playerViewController = AVPlayerViewController()
    
    private var videoPlayer: AVPlayer?
    
    private var isPlaying = false
    
    var subtitles: [Subtitle] = [] 
    
    var selectedSubtitle: Subtitle? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
        
        startPlayer()
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
        
        if !subtitles.isEmpty {
            self.ccButton.isHidden = false
        } else {
            self.ccButton.isHidden = true
        }
    }
    
    private func setupUI() {
        subtitleLabel.isHidden = true
        loader.startAnimating()

        ccButton.tintColor = .systemGray
        
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let player = object as? AVPlayer, player == videoPlayer, keyPath == "status" {
            if player.status == .readyToPlay {
//                videoPlayer?.play()
                // visible button
            } else if player.status == .failed {
//                stopBtnPressed(UIButton())
            }
        }
    }
    
    private func startPlayer() {
//        slider.isHidden = true
        if let url = URL(string: m3u8Url) {
            let asset = AVURLAsset(url: url, options: nil)
            let playerItem = AVPlayerItem(asset: asset)
            videoPlayer = AVPlayer(playerItem: playerItem)
            videoPlayer?.addObserver(self, forKeyPath: "status", options: [], context: nil)
            
            
//            let playerViewController = AVPlayerViewController()
//            let playerFrame = CGRect(x: 0, y: 300, width: view.frame.width, height: 300)
            let playerFrame = playerView.bounds
            playerViewController.player = videoPlayer
//            playerViewController.videoGravity = .resizeAspectFill
//            videoPlayer.rate = 1 //auto play
            playerViewController.view.frame = playerFrame

//            // Add subtitles
//            playerViewController.open(fileFromRemote: subtitleRemoteUrl!)
//            playerViewController.addSubtitles()
//            playerViewController.subtitleLabel?.textColor = UIColor.red
//
        parseSub()

            addChild(playerViewController)
            playerView.addSubview(playerViewController.view)
            playerViewController.didMove(toParent: self)
            
            
            
            // listen the current time of playing video
            videoPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: Double(1), preferredTimescale: 2), queue: DispatchQueue.main) { [weak self] (sec) in
                guard let self = self else { return }
                let seconds = CMTimeGetSeconds(sec)
                let (hours, minutes, second) = self.getHoursMinutesSecondsFrom(seconds: seconds)
                self.timerLabel.text = "\(hours):\(minutes):\(second)"
//                self.slider.value = Float(seconds)
                self.seekBarSlider.value = Float(seconds)
            }
//            videoPlayer?.volume = 1.0
            
//            let layer: AVPlayerLayer = AVPlayerLayer(player: videoPlayer)
//            layer.backgroundColor = UIColor.white.cgColor
//            layer.frame = playerView.bounds
//            layer.videoGravity = .resizeAspectFill
//            playerView.layer.sublayers?
//                .filter { $0 is AVPlayerLayer }
//                .forEach { $0.removeFromSuperlayer() }
//            playerView.layer.addSublayer(layer)
            
            
//            videoPlayer?.play()
        }
//        parseSub()
        initSlider()
        loader.stopAnimating()

    }
    
    private func initSlider() {
        if let videoPlayer = videoPlayer {
            seekBarSlider.minimumValue = 0.0
            if let duration = videoPlayer.currentItem?.asset.duration {
                let seconds = CMTimeGetSeconds(duration)
                seekBarSlider.maximumValue = Float(seconds)
                seekBarSlider.isHidden = false
            }
        } else {
            seekBarSlider.isHidden = true
        }
    }
    
    private func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        let secs = Int(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        return (hours, minutes, seconds)
    }
    
    private func parseSub() {
        
        let m3u8URL = URL(string: self.m3u8Url)!
        parseM3U8Subtitles(from: m3u8URL) { subtitles in
            print("Subtitles:")
            self.subtitles = subtitles
            
//            self.showCC = true
            

//            // Add subtitles
//            self.playerViewController.open(fileFromRemote: self.subtitles[0].url)
//            //            self.playerViewController.open(fileFromRemote: subtitleRemoteUrl!)
//            self.playerViewController.addSubtitles()
//            self.playerViewController.subtitleLabel?.textColor = UIColor.red

            for subtitle in subtitles {
                print("Language: \(subtitle.language), URL: \(subtitle.url)")
            }
        }
        
    }
    
    @IBAction private func adjustBrightness(_ sender: Any) {
        print("adjustBrightness")
        UIScreen.main.brightness = CGFloat(brightnessSlider.value)
    }
    
    @IBAction private func adjustVolume(_ sender: Any) {
        print("adjustVolume")
        videoPlayer?.volume = volumeSlider.value
    }
    
    @IBAction private func seekBarMoved(_ sender: Any) {
        print("seekBarMoved")
        let selectedTime: CMTime = CMTimeMake(value: Int64(Float64(seekBarSlider.value) * 1000 as Float64), timescale: 1000)
        
        videoPlayer?.seek(to: selectedTime)
    }
    
    @IBAction private func subtitlesPressed(_ sender: Any) {
        print("subtitlesPressed")
        subtitleLabel.isHidden = !subtitleLabel.isHidden

        
        if let vc = ViewControllerPopUp.initVC(with: subtitles) {
            vc.modalPresentationStyle = .overCurrentContext
//            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            
            vc.onSelection = { subtitle in
                self.selectedSubtitle = subtitle
                
                self.ccButton.tintColor = .systemBlue
                
                // Add subtitles
                self.playerViewController.open(fileFromRemote: self.selectedSubtitle!.url)
                
                self.playerViewController.addSubtitles()
                self.playerViewController.subtitleLabel?.textColor = UIColor.green
                self.playerViewController.subtitleLabel?.font = UIFont(name: "System", size: 6)
            }
            
            
            vc.onDeSelection = {
                self.selectedSubtitle = nil
                
                self.ccButton.tintColor = .systemGray
                self.playerViewController.subtitleLabel?.textColor = .clear
            }
            present(vc, animated: true)
                        
        }
        
        
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewControllerPopUp") as? ViewControllerPopUp {
//            vc.modalPresentationStyle = .overCurrentContext
////            if let sheet = vc.sheetPresentationController {
////                sheet.detents = [.medium(), .large()]
////                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
////                //            sheet.largestUndimmedDetentIdentifier = .medium
////                sheet.prefersGrabberVisible = true
////            }
//            present(vc, animated: true)
//        }
    }
    
    @IBAction private func refreshPressed(_ sender: Any) {
        print("refreshPressed")
        videoPlayer?.seek(to: .zero)
    }
    
    @IBAction private func rewindPressed(_ sender: Any) {
        print("rewindPressed")
        
        let moveBackword: Float64 = 5
        
        let playerCurrentTime = CMTimeGetSeconds(videoPlayer!.currentTime())
        print("playerCurrentTime  ", playerCurrentTime)
        
        var newTime = playerCurrentTime - moveBackword
        if newTime < 0 {
            newTime = 0
        }
        
//        player.pause()
        
        let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        
        videoPlayer?.seek(to: selectedTime)
        
        print("selectedTime  ", selectedTime)
        
//        player.play()
    }
    
    @IBAction private func pausePressed(_ sender: Any) {
        print("pausePressed")
        if isPlaying {
            videoPlayer?.pause()
            isPlaying = !isPlaying
            playButton.isEnabled = true
            pauseButton.isEnabled = false
        }
    }
    
    @IBAction private func playPressed(_ sender: Any) {
        print("playPressed")
        if !isPlaying {
            videoPlayer?.play()
            isPlaying = !isPlaying
            pauseButton.isEnabled = true
            playButton.isEnabled = false
        }
    }
    
    @IBAction private func fastForwardPressed(_ sender: Any) {
        print("fastForwardPressed")
        
        let moveForword : Float64 = 5
        
        if let duration  = videoPlayer?.currentItem?.duration {
            let playerCurrentTime = CMTimeGetSeconds(videoPlayer!.currentTime())
            print("playerCurrentTime  ", playerCurrentTime)
            let newTime = playerCurrentTime + moveForword
            if newTime < CMTimeGetSeconds(duration)
            {
                let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
                videoPlayer?.seek(to: selectedTime)
                print("selectedTime  ", selectedTime)
            }
//            player.pause()
//            player.play()
        }
    }
    
    @IBAction private func nextButtonPressed(_ sender: Any) {
        print("nextButtonPressed")
        
        if isPlaying {
            videoPlayer?.pause()
            isPlaying = !isPlaying
            playButton.isEnabled = true
            pauseButton.isEnabled = false
        }
        
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController4") as? ViewController4 {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController2") as? ViewController2 {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController3") as? ViewController3 {
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        
    }
    
}


//extension ViewController4: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return subtitles.count + 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubtitlesTableViewCell.identifier, for: indexPath) as? SubtitlesTableViewCell else { return UITableViewCell() }
//        if indexPath.row == 0 {
//            cell.subtitleLabel.text = "Off"
//        } else {
//            cell.subtitleLabel.text = subtitles[indexPath.row - 1].language
//        }
//        return cell
//    }
//
//}


//extension ViewController4: UITableViewDelegate {
//    func calculateHeightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
//            // Implement your logic to calculate the height based on content
//            // You may need to measure the height of your text, images, etc.
////            return calculatedHeight
//        return CGFloat( subtitles.count * 10)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        return calculateHeightForRowAtIndexPath(indexPath)
//        return 30
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if let cell = tableView.cellForRow(at: indexPath) as? SubtitlesTableViewCell {
//
//            cell.setSelected(true, animated: true)
//
////            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
//
//            if indexPath.row == 0 {
//                selectedSubtitle = nil
//                print("selected ", indexPath.row, selectedSubtitle )
//
//                self.playerViewController.subtitleLabel?.textColor = .clear
//                ccButton.tintColor = .systemGray
//
//
//            } else if indexPath.row == 1 {
//                selectedSubtitle = subtitles[indexPath.row - 1]
//                print("selected ", indexPath.row, selectedSubtitle )
//                ccButton.tintColor = .systemBlue
//
//                // Add subtitles
//                self.playerViewController.open(fileFromRemote: self.selectedSubtitle!.url)
//
//                self.playerViewController.addSubtitles()
//                self.playerViewController.subtitleLabel?.textColor = UIColor.white
//                self.playerViewController.subtitleLabel?.font = UIFont(name: "System", size: 6)
//            } else {
//                selectedSubtitle = subtitles[indexPath.row - 1]
//                print("selected ", indexPath.row, selectedSubtitle )
//                ccButton.tintColor = .systemBlue
//
//                // Add subtitles
//                self.playerViewController.open(fileFromRemote: self.selectedSubtitle!.url)
//
//                self.playerViewController.addSubtitles()
//                self.playerViewController.subtitleLabel?.textColor = UIColor.red
//                self.playerViewController.subtitleLabel?.font = UIFont(name: "System", size: 6)
//            }
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                self.subtitleLabel.isHidden = true
//            }
//        }
//
//
//    }
//}


extension ViewController4 {

    func parseM3U8Subtitles(from url: URL, completion: @escaping ([Subtitle]) -> Void) {
        // Create a URLSession instance
        let session = URLSession(configuration: .default)

        // Create a data task to fetch the M3U8 file
        let task = session.dataTask(with: url) { (data, response, error) in
            // Check for errors
            guard error == nil, let data = data else {
                print("Error fetching M3U8 file:", error?.localizedDescription ?? "Unknown error")
                return
            }

            // Convert data to a string
            if let m3u8String = String(data: data, encoding: .utf8) {
                // Parse the subtitles using regular expressions
                let subtitles = self.parseSubtitles(from: m3u8String)

                // Call the completion handler with the extracted subtitles
                completion(subtitles)
            }
        }

        // Start the data task
        task.resume()
    }


    // Function to parse subtitles from an M3U8 string using regular expressions
    func parseSubtitles(from m3u8String: String) -> [Subtitle] {
//        var subtitles: [Subtitle] = []

        // Define a regular expression pattern to match subtitle lines in the M3U8 file
        let pattern = #"(#EXT-X-MEDIA:TYPE=SUBTITLES.*,LANGUAGE="([^"]*)",URI="([^"]*)")"#

        // Create a regular expression object
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            print("Error creating regular expression")
            return subtitles
        }

        // Find matches in the M3U8 string
        let matches = regex.matches(in: m3u8String, options: [], range: NSRange(location: 0, length: m3u8String.utf16.count))
        

        // Extract information from the matches
        for match in matches {
            // Extract language and URL from the match
            if let languageRange = Range(match.range(at: 2), in: m3u8String), let urlRange = Range(match.range(at: 3), in: m3u8String) {
                let language = String(m3u8String[languageRange])
                let urlString = String(m3u8String[urlRange])
                if let url = URL(string: urlString) {
                    let subtitle = Subtitle(language: language, url: url)
                    subtitles.append(subtitle)
//                    ccButton.isHidden = false
                }
            }
            else {
                print(" error. no subtitles found! ")
            }
        }
        
        let url = URL(string: "https://raw.githubusercontent.com/furkanhatipoglu/AVPlayerViewController-Subtitles/master/Example/AVPlayerViewController-Subtitles/trailer_720p.srt")
        subtitles.append(Subtitle(language: "lang", url: url!))
        subtitles.append(Subtitle(language: "lang1", url: url!))
        subtitles.append(Subtitle(language: "lang2", url: url!))
        subtitles.append(Subtitle(language: "lang3", url: url!))
        subtitles.append(Subtitle(language: "lang4", url: url!))
        subtitles.append(Subtitle(language: "lang5", url: url!))
        

//        if subtitles.count > 0 {
//            ccButton.isHidden = false
//        }
        
        return subtitles
    }

//    // Example usage
//    let m3u8URL = URL(string: "https://example.com/yourfile.m3u8")!
//    parseM3U8Subtitles(from: m3u8URL) { subtitles in
//        print("Subtitles:")
//        for subtitle in subtitles {
//            print("Language: \(subtitle.language), URL: \(subtitle.url)")
//        }
//    }
}


//extension UIViewController {
//
//    func presentBottomSheetInsideNavigationController(viewController: UIViewController, configuration: BottomSheetConfiguration) {
//        let navigationController = BottomSheetNavigationController(rootViewController: viewController, configuration: configuration)
//        presentBottomSheet(viewController: navigationController, configuration: configuration)
//    }
//
//    func dismisModal() {
//        self.dismiss(animated: true)
//    }
//}





//    func parseManifest(manifestString: String) -> String {
//        let pattern = #"#EXTINF:\d+\.\d+,\n(.*)\n#"#
//        let regex = try! NSRegularExpression(pattern: pattern)
//
//        let matches = regex.matches(in: manifestString, range: NSRange(location: 0, length: manifestString.utf16.count))
//
//        var subtitleFile = String()
//
//        for match in matches {
//            let range = match.range(at: 1)
//            subtitleFile = (manifestString as NSString).substring(with: range)
//            //            print("Subtitle file: \(subtitleFile)")
//        }
//        return subtitleFile
//    }
//
//    func substringBeforeLastSlash(link: String) -> String {
//        if let lastSlashIndex = link.range(of: "/", options: .backwards)?.upperBound {
//            return String(link[..<lastSlashIndex])
//        } else {
//            return ""
//        }
//    }
//
//    func checkURL(_ url: URL) -> String {
//        let path = url.path
//        if path.contains(".m3u8") {
//            return ".m3u8 file"
//        } else if path.contains(".vtt") {
//            return ".vtt file"
//        } else if path.contains(".srt") {
//            return ".srt file"
//        } else {
//            return "None of the required file types found"
//        }
//    }
