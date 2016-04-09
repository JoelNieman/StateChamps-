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
import Parse

class VideosViewController: UIViewController , YouTubeAPIOnResponseDelegate, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var showVideosTableView: UITableView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var playerView: YouTubePlayerView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var loadingWheel: UIActivityIndicatorView!
    
    var youTubeApiCall: YouTubeAPICall?
    
    var initialVideo: SCVideo?
    var selectedSCVideo: SCVideo?
    var videoDetails: SCVideo?
    var retrievedShowVideos = [SCVideo]()
    var retrievedHighlightVideos = [SCVideo]()
    
    var showVideoShown = [Bool]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatVideosViewController()
        
        loadingWheel.startAnimating()
        
        youTubeApiCall = YouTubeAPICall(handler: self)
        youTubeApiCall!.fetchAllVideos()
        
        self.showVideosTableView.addSubview(self.refreshControl)
        
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        if playerView.playerState.rawValue == "1" {
            playerView.pause()
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
//        if let currentVideo = selectedSCVideo {
//            playerView.loadVideoID(currentVideo.videoID)
//        }
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
        
        showVideosTableView.rowHeight = 94
        showVideosTableView.userInteractionEnabled = false
        
    }
    
    
    //  YouTubeApiCallProtocol set-up----------------------------------------------------
    
    //  Upon finishing the YouTubeAPI call, showVideos is populated with the SCVideos
    //  and the tableview is reloaded.

    
    func onShowVideosResponse(showVideos: [SCVideo]) {
        retrievedShowVideos = showVideos
        showVideosTableView.reloadData()

        showVideoShown = [Bool](count: retrievedShowVideos.count, repeatedValue: false)
        
        if segmentedControl.selectedSegmentIndex == 0 {
            selectedSCVideo = retrievedShowVideos[0]
        } else {
            selectedSCVideo = retrievedHighlightVideos[0]
        }
        
        playerView.playerVars = [
            "playsinline": "1",
            "controls": "1",
            "showinfo": "0"
        ]
        
        playerView.hidden = false
        
        if playerView.playerState.rawValue != "1" {
            playerView.loadVideoID(selectedSCVideo!.videoID)
        }
        
        showVideosTableView.userInteractionEnabled = true
        loadingWheel.stopAnimating()

    }
    
    
    func onHighlightVideosResponse(highlightVideos: [SCVideo]) {
        retrievedHighlightVideos = highlightVideos
        segmentedControl.enabled = true
        loadingWheel.stopAnimating()
        showVideosTableView.userInteractionEnabled = true
        loadingWheel.stopAnimating()
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
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            if showVideoShown[indexPath.row] {
                return
            }
            
            showVideoShown[indexPath.row] = true
            
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -200, 500, 0)
            cell.layer.transform = rotationTransform
            
            UIView.animateWithDuration(0.3, animations: { cell.layer.transform = CATransform3DIdentity })
            
        }
    }
    
    //  Facebook and Twitter Sharing----------------------------------------------------
    
        func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
            if segmentedControl.selectedSegmentIndex == 0 {
            let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Share", handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
                
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
//                    var completionHandler: SLComposeViewControllerCompletionHandler!
                    
                    self.videoDetails = self.retrievedShowVideos[indexPath.row]
                        tweetComposer.setInitialText("Watch this video and more on the new State Champs! iPhone app!")
                        tweetComposer.addImage(self.videoDetails!.thumbnailImage)
                        tweetComposer.addURL(NSURL(string: "https://youtu.be/\(self.videoDetails!.videoID)PL8dd-D6tYC0DfIJarU3NrrTHvPmMkCjTd"))
                    
                        //  Record sharing activities by posting details to Parse
                        tweetComposer.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                            switch result {
                            case SLComposeViewControllerResult.Cancelled:
                                break
                            case SLComposeViewControllerResult.Done:
                                let sharedObject = PFObject(className: "Social")
                                sharedObject["Title"] = self.videoDetails!.title
                                sharedObject["Outlet"] = "Twitter"
                                sharedObject["MediaType"] = "Video - Episode"
                                sharedObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                                }
                            }
                        }
                    
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
                    
                    self.videoDetails = self.retrievedShowVideos[indexPath.row]
                    
                    facebookComposer.setInitialText("\(self.videoDetails!.title)\n\n Watch this video and more on the new State Champs! iPhone app!")
                    facebookComposer.addImage(self.videoDetails!.thumbnailImage)
                    facebookComposer.addURL(NSURL(string: "https://youtu.be/\(self.videoDetails!.videoID)PL8dd-D6tYC0DfIJarU3NrrTHvPmMkCjTd"))
                    
                    //  Record sharing activities by posting details to Parse
                    facebookComposer.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                        switch result {
                        case SLComposeViewControllerResult.Cancelled:
                            break
                        case SLComposeViewControllerResult.Done:
                            let sharedObject = PFObject(className: "Social")
                            sharedObject["Title"] = self.videoDetails!.title
                            sharedObject["Outlet"] = "Facebook"
                            sharedObject["MediaType"] = "Video - Episode"
                            sharedObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                            }
                        }
                    }
                    
                    
                    
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
                
            } else {
                let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Share", handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
                    
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
                        

                        self.videoDetails = self.retrievedHighlightVideos[indexPath.row]

                        
                        tweetComposer.setInitialText("Watch this video and more on the new State Champs! iPhone app!")
                        tweetComposer.addImage(self.videoDetails!.thumbnailImage)
                        tweetComposer.addURL(NSURL(string: "https://youtu.be/\(self.videoDetails!.videoID)PL8dd-D6tYC0DfIJarU3NrrTHvPmMkCjTd"))
                        
                        //  Record sharing activities by posting details to Parse
                        tweetComposer.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                            switch result {
                            case SLComposeViewControllerResult.Cancelled:
                                break
                            case SLComposeViewControllerResult.Done:
                                let sharedObject = PFObject(className: "Social")
                                sharedObject["Title"] = self.videoDetails!.title
                                sharedObject["Outlet"] = "Twitter"
                                sharedObject["MediaType"] = "Video - Highlight"
                                sharedObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                                }
                            }
                        }
                        
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

                        

                        self.videoDetails = self.retrievedHighlightVideos[indexPath.row]
                        facebookComposer.setInitialText(String("\(self.videoDetails!.title)\n\n Watch this video and more on the new State Champs! iPhone app!"))
                        facebookComposer.addImage(self.videoDetails!.thumbnailImage)
                        facebookComposer.addURL(NSURL(string: "https://youtu.be/\(self.videoDetails!.videoID)PL8dd-D6tYC0DfIJarU3NrrTHvPmMkCjTd"))
                        
                        //  Record sharing activities by posting details to Parse
                        facebookComposer.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                            switch result {
                            case SLComposeViewControllerResult.Cancelled:
                                break
                            case SLComposeViewControllerResult.Done:
                                let sharedObject = PFObject(className: "Social")
                                sharedObject["Title"] = self.videoDetails!.title
                                sharedObject["Outlet"] = "Facebook"
                                sharedObject["MediaType"] = "Video - Highlight"
                                sharedObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                                }
                            }
                        }
                        
                        
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
        }
    
    
    //  Pull To Refresh----------------------------------------------------------------
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            youTubeApiCall!.showVideosArray.removeAll()
            youTubeApiCall!.fetchShowVideos()
            showVideosTableView.userInteractionEnabled = false
        } else {
            youTubeApiCall!.highlightVideosArray.removeAll()
            youTubeApiCall!.fetchHighlightVideos()
            showVideosTableView.userInteractionEnabled = false
        }
        
        loadingWheel.startAnimating()
        self.showVideosTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    //  Segmented Control--------------------------------------------------------------
    
    
    @IBAction func segmentedControlPressed(sender: AnyObject) {
        showVideosTableView.reloadData()
        scrollToTop()
    }
    
    //  Managing location of user in tableView list.
    
    func scrollToTop() {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.showVideosTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
    }

    
}




