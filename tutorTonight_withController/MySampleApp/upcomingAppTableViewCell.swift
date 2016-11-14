//
//  upcomingAppTableViewCell.swift
//  MySampleApp
//
// 
//
//

import UIKit

class upcomingAppTableViewCell: UITableViewCell {
    @IBOutlet weak var ContactButton: UIButton!
    
    @IBOutlet weak var LessonDetail: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var BgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        ContactButton.layer.cornerRadius = 10.0
        BgView.layer.borderWidth = 3.0
        BgView.backgroundColor = UIColor.whiteColor()
        

        
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
