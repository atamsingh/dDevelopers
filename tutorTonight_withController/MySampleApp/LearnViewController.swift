//
//  LearnViewController.swift
//  MySampleApp
//
//  
//
//

import UIKit

class LearnViewController: UIViewController {

    @IBOutlet weak var SearchField: UITextField!
    @IBOutlet weak var FromDate: UITextField!
    @IBOutlet weak var ToDate: UITextField!
    @IBOutlet weak var LocationField: UITextView!
    
    @IBOutlet weak var CalendarDatePicker: UIDatePicker!
    @IBOutlet weak var CostLabel: UILabel!
    
    @IBOutlet weak var FromTime: UILabel!
    @IBOutlet weak var ToTime: UILabel!
    
    
    @IBAction func RequestAction(sender: AnyObject) {
        
        
        //performSegueWithIdentifier("request", sender: self)
        
        
        
        
        let alert = UIAlertController(title: "1 hour", message: "This session is going to cost \(CostLabel.text!) \n Are you sure you want to proceed?", preferredStyle: .Alert)
        
        
        
        
        
        alert.addAction(UIAlertAction(title: "YES", style: .Default, handler: { action in
            switch action.style{
                
            case .Default:
                
                //self.performSegueWithIdentifier("cancel", sender: self)
                
                _ = self.tabBarController?.selectedIndex = 0
                
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: { (action: UIAlertAction!) in
            
            alert .dismissViewControllerAnimated(true, completion: nil)
            
            
        }))
        
        
        User_Name = "Path Morin"
        Course_Name = "\(SearchField.text!)"
        Course_Date =  "\(FromDate.text!)"
        From = "\(FromTime.text!)"
        To = "\(ToTime.text!)"
        UpcomingPrice = "\(CostLabel.text!)"
        
        
        
        
//        NSUserDefaults.standardUserDefaults().setValue("Path Morin", forKey: "user")
//        NSUserDefaults.standardUserDefaults().setValue("\(SearchField.text!)", forKey: "coursename")
//        NSUserDefaults.standardUserDefaults().setValue("\(FromDate.text!)", forKey: "fromDate")
//        NSUserDefaults.standardUserDefaults().setValue("\(FromTime.text!)", forKey: "fromTime")
//        NSUserDefaults.standardUserDefaults().setValue("\(ToTime.text!)", forKey: "toTime")
//        NSUserDefaults.standardUserDefaults().setValue("\(CostLabel.text!)", forKey: "price")
        
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
        
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
