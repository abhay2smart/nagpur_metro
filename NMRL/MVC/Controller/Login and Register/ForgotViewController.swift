//
//  ForgotViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 31/07/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit

import Alamofire

class ForgotViewController: UIViewController, UITextFieldDelegate {
 
    @IBOutlet var Scroll        : SPSignInSignInPage!
    @IBOutlet var Email         : UITextField!
    @IBOutlet var SubmitButt    : UIButton!
    
    var tapGestureRecognizer    : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Email.delegate = self
        // SubmitButt.Shadow()
        
        Scroll.contentSize = CGSize(width : 0, height : 1000)
        if DeviceType.IS_IPHONE_5 {
            Scroll.contentSize = CGSize(width : 0, height : 700)
        }else if DeviceType.IS_IPHONE_6 {
            Scroll.contentSize = CGSize(width : 0, height : 800)
        }else if DeviceType.IS_IPHONE_6P {
            Scroll.contentSize = CGSize(width : 0, height : 900)
        }else if DeviceType.IS_IPHONE_X {
            Scroll.contentSize = CGSize(width : 0, height : 1000)
        }
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        Scroll.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        self.Scroll.setContentOffset(CGPoint.zero, animated: true)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.Scroll.setContentOffset(CGPoint.zero, animated: true)
        self.view.endEditing(true)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Sumbit(_ sender: Any) {
        if (Email.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please enter your registered email id or phone number.")
        }else {
            var txt = Email.text!
            Email.text! = txt.replacingOccurrences(of: " ", with: "")
            txt = Email.text!
            let val = Int(txt)
            if val != nil {
                print("Valid Integer")
                
                if !(Email.text?.isPhoneNumber)! {
                    kAppDelegate.shared.showAlert(self, message: "Please enter your valid phone number")
                }else {
                    ForgotPasswordMobileNumber(val: txt)
                }
                return
            }
            
            if !(Email.text?.isEmail)! {
                kAppDelegate.shared.showAlert(self, message: "Please enter your valid email address")
                return
            }
            let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers1 = ["authorization": "Basic \(base64Credentials)"]
            
            let url = "\(APILink)forgotPassword"
            
            let parameters: [String: Any] = [
                "email" : Email.text!
            ]
            
            print(parameters)
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show(withStatus: "Loading...")
            sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                SVProgressHUD.dismiss()
                print(dataResponse.result.value!)
                if let dict = dataResponse.result.value as? NSDictionary {
                    if let result = dict["resultType"] as? Int {
                        if result == 1 {
                            if let tok = dict["token"] as? String {
                                UserData.current?.token  = tok
                                do {
                                    let userData = try JSONEncoder().encode(UserData.current!)
                                    let decoded = try JSONSerialization.jsonObject(with: userData, options: [])
                                     UserData.current = UserData.current!
                                        kAppDelegate.shared.saveLoggedUserdetails(decoded as! NSDictionary)
                                    print(decoded as! NSDictionary)
                                }catch {
                                    
                                }
                                OTPPageHeading = "Verify OTP"
                                let VerifyViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController")
                                self.navigationController?.pushViewController(VerifyViewController!, animated: true)
                            }
                        }
                        else if result == 16 {
                            self.LogOutTokenInvalid()
                        }else if result == 3 {
                            kAppDelegate.shared.showAlert(self, message: "Invalid user.")
                        }else if result == 4 {
                            kAppDelegate.shared.showAlert(self, message: "Session expired.")
                        }else if result == 6 {
                            kAppDelegate.shared.showAlert(self, message: "Internal server error.")
                        }else if result == 7 {
                            kAppDelegate.shared.showAlert(self, message: "User not found.")
                        }else if result == 8 {
                            kAppDelegate.shared.showAlert(self, message: "User not verified.")
                            self.ResendCode()
                        }else if result == 24 {
                            kAppDelegate.shared.showAlert(self, message: "Please give valid email id or phone number.")
                        }else if result == 25 {
                            kAppDelegate.shared.showAlert(self, message: "Please give valid email id or phone number.")
                        }else {
                            kAppDelegate.shared.showAlert(self, message: "Phone number Incorrect.")
                        }
                    }
                }
            }
        }
    }
    
    func ForgotPasswordMobileNumber(val : String) {
        let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        let url = "\(APILink)forgotPassword"
        
        let parameters: [String: Any] = [
            "email" : Email.text!
        ]
        print(parameters)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading...")
        sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            SVProgressHUD.dismiss()
            if let dict = dataResponse.result.value as? NSDictionary {
                if let result = dict["resultType"] as? Int {
                    if result == 1 {
                        if let tok = dict["token"] as? String {
                            UserData.current!.token! = tok
                            do {
                                let userData = try JSONEncoder().encode(UserData.current!)
                                let decoded = try JSONSerialization.jsonObject(with: userData, options: [])
                                 UserData.current = UserData.current!
                                        kAppDelegate.shared.saveLoggedUserdetails(decoded as! NSDictionary)
                                print(decoded as! NSDictionary)
                            }catch {
                                
                            }
                            OTPPageHeading = "Verify OTP"
                            let VerifyViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController")
                            self.navigationController?.pushViewController(VerifyViewController!, animated: true)
                        }
                    }else if result == 16 {
                        self.LogOutTokenInvalid()
                    }else if result == 3 {
                        kAppDelegate.shared.showAlert(self, message: "Invalid user.")
                    }else if result == 4 {
                        kAppDelegate.shared.showAlert(self, message: "Session expired.")
                    }else if result == 6 {
                        kAppDelegate.shared.showAlert(self, message: "Internal server error.")
                    }else if result == 7 {
                        kAppDelegate.shared.showAlert(self, message: "User not found.")
                    }else if result == 8 {
                        kAppDelegate.shared.showAlert(self, message: "User not verified.")
                        self.ResendCode()
                        
                    }else if result == 24 {
                        kAppDelegate.shared.showAlert(self, message: "Please give valid email id or phone number.")
                    }else if result == 25 {
                        kAppDelegate.shared.showAlert(self, message: "Please give valid email id or phone number.")
                    }else {
                        kAppDelegate.shared.showAlert(self, message: "Phone number Incorrect.")
                    }
                }
            }
        }
    }
    
    func ResendCode() {
        let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        let url = "\(APILink)resend-verfication-code" //
        
        let parameters: [String: Any] = [
            //"token" : UserData.current!.token!,
            "email" : Email.text!
        ]
        
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading...")
        sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            SVProgressHUD.dismiss()
            if let dict = dataResponse.result.value as? NSDictionary {
                print("dict resend : \(dict)")
                if let result = dict["resultType"] as? Int {
                    print("result : \(result)")
                    if result == 1 {
                        if let tok = dict["token"] as? String {
                            UserData.current?.token = tok
                            do {
                                let userData = try JSONEncoder().encode(UserData.current!)
                                let decoded = try JSONSerialization.jsonObject(with: userData, options: [])
                                 UserData.current = UserData.current!
                                        kAppDelegate.shared.saveLoggedUserdetails(decoded as! NSDictionary)
                                print(decoded as! NSDictionary)
                            }catch {
                                
                            }
                        }
                        kAppDelegate.shared.showAlert(self, message: "You have to verify first")
                        OTPPageHeading = "Verify OTP"
                        let VerifyViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController")
                        self.navigationController?.pushViewController(VerifyViewController!, animated: true)
                    }else {
                        kAppDelegate.shared.showAlert(self, message: "Error \n Please try again.")
                    }
                }
            }
            
        }
    }
    
    func LogOutTokenInvalid() {
        kAppDelegate.shared.logoutCurrentUser { (success) in
        }
    }
    
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
