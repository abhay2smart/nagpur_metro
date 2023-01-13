//
//  ContactUsViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 05/11/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import Alamofire

class SupportCenterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var Scroll            : SPSignIn!
    @IBOutlet var Line1             : UILabel!
    @IBOutlet var Line2             : UILabel!
    @IBOutlet var RaiseView         : UIView!
    @IBOutlet var ShareView         : UIView!
    @IBOutlet var EmailField        : UITextField!
    @IBOutlet var MessageField      : UITextField!
    @IBOutlet var HelpBlackView     : UIView!
    @IBOutlet var InternetBlackView : UIView!
    @IBOutlet var LogoutBlaceView   : UIView!

    var tapGestureRecognizer        : UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        HelpBlackView.isHidden = true
        InternetBlackView.isHidden = true
        LogoutBlaceView.isHidden = true
        
        let leftView = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: self.EmailField.frame.height))
        leftView.backgroundColor = .clear
        EmailField.leftView = leftView
        EmailField.leftViewMode = .always
        EmailField.contentVerticalAlignment = .center
        EmailField.delegate = self
        
        let leftView1 = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: self.MessageField.frame.height))
        leftView1.backgroundColor = .clear
        MessageField.leftView = leftView1
        MessageField.leftViewMode = .always
        MessageField.contentVerticalAlignment = .center
        MessageField.delegate = self
        EmailField.text = UserData.current?.customerInfo?.emailAddress!
        Scroll.contentSize = CGSize(width : 0, height : 1000)
        if DeviceType.IS_IPHONE_5 {
            Scroll.contentSize = CGSize(width : 0, height : 700)
        }else if DeviceType.IS_IPHONE_6 {
            Scroll.contentSize = CGSize(width : 0, height : 800)
        }else if DeviceType.IS_IPHONE_6P {
            Scroll.contentSize = CGSize(width : 0, height : 900)
        }else if DeviceType.IS_IPHONE_X {
            Scroll.contentSize = CGSize(width : 0, height : 1000)
        }else if DeviceType.IS_IPHONE_XP {
            Scroll.contentSize = CGSize(width : 0, height : 1000)
        }
        RaiseView.layer.cornerRadius = 5
        RaiseView.layer.borderWidth = 2
        RaiseView.layer.borderColor = UIColor.lightGray.cgColor
        RaiseView.clipsToBounds = true
        ShareView.layer.cornerRadius = 5
        ShareView.layer.borderWidth = 2
        ShareView.layer.borderColor = UIColor.lightGray.cgColor
        ShareView.clipsToBounds = true
    tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        Scroll.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        Line1.frame = CGRect(x: Line1.frame.origin.x, y: Line1.frame.origin.y, width: Line1.frame.width, height: 1)
        Line2.frame = CGRect(x: Line2.frame.origin.x, y: Line2.frame.origin.y, width: Line2.frame.width, height: 1)
        self.Scroll.setContentOffset(CGPoint.zero, animated: true)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Line1.frame = CGRect(x: Line1.frame.origin.x, y: Line1.frame.origin.y, width: Line1.frame.width, height: 1)
        Line2.frame = CGRect(x: Line2.frame.origin.x, y: Line2.frame.origin.y, width: Line2.frame.width, height: 1)
        self.Scroll.setContentOffset(CGPoint.zero, animated: true)
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == EmailField {
            Line1.frame = CGRect(x: Line1.frame.origin.x, y: Line1.frame.origin.y, width: Line1.frame.width, height: 2)
            Line2.frame = CGRect(x: Line2.frame.origin.x, y: Line2.frame.origin.y, width: Line2.frame.width, height: 1)
        }else {
            Line1.frame = CGRect(x: Line1.frame.origin.x, y: Line1.frame.origin.y, width: Line1.frame.width, height: 1)
            Line2.frame = CGRect(x: Line2.frame.origin.x, y: Line2.frame.origin.y, width: Line2.frame.width, height: 2)
        }
    }
    
    @IBAction func InternetOK(_ sender: Any) {
        InternetBlackView.isHidden = true
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Log Out View
    @IBAction func LogOutClicked(_ sender: Any) {
        LogoutBlaceView.isHidden = false
    }
    
    @IBAction func ToFeedBack(_ sender: Any) {
        let ContactUsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
        self.navigationController?.pushViewController(ContactUsViewController, animated: true)
    }
    
    @IBAction func ToRaise(_ sender: Any) {
        let RaiseComplaintViewController = self.storyboard?.instantiateViewController(withIdentifier: "RaiseComplaintViewController") as! RaiseComplaintViewController
        self.navigationController?.pushViewController(RaiseComplaintViewController, animated: true)
    }
    
    @IBAction func PublicGrievience(_ sender: Any) {
        let PublicGrivienceViewController = self.storyboard?.instantiateViewController(withIdentifier: "PublicGrivienceViewController") as! PublicGrivienceViewController
        self.navigationController?.pushViewController(PublicGrivienceViewController, animated: true)
    }
    
    @IBAction func ShowHelpView(_ sender: Any) {
        HelpBlackView.isHidden = false
    }
    
    @IBAction func OKHideHelp(_ sender: Any) {
        HelpBlackView.isHidden = true
    }
    
    @IBAction func Submit(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
        }else {
            print("No internet.")
            InternetBlackView.isHidden = false
            return
        }
        if EmailField.text == ""{
        kAppDelegate.shared.showAlert(self, message: "Enter your email address")
        }else if MessageField.text == "" {
            kAppDelegate.shared.showAlert(self, message: "Enter your message")
        }else {
            sleep(1)
            kAppDelegate.shared.showAlert(self, message: "Your message submitted.")
        }
        
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

