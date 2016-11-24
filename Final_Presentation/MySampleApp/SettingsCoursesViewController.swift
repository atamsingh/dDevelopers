//
//  MainViewController.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.4
//

import UIKit
import AWSMobileHubHelper


class SettingsCoursesViewController: UITableViewController {
    
    var courseList = [String]()
    var willEnterForegroundObserver: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        
        
        // SEND JSON REQUEST FOR COURSES
        let inputData: String = "{\"callType\"  : \"GET\",\"object\"    : \"COURSES\",\"data\"      : {}}"
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
        print("AWS JSON REQUEST: \(jsonInput)")
        
        
        // RECEIVE JSON
        AWSCloudLogic.defaultCloudLogic().invokeFunction(functionName, withParameters: parameters, completionBlock: {(result: AnyObject?, error: NSError?) -> Void in
            if let result = result {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let NSjsonStr = result as! NSString;
                    let NSdataStr = NSjsonStr.dataUsingEncoding(NSUTF8StringEncoding)!;
                    let readableJSON = JSON(data: NSdataStr, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    print (readableJSON)
                    //                    print (readableJSON["status"])
                    //                    print (readableJSON["info"])
                    //                    print (readableJSON["info"]["courses"])
                    //                    print (readableJSON["info"]["courses"][0])
                    //                    print (readableJSON["info"]["courses"][1]["2"])
                    //                    let numCourses = readableJSON["info"]["courses"].count
                    
                    var i=1
                    for result in readableJSON["info"]["courses"].arrayValue {
                        let courseName = result[String(i)].stringValue
                        //                        print (readableJSON["info"]["courses"][1]["2"])
                        print(courseName)
                        self.courseList.append(courseName)
                        i = i+1
                    }
                    print(self.courseList)
                    self.tableView.reloadData()
                })
            }
            
            if let error = error {
                var errorMessage: String
                if let cloudUserInfo = error.userInfo as? [String: AnyObject],
                    let cloudMessage = cloudUserInfo["errorMessage"] as? String {
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
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(willEnterForegroundObserver)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainViewCell")!
        cell.textLabel!.text = courseList[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseList.count
    }
    
    
    func updateTheme() {
        let settings = ColorThemeSettings.sharedInstance
        settings.loadSettings { (themeSettings: ColorThemeSettings?, error: NSError?) -> Void in
            guard let themeSettings = themeSettings else {
                print("Failed to load color: \(error)")
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                let titleTextColor: UIColor = themeSettings.theme.titleTextColor.UIColorFromARGB()
                self.navigationController!.navigationBar.barTintColor = themeSettings.theme.titleBarColor.UIColorFromARGB()
                self.view.backgroundColor = themeSettings.theme.backgroundColor.UIColorFromARGB()
                self.navigationController!.navigationBar.tintColor = titleTextColor
                self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: titleTextColor]
            })
        }
    }
}

extension String {
    private func makeJsonable() -> String {
        let resultComponents: NSArray = self.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        return resultComponents.componentsJoinedByString("")
    }
}
