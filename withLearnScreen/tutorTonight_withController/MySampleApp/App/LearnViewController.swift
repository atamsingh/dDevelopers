//
//  LearnViewController.swift
//  MySampleApp
//
//  Created by Arzaan Irani & Corey Cougle on 2016-11-16.
//
//

import UIKit
import UIKit
import AWSMobileHubHelper




class LearnViewController: UIViewController {
    
//    @IBOutlet weak var SearchField: UITextField!
//    @IBOutlet weak var LocationField: UITextView!
//    
    
    @IBOutlet weak var SearchField: UITextField!
    @IBOutlet weak var CalendardatePicker: UIDatePicker!
    @IBOutlet weak var CalendardatePicker1: UIDatePicker!
    @IBOutlet weak var LocationField: UITextView!
    
    @IBOutlet weak var scrollViewMain: UIScrollView!

    var startDate: String = "";
    var endDate: String = "";
    
    var i = 0
    var Lessons = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //LocationField.bindToKeyboard()
        // Do any additional setup after loading the view.
        
        CalendardatePicker.addTarget(self, action: #selector(datePicker1Changed(_:)), forControlEvents: .ValueChanged)
        CalendardatePicker.minimumDate = NSDate()
        
        CalendardatePicker1.addTarget(self, action: #selector(datePicker2Changed(_:)), forControlEvents: .ValueChanged)
        CalendardatePicker1.minimumDate = NSDate()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LearnViewController.hideKeyboard))
        
        // prevents the scroll view from swallowing up the touch event of child buttons
        tapGesture.cancelsTouchesInView = false
        
