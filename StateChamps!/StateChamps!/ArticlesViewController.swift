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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func onArticlesResponse(articles: [SCArticle]) {
        retrievedArticles = articles
        articlesTableView.reloadData()

        initialArticle = retrievedArticles[0]
        pictureView.image = initialArticle.thumbnailImage

        
    }

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
    
    
    func formatArticlesViewController() {
        formatViewController()
        
        segmentedControl.backgroundColor = sCGreyColor
        segmentedControl.tintColor = sCRedColor
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Selected)
        
        articlesTableView.rowHeight = 80
    }

}
