//
//  FullArticleViewController.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/11/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import UIKit

class FullArticleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var fullArticleTableView: UITableView!
    
    var fullSCArticle = SCArticle()

    override func viewDidLoad() {
        super.viewDidLoad()
        formatTableCell()
        fullArticleTableView.reloadData()
        print(fullSCArticle.title)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        fullArticleTableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FullSCArticleCell") as! CustomCell!
        
        let articleDetails = fullSCArticle
        
        cell.fullArticleTitleOutlet.text = articleDetails.title
        cell.fullArticleAuthorOutlet.text = articleDetails.author
        cell.fullArticleDateOutlet.text = articleDetails.publishedDate
        cell.fullArticleImageOutlet.image = articleDetails.thumbnailImage
        cell.fullArticleBodyOutlet.text = articleDetails.body
        
        return cell
    }
    
    func formatTableCell() {
        fullArticleTableView.estimatedRowHeight = 3000
        fullArticleTableView.rowHeight = UITableViewAutomaticDimension
        
        fullArticleTableView.allowsSelection = false
    }
}
