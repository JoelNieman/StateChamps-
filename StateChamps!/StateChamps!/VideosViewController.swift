//
//  VideosViewController.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/5/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideosViewController: UIViewController {
    
    @IBOutlet weak var header: UIView!
    @IBOutlet var playerView: YouTubePlayerView!
    
    let myVideoURL = NSURL(string: "https://www.youtube.com/watch?v=wQg3bXrVLtg")
    var showVideosArray: Array<Dictionary<NSObject, AnyObject>> = []
    var highlightVideosArray: Array<Dictionary<NSObject, AnyObject>> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatViewController()
        loadVideo()
        getPlaylistVideos()
    }
    
    func loadVideo() {
        playerView.playerVars = [
            "playsinline": "1",
            "controls": "1",
            "showinfo": "0"
        ]
        playerView.loadVideoURL(myVideoURL!)
    }
}
