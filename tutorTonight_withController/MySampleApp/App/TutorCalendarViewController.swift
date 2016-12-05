//
//  TutorCalendarViewController.swift
//  MySampleApp
//
//  Created by Satinder Singh on 2016-12-03.
//
//

import Foundation
import UIKit
import MessageUI

var availabilities = [String]()

class TutorCalendarViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate{
    
    
    @IBOutlet weak var myTableView: UITableView!
    var msgBody = ""
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (availabilities.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.textLabel?.text = availabilities[indexPath.row]
        return (cell)
    }
    
    //SWIPE LEFT TO DELETE
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            availabilities.removeAtIndex(indexPath.row)
            myTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureMailComposedViewController() ->MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["becomeAtutor@tutorTonight.ca"])
        mailComposerVC.setSubject("I want to Tutor!")
        msgBody += "Hi!\nMy Name is \(LoginViewController.myGlobals.globalFirstName) \(LoginViewController.myGlobals.globalLastName) and I want to become a tutor!\n\nHere is my availability:\n\n"
        for avail: String in availabilities {
            msgBody += avail + "\n"
        }
        mailComposerVC.setMessageBody(msgBody, isHTML: false)
        print(msgBody)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Mail", message: "Check Your e-mail settings bro", delegate: self, cancelButtonTitle: "Ok")
        sendMailErrorAlert.show()
        self.performSegueWithIdentifier("teachToHomeSeg", sender: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result {
        case MFMailComposeResult.Cancelled:
            print("cancelled")
//            self.performSegueWithIdentifier("teachToHomeSeg", sender: nil)
        case MFMailComposeResult.Sent:
            print("sent")
//            self.performSegueWithIdentifier("teachToHomeSeg", sender: nil)
        default: break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func confirmScheduleButton(sender: AnyObject) {
        let mailComposedViewController = configureMailComposedViewController()
//        if MFMailComposeViewController.canSendMail(){
//            self.presentViewController(mailComposedViewController, animated: true, completion: nil)
//        } else {
//            self.showSendMailErrorAlert()
//        }
//        self.presentViewController(mailComposedViewController, animated: true, completion: nil)

    }
    
}
