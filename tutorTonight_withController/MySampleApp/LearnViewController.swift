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


extension String {
    private func makeJsonable() -> String {
        let resultComponents: NSArray = self.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        return resultComponents.componentsJoinedByString("")
    }
}


class LearnViewController: UIViewController {
    
    
    var datePickerView:UIDatePicker = UIDatePicker()
    var TimePickerView1:UIDatePicker = UIDatePicker()
    var TimePickerView2:UIDatePicker = UIDatePicker()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var FromTime: UITextField!
    @IBOutlet weak var ToTime: UITextField!
    
    
    @IBOutlet weak var SearchField: UITextField!
    @IBOutlet weak var FromDate: UITextField!
    
    @IBOutlet weak var LocationField: UITextView!
    
    
    @IBOutlet weak var CostLabel: UILabel!
    
    
    
    
    // From Time Picker
    
    @IBAction func StartTimePicker(sender: UITextField) {
        
        
        
        
        TimePickerView2.datePickerMode = UIDatePickerMode.Time
        
        
        
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(LearnViewController.FromdonePicker(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        
        
        sender.inputView = TimePickerView2
        sender.inputAccessoryView = toolBar
        
        TimePickerView2.addTarget(self, action: #selector(LearnViewController.FromTimePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    // To Time Picker
    
    @IBAction func StartToTime(sender: UITextField) {
        
        
        
        TimePickerView1.datePickerMode = UIDatePickerMode.Time
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(LearnViewController.TodonePicker(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        
        
        sender.inputView = TimePickerView1
        sender.inputAccessoryView = toolBar
        
        TimePickerView1.addTarget(self, action: #selector(LearnViewController.ToTimePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        
        
        
    }
    
    
    
    
    // Date Picker
    
    @IBAction func StartDatePicker(sender: UITextField) {
        
        
        
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(LearnViewController.DatedonePicker(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        
        
        sender.inputView = datePickerView
        sender.inputAccessoryView = toolBar
        
        datePickerView.addTarget(self, action: #selector(LearnViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        
        
        
        
    }
    
    
    
    var i = 0
    var Lessons = [String]()
    
    
    

    
    
    
    func DatedonePicker (sender:UIBarButtonItem)
    {
        
        print("\(FromDate.text!)")
        
        self.dismissKeyboard()
        
    }
    
    
    func FromdonePicker (sender:UIBarButtonItem)
    {
        
        print("\(FromTime.text!)")
        
       self.dismissKeyboard()
        
    }
    
    
    func TodonePicker (sender:UIBarButtonItem)
    {
        
        print("\(ToTime.text!)")
        
        self.dismissKeyboard()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
        
        SetFieldsANDButtons()
        activityIndicator.hidden  = true
        
        
        
        
        
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func SetFieldsANDButtons() {
        
        self.hideKeyboardWhenTappedAround()
        
        
        
        
        
        LocationField.layer.borderWidth = 3.0
        SearchField.layer.borderWidth = 3.0
        FromDate.layer.borderWidth = 3.0
        
        
        
        
        
    }
    
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = .MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        FromDate.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    
    
    
    func FromTimePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter1 = NSDateFormatter()
        
        dateFormatter1.dateStyle = NSDateFormatterStyle.NoStyle
        
        
        
        dateFormatter1.dateFormat = "HH:mm"
        
        FromTime.text = dateFormatter1.stringFromDate(sender.date)
        
    }
    
    
    
    
    func ToTimePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        
        
        dateFormatter.dateFormat = "HH:mm"
        
        ToTime.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return false
    }
    
    
    @IBAction func RequestAction(sender: AnyObject) {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
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
                        self.activityIndicator.hidden = true
                        self.activityIndicator.stopAnimating()
                        
                    } else {
                        // LOGIN SUCCESSFUL
                        
                        //Now we want to CREATE_SESSION with userID, SearchField.text!
                        //But for now we print
                        //print("AWS Response info: \(info)")
                        //let courses = info["courses"]!
                        //print("AWS Response courses: \(courses)")
                        
                        //let createSession: String = "{\"callType\": \"CREATE\",\"object\": \"SESSION\",\"data\": {\"studentID\": \"\(LoginViewController.myGlobals.globalUserID)\",\"course\": \"\(SearchField.text!)\",\"date\": \"Nov 13, 2016\",\"start\":\"10:00\",\"end\": \"14:00\"}"
                        
                        //if SearchField.text! == one of the elements in "courses" then
                        
                        let numCourses = readableJSON["info"]["courses"].count
                        
                        print(numCourses)
                        
                        var courseName = "" 
                        var i=1
                        for result in readableJSON["info"]["courses"].arrayValue {
                            courseName = result[String(i)].stringValue
                            if courseName == self.SearchField.text! {
                                let sessionStr: String = "{\"callType\": \"CREATE\",\"object\": \"SESSION\",\"data\": {\"studentID\": \"\(LoginViewController.myGlobals.globalUserID)\",\"course\": \"\(self.SearchField.text!)\",\"date\": \"\(self.FromDate.text!)\",\"start\": \"\(self.FromTime.text!)\",\"end\": \"\(self.ToTime.text!)\"}}"
                                
                                
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
                                                self.activityIndicator.hidden = true
                                                self.activityIndicator.stopAnimating()
                                                
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
                            
                            
                            self.activityIndicator.hidden = true
                            self.activityIndicator.stopAnimating()
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
                    
                    self.activityIndicator.hidden = true
                    self.activityIndicator.stopAnimating()
                })
            }
        })
        
    }
}

