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


class VideosViewController: UIViewController , YouTubeAPIOnResponseDelegate, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet var showVideosTableView: UITableView!
    @IBOutlet weak var header: UIView!
    @IBOutlet var playerView: YouTubePlayerView!
    @IBOutlet weak var descriptionOutlet: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var myVideoID: String?
    var retrievedShowVideos = [SCVideo]()
    var retrievedHighlightVideos = [SCVideo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatVideosViewController()
        let apiCall = YouTubeAPICall(handler: self)
        apiCall.fetchAllVideos()

        
    }
    
    override func viewWillDisappear(animated: Bool) {
        playerView.pause()
        
//        switch playerView.playerState {
//        case Playing:
//            playerView.pause()
//        default:
//            break
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //  Upon finishing the YouTubeAPI call, showVideos is populated with the SCVideos
    //  and the tableview is reloaded.
    
    
    
    
    func onShowVideosResponse(showVideos: [SCVideo]) {
        retrievedShowVideos = showVideos
        showVideosTableView.reloadData()

        myVideoID = retrievedShowVideos[0].videoID
        descriptionOutlet.text = showVideos[0].description
        
        playerView.playerVars = [
            "playsinline": "1",
            "controls": "1",
            "showinfo": "0"
        ]
        playerView.loadVideoID(myVideoID!)
    }
    
    func onHighlightVideosResponse(highlightVideos: [SCVideo]) {
        retrievedHighlightVideos = highlightVideos
    }
    
    
    
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            return retrievedShowVideos.count
        } else {
            return retrievedHighlightVideos.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SCVideoCell") as! CustomCell!
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            let videoDetails = retrievedShowVideos[indexPath.row]
            cell.titleOutlet.text = videoDetails.title as String
            cell.thumbnailOutlet.image = videoDetails.thumbnailImage
            
            return cell
            
        } else {
            
            let videoDetails = retrievedHighlightVideos[indexPath.row]
            cell.titleOutlet.text = videoDetails.title as String
            cell.thumbnailOutlet.image = videoDetails.thumbnailImage
            
            return cell
        }
        
    }
 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let selectedVideo = retrievedShowVideos[indexPath.row]
            playerView.loadVideoID(selectedVideo.videoID)
            descriptionOutlet.text = selectedVideo.description
        } else {
            let selectedVideo = retrievedHighlightVideos[indexPath.row]
            playerView.loadVideoID(selectedVideo.videoID)
            descriptionOutlet.text = selectedVideo.description
        }
    }
    @IBAction func segmentedControlPressed(sender: AnyObject) {
        showVideosTableView.reloadData()
    }
    
    
    func formatVideosViewController() {
        formatViewController()
        
        segmentedControl.backgroundColor = sCGreyColor
        segmentedControl.tintColor = sCRedColor
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Selected)
        
        showVideosTableView.rowHeight = 80
    }
}




