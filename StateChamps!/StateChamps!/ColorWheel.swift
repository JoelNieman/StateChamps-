//
//  ColorWheel.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/4/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//


import UIKit

let sCRedColor = UIColor.init(colorLiteralRed: 213/255, green: 28/255, blue: 41/255, alpha: 1)
let sCBlueColor = UIColor.init(colorLiteralRed: 31/255, green: 84/255, blue: 204/255, alpha: 1)
let sCGreyColor = UIColor.init(colorLiteralRed: 90/255, green: 91/255, blue: 93/255, alpha: 1)

//class ViewControllerFormatter {

func formatViewController() {
    UITabBar.appearance().barTintColor = sCRedColor
    UITabBar.appearance().tintColor = UIColor.whiteColor()
    UITabBar.appearance().translucent = false
    }
//}
