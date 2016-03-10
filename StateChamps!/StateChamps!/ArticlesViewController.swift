//
//  ArticlesViewController.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/7/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ParseAPIOnResponseDelegate {

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var articlesTableView: UITableView!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    var retrievedArticles = [SCArticle]()
    var initialArticle = SCArticle()
    
    
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

        initialArticle = retrievedArticles[0]
        pictureView.image = initialArticle.thumbnailImage
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
        cell.articleDateOutlet.text = articleDetails.publishedDate as String

        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedArticle = retrievedArticles[indexPath.row]
        pictureView.image = selectedArticle.thumbnailImage
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
        
//        let refreshApiCall = YouTubeAPICall(handler: self)
//        refreshApiCall.fetchAllVideos()
        
        let refreshParseApiCall = ParseAPICall(handler: self)
        refreshParseApiCall.queryParseForArticles()
        
        self.articlesTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    


}
