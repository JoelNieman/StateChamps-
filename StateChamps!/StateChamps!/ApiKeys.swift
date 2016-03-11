//
//  ApiKeys.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/6/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import Foundation

func valueForAPIKey(keyname:String) -> String {
    let filePath = NSBundle.mainBundle().pathForResource("MyApiKeys", ofType:"plist")

    
    let plist = NSDictionary(contentsOfFile: filePath!)

    
    
    
    let value:String = plist?.objectForKey(keyname) as! String
    return value
}

let youTubeClientID = valueForAPIKey("YOUTUBE_API_CLIENT_ID")

