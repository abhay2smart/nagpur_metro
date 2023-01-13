//
//  Contact_CheckStatus_ClosedCellTableViewCell.swift
//  NMRL
//
//  Created by Akhil Johny on 11/04/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit

class Contact_CheckStatus_ClosedCellTableViewCell: UITableViewCell {
    
    @IBOutlet var TimeLbl               : UILabel!
    @IBOutlet var StatusLbl             : UILabel!
    @IBOutlet var ReachLbl              : UILabel!
    @IBOutlet var ResolutionLbl         : UILabel!
    @IBOutlet var ClosedLbl             : UILabel!
    @IBOutlet var SupportButt           : UIButton!
    @IBOutlet var SupportHeadingLbl     : UILabel!
    @IBOutlet var Vw                    : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
