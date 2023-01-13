//
//  Contact_ComplaintDetailsViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 22/04/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit
import Alamofire
import CoreData


class Contact_ComplaintDetailsViewController: UIViewController {

    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var Scroll: SPSignIn!
    
    @IBOutlet var InternetBlackView: UIView!
    
     
    
    @IBOutlet var WhiteVw: UIView!
    
    @IBOutlet var RequestLbl: UILabel!
    
    @IBOutlet var HeadingLbl: UILabel!
    
    @IBOutlet var DateLbl: UILabel!
    
    @IBOutlet var StatusLbl: UILabel!
    
    @IBOutlet var ComplaintTypeLbl: UILabel!
    
    @IBOutlet var SubComplaintLbl: UILabel!
    
    @IBOutlet var LocationLbl: UILabel!
    
    @IBOutlet var StationLbl: UILabel!
    
    
    @IBOutlet var ComplaintDescLbl: UILabel!
    
    @IBOutlet var SolutionHeading: UILabel!
    
    @IBOutlet var SolutionDescLbl: UILabel!
    
    @IBOutlet var SolutionLine: UILabel!
    
    var RequestStr = String()
    
    var HeadingStr = String()
    
    var DateStr = String()
    
    var StatusStr = String()
    
    var ComplaintStr = String()
    
    var SubComplaintStr = String()
    
    var LocationStr = String()
    
    var StationStr = String()
    
    var ComplaintDescStr = String()
    
    var SolutionDescStr = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        InternetBlackView.isHidden = true
        
        LogoutBlaceView.isHidden = true
        
        
        RequestLbl.text = "\(RequestStr)"
        
       // print("HeadingStr : \(HeadingStr)")
        
        HeadingLbl.text = HeadingStr
        
        if HeadingStr == ""
        {
            HeadingLbl.text = "No description provided"
        }
        
        DateLbl.text = "\(DateStr)"
        
        StatusLbl.text = "\(StatusStr)"
        
        ComplaintTypeLbl.text = ComplaintStr
        
        SubComplaintLbl.text = SubComplaintStr
        
        if ComplaintStr == ""
        {
            ComplaintTypeLbl.text = "Complaint type not available."
        }
        
        if SubComplaintStr == ""
        {
            SubComplaintLbl.text = "Sub complaint not available."
        }
        
        LocationLbl.text = LocationStr
        
        if LocationStr == ""
        {
            LocationLbl.text = "Location not available."
        }
        
        
        
        StationLbl.text = StationStr
        
        if StationStr == ""
        {
            StationLbl.text = "Station details not availble"
        }
        
        ComplaintDescLbl.text = ComplaintDescStr
        
        if ComplaintDescStr == ""
        {
            ComplaintDescLbl.text = "Complaint details not available."
        }
        
        SolutionDescLbl.text = SolutionDescStr
        
        SolutionHeading.isHidden = true
        SolutionDescLbl.isHidden = true
        SolutionLine.isHidden = true
        
        WhiteVw.layer.borderWidth = 0.5
        WhiteVw.layer.borderColor = UIColor.black.cgColor
        
        WhiteVw.layer.cornerRadius = 5
        WhiteVw.clipsToBounds = true
        
        
        Scroll.contentSize = CGSize(width : 0, height : 1000)
        
        if DeviceType.IS_IPHONE_5
        {
            Scroll.contentSize = CGSize(width : 0, height : 1100)
        }
        else if DeviceType.IS_IPHONE_6
        {
            Scroll.contentSize = CGSize(width : 0, height : 1200)
        }
        else if DeviceType.IS_IPHONE_6P
        {
            Scroll.contentSize = CGSize(width : 0, height : 1300)
        }
        else if DeviceType.IS_IPHONE_X
        {
            Scroll.contentSize = CGSize(width : 0, height : 1450)
        }
        else if DeviceType.IS_IPHONE_XP
        {
            Scroll.contentSize = CGSize(width : 0, height : 1550)
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func OK(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Internet
    
    @IBAction func InternetOK(_ sender: Any) {
        
        InternetBlackView.isHidden = true
    }
    
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Log Out View
    
    @IBOutlet var LogoutBlaceView: UIView!
    
    @IBAction func LogOutClicked(_ sender: Any) {
        
        LogoutBlaceView.isHidden = false
    }
    
    @IBAction func LogOK(_ sender: Any) {
        kAppDelegate.shared.logoutCurrentUser { (success) in
                self.LogoutBlaceView.isHidden = true
                self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func LogCancel(_ sender: Any) {
        LogoutBlaceView.isHidden = true
    }
}
