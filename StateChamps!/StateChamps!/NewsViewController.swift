//
//  ArticlesViewController.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/7/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import UIKit
import Social

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


    
    var retrievedArticles = [SCArticle]()
    var selectedArticle: SCArticle?
    var articleShown = [Bool]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingWheel.startAnimating()
        
        formatViewController()
        formatArticlesViewController()
        
        let parseAPICall = ParseAPICall(handler: self)
        parseAPICall.queryParseForArticles()
        
        self.articlesTableView.addSubview(self.refreshControl)
    }

    override func viewWillAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func formatArticlesViewController() {
        formatViewController()
        spacerView.backgroundColor = sCRedColor
        articlesTableView.rowHeight = 80
        
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
        
        articleShown = [Bool](count: retrievedArticles.count, repeatedValue: false)
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
            cell.thumbnailOutlet.image = articleDetails.thumbnailImage
            cell.titleOutlet.text = articleDetails.title as String
            cell.dateOutlet.text = articleDetails.publishedDate as String
            return cell
            
          }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedArticle = retrievedArticles[indexPath.row]
        articlePreviewTitle.text = selectedArticle?.title
        articlePreviewBody.text = selectedArticle?.body
        
        articlePreviewTitle.hidden = false
        articlePreviewBody.hidden = false
        
        
        readMoreLabel.hidden = false
        imageView.hidden = true
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        if articleShown[indexPath.row] {
            return
        }
        
        articleShown[indexPath.row] = true
        

        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 500, 0)
        cell.layer.transform = rotationTransform
        
        UIView.animateWithDuration(0.2, animations: { cell.layer.transform = CATransform3DIdentity })
    }
    
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
                    tweetComposer.addImage(articleDetails.thumbnailImage)
                    tweetComposer.addURL(articleDetails.articleURL)
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
                    //  facebookComposer.addImage(articleDetails.thumbnailImage)
                    
                    facebookComposer.addURL(articleDetails.articleURL)
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
        
        let refreshParseApiCall = ParseAPICall(handler: self)
        refreshParseApiCall.queryParseForArticles()
        
        self.articlesTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    
    //  Managing location of user in tableView list.
    
    func scrollToTop() {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.articlesTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
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
            
            if let articleToPass = selectedArticle {
                destinationVC.fullSCArticle = articleToPass
            } else {
                destinationVC.fullSCArticle = retrievedArticles[0]
            }
        }
    }
}

