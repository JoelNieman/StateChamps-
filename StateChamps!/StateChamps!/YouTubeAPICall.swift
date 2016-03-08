//
//  YouTubeAPI2.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/6/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import Foundation
import UIKit

class YouTubeAPICall {
    
    //  Implementing the APIOnResponseDelegate protocol
    let handler: APIOnResponseDelegate
    init(handler: APIOnResponseDelegate) {
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
    
    
    //  FetchShowVideos forms and executes the NSURL request
    //  If successful, the function will call parseJSON and pass it the return data
    
    func fetchShowVideos() {
        let url = NSURL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(showsPlaylistID)&maxResults=\(maxShowResults)&key=\(apiKey)")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {
            data, response, error in
            if let taskError = error {
                print("Task Error is FetchData")
            } else {
                let httpResponse = response as! NSHTTPURLResponse
                switch httpResponse.statusCode {
                case 200:
                    print("Got 200")
                    self.parseJSON(data!)
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
    
    func parseJSON(data: NSData) {
        
        do {
            let serializedJSON: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            let unwrappedJSON = serializedJSON!
            
            createSCVideos(unwrappedJSON as! NSDictionary)
            //        print("the unwrappedJSON is: \n\n \(unwrappedJSON)")
            
        } catch {
            print("caught an error when calling parseJSON!")
        }
    }
    
    
    //  createSCVideos takes the unwrappedJSON and parses it, creating SCVideo Objects
    //  Each SCVideo is appended to the showVideosArray
    
    func createSCVideos(unwrappedJSON: NSDictionary) {
        
        let tempVideosCollection = unwrappedJSON.objectForKey("items")!
        
        let count = tempVideosCollection.count
        print("unwrappedJSON.count = \(count)")
        
        for index = 0; index < count; ++index {
            
            let video = SCVideo()
            
            video.title = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("title") as! String
            video.description = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("description") as! String
            video.publishedDate = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("publishedAt") as! String
            video.videoID = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("resourceId")!.objectForKey("videoId")! as! String
            video.thumbnailURLString = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("thumbnails")!.objectForKey("medium")!.objectForKey("url") as! String
            
            
            
            video.thumbnailImageData = NSData(contentsOfURL: NSURL(string: video.thumbnailURLString)!)
            
            video.thumbnailImage = UIImage(data: video.thumbnailImageData!)
            
            //  TRY THIS WHEN I GET HOME. ----------------------------------------------------
            
            //  let thumbnailString = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("thumbnails")!.objectForKey("medium")!.objectForKey("url") as! String
            
            //  video.thumbnailURL = NSURL(thumbnailString)!
            
            
            showVideosArray.append(video)
            
        }
        //  Upon completing the for loop, this the protocol method ("handler") is called and passed the completed array.
        
        dispatch_async(dispatch_get_main_queue()) {
            self.handler.onResponse(self.showVideosArray)
        }
    }
}










