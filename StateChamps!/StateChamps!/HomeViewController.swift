//
//  HomeViewController.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/4/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import UIKit
import YouTubePlayer
//import Parse


class HomeViewController: UIViewController {

    @IBOutlet weak var header: UIView!
    @IBOutlet var playerView: YouTubePlayerView!
    
    let myVideoURL = NSURL(string: "https://www.youtube.com/watch?v=wQg3bXrVLtg")
    var playerState = YouTubePlayerState(rawValue: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatViewController()
        loadVideo()
        fetchShowVideos()

    }
    
    override func viewWillDisappear(animated: Bool) {
        playerView.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //  This sets up the video. The values (0 or 1) change the properties of the video player
    
    func loadVideo() {
        playerView.playerVars = [
            "playsinline": "1",
            "controls": "1",
            "showinfo": "0"
        ]
        playerView.loadVideoURL(myVideoURL!)
    }
    

}

