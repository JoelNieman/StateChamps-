//
//  ArticlesViewController.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/7/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import UIKit
import Social

class ArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ParseAPIOnResponseDelegate {

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var articlesTableView: UITableView!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    var retrievedArticles = [SCArticle]()
    var initialArticle = SCArticle()
    var selectedArticle: SCArticle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        segmentedControl.backgroundColor = sCGreyColor
        segmentedControl.tintColor = sCRedColor
        

        
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Selected)
        
        articlesTableView.rowHeight = 80
    }
    
    
    
    //  ParseApiCallProtocol set-up----------------------------------------------------
    
    //  Upon finishing the Parse query, retrievedArticles is populated with the SCArticles
    //  and the tableview is reloaded.
    

    func onArticlesResponse(articles: [SCArticle]) {
        retrievedArticles = articles
        articlesTableView.reloadData()

        if selectedArticle == nil {
            initialArticle = retrievedArticles[0]
            pictureView.image = initialArticle.thumbnailImage

        }
    }

    
    //  TableView set-up---------------------------------------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            return retrievedArticles.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SCArticleCell") as! CustomCell!
            
            let articleDetails = retrievedArticles[indexPath.row]
            cell.thumbnailOutlet.image = articleDetails.thumbnailImage
            cell.titleOutlet.text = articleDetails.title as String
            cell.dateOutlet.text = articleDetails.publishedDate as String
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FullSCArticleCell") as! CustomCell!
            
            
            if let article = selectedArticle {
                
                cell.fullArticleTitleOutelt.text = article.title
                cell.fullArticleAuthorOutlet.text = article.author
                cell.fullArticleDateOutlet.text = article.publishedDate
                cell.fullArticleBodyOutlet.text = article.body
                
                return cell
                
            } else {
                let article = initialArticle
                
                cell.fullArticleTitleOutelt.text = article.title
                cell.fullArticleAuthorOutlet.text = article.author
                cell.fullArticleDateOutlet.text = article.publishedDate
                cell.fullArticleBodyOutlet.text = article.body
                return cell
            }
        }
    }
    
    
    //  Facebook and Twitter Sharing----------------------------------------------------
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction] {
        if segmentedControl.selectedSegmentIndex == 0 {
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
                    
//                    facebookComposer.setInitialText("Read this article and more on the new State Champs! iPhone app!")
//                    facebookComposer.addImage(articleDetails.thumbnailImage)
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
            
        } else {
            let noAction = UITableViewRowAction()
            return [noAction]
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
        selectedArticle = retrievedArticles[indexPath.row]
        pictureView.image = selectedArticle!.thumbnailImage
        }
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
        
        
        let refreshParseApiCall = ParseAPICall(handler: self)
        refreshParseApiCall.queryParseForArticles()
        
        self.articlesTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    //  Segmented Control--------------------------------------------------------------
    
    @IBAction func segmentedControlPressed(sender: AnyObject) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            articlesTableView.estimatedRowHeight = 80
            articlesTableView.rowHeight = 80
            articlesTableView.allowsSelection = true
            articlesTableView.reloadData()
            scrollToTop()
            

        } else {
            
            articlesTableView.estimatedRowHeight = 1000
            articlesTableView.rowHeight = UITableViewAutomaticDimension
            
            articlesTableView.allowsSelection = false
            articlesTableView.reloadData()
            scrollToTop()
            
        }
    }

    
    func scrollToTop() {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.articlesTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
    }

}

