//
//  HomeViewController.swift
//  StateChamps!
//
//  Created by Joel Nieman on 3/9/16.
//  Copyright © 2016 JoelNieman. All rights reserved.
//

import UIKit
import TwitterKit
import Crashlytics

class SocialViewController: TWTRTimelineViewController {


    @IBOutlet weak var noteOutlet: UILabel!

    var logInButton = TWTRLogInButton()
    
    let titleFontColorDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName: UIFont.systemFontOfSize(20)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatViewController()
        formatNavBar()
        authenticateUser()

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func makeAPICall() {
        let client = TWTRAPIClient()
        self.dataSource = TWTRUserTimelineDataSource(screenName: "statechampsnet", APIClient: client)

        removeFuckingButton()
        noteOutlet.removeFromSuperview()
    }
    
    func authenticateUser() {
        
        logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                let alert = UIAlertController(title: "Logged In",
                    message: "User \(unwrappedSession.userName) has logged in",
                    preferredStyle: UIAlertControllerStyle.Alert
                    
                )
                
                
                self.makeAPICall()
                
                
                
                let alertAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                })
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
                
            } else {
                print("Login error: \(error!.localizedDescription)");
            }
            

            
        }
        
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
    }
    
    func removeFuckingButton() {
        self.logInButton.removeFromSuperview()
    }
    
    func formatNavBar() {
        
        self.navigationController!.navigationBar.titleTextAttributes = (titleFontColorDict as! [String : AnyObject])
        
        self.navigationController!.navigationBar.backgroundColor = sCRedColor
        self.navigationController!.navigationBar.barTintColor = sCRedColor
        self.navigationController?.navigationBar.translucent = false
    }
    


}
