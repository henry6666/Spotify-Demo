//
//  AudioVC.swift
//  Spotify Demo
//
//  Created by Henry Aguinaga on 2016-12-26.
//  Copyright © 2016 Henry Aguinaga. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AudioVC: UIViewController {
    
    var image = UIImage()
    var mainSongTitle = String()
    var mainPreviewURl = String()
    
    @IBOutlet weak var playPauseBtn: UIButton!
    
    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songTitle.text = mainSongTitle
        background.image = image
        mainImageView.image = image
        
        downloadFileFronURL(url: URL(string: mainPreviewURl)!)
        
        playPauseBtn.setTitle("Pause", for: UIControlState.normal)
        
    }
    
    
    func downloadFileFronURL(url: URL) {
        var downloadTask = URLSessionDownloadTask()
        
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
        
            customURL, response, error in
            
            self.play(url: customURL!)
            
        })
        
        downloadTask.resume()
        
    }
    
    func play(url: URL) {

        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        
        } catch {
            print(error)
        
        }
        
    }
    
    @IBAction func pausePlay(_ sender: UIButton) {
        
        if player.isPlaying {
            player.pause()
            playPauseBtn.setTitle("Play", for: UIControlState.normal)
        
        } else {
            player.play()
            playPauseBtn.setTitle("Pause", for: UIControlState.normal)
        }
    }
    
}







