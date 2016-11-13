//
//  LoginViewController.swift
//  MySampleApp
//
//  Created by Satinder Singh on 2016-11-12.
//
//

import Foundation
import UIKit
import AWSMobileHubHelper

class LoginViewController: UIViewController {
    @IBOutlet weak var loginBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var rememberMeSwitch: UISwitch!

    @IBAction func loginTry(sender: AnyObject) {
        
        loginBox.text = "atamsingh"
        passwordBox.text = "Compsci3004!"
        
        if loginBox.text!.characters.count == 0 || passwordBox.text!.characters.count < 8 {
            return
        }
        
        let userName = loginBox.text!
        let password = passwordBox.text!
        let inputData: String = "{\"callType\"  : \"GET\",\"object\"    : \"USERS\",\"data\"      : {\"username\"  : \"\(userName)\",\"password\"  : \"\(password)\"}}"
        let functionName = "mainController"
        let jsonInput = inputData.makeJsonable()
        let jsonData = jsonInput.dataUsingEncoding(NSUTF8StringEncoding)!
        var parameters: [String: AnyObject]
        do {
            let anyObj = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [String: AnyObject]
            parameters = anyObj
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
            return
        }
        print("Json Input: \(jsonInput)")
        
        
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(functionName, withParameters: parameters, completionBlock: {(result: AnyObject?, error: NSError?) -> Void in
            if let result = result {
                dispatch_sync(dispatch_get_main_queue(), {
                    
                    let NSjsonStr = result as! NSString;
                    let NSdataStr = NSjsonStr.dataUsingEncoding(NSUTF8StringEncoding)!;
                    do {
                        let jsonArray: NSDictionary = try NSJSONSerialization.JSONObjectWithData(NSdataStr, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        
                        //                        print("jsonArray: \(jsonArray)")
                        
                        let status = jsonArray["status"]! as! String
                        let info = jsonArray["info"]!
                        
                        
                        
                        if status == "fail" {
                            // FAILED LOGIN
                            let reason = info["reason"] as String!
                            
                            //pop up alert message
                            let alert = UIAlertView()
                            alert.title = "Error"
                            alert.message = reason
                            alert.addButtonWithTitle("Ok")
                            alert.show()
                            
                        } else {
                            // LOGIN SUCCESSFUL
                            let userID = info["userID"] as String!
                            
                            // save user information to global variables
//                            myGlobals.globalUserName = userName
//                            myGlobals.globalUserID = info["userID"] as String!
//                            myGlobals.globalFirstName = info["firstName"] as String!
//                            myGlobals.globalLastName = info["lastName"] as String!
//                            myGlobals.globalFullName = (info["firstName"] as String!) + (info["lastName"] as String!
//                            myGlobals.globalEmail = info["email"] as String!
                            
                            
                            
                            // next screen
                            self.performSegueWithIdentifier("toMain", sender: nil)
                            
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                    
                    
                })
            }
            
            print("after async")
            
            
            var errorMessage: String
            if let error = error {
                if let cloudUserInfo = error.userInfo as? [String: AnyObject],
                    cloudMessage = cloudUserInfo["errorMessage"] as? String {
                    errorMessage = "Error: \(cloudMessage)"
                } else {
                    errorMessage = "Error occurred in invoking the Lambda Function. No error message found."
                }
                dispatch_async(dispatch_get_main_queue(), {
                    print("Error occurred in invoking Lambda Function: \(error)")
                    //Do something with error message
                    let alertView = UIAlertController(title: NSLocalizedString("Error", comment: "Title bar for error alert."), message: error.localizedDescription, preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Button on alert dialog."), style: .Default, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                })
            }
        })
        
    }
}


extension String {
    private func makeJsonable() -> String {
        let resultComponents: NSArray = self.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        return resultComponents.componentsJoinedByString("")
    }
}
