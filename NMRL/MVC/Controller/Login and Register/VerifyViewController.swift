//
//  VerifyViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 31/07/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit

import Alamofire

class VerifyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var otp           : UITextField!
    @IBOutlet var timeLbl       : UILabel!
    @IBOutlet var SubmitButt    : UIButton!
    @IBOutlet var HeadingLbl    : UILabel!
    @IBOutlet var Scroll        : SPSignInSignInPage!
    
    var Minute          = 4
    var Second          = 60
    var timer           = Timer()
    var isTimerRunning  = false
    var ResendAgain     = 0
    var token           = ""
    
    var tapGestureRecognizer    : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HeadingLbl.text = OTPPageHeading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.runTimer()
        }
        otp.delegate = self
        if #available(iOS 12.0, *) {
            otp.textContentType = .oneTimeCode
        } else {
        }
        //  SubmitButt.Shadow()
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
    
    //MARK: - Timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(VerifyViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        Second -= 1
        timeLbl.text = "Remaining time : \(Minute) min, \(Second) sec"
        if Second == 0 {
            if Minute != 0 {
                Second = 60
                Minute -= 1
            }
        }
        if Minute == 0 && Second == 0 {
            timeLbl.text = "Remaining time : \(Minute) min, \(Second) sec"
            timer.invalidate()
            ResendAgain = 1
            SubmitButt.setTitle("Resend OTP", for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Submit(_ sender: Any) {
        if ResendAgain == 0 {
            if (otp.text?.isBlank)! {
                kAppDelegate.shared.showAlert(self, message: "Please enter your verification code")
            }else {
                    let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
                    let base64Credentials = credentialData.base64EncodedString(options: [])
                    let headers1 = ["authorization": "Basic \(base64Credentials)"]
                    
                    let url = "\(APILink)verify"
                    
                    let parameters: [String: Any] = [
                        "inputCode" : otp.text!,
                        "token" : token
                    ]
                    
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                    SVProgressHUD.show()
                    sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                        SVProgressHUD.dismiss()
                        print(dataResponse.result.value!)
                        if let dict = dataResponse.result.value as? NSDictionary {
                            if let result = dict["resultType"] as? Int {
                                if result == 12 {
                                    print("Code expired")
                                }
                                if result == 1 {
                                    if let tok = dict["token"] as? String {
                                        print(tok)
                                        let SignInViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController")
                                        self.navigationController?.pushViewController(SignInViewController!, animated: true)
                                    }
                                }
                            }
                        }
                    }
            }
        }else {
                let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
                let base64Credentials = credentialData.base64EncodedString(options: [])
                let headers1 = ["authorization": "Basic \(base64Credentials)"]
                
                let url = "\(APILink)newVerificationCode"
                
                let parameters: [String: Any] = [
                    "token" : token
                ]
                
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.show()
                sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                    SVProgressHUD.dismiss()
                    if let dict = dataResponse.result.value as? NSDictionary {
                        if let result = dict["resultType"] as? Int {
                            if result == 1 {
                                self.timer.invalidate()
                                self.Minute = 4
                                self.Second = 60
                                self.SubmitButt.setTitle("SUBMIT", for: .normal)
                                self.ResendAgain = 0
                                self.runTimer()
                            }
                        }
                    }
                }
        }
    }
    
    @IBAction func Resend(_ sender: Any) {
       
            self.timer.invalidate()
            
            let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers1 = ["authorization": "Basic \(base64Credentials)"]
            
            let url = "\(APILink)newVerificationCode"
            
            let parameters: [String: Any] = ["token" : token]
            
            print(parameters)
            
            sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                if let dict = dataResponse.result.value as? NSDictionary {
                    if let result = dict["resultType"] as? Int {
                        if result == 1 {
                            self.timer.invalidate()
                            self.Minute = 4
                            self.Second = 60
                            self.SubmitButt.setTitle("SUBMIT", for: .normal)
                            self.ResendAgain = 0
                            self.runTimer()
                        }
                    }
                }
            }
    }
    
    @IBAction func Back(_ sender: Any) {
        timer.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
}
