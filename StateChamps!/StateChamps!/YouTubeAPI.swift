//
//  YouTubeAPI.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/6/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import Foundation

let VC = VideosViewController()

let showsPlaylistID = "PL8dd-D6tYC0DfIJarU3NrrTHvPmMkCjTd"
let highlightsPlaylistID = "PL8dd-D6tYC0BeICQ2C3hym16jEyj0SzSJ"
let maxShowResults = 20
var apiKey = youTubeClientID
var youTubeVideoSelected = ""
var videoID: String!
var youTubeURL = "https://youtu.be/"



func performGetRequest(targetURL: NSURL!, completion: (data: NSData?, HTTPStatusCode: Int, error: NSError?) -> Void) {
    let request = NSMutableURLRequest(URL: targetURL)
    request.HTTPMethod = "GET"
    
    let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: sessionConfiguration)
    let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            completion(data: data, HTTPStatusCode: (response as! NSHTTPURLResponse).statusCode, error: error)
        })
    })
    task.resume()
}

func getPlaylistVideos() {
        
        //  Form the request URL string.
        //  This is where I define the parameters of the search (i.e., PlaylistID, MaxResults, & APIKey)
        let urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(showsPlaylistID)&maxResults=\(maxShowResults)&key=\(apiKey)"
        
        // Create a NSURL object based on the above string.
        let targetURL = NSURL(string: urlString)!
        
        // Fetch the playlist from YouTube.
        performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            if HTTPStatusCode == 200 && error == nil {
                do {
                    // Convert the JSON data into a dictionary.
                    let resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! Dictionary<NSObject, AnyObject>
                    
//                    print("the resultsDict is: \n\n \(resultsDict)")
                    
                    // Get all playlist items ("items" array).
                    let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                    
//                    print("the items are: \n\n \(items)")
                    
                    // Use a loop to go through all video items.
                    for var i=0; i<items.count; ++i {
                        let playlistSnippetDict = (items[i] as Dictionary<NSObject, AnyObject>)["snippet"] as! Dictionary<NSObject, AnyObject>
                        
//                        print("the playlistSnippetDict is: \n\n \(playlistSnippetDict)")
                        
                        // Initialize a new dictionary and store the data of interest.
                        var desiredPlaylistItemDataDict = Dictionary<NSObject, AnyObject>()
                        
                        desiredPlaylistItemDataDict["title"] = playlistSnippetDict["title"]
                        
                        desiredPlaylistItemDataDict["videoID"] = (playlistSnippetDict["resourceId"] as! Dictionary<NSObject, AnyObject>)["videoId"]
                        
                        let thumbnailsArray = playlistSnippetDict["thumbnails"]
                        desiredPlaylistItemDataDict["thumbnailURLString"] = (thumbnailsArray!["default"] as! Dictionary<NSObject, AnyObject>)["url"]
                        
                        
                        print("The desiredPlaylistItemDataDict is: \(desiredPlaylistItemDataDict)")
                        
                        // Append the desiredPlaylistItemDataDict dictionary to the videos array.
                        VC.showVideosArray.append(desiredPlaylistItemDataDict)
                        
                        // dispatch the task back to the main thread.
//                        dispatch_async(dispatch_get_main_queue()) {
//                            VC.videoTableView.reloadData()
//                        }
                    }
                } catch {
                    print(error)
                }
//                print("The showVideosArray is: \n\n \(VC.showVideosArray)")
            }
            else {
                print("HTTP Status Code = \(HTTPStatusCode)")
                print("Error while loading channel videos: \(error)")
            }
        })

        
    }