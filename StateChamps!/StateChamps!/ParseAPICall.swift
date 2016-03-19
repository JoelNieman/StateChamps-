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
                
                // Create a MKPointAnnotation for every EventLocation object, append the collection, and place a pin on the map.
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
                        

                        let imageString = object.valueForKey("imageString") as! String
                        let imageData = NSData(contentsOfURL: NSURL(string: imageString)!)
                        
                        article.pictureImage = UIImage(data: imageData!)
                        
                        
                        
                        self.articles.append(article)
                        
//                        print("\(article.title)")
//                        print("\(article.title) has been added as article # \(self.index)")

                        self.index++
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.handler.onArticlesResponse(self.articles)
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func queryParseForDefuaultImage() {
        let query = PFQuery(className: "ImageObjectID")
        query.getObjectInBackgroundWithId("gDfAAhEZTI") {
            (imageID:PFObject?, error:NSError?) -> Void in
            
            if error == nil && imageID != nil {
                self.defaultImageID = imageID!["objectIDForDefaultImage"] as! String
                self.queryParseForImageWithImageID(self.defaultImageID)
                
            } else {
                print(error)
            }
        }
    }
    
    func queryParseForImageWithImageID(objectID: String) {
        let query = PFQuery(className: "DefaultImage")
        query.getObjectInBackgroundWithId(objectID) {
            (image:PFObject?, error:NSError?) -> Void in
            
            if error == nil && image != nil {
                self.defaultImageString = image!["imageString"] as! String
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.handler.onDefaultImageresponse(self.defaultImageString)
                }
            } else {
                print(error)
            }
        }
    }
}

