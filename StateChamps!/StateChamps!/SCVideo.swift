//
//  SCVideo.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/6/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//



// this is currently not used. The api call to youtube creates an array of dictionaries. I can make YouTubeVideo objects but it seems uneccesary.

import UIKit

class SCVideo {
    var title = ""
    var description = ""
    var publishedDate = ""
    var videoID = ""
    var thumbnailURLString = ""
    var thumbnailImageData: NSData?
    var thumbnailImage: UIImage?
    
//    init (title: String, description: String, publishedDate: String, videoID: String, thumbnailURLString: String) {
//        self.title = title
//        self.description = description
//        self.publishedDate = publishedDate
//        self.videoID = videoID
//        self.thumbnailURLString = thumbnailURLString
//    }
}
