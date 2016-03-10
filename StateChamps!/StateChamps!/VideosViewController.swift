//
//  HomeViewController.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/4/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import UIKit
import YouTubePlayer
import Social

class VideosViewController: UIViewController , YouTubeAPIOnResponseDelegate, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var showVideosTableView: UITableView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var playerView: YouTubePlayerView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var initialVideoID: String?
    var selectedSCVideo: SCVideo?
    var retrievedShowVideos = [SCVideo]()
    var retrievedHighlightVideos = [SCVideo]()
    
    
    
    
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatVideosViewController()
        
        let apiCall = YouTubeAPICall(handler: self)
        apiCall.fetchAllVideos()
        
        self.showVideosTableView.addSubview(self.refreshControl)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        playerView.pause()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        if let currentVideo = selectedSCVideo {
            playerView.loadVideoID(currentVideo.videoID)
        } else {
            if initialVideoID != nil {
                playerView.loadVideoID(initialVideoID!)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func formatVideosViewController() {
        formatViewController()
        
        segmentedControl.backgroundColor = sCGreyColor
        segmentedControl.tintColor = sCRedColor
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Selected)
        
        showVideosTableView.rowHeight = 80
        
        
        
    }
    
    
    //  YouTubeApiCallProtocol set-up----------------------------------------------------
    
    //  Upon finishing the YouTubeAPI call, showVideos is populated with the SCVideos
    //  and the tableview is reloaded.

    
    func onShowVideosResponse(showVideos: [SCVideo]) {
        retrievedShowVideos = showVideos
        showVideosTableView.reloadData()

        initialVideoID = retrievedShowVideos[0].videoID
        
        playerView.playerVars = [
            "playsinline": "1",
            "controls": "1",
            "showinfo": "0"
        ]
        
        if selectedSCVideo == nil {
            playerView.loadVideoID(initialVideoID!)
        }
    }
    
    
    func onHighlightVideosResponse(highlightVideos: [SCVideo]) {
        retrievedHighlightVideos = highlightVideos
    }
    
    
    //  TableView set-up---------------------------------------------------------------

    
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
            
            let sCVideoDetails = retrievedShowVideos[indexPath.row]
            cell.titleOutlet.text = sCVideoDetails.title as String
            cell.thumbnailOutlet.image = sCVideoDetails.thumbnailImage
            
            return cell
            
        } else {
            
            let sCVideoDetails = retrievedHighlightVideos[indexPath.row]
            cell.titleOutlet.text = sCVideoDetails.title as String
            cell.thumbnailOutlet.image = sCVideoDetails.thumbnailImage
            
            return cell
        }
    }
 
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if segmentedControl.selectedSegmentIndex == 0 {
            selectedSCVideo = retrievedShowVideos[indexPath.row]
            playerView.loadVideoID(selectedSCVideo!.videoID)

        } else {
            selectedSCVideo = retrievedHighlightVideos[indexPath.row]
            playerView.loadVideoID(selectedSCVideo!.videoID)
        }
    }
    
    
    //  Facebook and Twitter Sharing----------------------------------------------------
    
        func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction] {
            
            let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share", handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
                
                let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .ActionSheet)
                
                let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    
                    //  Check if Twitter is available, otherwise display an error message
                    
                    guard
                        SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) else {
                            let alertMessage = UIAlertController(title: "Twitter Unavailable", message: "You haven't registered your Twitter account. Please go to Settings > Twitter to create one.", preferredStyle: .Alert)
                            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                            self.presentViewController(alertMessage, animated: true, completion: nil)
                            
                            return
                    }
                    
                    // Display Tweet Composer
                    let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                        
                        let videoDetails = self.selectedSCVideo!
                        tweetComposer.setInitialText(videoDetails.title as String)
                        tweetComposer.addImage(videoDetails.thumbnailImage)
                        tweetComposer.addURL(NSURL(string: "https://youtu.be/\(videoDetails.videoID)PL8dd-D6tYC0DfIJarU3NrrTHvPmMkCjTd"))
                        self.presentViewController(tweetComposer, animated: true, completion: nil)
            
                })
                
                
                let facebookAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    
                    //  Check if Facebook is available, otherwise display an error message
                    guard
                        SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) else {
                            let alertMessage = UIAlertController(title: "Facebook Unavailable", message: "You haven't registered your Facebook account. Please go to Settings > Facebook to create one.", preferredStyle: .Alert)
                            alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                            self.presentViewController(alertMessage, animated: true, completion: nil)
                            
                            return
                    }
                    
                    
                    
                    //  Display Facebook Composer
                    let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    
                    let videoDetails = self.selectedSCVideo!
                    facebookComposer.setInitialText(videoDetails.title as String)
                    facebookComposer.addImage(videoDetails.thumbnailImage)
                    facebookComposer.addURL(NSURL(string: "https://youtu.be/\(videoDetails.videoID)PL8dd-D6tYC0DfIJarU3NrrTHvPmMkCjTd"))
                    self.presentViewController(facebookComposer, animated: true, completion: nil)
                    
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
                
                shareMenu.addAction(facebookAction)
                shareMenu.addAction(twitterAction)
                shareMenu.addAction(cancelAction)
                
                self.presentViewController(shareMenu, animated: true, completion: nil)
                }
            )
            
            return [shareAction]
        }
    
    
    
    //  Pull To Refresh----------------------------------------------------------------
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        let refreshApiCall = YouTubeAPICall(handler: self)
        refreshApiCall.fetchAllVideos()
        
        self.showVideosTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    //  Segmented Control--------------------------------------------------------------
    
    
    @IBAction func segmentedControlPressed(sender: AnyObject) {
        showVideosTableView.reloadData()
    }
    
}




