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

class HomeViewController: UITableViewController {

    
    var sessions: [HomeSessionObject] = []
    var willEnterForegroundObserver: AnyObject!
    
    // MARK: - View lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        // You need to call `- updateTheme` here in case the sign-in happens before `- viewWillAppear:` is called.
        updateTheme()
        willEnterForegroundObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil, queue: NSOperationQueue.currentQueue()) { _ in
            self.updateTheme()
        }
        
        // SEND JSON REQUEST FOR COURSES
        let inputData: String = "{\"callType\":\"GET\",\"object\":\"COURSES\",\"data\":{}}"
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
                    
                    var i=1
                    for result in readableJSON["info"]["courses"].arrayValue {
                        let session = HomeSessionObject.init(
                            course: NSLocalizedString(result[String(i)].stringValue,comment: "course"),
                            date: NSLocalizedString("Mon \(i)-\(i+1)", comment: "time"),
                            icon: "ContentDeliveryCheckmark"
                        )
                        self.sessions.append(session)
                        i = i+1
                    }
                    self.tableView.reloadData()
                })
            }
            
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
        self.tableView.reloadData()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(willEnterForegroundObserver)
    }
    
    
    // MARK: - UITableViewController delegates
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainViewCell")!
        let session = sessions[indexPath.row]
        cell.textLabel!.text = session.course
        cell.detailTextLabel!.text = session.date
        cell.imageView!.image = UIImage(named: session.icon)
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    // WHEN A CELL IS SELECTED
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let session = sessions[indexPath.row]
        
        //POP UP CANCEL MSG
        let alert = UIAlertView()
        alert.title = session.course
        alert.message = session.date
        alert.addButtonWithTitle("Back")
        alert.addButtonWithTitle("Cancel")
        alert.show()
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

//class FeatureDescriptionViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Back", style: .Plain, target: nil, action: nil)
//    }
//}


extension String {
    private func makeJsonable() -> String {
        let resultComponents: NSArray = self.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        return resultComponents.componentsJoinedByString("")
    }
}
