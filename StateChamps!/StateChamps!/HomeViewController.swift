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


class HomeViewController: UIViewController , APIOnResponseDelegate, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet var showVideosTableView: UITableView!
    @IBOutlet weak var header: UIView!
    @IBOutlet var playerView: YouTubePlayerView!
    
    var myVideoID: String?
    var showVideos = [SCVideo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatViewController()
//        loadVideo()
        let apiCall = YouTubeAPICall(handler: self)
        apiCall.fetchShowVideos()
        
        
        
        showVideosTableView.rowHeight = 80
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        playerView.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //  This sets up the video. The values (0 or 1) change the properties of the video player
    
//    func loadVideo() {
//        playerView.playerVars = [
//            "playsinline": "1",
//            "controls": "1",
//            "showinfo": "0"
//        ]
//        playerView.loadVideoID(myVideoID!)
//    }
    
    //  Upon finishing the YouTubeAPI call, showVideos is populated witht the SCVideos
    //  and the tableview is reloaded.
    
    func onResponse(SCVideos: [SCVideo]) {
        showVideos = SCVideos
        showVideosTableView.reloadData()
        
        myVideoID = showVideos[0].videoID
        playerView.playerVars = [
            "playsinline": "1",
            "controls": "1",
            "showinfo": "0"
        ]
        playerView.loadVideoID(myVideoID!)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showVideos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SCVideoCell") as! VideoCell!
        
        let videoDetails = showVideos[indexPath.row]
        cell.titleOutlet.text = videoDetails.title as String
        cell.thumbnailOutlet.image = videoDetails.thumbnailImage
        
        return cell
    }
    
}

