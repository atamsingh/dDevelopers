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
        
        let firstName = firstNameBox.text!
        let lastName = lastNameBox.text!
        let email = emailBox.text!
        let password = passwordBox.text!
        let studentStatus = true
        let tutorStatus = false
        
        
        let inputData: String = "{\"callType\"  : \"PUT\",\"object\"    : \"USERS\",\"data\"      : {\"username\"  : \"\(email)\",\"password\"  : \"\(password)\",\"email\"  : \"\(email)\",\"firstName\"  : \"\(firstName)\",\"lastName\"  : \"\(lastName)\",\"studentStatus\"  : true, \"tutorStatus\"  : false}}"
        let functionName = "mainController"
        let jsonInput = inputData.makeJsonable()
        let jsonData = jsonInput.dataUsingEncoding(NSUTF8StringEncoding)!
        var parameters: [String: AnyObject]
        do {
            let anyObj = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [String: AnyObject]
            parameters = anyObj
        } catch let error as NSError {
            print("Yalla json error: \(error.localizedDescription)")
            return
        }
        print("Yalla Json Input: \(jsonInput)")
        
        
        
        // RETURN FROM AWS LAMBDA
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
                            
                            //let userID = info["userID"] as String!
                            
                            LoginViewController.myGlobals.globalUserName = info["userName"] as String!
                            LoginViewController.myGlobals.globalUserID = info["userID"] as String!
                            LoginViewController.myGlobals.globalFirstName = info["firstName"] as String!
                            LoginViewController.myGlobals.globalLastName = info["lastName"] as String!
                            LoginViewController.myGlobals.globalEmail = email
                            let ss = info["studentStatus"] as String!
                            let ts = info["tutorStatus"] as String!
                            LoginViewController.myGlobals.globalStudentStatus = (ss=="true") ? "Yes" : "No";
                            LoginViewController.myGlobals.globalTutorStatus = (ts=="true") ? "Yes" : "No";
                            
                            let inputData: String = "{\"callType\"  : \"CREATE\",\"object\"    : \"STUDENT\",\"data\"      : {\"userID\"  : \"\(LoginViewController.myGlobals.globalUserID)\",\"universityID\"  : \"Carleton\"}}"
                            //let functionName = "mainController"
                            let jsonInput = inputData.makeJsonable()
                            let jsonData = jsonInput.dataUsingEncoding(NSUTF8StringEncoding)!
                            //var parameters: [String: AnyObject]
                            do {
                                let anyObj = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [String: AnyObject]
                                parameters = anyObj
                            } catch let error as NSError {
                                print("Yalla json error: \(error.localizedDescription)")
                                return
                            }
                            print("Yalla CREATE_STUDENT REQUEST: \(jsonInput)")
                            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                            //// CREATE_STUDENT
                            AWSCloudLogic.defaultCloudLogic().invokeFunction(functionName, withParameters: parameters, completionBlock: {(result: AnyObject?, error: NSError?) -> Void in
                                if let result = result {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        let NSjsonStr = result as! NSString;
                                        let NSdataStr = NSjsonStr.dataUsingEncoding(NSUTF8StringEncoding)!;
                                        let readableJSON = JSON(data: NSdataStr, options: NSJSONReadingOptions.MutableContainers, error: nil)
                                        print("Yalla Returned JSON from CREATE STUDENT: \(readableJSON)")
                                        
                                        if readableJSON["status"] == "fail" {
                                            //"{\"status\":\"fail\",\"info\":{\"reason\":\"user already a Student\"}}"
                                            // FAILED CREATE_STUDENT
                                            let reason = info["reason"] as String!
                                            
                                            //pop up alert message
                                            let alert = UIAlertView()
                                            alert.title = "Error"
                                            alert.message = reason
                                            alert.addButtonWithTitle("Ok")
                                            alert.show()
                                        } else if readableJSON["status"] == "error" {
                                            //"{\"status\":\"error\",\"info\": {\"error\":\"1201\",\"errorMessage\":\"Unable to access userDB\",\"errorDetail\":ValidationException: ExpressionAttributeValues contains invalid value: One or more parameter values were invalid: An AttributeValue may not contain an empty string for key :i\"}}"
                                            
                                            let errorMessage = info["errorMessage"] as String!
                                            print("Yalla CREATE_STUDENT errorMessage: \(errorMessage)")
                                        } else {
                                            // CREATE_STUDENT SUCCESSFUL
                                            //"{\"status\":\"pass\",\"info\":{\"userID\":\"undefined\",\"univeristyID\":\"undefined\",\"studentRating\":\"0.0\"\"paymentMethod\":\"none\",}}"
                                            
                                            //LoginViewController.myGlobals.globalStuStatus = info["studentRating"] as Int
                                            
                                            print("Yalla CREATE_STUDENT SUCCESS")
                                            
                                            
                                            // next screen
                                            self.performSegueWithIdentifier("signup2main", sender: nil)
                                        }
                                        
                                        
                                    })
                                }
                                
                                var errorMessage: String
                                if let error = error {
                                    if let cloudUserInfo = error.userInfo as? [String: AnyObject],
                                        cloudMessage = cloudUserInfo["errorMessage"] as? String {
                                        errorMessage = "Error: \(cloudMessage)"
                                    } else {
                                        errorMessage = "Error occurred in invoking the Lambda Function. No error message found."
                                    }
                                    dispatch_async(dispatch_get_main_queue(), {
                                        print("Yalla Error occurred in invoking Lambda Function: \(error)")
                                        //Do something with error message
                                        let alertView = UIAlertController(title: NSLocalizedString("Error", comment: "Title bar for error alert."), message: error.localizedDescription, preferredStyle: .Alert)
                                        alertView.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Button on alert dialog."), style: .Default, handler: nil))
                                        self.presentViewController(alertView, animated: true, completion: nil)
                                    })
                                }
                            })
                            //End of CREATE_STUDENT
                            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                            
                        }
                    } catch {
                        print("Yalla Error: \(error)")
                    }
                    
                    
                })
            }
            
            print("Yalla after async")
            
            
            var errorMessage: String
            if let error = error {
                if let cloudUserInfo = error.userInfo as? [String: AnyObject],
                    cloudMessage = cloudUserInfo["errorMessage"] as? String {
                    errorMessage = "Error: \(cloudMessage)"
                } else {
                    errorMessage = "Error occurred in invoking the Lambda Function. No error message found."
                }
                dispatch_async(dispatch_get_main_queue(), {
                    print("Yalla Error occurred in invoking Lambda Function: \(error)")
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
