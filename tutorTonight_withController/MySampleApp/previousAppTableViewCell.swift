//
//  previousAppTableViewCell.swift
//  MySampleApp
//
//  
//
//

import UIKit

class previousAppTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var LessonDetail: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    
    @IBOutlet weak var Star1: UIImageView!
    @IBOutlet weak var Star2: UIImageView!
    @IBOutlet weak var Star3: UIImageView!
    @IBOutlet weak var Star4: UIImageView!
    @IBOutlet weak var Star5: UIImageView!

    @IBOutlet weak var BgView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        BgView.layer.borderWidth = 3.0
        BgView.backgroundColor = UIColor.whiteColor()
        
        
        
        
        
        
        
        
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
