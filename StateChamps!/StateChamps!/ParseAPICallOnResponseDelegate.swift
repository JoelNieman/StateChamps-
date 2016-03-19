//
//  ParseAPICallOnResponseDelegate.swift
//  StateChamps!
//
//  Created by Nieman, Joel (J.M.) on 3/8/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import Foundation

protocol ParseAPIOnResponseDelegate {
    func onArticlesResponse(articles:[SCArticle])
    
    func onDefaultImageresponse(retrievedImageString: String)
}