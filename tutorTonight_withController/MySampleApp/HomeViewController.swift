//
//  HomeViewController.swift
//  MySampleApp
//
//  
//
//

import UIKit

var User_Name = ""
var Course_Name = ""
var Course_Date = ""
var From = ""
var To = ""
var UpcomingPrice = ""



extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
}


var UserName = "Atam"

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var i = 0
    
    var Lessons:[LessonData] = [LessonData]()
    

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var Welcome: UILabel!
    @IBOutlet weak var MessageLabel: UILabel!
    
    @IBOutlet weak var UpcomingTitle: UILabel!
   
    
    @IBOutlet weak var PreviousTitle: UILabel!
    
    
    @IBOutlet weak var PreviousAppTableView: UITableView!
    @IBOutlet weak var UpcomingAppTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        SettingLabelsANDViews()
        ParseJSON()
        
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        self.UpcomingAppTableView.reloadData()
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    func SettingLabelsANDViews() {
    
        
        
    
        scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: 1000.0)
    
        PreviousAppTableView.delegate = self
        PreviousAppTableView.dataSource = self
        
        
        
        TopView.backgroundColor = UIColor.whiteColor()
        Welcome.text = "Good Morning \(UserName)!"
        MessageLabel.text = "Ready To Learn Something New Today?"
        
        UpcomingTitle.text = "Upcoming Appointments"
        
        
        
        PreviousTitle.text = "Previous Appointments"
        
        

    
    
    }
    
    
    func ParseJSON() {
        
        
        


        let path: String = NSBundle.mainBundle().pathForResource("Appointments", ofType: "json") as String!
        
        
        let data = NSData(contentsOfFile: path) as NSData!
       
    
        let readableJSON = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
                
        
        
        while readableJSON["\(i)"] != nil {
        
        
            let LessonsResult = LessonData(Stars: readableJSON["\(i)"]["stars"].string!, Price: readableJSON["\(i)"]["price"].string!, UserName: readableJSON["\(i)"]["user"].string!, CourseName: readableJSON["\(i)"]["course_name"].string!, Date: readableJSON["\(i)"]["date"].string!, FromTime: readableJSON["\(i)"]["from_time"].string!, ToTime: readableJSON["\(i)"]["to_time"].string!)
            
            
            Lessons.append(LessonsResult)
            
            self.PreviousAppTableView.reloadData()
        
            
          i += 1
        }
        
        
        
        
    
    
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if tableView == self.PreviousAppTableView {
        
        return Lessons.count
            
            
        }else {
        
        return 1
        
        }
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        return 110
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        if tableView == self.PreviousAppTableView {
            
            
            
        let cell = tableView.dequeueReusableCellWithIdentifier("previousApp", forIndexPath: indexPath) as! previousAppTableViewCell
       
        
        cell.backgroundColor = UIColor.clearColor()
        
        
        let User_Name = Lessons[indexPath.row].UserName
        let Course_Name = Lessons[indexPath.row].CourseName
        let Course_Date = Lessons[indexPath.row].Date
        let From = Lessons[indexPath.row].FromTime
        let To = Lessons[indexPath.row].ToTime
        let Price = Lessons[indexPath.row].Price
        let Stars = Lessons[indexPath.row].Stars
        
        
        
        
        cell.LessonDetail.text = "Lesson With \(User_Name) for \(Course_Name) \n on \(Course_Date) from \(From) to \(To)"
        cell.PriceLabel.text = "$ \(Price)"
        
        
        
        
        
        
        
        if Stars == "1" {
            
            
            cell.Star1.image = UIImage(named: "Star-ON")
            
            
        }else if Stars == "2" {
            
            
            cell.Star1.image = UIImage(named: "Star-ON")
            cell.Star2.image = UIImage(named: "Star-ON")
            
            
        }else if Stars == "3" {
            
            
            cell.Star1.image = UIImage(named: "Star-ON")
            cell.Star2.image = UIImage(named: "Star-ON")
            cell.Star3.image = UIImage(named: "Star-ON")
            
            
        }else if Stars == "4" {
            
            
            cell.Star1.image = UIImage(named: "Star-ON")
            cell.Star2.image = UIImage(named: "Star-ON")
            cell.Star3.image = UIImage(named: "Star-ON")
            cell.Star4.image = UIImage(named: "Star-ON")
            
            
        }else {
            
            
            cell.Star1.image = UIImage(named: "Star-ON")
            cell.Star2.image = UIImage(named: "Star-ON")
            cell.Star3.image = UIImage(named: "Star-ON")
            cell.Star4.image = UIImage(named: "Star-ON")
            cell.Star5.image = UIImage(named: "Star-ON")
            
            
        }
        
        
        
        
        return cell
    
        }else {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("upcomingApp", forIndexPath: indexPath) as! upcomingAppTableViewCell
        
            
            
//            
//            if NSUserDefaults.valueForKey("price") != nil {
//            
//            cell.PriceLabel.text = "\(NSUserDefaults.valueForKey("price"))"
//                
//                
//            }else {
//            
//                cell.PriceLabel.text = ""
//                
//            
//            }
            
            
        
        
            cell.PriceLabel.text = UpcomingPrice
            cell.LessonDetail.text = "Lesson With \(User_Name) for \(Course_Name) \n on \(Course_Date) from \(From) to \(To)"
        
        
        
        
        
        
        return cell
        
        
        }
    }
    
    
    

}
