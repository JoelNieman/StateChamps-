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
    @IBOutlet weak var articlePreview: UIView!

    
    
    var retrievedArticles = [SCArticle]()
    
    
    
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

//        myVideoID = retrievedShowVideos[0].videoID
//        descriptionOutlet.text = showVideos[0].description
        
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
        cell.articleTitleOutlet.text = articleDetails.title as String
        cell.articleDateOutlet.text = articleDetails.publishedDate as String
        cell.articleThumbnailOutlet.image = articleDetails.thumbnailImage

        return cell
        
    }
    
    func formatArticlesViewController() {
        formatViewController()
        articlesTableView.rowHeight = 80
    }
}
