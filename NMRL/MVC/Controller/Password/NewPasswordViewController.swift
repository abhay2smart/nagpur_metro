//
//  NewPasswordViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 01/08/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import Alamofire

class NewPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var Scroll        : SPSignInSignInPage!
    @IBOutlet var NewPass       : UITextField!
    @IBOutlet var RetypePass    : UITextField!
    @IBOutlet var ResetButt     : UIButton!
    
    var tapGestureRecognizer    : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NewPass.delegate = self
        RetypePass.delegate = self
        //ResetButt.Shadow()
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
    
    @IBAction func Reset(_ sender: Any) {
        if (NewPass.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please enter password")
        }else if (RetypePass.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please re-type password")
        }else if NewPass.text != RetypePass.text {
            kAppDelegate.shared.showAlert(self, message: "Passwords do not match")
        }else {
            let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers1 = ["authorization": "Basic \(base64Credentials)"]
            
            let url = "\(APILink)resetPassword"
            
            let parameters: [String: Any] = [
                "temporaryToken" : UserData.current!.token!,
                "newPassword" : NewPass.text!
            ]
            
            print(parameters)
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show()
            sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                SVProgressHUD.dismiss()
                print(dataResponse.result.value!)
                if let dict = dataResponse.result.value as? NSDictionary {
                    if let result = dict["resultType"] as? Int {
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
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        var array : [UIViewController] = (self.navigationController?.viewControllers)!
        array.remove(at: array.count - 1)
        array.remove(at: array.count - 1)
        self.navigationController?.viewControllers = array
        self.navigationController?.popViewController(animated: true)
    }
}
