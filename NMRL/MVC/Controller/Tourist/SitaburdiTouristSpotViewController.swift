//
//  SitaburdiTouristSpotViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 25/04/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class SitaburdiTouristSpotViewController: UIViewController {
    
    @IBOutlet var btnLogout             : UIButton!
    @IBOutlet var InternetBlackView     : UIView!
    @IBOutlet var LogoutBlaceView       : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        InternetBlackView.isHidden = true
        LogoutBlaceView.isHidden = true
    }
    
    //MARK: - Log Out View
    @IBAction func LogOutClicked(_ sender: Any) {
        LogoutBlaceView.isHidden = false
    }
    
    @IBAction func LogCancel(_ sender: Any) {
        LogoutBlaceView.isHidden = true
    }
    
    @IBAction func InternetOK(_ sender: Any) {
        InternetBlackView.isHidden = true
    }
    
    @IBAction func LogOK(_ sender: Any) {
        kAppDelegate.shared.logoutCurrentUser { (success) in
            self.LogoutBlaceView.isHidden = true
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
