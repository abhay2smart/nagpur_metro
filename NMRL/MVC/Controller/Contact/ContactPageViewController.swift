//
//  ContactPageViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 09/04/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit
import Alamofire

class ContactPageViewController: UIViewController {
    
    @IBOutlet var Scroll: SPSignIn!
    @IBOutlet var InternetBlackView: UIView!
    @IBOutlet var btnLogout: UIButton!
    
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
    
    //MARK: - Actions
    @IBAction func RaiseAComplaint(_ sender: Any) {
        let Contact_RaiseViewController = self.storyboard?.instantiateViewController(withIdentifier: "Contact_RaiseViewController") as! Contact_RaiseViewController
        self.navigationController?.pushViewController(Contact_RaiseViewController, animated: true)
    }
    
    @IBAction func ShareFeedback(_ sender: Any) {
        let Contact_FeedbackViewController = self.storyboard?.instantiateViewController(withIdentifier: "Contact_FeedbackViewController") as! Contact_FeedbackViewController
        self.navigationController?.pushViewController(Contact_FeedbackViewController, animated: true)
    }
    
    @IBAction func ToComplement(_ sender: Any) {
        let Contact_ComplimentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Contact_ComplimentViewController") as! Contact_ComplimentViewController
        self.navigationController?.pushViewController(Contact_ComplimentViewController, animated: true)
    }
    
    @IBAction func ToLostAndFound(_ sender: Any) {
        let Contact_LostFoundViewController = self.storyboard?.instantiateViewController(withIdentifier: "Contact_LostFoundViewController") as! Contact_LostFoundViewController
        self.navigationController?.pushViewController(Contact_LostFoundViewController, animated: true)
    }
    
    @IBAction func PublicGrievience(_ sender: Any) {
        let PublicGrivienceViewController = self.storyboard?.instantiateViewController(withIdentifier: "PublicGrivienceViewController") as! PublicGrivienceViewController
        self.navigationController?.pushViewController(PublicGrivienceViewController, animated: true)
    }
    
    //MARK: - To Status
    @IBAction func CheckStatus(_ sender: Any) {
        let Contact_CheckStatusViewController = self.storyboard?.instantiateViewController(withIdentifier: "Contact_CheckStatusViewController") as! Contact_CheckStatusViewController
        self.navigationController?.pushViewController(Contact_CheckStatusViewController, animated: true)
    }
    
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
