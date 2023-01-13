//
//  SignInViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 31/07/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var Scroll            : SPSignInSignInPage!
    @IBOutlet var Email             : UITextField!
    @IBOutlet var Password          : UITextField!
    @IBOutlet var SignIn            : UIButton!
    @IBOutlet var SignInLbl         : UILabel!
    @IBOutlet var Line1             : UILabel!
    @IBOutlet var Line2             : UILabel!
    @IBOutlet var EyeButt           : UIButton!
    
    var tapGestureRecognizer        : UITapGestureRecognizer!
    var TicketsArr_2                = NSArray()
    var people: [NSManagedObject]   = []
    var AlreadySavedData            = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        let leftView = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: self.Email.frame.height))
        leftView.backgroundColor = .clear
        Email.leftView = leftView
        Email.leftViewMode = .always
        Email.contentVerticalAlignment = .center
        Email.delegate = self
        
        let leftView1 = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: self.Password.frame.height))
        leftView1.backgroundColor = .clear
        Password.leftView = leftView1
        Password.leftViewMode = .always
        Password.contentVerticalAlignment = .center
        Password.delegate = self
        
        //SignIn.Shadow()
        //        if DeviceType.IS_IPHONE_5
        //        {
        //            SignInLbl.font = UIFont(name: "Montserrat-Bold", size: 16)
        //        }
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
        if textField == Email {
            Line1.frame = CGRect(x: Line1.frame.origin.x, y: Line1.frame.origin.y, width: Line1.frame.width, height: 2)
            Line2.frame = CGRect(x: Line2.frame.origin.x, y: Line2.frame.origin.y, width: Line2.frame.width, height: 1)
        }else {
            Line1.frame = CGRect(x: Line1.frame.origin.x, y: Line1.frame.origin.y, width: Line1.frame.width, height: 1)
            Line2.frame = CGRect(x: Line2.frame.origin.x, y: Line2.frame.origin.y, width: Line2.frame.width, height: 2)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func SignInClicked(_ sender: Any) {
        if (Email.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please enter your registered email id or phone number")
        }else {
            var txt = Email.text!
            Email.text! = txt.replacingOccurrences(of: " ", with: "")
            txt = Email.text!
            let val = Int(txt)
            if val != nil {
                print("Valid Integer")
                if !(Email.text?.isPhoneNumber)! {
                    kAppDelegate.shared.showAlert(self, message: "Please enter your valid phone number")
                }else if (Password.text?.isBlank)! {
                    kAppDelegate.shared.showAlert(self, message: "Please enter your password")
                }else if (Password.text?.count)! < 6 {
                    kAppDelegate.shared.showAlert(self, message: "Please enter minimum 6 charecters for password")
                }else if (Password.text?.isAlphanumericBoth)! {
                    kAppDelegate.shared.showAlert(self, message: "Password must be alphanumeric")
                }else {
                    MobileNumberLogin()
                }
                return
            }
            print("String val")
            
            //        if (Email.text?.isBlank)!
            //        {
            //             kAppDelegate.shared.showAlert(self, message: "Please enter your registered email address")
            //        }
            if !(Email.text?.isEmail)! {
                kAppDelegate.shared.showAlert(self, message: "Please enter your valid email address")
            }else if (Password.text?.isBlank)! {
                kAppDelegate.shared.showAlert(self, message: "Please enter your password")
            }else if (Password.text?.count)! < 6 {
                kAppDelegate.shared.showAlert(self, message: "Please enter minimum 6 charecters for password")
            }else if (Password.text?.isAlphanumericBoth)! {
                kAppDelegate.shared.showAlert(self, message: "Password must be alphanumeric")
            }else {
                if Connectivity.isConnectedToInternet() {
                    print("Yes! internet is available.")
                    // do some tasks..
                }else {
                    print("No internet.")
                    //  InternetBlackView.isHidden = false
                    return
                }
                
                self.Scroll.setContentOffset(CGPoint.zero, animated: true)
                self.view.endEditing(true)
                let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
                let base64Credentials = credentialData.base64EncodedString(options: [])
                let headers1 = ["authorization": "Basic \(base64Credentials)"]
                let url = "\(APILink)login"
                var ResultVal = 1
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.show(withStatus: "Loading...")
                sessionManager1.request(url, method : .post, parameters : ["email" : Email.text!,"password" : Password.text!], encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                    SVProgressHUD.dismiss()
                    if let dict = dataResponse.result.value as? NSDictionary {
                        print("Sign in : \(dict)")
                        if let result = dict["resultType"] as? Int {
                            ResultVal = result
                            if result == 1 {
                                let coder = JSONDecoder()
                                do {
                                    let responseData = try coder.decode(UserData.self, from: CommonFunctions().getSerializedData(response: dataResponse))
                                    UserData.current = responseData
                                    CommonFunctions().saveLoggedUserdetails(dict)
                                    kAppDelegate.setUpPushTokenToServer()
                                    let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController2")
                                    self.navigationController?.pushViewController(ViewController!, animated: true)
                                }catch let error {
                                    print(error.localizedDescription)
                                }
                            }else if result == 2 {
                                kAppDelegate.shared.showAlert(self, message: "Registration error. Please register again.")
                            }else if result == 3 {
                                kAppDelegate.shared.showAlert(self, message: "Invalid user.")
                            }else if result == 4 {
                                kAppDelegate.shared.showAlert(self, message: "Session expired.")
                            }else if result == 6 {
                                kAppDelegate.shared.showAlert(self, message: "Internal server error. please try again.")
                            }else if result == 7 {
                                kAppDelegate.shared.showAlert(self, message: "User not found. Please register.")
                            }else if result == 9 {
                                kAppDelegate.shared.showAlert(self, message: "Incorrect password.")
                            }else if result == 14 {
                                kAppDelegate.shared.showAlert(self, message: "Invalid action.")
                            }else if result == 15 {
                                kAppDelegate.shared.showAlert(self, message: "User logged in another device.")
                            }else if result == 16 {
                                kAppDelegate.shared.showAlert(self, message: "Invalid token. Please try again.")
                            }else if result == 17 {
                                kAppDelegate.shared.showAlert(self, message: "Invalid token. Please try again.")
                            }else if result == 18 {
                                kAppDelegate.shared.showAlert(self, message: "Booking device mismatch. Please try again.")
                            }else if result == 19 {
                                kAppDelegate.shared.showAlert(self, message: "Business time over. Please try again.")
                            }else if result == 21 {
                                kAppDelegate.shared.showAlert(self, message: "Invalid product code. Please try again.")
                            }else if result == 22 {
                                kAppDelegate.shared.showAlert(self, message: "Invalid email address.")
                            }else if result == 23 {
                                kAppDelegate.shared.showAlert(self, title: Alert.kTitle, message: "User not verified. Please verify.", completion: { (success) in
                                    if success {
                                        if UserData.current?.token != nil {
                                            self.ResendCode()
                                        }
                                    }
                                })
                            }else if result == 24 {
                                kAppDelegate.shared.showAlert(self, message: "Invalid email address or mobile number.")
                            }else if result == 25 {
                                kAppDelegate.shared.showAlert(self, message: "Invalid request. Please try again")
                            }else if result == 8 {
                                kAppDelegate.shared.showAlert(self, title: Alert.kTitle, message: "User not verified. Please verify.", completion: { (success) in
                                    if success {
                                        self.resendCode(self.Email.text!)
                                    }
                                })
                            }else {
                                kAppDelegate.shared.showAlert(self, message: "Username or Password Incorrect.")
                            }
                        }
                    }
                    if ResultVal != 8 {
                        
                    }
                }
            }
        }
    }
    
    func MobileNumberLogin() {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
        }else {
            print("No internet.")
            return
        }
        
        self.Scroll.setContentOffset(CGPoint.zero, animated: true)
        self.view.endEditing(true)
        let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        let url = "\(APILink)login"
        
        let parameters: [String: Any] = ["email" : Email.text!,"password" : Password.text!]
        
        var ResultVal = 1
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading...")
        sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            SVProgressHUD.dismiss()
            if let dict = dataResponse.result.value as? NSDictionary {
                print("Sign in : \(dict)")
                if let result = dict["resultType"] as? Int {
                    ResultVal = result
                    let coder = JSONDecoder()
                    do {
                        let responseData = try coder.decode(UserData.self, from: CommonFunctions().getSerializedData(response: dataResponse))
                        UserData.current = responseData
                        CommonFunctions().saveLoggedUserdetails(dict)
                        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController2")
                        self.navigationController?.pushViewController(homeVC!, animated: true)
                    }catch let error {
                        print(error.localizedDescription)
                    }
                    if result == 2 {
                        kAppDelegate.shared.showAlert(self, message: "Registration error. Please register again.")
                    }else if result == 3 {
                        kAppDelegate.shared.showAlert(self, message: "Invalid user.")
                    }else if result == 4 {
                        kAppDelegate.shared.showAlert(self, message: "Session expired.")
                    }else if result == 6 {
                        kAppDelegate.shared.showAlert(self, message: "Internal server error. please try again.")
                    }else if result == 7 {
                        kAppDelegate.shared.showAlert(self, message: "User not found. Please register.")
                    }else if result == 9 {
                        kAppDelegate.shared.showAlert(self, message: "Incorrect password.")
                    }else if result == 14 {
                        kAppDelegate.shared.showAlert(self, message: "Invalid action.")
                    }else if result == 15 {
                        kAppDelegate.shared.showAlert(self, message: "User logged in another device.")
                    }else if result == 16 {
                        kAppDelegate.shared.showAlert(self, message: "Invalid token. Please try again.")
                    }else if result == 17 {
                        kAppDelegate.shared.showAlert(self, message: "Invalid token. Please try again.")
                    }else if result == 18 {
                        kAppDelegate.shared.showAlert(self, message: "Booking device mismatch. Please try again.")
                    }else if result == 19 {
                        kAppDelegate.shared.showAlert(self, message: "Business time over. Please try again.")
                    }else if result == 21 {
                        kAppDelegate.shared.showAlert(self, message: "Invalid product code. Please try again.")
                    }else if result == 22 {
                        kAppDelegate.shared.showAlert(self, message: "Invalid email address.")
                    }else if result == 23 {
                        kAppDelegate.shared.showAlert(self, message: "User not verified. Please verify.")
                        self.ResendCode()
                    }else if result == 24 {
                        kAppDelegate.shared.showAlert(self, message: "Invalid email address or mobile number.")
                    }else if result == 25 {
                        kAppDelegate.shared.showAlert(self, message: "Invalid request. Please try again")
                    }else if result == 8 {
                        kAppDelegate.shared.showAlert(self, title: Alert.kTitle, message: "User not verified. Please verify.", completion: { (success) in
                            if success {
                                self.resendCode(self.Email.text!)
                            }
                        })
                    }else {
                        kAppDelegate.shared.showAlert(self, message: "Username or Password Incorrect.")
                    }
                }
            }
            
            if ResultVal != 8 {
            }
        }
    }
    
    func ResendCode() {
        if UserData.current?.token != nil {
            let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers1 = ["authorization": "Basic \(base64Credentials)"]
            
            let url = "\(APILink)newVerificationCode"
            
            let parameters: [String: Any] = [
                "token" : UserData.current!.token!
            ]
            print(parameters)
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show(withStatus: "Loading...")
            sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                SVProgressHUD.dismiss()
                if let dict = dataResponse.result.value as? NSDictionary {
                    print("dict : \(dict)")
                    if let result = dict["resultType"] as? Int {
                        if result == 1 {
                            kAppDelegate.shared.showAlert(self, message: "You have to verify first")
                            OTPPageHeading = "Verify OTP"
                            let VerifyViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController")
                            self.navigationController?.pushViewController(VerifyViewController!, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func resendCode(_ email: String) {
            let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers1 = ["authorization": "Basic \(base64Credentials)"]
            
            let url = "\(APILink)resend-verfication-code"
           
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show(withStatus: "Loading...")
            
            sessionManager1.request(url, method : .post, parameters : [ "email" : email], encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                SVProgressHUD.dismiss()
                if let dict = dataResponse.result.value as? NSDictionary {
                    print("dict : \(dict)")
                    if let result = dict["resultType"] as? Int {
                        if result == 1 {
                            kAppDelegate.shared.showAlert(self, title: Alert.kTitle, message: "You have to verify first.", completion: { (success) in
                                OTPPageHeading = "Verify OTP"
                                let veryfyVC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
                                veryfyVC.token = dict["token"] as! String
                                self.navigationController?.pushViewController(veryfyVC, animated: true)
                            })
                        }
                    }
                }
            }
    }
    
    @IBAction func EyeClicked(_ sender: Any) {
        if EyeButt.backgroundImage(for: .normal) == #imageLiteral(resourceName: "EyeHide") {
            EyeButt.setBackgroundImage(#imageLiteral(resourceName: "EyeShow"), for: .normal)
            Password.isSecureTextEntry = false
        }else {
            EyeButt.setBackgroundImage(#imageLiteral(resourceName: "EyeHide"), for: .normal)
            Password.isSecureTextEntry = true
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Core Data
    func save(arr : NSArray) {
        deleteAllRecords()
        let StatusDict = NSMutableDictionary()
        for dic in arr {
            if let dd = dic as? NSDictionary {
                if let ticketSerial = dd["ticketSerial"] as? Int {
                    if let qrTicketStatus = dd["qrTicketStatus"] as? String {
                        let dict2 = NSMutableDictionary()
                        dict2.setValue(qrTicketStatus, forKey: "Status")
                        dict2.setValue("0", forKey: "EntryCount")
                        dict2.setValue("0", forKey: "ExitCount")
                        StatusDict.setValue(dict2, forKey: "\(ticketSerial)")
                    }
                }
            }
        }
        
        ////////// Saving Data
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "TicketData",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        person.setValue(arr, forKeyPath: "tickets")
        
        person.setValue(StatusDict, forKeyPath: "ticketstatus2")
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        ReadData()
    }
    
    func ReadData() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "TicketData")
        
        //3
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let db = people.map { $0.value(forKey: "tickets") as! NSArray}
        AlreadySavedData = db as NSArray
        PublicAlreadySavedData = AlreadySavedData
        
        print("PublicAlreadySavedData : \(PublicAlreadySavedData)")
        
        let dd = people.map({$0.value(forKey: "ticketstatus2") as? NSDictionary })
         print("DD : \(dd)")
        let statusData = people.map { $0.value(forKey: "ticketstatus2") as! NSDictionary}
        
        if statusData.count > 0 {
            Public_AlreadySavedTicketStatusData = NSDictionary()
            Public_AlreadySavedTicketStatusData = statusData[0]
        }
        
        print("AlreadySavedTicketStatusData : \(Public_AlreadySavedTicketStatusData)")
    }
    
    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TicketData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
}
