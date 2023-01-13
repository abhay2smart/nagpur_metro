//
//  ChangePassViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 01/08/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//
import UIKit
import Alamofire
import CoreData

class ChangePassViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var Scroll                : SPSignInSignInPage!
    @IBOutlet var NewPass               : UITextField!
    @IBOutlet var RePass                : UITextField!
    @IBOutlet var SaveButt              : UIButton!
    @IBOutlet var btnLogout             : UIButton!
    @IBOutlet var CurrentPass           : UITextField!
    @IBOutlet var RePassEyeButt         : UIButton!
    @IBOutlet var NewPassEyeButt        : UIButton!
    @IBOutlet var LogoutBlaceView       : UIView!
    @IBOutlet var NoInternetBlackView   : UIView!
    @IBOutlet var CurrentPassEyeButt    : UIButton!
    
    var tapGestureRecognizer    : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        NoInternetBlackView.isHidden = true
        LogoutBlaceView.isHidden = true
        CurrentPass.delegate = self
        NewPass.delegate = self
        RePass.delegate = self
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
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        Scroll.addGestureRecognizer(tapGestureRecognizer)
        PublicCalculateQRAgain = 1
        CurrentPassEyeButt.setBackgroundImage(#imageLiteral(resourceName: "EyeHide"), for: .normal)
        NewPassEyeButt.setBackgroundImage(#imageLiteral(resourceName: "EyeHide"), for: .normal)
        RePassEyeButt.setBackgroundImage(#imageLiteral(resourceName: "EyeHide"), for: .normal)
    }
    
    @IBAction func CurrentEyeClicked(_ sender: Any) {
        if CurrentPassEyeButt.backgroundImage(for: .normal) == #imageLiteral(resourceName: "EyeHide") {
            CurrentPassEyeButt.setBackgroundImage(#imageLiteral(resourceName: "EyeShow"), for: .normal)
            CurrentPass.isSecureTextEntry = false
        }else {
            CurrentPassEyeButt.setBackgroundImage(#imageLiteral(resourceName: "EyeHide"), for: .normal)
            CurrentPass.isSecureTextEntry = true
        }
    }
    
    @IBAction func NewEyeClicked(_ sender: Any) {
        if NewPassEyeButt.backgroundImage(for: .normal) == #imageLiteral(resourceName: "EyeHide") {
            NewPassEyeButt.setBackgroundImage(#imageLiteral(resourceName: "EyeShow"), for: .normal)
            NewPass.isSecureTextEntry = false
        }else {
            NewPassEyeButt.setBackgroundImage(#imageLiteral(resourceName: "EyeHide"), for: .normal)
            NewPass.isSecureTextEntry = true
        }
    }
    
    @IBAction func ReEyeClicked(_ sender: Any) {
        if RePassEyeButt.backgroundImage(for: .normal) == #imageLiteral(resourceName: "EyeHide") {
            RePassEyeButt.setBackgroundImage(#imageLiteral(resourceName: "EyeShow"), for: .normal)
            RePass.isSecureTextEntry = false
        }else {
            RePassEyeButt.setBackgroundImage(#imageLiteral(resourceName: "EyeHide"), for: .normal)
            RePass.isSecureTextEntry = true
        }
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
    
    @IBAction func NoInternetOK(_ sender: Any) {
        NoInternetBlackView.isHidden = true
    }
    
    @IBAction func Save(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
        }else {
            print("No internet.")
            NoInternetBlackView.isHidden = false
            return
        }
        
        if (CurrentPass.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please enter your current password")
        }else if (NewPass.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please enter your new password")
        }else if (RePass.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please re-type password")
        }else if NewPass.text != RePass.text {
            kAppDelegate.shared.showAlert(self, message: "Passwords do not match")
        }else if (NewPass.text?.count)! < 6 {
            kAppDelegate.shared.showAlert(self, message: "Please enter minimum 6 charecters for password")
        }else if (NewPass.text?.isAlphanumericBoth)! {
            kAppDelegate.shared.showAlert(self, message: "Password must be alphanumeric")
        }else {
            if UserData.current?.token != nil {
                let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
                let base64Credentials = credentialData.base64EncodedString(options: [])
                let headers1 = ["authorization": "Basic \(base64Credentials)"]
                
                let url = "\(APILink)changePassword"
                
                let parameters: [String: Any] = [
                    "token" : UserData.current!.token!,
                    "oldPassword" : CurrentPass.text!,
                    "newPassword" : NewPass.text!
                ]
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
                                         UserData.current = UserData.current!
                                        kAppDelegate.shared.saveLoggedUserdetails(decoded as! NSDictionary)
                                        print(decoded as! NSDictionary)
                                    }catch {
                                        
                                    }
                                    kAppDelegate.shared.showAlertYes(self, title: Alert.kTitle, message: "Password updated", completion: { (success) in
                                        kAppDelegate.shared.logoutCurrentUser { (success) in
                                            self.LogoutBlaceView.isHidden = true
                                            self.navigationController?.popToRootViewController(animated: true)
                                        }
                                    })
                                    
                                    // let SignInViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController")
                                    //self.navigationController?.pushViewController(SignInViewController!, animated: true)
                                }
                            }else {
                                kAppDelegate.shared.showAlert(self, message: "Internal server error.")
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func Forgot(_ sender: Any) {
        let ForgotViewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotViewController")
        self.navigationController?.pushViewController(ForgotViewController!, animated: true)
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func LogOutClicked(_ sender: Any) {
        LogoutBlaceView.isHidden = false
    }
    
    //MARK: - Core Data
    var AlreadySavedData   = NSArray()
    
    var people: [NSManagedObject] = []
    
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
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "TicketData", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        person.setValue(arr, forKeyPath: "tickets")
        person.setValue(StatusDict, forKeyPath: "ticketstatus2")
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
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
        
        let statusData = people.map { $0.value(forKey: "ticketstatus2") as! NSDictionary}
        
        if statusData.count > 0 {
            Public_AlreadySavedTicketStatusData = NSDictionary()
            Public_AlreadySavedTicketStatusData = statusData[0]
        }
        
        // print("AlreadySavedTicketStatusData : \(Public_AlreadySavedTicketStatusData)")
        
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

