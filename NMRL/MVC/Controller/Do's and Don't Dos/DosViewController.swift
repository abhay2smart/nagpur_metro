//
//  DosViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 17/04/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class DosViewController: UIViewController {
    
    @IBOutlet var Scroll            : UIScrollView!
    @IBOutlet var btnLogout         : UIButton!
    @IBOutlet var LogoutBlaceView   : UIView!
    @IBOutlet var InternetBlackView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        LogoutBlaceView.isHidden = true
        if DeviceType.IS_IPHONE_5 {
            Scroll.contentSize = CGSize(width : 0, height : 1400)
        }else if DeviceType.IS_IPHONE_6 {
            Scroll.contentSize = CGSize(width : 0, height : 1500)
        }else if DeviceType.IS_IPHONE_6P {
            Scroll.contentSize = CGSize(width : 0, height : 1700)
        }else if DeviceType.IS_IPHONE_X {
            Scroll.contentSize = CGSize(width : 0, height : 1850)
        }else if DeviceType.IS_IPHONE_XP {
            Scroll.contentSize = CGSize(width : 0, height : 1950)
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
}
