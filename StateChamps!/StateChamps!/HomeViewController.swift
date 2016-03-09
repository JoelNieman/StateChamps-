//
//  HomeViewController.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/9/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var header: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
