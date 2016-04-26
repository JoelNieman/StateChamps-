//
//  ArticlesViewController.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/7/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import UIKit
import Social
import Parse

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ParseAPIOnResponseDelegate {

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var articlesTableView: UITableView!
    @IBOutlet weak var spacerView: UIView!
    @IBOutlet weak var readMoreLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var articlePreviewTitle: UILabel!
    @IBOutlet weak var articlePreviewBody: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingWheel: UIActivityIndicatorView!

    var parseAPICall: ParseAPICall?
    var retrievedArticles = [SCArticle]()
    var selectedArticle: SCArticle?
    var selectedArticleInt: Int?
    var selectedArticleIndex: NSIndexPath?
    var articleShown = [Bool]()
    var rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -200, 500, 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NSLog("viewDidLoad called")
        
        loadingWheel.startAnimating()
        
        formatViewController()
        formatArticlesViewController()
        
        parseAPICall = ParseAPICall(handler: self)
        parseAPICall!.queryParseForArticles()
        
        self.articlesTableView.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        if selectedArticleInt != nil {
            selectedArticle = retrievedArticles[selectedArticleInt!]
            articlePreviewTitle.text = selectedArticle!.title
            articlePreviewBody.text = selectedArticle!.body
            scrollToSelectedArticle()
            stopAnimations()
            
            if (selectedArticleInt != 0) {
            articlesTableView.selectRowAtIndexPath(selectedArticleIndex!, animated: false, scrollPosition: UITableViewScrollPosition.Top)
            }
            
            
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func formatArticlesViewController() {
        formatViewController()
        spacerView.backgroundColor = sCRedColor
        articlesTableView.rowHeight = 94
        
        
        if selectedArticle == nil {
            articlePreviewTitle.hidden = true
            articlePreviewBody.hidden = true
        }
    }
    
    
    
    //  ParseApiCallProtocol set-up----------------------------------------------------
    
    //  Upon finishing the Parse query, retrievedArticles is populated with the SCArticles
    //  and the tableview is reloaded.
    

    func onArticlesResponse(articles: [SCArticle]) {
        retrievedArticles = articles
        articlesTableView.reloadData()

        selectedArticle = retrievedArticles[0]
            
        articlePreviewTitle.text = selectedArticle!.title
        articlePreviewBody.text = selectedArticle!.body
        loadingWheel.stopAnimating()
        
//        articleShown = [Bool](count: retrievedArticles.count, repeatedValue: false)
        
        articlesTableView.userInteractionEnabled = true
        articlePreviewTitle.hidden = true
        articlePreviewBody.hidden = true
        readMoreLabel.hidden = true
        imageView.hidden = false
        
//        NSLog("onArticlesResponse called")
    }
    

    
    //  TableView set-up---------------------------------------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retrievedArticles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SCArticleCell") as! CustomCell!
            
        let articleDetails = retrievedArticles[indexPath.row]
        cell.thumbnailOutlet.image = articleDetails.pictureImage
        cell.titleOutlet.text = articleDetails.title as String
        cell.dateOutlet.text = articleDetails.publishedDate as String
        
        
        if articleDetails.pictureFile != nil {
            articleDetails.pictureFile!.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    let image = UIImage(data: imageData!)
                    cell.thumbnailOutlet.image = image
                    self.retrievedArticles[indexPath.row].pictureImage = image
                        }
                    })
                } else {
                    cell.thumbnailOutlet.image = articleDetails.pictureImage
            }
        return cell
        }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedArticle = retrievedArticles[indexPath.row]
        selectedArticleInt = indexPath.row
        print(selectedArticleInt)
        
        articlePreviewTitle.text = selectedArticle?.title
        articlePreviewBody.text = selectedArticle?.body
        
        articlePreviewTitle.hidden = false
        articlePreviewBody.hidden = false
        
        readMoreLabel.hidden = false
        imageView.hidden = true
        
        selectedArticleIndex = NSIndexPath(forRow: selectedArticleInt!, inSection: 0)
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//        
//        
//        if articleShown[indexPath.row] {
//            return
//        }
//        
//        articleShown[indexPath.row] = true
//        
////        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -200, 500, 0)
////        Made a global variable of this constant but keeping it here for later reference
//        cell.layer.transform = rotationTransform
//        UIView.animateWithDuration(0.3, animations: { cell.layer.transform = CATransform3DIdentity })
//    }
    
    //  Facebook and Twitter Sharing----------------------------------------------------
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
            
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

                    let articleDetails = self.retrievedArticles[indexPath.row]
                    tweetComposer.setInitialText("Read this article and more on the new State Champs! iPhone app!")
                    tweetComposer.addImage(articleDetails.pictureImage)
                    tweetComposer.addURL(articleDetails.articleURL)
                    
                    //  Record sharing activities by posting details to Parse
                    tweetComposer.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                        switch result {
                        case SLComposeViewControllerResult.Cancelled:
                            break
                        case SLComposeViewControllerResult.Done:
                            let sharedObject = PFObject(className: "Social")
                            sharedObject["Title"] = articleDetails.title
                            sharedObject["Outlet"] = "Twitter"
                            sharedObject["MediaType"] = "Article"
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
                    
                    

                    let articleDetails = self.retrievedArticles[indexPath.row]
                    
                    //  Set initial text for facebook has been disabled due to FB policy.
                    //  facebookComposer.setInitialText("Read this article and more on the new State Champs! iPhone app!")
                    //  facebookComposer.addImage(articleDetails.pictureImage)
                    
                    facebookComposer.addURL(articleDetails.articleURL)
                    
                    //  Record sharing activities by posting details to Parse
                    facebookComposer.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                        switch result {
                        case SLComposeViewControllerResult.Cancelled:
                            break
                        case SLComposeViewControllerResult.Done:
                            let sharedObject = PFObject(className: "Social")
                            sharedObject["Title"] = articleDetails.title
                            sharedObject["Outlet"] = "Facebook"
                            sharedObject["MediaType"] = "Article"
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
    
            })
            
            return [shareAction]
    }
    
    
    
    //  Pull To Refresh----------------------------------------------------------------
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        

        articlesTableView.userInteractionEnabled = false
        parseAPICall!.articles.removeAll()
        self.parseAPICall!.queryParseForArticles()
        self.articlesTableView.reloadData()
        loadingWheel.startAnimating()
        stopAnimations()
        
        selectedArticleInt = 0
        selectedArticleIndex = NSIndexPath(forRow: selectedArticleInt!, inSection: 0)
        articlesTableView.deselectRowAtIndexPath(selectedArticleIndex!, animated: false)
        
        refreshControl.endRefreshing()
    }

    
    
    //  Segue between articles list and full articles---------------------------------------------------
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }
    
    @IBAction func readMoreButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("segueToFullArticle", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToFullArticle" {
            let destinationVC = segue.destinationViewController as! FullArticleViewController
            
                destinationVC.passedArticles = retrievedArticles
                destinationVC.currentArticleIndex = selectedArticleInt
        }
    }
    
    func scrollToSelectedArticle() {
        let indexPath = NSIndexPath(forRow: selectedArticleInt!, inSection: 0)
        self.articlesTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
    }
    
    func stopAnimations() {
        rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 0)
    }
}

