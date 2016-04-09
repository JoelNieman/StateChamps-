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
    
    var currentArticleIndex:Int?
    var passedArticles = [SCArticle]()
    
    var fullSCArticle = SCArticle()

    override func viewDidLoad() {
        super.viewDidLoad()
        formatTableCell()
        fullArticleTableView.reloadData()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(FullArticleViewController.handleSwipes(_:)))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(FullArticleViewController.handleSwipes(_:)))
        leftSwipe.direction = .Left
        view.addGestureRecognizer(leftSwipe)
        
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

        cell.fullArticleTitleOutlet.text = passedArticles[currentArticleIndex!].title
        cell.fullArticleAuthorOutlet.text = passedArticles[currentArticleIndex!].author
        cell.fullArticleDateOutlet.text = passedArticles[currentArticleIndex!].publishedDate
        cell.fullArticleImageOutlet.image = passedArticles[currentArticleIndex!].pictureImage
        cell.fullArticleBodyOutlet.text = passedArticles[currentArticleIndex!].body
        
        return cell
    }
    
    func formatTableCell() {
        fullArticleTableView.estimatedRowHeight = 3000
        fullArticleTableView.rowHeight = UITableViewAutomaticDimension
        fullArticleTableView.allowsSelection = false
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .Right && currentArticleIndex == 0) {
            
            performSegueWithIdentifier("backToArticles", sender: UISwipeGestureRecognizer.self)
            
            
        } else if (sender.direction == .Right) {
            currentArticleIndex! -= 1
            fullArticleTableView.reloadData()
            scrollToTop()
            
        } else if (sender.direction == .Left) {
            currentArticleIndex! += 1
            fullArticleTableView.reloadData()
            scrollToTop()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToArticles" {
            let destinationVC = segue.destinationViewController as! NewsViewController
                destinationVC.selectedArticleInt = currentArticleIndex
        }
    }
    
    func scrollToTop() {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.fullArticleTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
    }
}
