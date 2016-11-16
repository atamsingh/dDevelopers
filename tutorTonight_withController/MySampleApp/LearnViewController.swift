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
    
    @IBOutlet weak var SearchField: UITextField!
    @IBOutlet weak var FromDate: UITextField!
    @IBOutlet weak var ToDate: UITextField!
    @IBOutlet weak var LocationField: UITextView!
    
    @IBOutlet weak var CalendarDatePicker: UIDatePicker!
    @IBOutlet weak var CostLabel: UILabel!
    
    @IBOutlet weak var FromTime: UILabel!
    @IBOutlet weak var ToTime: UILabel!
    
    
    
    var i = 0
    var Lessons = [String]()
    
    @IBAction func RequestAction(sender: AnyObject) {
        
        let getCourses: String = "{\"callType\"  : \"GET\",\"object\"    : \"COURSES\",\"data\"      : {}}";
        
        let functionName = "mainController";
        let jsonInput = getCourses.makeJsonable()
        let jsonData = jsonInput.dataUsingEncoding(NSUTF8StringEncoding)!
        var parameters: [String: AnyObject]
        do {
            let anyObj = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! [String: AnyObject]
            parameters = anyObj
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
            return
        }
        print("AWS JSON REQUEST: \(jsonInput)")
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(functionName, withParameters: parameters, completionBlock: {(result: AnyObject?, error: NSError?) -> Void in
            if let result = result {
                //RESULT is always "{\"status\":\"pass\",\"info\":{\"school\":\"Carleton University\",\"courses\":[{\"1\":\"COMP1001\"},{\"2\":\"COMP1005\"},{\"3\":\"COMP2001\"},{\"4\":\"COMP3001\"},{\"5\":\"HIST1001\"}]}}"
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let NSjsonStr = result as! NSString;
                    let NSdataStr = NSjsonStr.dataUsingEncoding(NSUTF8StringEncoding)!;
                    do {
                        let jsonArray: NSDictionary = try NSJSONSerialization.JSONObjectWithData(NSdataStr, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        
                        let status = jsonArray["status"]! as! String
                        let info = jsonArray["info"]!
                        
                        //WE NEED TO GET NEXT LEVEL, CAN WE REMOVE THE "[]" IN LAMBDA?
                        
                        if status == "fail" {
                            
                            let alert = UIAlertController(title: "Alert", message: "The Course You've Entered Does Not Exist", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                        } else {
                            // LOGIN SUCCESSFUL
                            
                            //Now we want to CREATE_SESSION with userID, SearchField.text!
                            //But for now we print
                            print("AWS Response info: \(info)")
                            //let courses = info["courses"]!
                            //print("AWS Response courses: \(courses)")
                            
                            
                            
                        }
                    } catch {
                        print("Error: \(error)")
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
                    print("Error occurred in invoking Lambda Function: \(error)")
                    //Do something with error message
                    let alertView = UIAlertController(title: NSLocalizedString("Error", comment: "Title bar for error alert."), message: error.localizedDescription, preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Button on alert dialog."), style: .Default, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                })
            }
        })
        
        
        
        
    }
    
    
    @IBAction func FromAction(sender: AnyObject) {
        
        
        CalendarDatePicker.hidden = false
        
    }
    
    
    @IBAction func ToAction(sender: AnyObject) {
        
        
        CalendarDatePicker.hidden = false
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
        
        SetFieldsANDButtons()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func SetFieldsANDButtons() {
        
        self.hideKeyboardWhenTappedAround()
        
        
        
        CalendarDatePicker.hidden = true
        
        LocationField.layer.borderWidth = 3.0
        SearchField.layer.borderWidth = 3.0
        FromDate.layer.borderWidth = 3.0
        ToDate.layer.borderWidth = 3.0
        
        CalendarDatePicker.addTarget(self, action: #selector(LearnViewController.dateValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        
    }
    
    
    
    
    // Date Picker Function To Change The Text In The Field
    
    
    func dateValueChanged (datePicker: UIDatePicker) {
        
        
        
        let dateformatter = NSDateFormatter()
        
        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        let dateValue = dateformatter.stringFromDate(datePicker.date)
        
        FromDate.text! = dateValue
        
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
}

extension String {
    private func makeJsonable() -> String {
        let resultComponents: NSArray = self.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        return resultComponents.componentsJoinedByString("")
    }
}
