//
//  ViewController2.swift
//  Player
//
//  Created by SHAYANUL HAQ SADI on 12/3/23.
//

import UIKit
import AVFoundation
import AVKit
import AVPlayerViewControllerSubtitles


class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Player in Controller"

        self.addPlayer()
    }

    func addPlayer() {
        guard let url = URL(string: "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_50mb.mp4") else { return }
        
        let subtitleRemoteUrl = URL(string: "https://raw.githubusercontent.com/furkanhatipoglu/AVPlayerViewController-Subtitles/master/Example/AVPlayerViewController-Subtitles/trailer_720p.srt")
        
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        let playerFrame = CGRect(x: 0, y: 300, width: view.frame.width, height: 300)
        playerViewController.player = player
        player.rate = 1 //auto play
        playerViewController.view.frame = playerFrame

        // Add subtitles
        playerViewController.open(fileFromRemote: subtitleRemoteUrl!)
        playerViewController.addSubtitles()

//        playerViewController.addSubtitles().open(file: subtitleURL, encoding: String.Encoding.utf8)
        
        playerViewController.subtitleLabel?.textColor = UIColor.red


        
        addChild(playerViewController)
        view.addSubview(playerViewController.view)
        playerViewController.didMove(toParent: self)
    }

}
