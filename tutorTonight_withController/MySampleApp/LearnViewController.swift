//
//  LearnViewController.swift
//  MySampleApp
//
//  Created by Arzaan Irani on 2016-11-10.
//
//

import UIKit

class LearnViewController: UIViewController {

    @IBOutlet weak var SearchField: UITextField!
    @IBOutlet weak var FromDate: UITextField!
    @IBOutlet weak var ToDate: UITextField!
    @IBOutlet weak var LocationField: UITextView!
    
    @IBOutlet weak var CalendarDatePicker: UIDatePicker!
    
    @IBAction func RequestAction(sender: AnyObject) {
        
        
        performSegueWithIdentifier("request", sender: self)
        
        
        
    }
    
    
    @IBAction func FromAction(sender: AnyObject) {
        
        
        //CalendarDatePicker.hidden = false
        
    }
    
    
    @IBAction func ToAction(sender: AnyObject) {
        
        
        //CalendarDatePicker.hidden = false

        
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

        
        
        
        
        
        
//        CalendarDatePicker.addTarget(self, action: #selector(LearnViewController.dateValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    
    
    }

    
    
    
    // Date Picker Function To Change The Text In The Field //
    
    
//    func dateValueChanged (datePicker: UIDatePicker) {
//        
//        
//        
//        let dateformatter = NSDateFormatter()
//        
//        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
//        dateformatter.timeStyle = NSDateFormatterStyle.NoStyle
//        
//        let dateValue = dateformatter.stringFromDate(datePicker.date)
//        
//        FromDate.text! = dateValue
//        
//    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }


}
