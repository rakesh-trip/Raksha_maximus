//
//  CustomCell.swift
//  Raksha
//
//  Created by Admin on 17/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//


//class to define custm cells in the app used in SelectCardVC and LatestTransactions VC
import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var lblCard: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblexpDate: UILabel!
    
    @IBOutlet weak var imgCard: UIImageView!

    @IBOutlet weak var lblTransDate: UILabel!
    
    @IBOutlet weak var lblTransAmt: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
