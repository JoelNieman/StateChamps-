//
//  APIOnResponseDelegate.swift
//  StateChamps!
//
//  Created by Nieman, Joel (J.M.) on 3/8/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import Foundation
import UIKit

protocol YouTubeAPIOnResponseDelegate {

    func onShowVideosResponse(showVideos:[SCVideo])
    func onHighlightVideosResponse(highlightVideos: [SCVideo])
}