        scrollViewMain.addGestureRecognizer(tapGesture)
    }
    
    func hideKeyboard() {
        SearchField.resignFirstResponder()
        CalendardatePicker.resignFirstResponder()
        CalendardatePicker1.resignFirstResponder()
        LocationField.resignFirstResponder()
    }
    
    func datePicker1Changed(picker: UIDatePicker) {
        CalendardatePicker1.minimumDate = CalendardatePicker.date
    }
    
    func datePicker2Changed(picker: UIDatePicker) {
        if(CalendardatePicker1.date.timeIntervalSince1970 < CalendardatePicker.date.timeIntervalSince1970){
            CalendardatePicker.minimumDate = CalendardatePicker1.date
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // Date Picker Function To Change The Text In The Field

    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func RequestAction(sender: AnyObject) {
        
        let getCourses: String = "{\"callType\"  : \"GET\",\"object\"    : \"COURSES\",\"data\"      : {}}";
        
        let functionName = "mainController";
        let getCoursesJson = getCourses.makeJsonable()
        let getCoursesData = getCoursesJson.dataUsingEncoding(NSUTF8StringEncoding)!
        var parameters: [String: AnyObject]
        do {
            let anyObj = try NSJSONSerialization.JSONObjectWithData(getCoursesData, options: []) as! [String: AnyObject]
            parameters = anyObj
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
            return
        }
        print("AWS JSON REQUEST: \(getCoursesData)")
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(functionName, withParameters: parameters, completionBlock: {(result: AnyObject?, error: NSError?) -> Void in
            if let result = result {
                //RESULT is always "{\"status\":\"pass\",\"info\":{\"school\":\"Carleton University\",\"courses\":[{\"1\":\"COMP1001\"},{\"2\":\"COMP1005\"},{\"3\":\"COMP2001\"},{\"4\":\"COMP3001\"},{\"5\":\"HIST1001\"}]}}"
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let NSjsonStr = result as! NSString;
                    let NSdataStr = NSjsonStr.dataUsingEncoding(NSUTF8StringEncoding)!;
                    let readableJSON = JSON(data: NSdataStr, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    print ("Readable JSON: \(readableJSON)")
                    
                    //let status = readableJSON["status"]
                    print("Status of get courses \(readableJSON["status"].stringValue)")
                    
                    //WE NEED TO GET NEXT LEVEL, CAN WE REMOVE THE "[]" IN LAMBDA?
                    
                    if readableJSON["status"].stringValue == "fail" {
                        
                        let reason = readableJSON["info"]["reason"]
                        
                        //pop up alert message
                        let alert = UIAlertView()
                        alert.title = "Error"
                        alert.message = String(reason)
                        alert.addButtonWithTitle("Ok")
                        alert.show()
                        
                    } else {
                        // LOGIN SUCCESSFUL
                        
                        //pop up alert message
                        
                        
                        //Now we want to CREATE_SESSION with userID, SearchField.text!
                        //But for now we print
                        //print("AWS Response info: \(info)")
                        //let courses = info["courses"]!
                        //print("AWS Response courses: \(courses)")
                        
                        //let createSession: String = "{\"callType\": \"CREATE\",\"object\": \"SESSION\",\"data\": {\"studentID\": \"\(LoginViewController.myGlobals.globalUserID)\",\"course\": \"\(SearchField.text!)\",\"date\": \"Nov 13, 2016\",\"start\":\"10:00\",\"end\": \"14:00\"}"
                        
                        //if SearchField.text! == one of the elements in "courses" then
                        
                        //let numCourses = readableJSON["info"]["courses"].count
                        var courseName = ""
                        var i=1
                        for result in readableJSON["info"]["courses"].arrayValue {
                            courseName = result[String(i)].stringValue
                            if courseName == self.SearchField.text! {
                                
                                
//!!!!!!!!!!!!!!!!
// Update this with custom time
                                let sessionStr: String = "{\"callType\": \"CREATE\",\"object\": \"SESSION\",\"data\": {\"studentID\": \"\(LoginViewController.myGlobals.globalUserID)\",\"course\": \"\(self.SearchField.text!)\",\"date\": \"Nov 12, 2016\",\"start\": \"10:00\",\"end\": \"14:00\"}}"
                                
                                
                                print("sessionStr: \(sessionStr)")
                                let functionName = "mainController"
                                
                                let createSessionJSON = sessionStr.makeJsonable()
                                let createSessionJsonData = createSessionJSON.dataUsingEncoding(NSUTF8StringEncoding)!
                                var para: [String: AnyObject]
                                do {
                                    let anyObj = try NSJSONSerialization.JSONObjectWithData(createSessionJsonData, options: []) as! [String: AnyObject]
                                    para = anyObj
                                } catch let error as NSError {
                                    print("json error: \(error.localizedDescription)")
                                    return
                                }
                                print("CreateSession Request: \(sessionStr)")
                                
                                AWSCloudLogic.defaultCloudLogic().invokeFunction(functionName, withParameters: para, completionBlock: {(result: AnyObject?, error: NSError?) -> Void in
                                    if let result = result {
                                        dispatch_sync(dispatch_get_main_queue(), {
                                            
                                            
                                            //RETREIVE JSON OBJECT FROM AWS
                                            
                                            let NSjsonStr = result as! NSString;
                                            let NSdataStr = NSjsonStr.dataUsingEncoding(NSUTF8StringEncoding)!;
                                            let readableJSON = JSON(data: NSdataStr, options: NSJSONReadingOptions.MutableContainers, error: nil)
                                            
                                            let status = readableJSON["status"]
                                            
                                            
                                            if String(status) == "pass" {
                                                // Create_Session SUCCESSFUL
                                                
                                                // "{\"status\":\"pass\",\"info\":{\"sessionID\":\"80246b78-370b-496d-90fa-d2af1f99d91e|~~|4\"}}"
                                                let alert2 = UIAlertView()
                                                alert2.title = "Yayy!"
                                                alert2.message = String("We are looking for your tutor Right now. Hang in there!")
                                                alert2.addButtonWithTitle("Ok")
                                                alert2.show()
                                                
                                                self.SearchField.text = ""
                                                
                                                // next screen
                                                //self.performSegueWithIdentifier("toMain", sender: nil)
                                                
                                            } else {
                                                // FAILED Create_Session
                                                
                                                //"{\"status\":\"fail\",\"info\":{\"reason\":\"no student found\"}}"
                                                let reason = readableJSON["info"]["reason"]
                                                
                                                //pop up alert message
                                                let alert = UIAlertView()
                                                alert.title = "Error"
                                                alert.message = String(reason)
                                                alert.addButtonWithTitle("Ok")
                                                alert.show()
                                                
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
                                break
                            }
                            i = i+1
                        }
                        
                        if courseName != self.SearchField.text! {
                            let reason = "Course Not Found"
                            
                            //pop up alert message
                            let alert = UIAlertView()
                            alert.title = "Error"
                            alert.message = reason
                            alert.addButtonWithTitle("Ok")
                            alert.show()
                        }
                        
                        
                        
                    }
                    //                    } catch {
                    //                    print("Error: \(error)")
                    //                }
                    
                    
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
