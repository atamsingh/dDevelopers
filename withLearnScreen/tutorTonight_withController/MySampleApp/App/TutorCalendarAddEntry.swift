//
//  TutorCalendarAddEntry.swift
//  MySampleApp
//
//  Created by Satinder Singh on 2016-12-03.
//
//

import UIKit
import Foundation


class TutorCalendarAddEntry: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBAction func addAvailability(sender: AnyObject) {
        availabilities.append(availability)
        print(availability)
        self.performSegueWithIdentifier("backToScheduleSeg", sender: nil)
    }
    
    @IBOutlet weak var pickerData: UIPickerView!
    
    let timeFormatter = NSDateFormatter()
    @IBOutlet weak var timeFromPicker: UIDatePicker!
    @IBAction func timeFromPickerChanged(sender: AnyObject) {
        setDateAndTime()
    }
    
    @IBOutlet weak var timeToPicker: UIDatePicker!
    @IBAction func timeToPickerChanged(sender: AnyObject) {
        setDateAndTime()
    }

    let days = ["Mondays", "Tuesdays", "Wednesdays", "Thursdays", "Fridays", "Saturdays", "Sundays"]
    var day = ""
    var timeFromStr = "a"
    var timeToStr = "b"
    var timeRange = "c"
    var availability = "d"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // INPUT PICKER DATA:
        pickerData.dataSource = self
        pickerData.delegate = self
    }

    //MARK: - Delegates and data sources
        //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return days.count
    }
        //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return days[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        day = days[row]
    }
    
    func setDateAndTime() {
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        timeFromStr  = timeFormatter.stringFromDate(timeFromPicker.date)
        timeToStr    = timeFormatter.stringFromDate(timeToPicker.date)
        timeRange    = timeFromStr + "-" + timeToStr
        availability = day + ": " + timeRange
    }
    
    
    
}
