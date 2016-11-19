//
//  SignUpViewController.swift
//  MySampleApp
//
//  Created by Satinder Singh on 2016-11-12.
//
//

import Foundation
import UIKit
import AWSMobileHubHelper

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameBox: UITextField!
    @IBOutlet weak var lastNameBox: UITextField!
    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    // CALL AWS GIVEN JSON
    @IBAction func signUpButtonPress(sender: AnyObject) {

        if firstNameBox.text!.characters.count < 2  ||
            lastNameBox.text!.characters.count < 2  ||
               emailBox.text!.characters.count < 10 ||
            passwordBox.text!.characters.count < 8 {
            //POP UP INVALID
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Please enter valid credentials"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }

        /* TEST
         {
             "callType"  : "PUT",
             "object"    : "USERS",
             "data"      : {
                "username"  : "atamsingh",
                "password"  : "Compsci3004!",
                "email"     : "atam_singh@hotmail.com",
                "firstName" : "Atamjeet",
                "lastName"  : "Singh",
                "studentStatus" : false,
                "tutorStatus"   : false
             }
         }
         */
        
        let firstName = firstNameBox.text!
        let lastName = lastNameBox.text!
        let email = emailBox.text!
        let password = passwordBox.text!
        let studentStatus = true
        let tutorStatus = true
        

        let inputData: String = "{\"callType\"  : \"PUT\",\"object\"    : \"USERS\",\"data\"      : {\"username\"  : \"\(email)\",\"password\"  : \"\(password)\",\"email\"  : \"\(email)\",\"firstName\"  : \"\(firstName)\",\"lastName\"  : \"\(lastName)\",\"studentStatus\"  : \"\(studentStatus)\", \"tutorStatus\"  : \"\(tutorStatus)\"}}"
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

        
        
        // RETURN FRO AWS LAMBDA
        AWSCloudLogic.defaultCloudLogic().invokeFunction(functionName, withParameters: parameters, completionBlock: {(result: AnyObject?, error: NSError?) -> Void in
            if let result = result {
                dispatch_sync(dispatch_get_main_queue(), {
                    
                    //RETREIVE JSON OBJECT FROM AWS
                    let NSjsonStr = result as! NSString;
                    let NSdataStr = NSjsonStr.dataUsingEncoding(NSUTF8StringEncoding)!;
                    do {
                        let jsonArray: NSDictionary = try NSJSONSerialization.JSONObjectWithData(NSdataStr, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        
                        //                        print("jsonArray: \(jsonArray)")
                        
                        let status = jsonArray["status"]! as! String
                        let info = jsonArray["info"]!
                        
                        
//                        FAILED SIGN UP
//                            "{\"status\":\"fail\",\"info\":{\"reason\":\"password not valid\"}}"
                        if status == "fail" {
                            let reason = info["reason"] as String!
                            
                            //pop up alert message
                            let alert = UIAlertView()
                            alert.title = "Error"
                            alert.message = reason
                            alert.addButtonWithTitle("Ok")
                            alert.show()
                            
                        } else {
                            // LOGIN SUCCESSFUL
// "{\"status\":\"pass\",\"info\":{\"userID\":\"268116fb-3b72-4872-8034-0b786fc5d7aa\",\"userName\":\"sunnysingh\",\"firstName\":\"Sunny\",\"lastName\":\"Singh\",\"studentStatus\":\"false\",\"tutorStatus\":\"false\"}}"
                            let userID = info["userID"] as String!
                            
                            
                            // next screen
//                            self.performSegueWithIdentifier("toMain", sender: nil)
                            self.performSegueWithIdentifier("signup2main", sender: nil)
                            
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                    
                    
                })
            }
            
            print("after async")
            
            
            if let error = error {
                var errorMessage: String
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
