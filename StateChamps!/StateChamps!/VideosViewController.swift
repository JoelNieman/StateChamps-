//
//  VideosViewController.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/5/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var header: UIView!
    @IBOutlet var playerView: YouTubePlayerView!
    @IBOutlet var videoTableView: UITableView!
    
    let myVideoURL = NSURL(string: "https://www.youtube.com/watch?v=wQg3bXrVLtg")
//    var showVideosArray = [SCVideo]()
    var highlightVideosArray = [SCVideo]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatViewController()
        loadVideo()
        print("the showVideosArray is: \n\n\(showVideosArray)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        playerView.stop()
    }
    
    func loadVideo() {
        playerView.playerVars = [
            "playsinline": "1",
            "controls": "1",
            "showinfo": "0"
        ]
        playerView.loadVideoURL(myVideoURL!)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showVideosArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        let videoDetails = showVideosArray[indexPath.row]
        cell.textLabel?.text = videoDetails.title as? String
        return cell
    }
}
