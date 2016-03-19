//
//  YouTubeAPI2.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/6/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import Foundation
import UIKit
import YouTubePlayer



class YouTubeAPICall {
    
    
    
    
    //  Implementing the APIOnResponseDelegate protocol
    
    let handler: YouTubeAPIOnResponseDelegate
    init(handler: YouTubeAPIOnResponseDelegate) {
        self.handler = handler

    }
    
    
    
    
    //  These are the collections of videos that can be populated with instances of this YouTubeAPICall.
    var showVideosArray = [SCVideo]()
    var highlightVideosArray = [SCVideo]()
    
    private let youTubeURL = "https://youtu.be/"
    private let showsPlaylistID = "PL8dd-D6tYC0DfIJarU3NrrTHvPmMkCjTd"
    private let highlightsPlaylistID = "PL8dd-D6tYC0BeICQ2C3hym16jEyj0SzSJ"
    private let maxShowResults = 20
    private var apiKey = youTubeClientID
    private var index = Int()
    
    
    
    
    //  FetchShowVideos forms and executes the NSURL request for show videos
    //  If successful, the function will call parseJSON and pass it the return data
    
    
    func fetchAllVideos() {
        fetchShowVideos()
        fetchHighlightVideos()
    }
    
    func fetchShowVideos() {
        let url = NSURL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(showsPlaylistID)&maxResults=\(maxShowResults)&key=\(apiKey)")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {
            data, response, error in
            if let taskError = error {
                print("Task Error Domain is: \(taskError.domain)\n\nThe Error Code is: \(taskError.code)\n\nThe Error userInfo is: \n\n\(taskError.userInfo)")
                
//                let alert = UIAlertController(title: "No Internet", message: "Looks like you are not connected to the internet", preferredStyle: .ActionSheet)
//                
//                let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                }
//                
//                alert.addAction(okAction)
//                
//                alert.popoverPresentationController?.sourceView = self.controller.view
//                alert.popoverPresentationController?.sourceRect = self.controller.view.bounds
//                
//                
//                
//                self.controller.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                let httpResponse = response as! NSHTTPURLResponse
                switch httpResponse.statusCode {
                case 200:
                    print("Got 200")
                    self.parseShowsJSON(data!)
                    
                default:
                    print("Request failed: \(httpResponse.statusCode)")
                }
                
            }
        })
        
        //  All tasks are suspended. resume() must be called to execute them.
        task.resume()
    }
    
    
    //  pareseJSON will take the data and try to serialize it.
    //  If successful, parseJSON will call createSCVideos and pass is the serializedJSON
    
    func parseShowsJSON(data: NSData) {
        
        do {
            let serializedJSON: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            let unwrappedJSON = serializedJSON!
            
            createShowSCVideos(unwrappedJSON as! NSDictionary)
            //        print("the unwrappedJSON is: \n\n \(unwrappedJSON)")
            
        } catch {
            print("caught an error when calling parseJSON!")
        }
    }
    
    
    //  createSCVideos takes the unwrappedJSON and parses it, creating SCVideo Objects
    //  Each SCVideo is appended to the showVideosArray
    
    func createShowSCVideos(unwrappedJSON: NSDictionary) {
        
        let tempVideosCollection = unwrappedJSON.objectForKey("items")!
        
        let count = tempVideosCollection.count
        print("SCShowVideo unwrappedJSON.count = \(count)")
        
        for index = 0; index < count; ++index {
            
            let video = SCVideo()
            
            video.title = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("title") as! String
            video.description = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("description") as! String
            video.publishedDate = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("publishedAt") as! String
            video.videoID = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("resourceId")!.objectForKey("videoId")! as! String
            
            let thumbnailURLString = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("thumbnails")!.objectForKey("medium")!.objectForKey("url") as! String
            let thumbnailImageData = NSData(contentsOfURL: NSURL(string: thumbnailURLString)!)
            
            video.thumbnailImage = UIImage(data: thumbnailImageData!)
            
            showVideosArray.append(video)
            
        }
        
        //  Upon completing the for loop, this the protocol method ("handler") is called and passed the completed array.
        
        dispatch_async(dispatch_get_main_queue()) {
            self.handler.onShowVideosResponse(self.showVideosArray)
        }
    }
    
    
    func fetchHighlightVideos() {
        let url = NSURL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(highlightsPlaylistID)&maxResults=\(maxShowResults)&key=\(apiKey)")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {
            data, response, error in
            if let taskError = error {
                print("Task Error Domain is: \(taskError.domain)\n\nThe Error Code is: \(taskError.code)\n\nThe Error userInfo is: \n\n\(taskError.userInfo)")
                
            } else {
                let httpResponse = response as! NSHTTPURLResponse
                switch httpResponse.statusCode {
                case 200:
                    print("Got 200")
                    self.parseHighlightsJSON(data!)
                default:
                    print("Request failed: \(httpResponse.statusCode)")
                }
                
            }
        })
        
        //  All tasks are suspended. resume() must be called to execute them.
        task.resume()
    }
    
    //  pareseJSON will take the data and try to serialize it.
    //  If successful, parseJSON will call createSCVideos and pass is the serializedJSON
    
    func parseHighlightsJSON(data: NSData) {
        
        do {
            let serializedJSON: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            let unwrappedJSON = serializedJSON!
            
            createHighlightSCVideos(unwrappedJSON as! NSDictionary)
            //        print("the unwrappedJSON is: \n\n \(unwrappedJSON)")
            
        } catch {
            print("caught an error when calling parseJSON!")
        }
    }
    
    
    //  createSCVideos takes the unwrappedJSON and parses it, creating SCVideo Objects
    //  Each SCVideo is appended to the showVideosArray
    
    func createHighlightSCVideos(unwrappedJSON: NSDictionary) {
        
        let tempVideosCollection = unwrappedJSON.objectForKey("items")!
        
        let count = tempVideosCollection.count
        print("SCHighlightVideo unwrappedJSON.count = \(count)")
        
        for index = 0; index < count; ++index {
            
            let video = SCVideo()
            
            video.title = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("title") as! String
            video.description = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("description") as! String
            video.publishedDate = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("publishedAt") as! String
            video.videoID = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("resourceId")!.objectForKey("videoId")! as! String
            
            let thumbnailURLString = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("thumbnails")!.objectForKey("medium")!.objectForKey("url") as! String
            let thumbnailImageData = NSData(contentsOfURL: NSURL(string: thumbnailURLString)!)
            
            video.thumbnailImage = UIImage(data: thumbnailImageData!)
            
            highlightVideosArray.append(video)
            
        }
        //  Upon completing the for loop, this the protocol method ("handler") is called and passed the completed array.
        
        dispatch_async(dispatch_get_main_queue()) {
            self.handler.onHighlightVideosResponse(self.highlightVideosArray)
        }
    }
}










