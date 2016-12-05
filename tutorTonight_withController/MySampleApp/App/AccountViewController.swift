//
//  SettingsViewController.swift
//  MySampleApp
//
//  Created by Satinder Singh on 2016-11-12.
//
//

import Foundation
import UIKit
import AWSMobileHubHelper

class AccountViewController: UIViewController {
    
//    override func viewDidLoad() {
//        //        super.viewDidLoad()
//        print("settings controller:")
//        print(LoginViewController.myGlobals.globalUserID)
//        print(LoginViewController.myGlobals.globalFirstName)
//        print(LoginViewController.myGlobals.globalLastName)
//        print(LoginViewController.myGlobals.globalEmail)
//        print(LoginViewController.myGlobals.globalUserName)
//        
//    }

    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt1.text = LoginViewController.myGlobals.globalFirstName
        txt2.text = LoginViewController.myGlobals.globalLastName
        txt3.text = LoginViewController.myGlobals.globalEmail
    }
//
//
//    
//    
//    
    
}
