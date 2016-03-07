//
//  YouTubeAPI2.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/6/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import Foundation

let VC = VideosViewController()

var video = SCVideo()

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
    print("parseJSON has been called!")
    
    do {
        let json: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        let unwrappedJSON = json!
        
//        print("the unwrappedJSON is: \n\n \(unwrappedJSON)")
        parseBookings(unwrappedJSON as! NSDictionary)
    } catch {
        print("caught an error when calling parseJSON!")
    }
}


func parseBookings(unwrappedJSON: NSDictionary) {
    print("parseBookings has been called!")
    
    let tempVideosCollection = unwrappedJSON.objectForKey("items")!
    print("The tempVideosCollection is: \n \(tempVideosCollection)")
    
    let count = tempVideosCollection.count
    print("unwrappedJSON.count = \(count)")
    
    for index = 0; index < count; ++index {
        
        video.title = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("title") as! String
        video.description = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("description") as! String
        video.publishedDate = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("publishedAt") as! String
        video.videoID = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("resourceId")!.objectForKey("videoId")! as! String
        video.thumbnailURLString = tempVideosCollection[index]!.objectForKey("snippet")!.objectForKey("thumbnails")!.objectForKey("medium")!.objectForKey("url") as! String
        
        VC.showVideosArray.append(video)
        
    }
//    print("The showVideosArray2 contains: \n\n\(VC2.showVideosArray2)")
//    print("the title for Video #1 is \n\n\(VC2.showVideosArray2[0].title)")
//    print("the description for Video #1 is \n\n\(VC2.showVideosArray2[0].description)")
//    print("the publishedDate for Video #1 is \n\n\(VC2.showVideosArray2[0].publishedDate)")
//    print("the videoID for Video #1 is \n\n\(VC2.showVideosArray2[0].videoID)")
//    print("the thumbnialURLString for Video #1 is \n\n\(VC2.showVideosArray2[0].thumbnailURLString)")
    
}







