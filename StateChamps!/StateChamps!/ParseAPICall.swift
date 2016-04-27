//
//  ParseAPICall.swift
//  StateChamps!
//
//  Created by Nieman, Joel (J.M.) on 3/8/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import Foundation
import Parse

class ParseAPICall {
    
    //  Implementing the APIOnResponseDelegate protocol
    let handler: ParseAPIOnResponseDelegate
    init(handler: ParseAPIOnResponseDelegate) {
        self.handler = handler
    }
    
    var articles = [SCArticle]()
    var defaultImageID = String()
    var defaultImageString = String()
    
    
    var index = 0
    
    func queryParseForArticles() {
        let query = PFQuery(className:"Article")
        query.whereKey("articleNumber", greaterThan: 0)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("\n\nSuccessfully retrieved \(objects!.count) objects.")
                
                if let objects = objects {
                    for object in objects {
                        
                        let article = SCArticle()
                        
                        article.title = object.valueForKey("title") as! String
                        article.author = object.valueForKey("author") as! String
                        article.publishedDate = object.valueForKey("publishDate") as! String
                        article.body = object.valueForKey("body") as! String
                        article.sport = object.valueForKey("sport") as! String

                        
                        let articleURLString = object.valueForKey("articleURL") as! String
                        article.articleURL = NSURL(string: articleURLString)
                        
                        if let pictureFile = object.valueForKey("imageFile") as? PFFile {
                            article.pictureFile = pictureFile
                        }
                        
                        self.articles.append(article)

                        self.index++
                        
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            self.handler.onArticlesResponse(self.articles)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
}

