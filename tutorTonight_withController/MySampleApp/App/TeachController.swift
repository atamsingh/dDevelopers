//
//  TeachController.swift
//  MySampleApp
//
//  Created by Satinder Singh on 2016-11-29.
//
//

import UIKit
import AWSMobileHubHelper


class TeachController: UIViewController {

    override func viewDidLoad() {
        
        if (LoginViewController.myGlobals.globalTutorStatus == "Yes"){
            print(LoginViewController.myGlobals.globalTutorStatus)
            self.performSegueWithIdentifier("tutorSeg", sender: nil)
        }
        
    }
    
}
