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
    
    var demoFeatures = ["one", "two"]
    var willEnterForegroundObserver: AnyObject!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        updateTheme()
        willEnterForegroundObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil, queue: NSOperationQueue.currentQueue()) { _ in
            self.updateTheme()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(willEnterForegroundObserver)
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainViewCell")!
//        let demoFeature = demoFeatures[indexPath.row]
//        cell.imageView!.image = UIImage(named: demoFeature.icon)
//        cell.textLabel!.text = demoFeature.displayName
//        cell.detailTextLabel!.text = demoFeature.detailText
        cell.textLabel!.text = demoFeatures[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoFeatures.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
