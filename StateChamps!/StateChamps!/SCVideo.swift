//
//  SCVideo.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/6/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import Foundation

class SCVideo {
    var title: String?
    var publishedDate:String?
    var videoURL: String?
    
    init (title: String, publishedDate: String, videoURL: String) {
        self.title = title
        self.publishedDate = publishedDate
        self.videoURL = videoURL
    }
}
