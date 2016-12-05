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

class TeachSessionViewController: UITableViewController {
    
    struct sessionDetails {
        static var id = ""
        static var course = ""
        static var date = ""
        static var startTime = ""
        static var endTime = ""
        static var studentRating = ""
    }
    
    var sessions: [TutorSessionObject] = []
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
        /* TEST
         {
         "callType"  : "GET",
         "object"    : "PENDING_SESSIONS",
         "data"      : {
         }
         }
         */
        let inputData: String = "{\"callType\":\"GET\",\"object\":\"PENDING_SESSIONS\",\"data\":{}}"
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
//                    let NSjsonStr = "{\"status\":\"pass\",\"info\":{\"sessions\":[{\"sessionID\":\"80246b78-370b-496d-90fa-d2af1f99d91e|~~|8\",\"sessionDate\":\"Nov 12, 2016\",\"courseName\":\"HIST1001\",\"startTime\":\"10:00\",\"studentID\":\"80246b78-370b-496d-90fa-d2af1f99d91e\",\"endTime\":\"14:00\"},{\"sessionID\":\"80246b78-370b-496d-90fa-d2af1f99d91e|~~|2\",\"sessionDate\":\"Nov 12, 2016\",\"courseName\":\"COMP1001\",\"startTime\":\"10:00\",\"studentID\":\"80246b78-370b-496d-90fa-d2af1f99d91e\",\"endTime\":\"14:00\"}]}}"
                    let NSdataStr = NSjsonStr.dataUsingEncoding(NSUTF8StringEncoding)!;
                    let readableJSON = JSON(data: NSdataStr, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    print ("AWS RESPONSE:")
                    print (readableJSON)
//                    print (NSdataStr)
//                    print (readableJSON)
//                    {
//                        \"status\": \"pass\",
//                        \"info\": {
//                        \"sessions\": [
//                        {
//                            \"sessionID\": \"80246b78-370b-496d-90fa-d2af1f99d91e|~~|8\",
//                            \"sessionDate\": \"Nov 12,2016\",
//                            \"courseName\": \"HIST1001\",
//                            \"startTime\": \"10: 00\",
//                            \"studentID\": \"80246b78-370b-496d-90fa-d2af1f99d91e\",
//                            \"endTime\": \"14: 00\"
//                        }
                    
                    for result in readableJSON["info"]["sessions"].arrayValue {
                        let session = TutorSessionObject.init(
                            id:   NSLocalizedString(result["sessionID"].stringValue,comment: "id"),
                            name: NSLocalizedString(result["courseName"].stringValue,comment: "course"),
                            date: NSLocalizedString(result["sessionDate"].stringValue, comment: "date"),
                            startTime: NSLocalizedString(result["startTime"].stringValue,comment: "startTime"),
                            endTime: NSLocalizedString(result["endTime"].stringValue, comment: "endTime"),
                            icon: "MonetizationEvent",
                            seg: "tutorSessionSeg"
                        )
                        self.sessions.append(session)
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
        cell.imageView!.image = UIImage(named: session.icon)
        cell.textLabel!.text = session.name
        cell.detailTextLabel!.text = session.date + " " + session.startTime + "-" + session.endTime
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    // WHEN A CELL IS SELECTED
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let session = sessions[indexPath.row]
//        let storyboard = UIStoryboard(name: session.storyboard, bundle: nil)
//        let viewController = storyboard.instantiateViewControllerWithIdentifier(session.storyboard)
//                self.navigationController!.pushViewController(viewController, animated: true)
        sessionDetails.course = session.name
        sessionDetails.date = session.date
        sessionDetails.startTime = session.startTime
        sessionDetails.endTime = session.endTime
        self.performSegueWithIdentifier(session.seg, sender: nil)
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
