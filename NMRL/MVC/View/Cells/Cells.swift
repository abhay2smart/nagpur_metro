//
//  MyTicketTableViewCell.swift
//  NMRL
//
//  Created by Akhil Johny on 05/09/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit

class MyTicketTableViewCell: UITableViewCell {
    
    @IBOutlet var ViewButt      : UIButton!
    @IBOutlet var ExpiryLbl     : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let userUpdateNotification = Notification.Name("userUpdate")
        NotificationCenter.default.addObserver(self, selector: #selector(ReceivedStr(str:)), name: userUpdateNotification, object: nil)
    }
    
    @objc func ReceivedStr(str : NSNotification) {
        self.ExpiryLbl.text = str.userInfo!["name"] as? String
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
