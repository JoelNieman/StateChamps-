//
//  HomeViewController.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/4/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var playerView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatViewController()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func formatViewController() {
        UITabBar.appearance().barTintColor = sCRedColor
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        header.backgroundColor = sCRedColor
        playerView.backgroundColor = sCGreyColor
    }

}
