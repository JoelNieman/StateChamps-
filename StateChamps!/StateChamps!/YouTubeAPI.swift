//
//  YouTubeAPI2.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/6/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import Foundation

let VC = VideosViewController()
var showVideosArray = [SCVideo]()

let showsPlaylistID = "PL8dd-D6tYC0DfIJarU3NrrTHvPmMkCjTd"
let highlightsPlaylistID = "PL8dd-D6tYC0BeICQ2C3hym16jEyj0SzSJ"
let maxShowResults = 20
var apiKey = youTubeClientID
var youTubeURL = "https://youtu.be/"

var index = Int()


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
                parseJSON(data!)
            default:
                print("Request failed: \(httpResponse.statusCode)")
            }
            
        }
    })
    task.resume()
}

func parseJSON(data: NSData) {
    
    do {
        let json: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        let unwrappedJSON = json!
        
//        print("the unwrappedJSON is: \n\n \(unwrappedJSON)")
        parseVideos(unwrappedJSON as! NSDictionary)
    } catch {
        print("caught an error when calling parseJSON!")
    }
}


func parseVideos(unwrappedJSON: NSDictionary) {
    
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
        
        showVideosArray.append(video)
        
    }
//    print("The showVideosArray contains: \n\(showVideosArray)\n")
//    print("the title for Video #1 is \n\(showVideosArray[0].title)\n")
//    print("the description for Video #1 is \n\(showVideosArray[0].description)\n")
//    print("the publishedDate for Video #1 is \n\(showVideosArray[0].publishedDate)\n")
//    print("the videoID for Video #1 is \n\(showVideosArray[0].videoID)\n")
//    print("the thumbnialURLString for Video #1 is \n\(showVideosArray[0].thumbnailURLString)\n")
    
}







