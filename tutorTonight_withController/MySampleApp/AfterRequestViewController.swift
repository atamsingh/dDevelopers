//
//  AfterRequestViewController.swift
//  MySampleApp
//
//  Created by Arzaan Irani on 2016-11-16.  
//
//

import UIKit

class AfterRequestViewController: UIViewController {

    @IBOutlet weak var BackgroundView: UIView!
    @IBOutlet weak var DetailsLabel: UILabel!
    
    @IBAction func CancelAction(sender: AnyObject) {
        
        // Show Alert Message
        

        
        
        let alert = UIAlertController(title: "Cancel", message: "Are you sure you want to \n cancel the request?You will be \n charged a non refundable fee \n of $5.00 CAD if the request \n has already been accepted by a tutor", preferredStyle: .Alert)
        
     
        
        
        alert.addAction(UIAlertAction(title: "YES", style: .Default, handler: { action in
            switch action.style{
                
            case .Default:
                
                self.performSegueWithIdentifier("cancel", sender: self)
               
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "NO", style: .Cancel, handler: { (action: UIAlertAction!) in
            
            alert .dismissViewControllerAnimated(true, completion: nil)
            
            
        }))

        
        self.presentViewController(alert, animated: true, completion: nil)
        
        

        
    
    
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        SetFieldsANDLabels()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func SetFieldsANDLabels() {
    
    
        BackgroundView.layer.borderWidth = 3.0
        BackgroundView.backgroundColor = UIColor.whiteColor()
        
        DetailsLabel.backgroundColor = UIColor.whiteColor()
        
    
    
    
    }


}
