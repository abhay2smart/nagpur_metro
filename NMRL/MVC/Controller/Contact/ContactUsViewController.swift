//
//  ContactUsViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 05/11/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit

import Alamofire

import CoreData

import MessageUI

class ContactUsViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
 
    
    @IBOutlet var Scroll: SPSignIn!
    
    @IBOutlet var EmailField: UITextField!
    
    @IBOutlet var MessageField: UITextField!
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet var Line1: UILabel!
    
    @IBOutlet var Line2: UILabel!
    
     
    
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
        
        if DeviceType.IS_IPHONE_5
        {
            Scroll.contentSize = CGSize(width : 0, height : 700)
        }
        else if DeviceType.IS_IPHONE_6
        {
            Scroll.contentSize = CGSize(width : 0, height : 800)
        }
        else if DeviceType.IS_IPHONE_6P
        {
            Scroll.contentSize = CGSize(width : 0, height : 900)
        }
        else if DeviceType.IS_IPHONE_X
        {
            Scroll.contentSize = CGSize(width : 0, height : 1000)
        }
        else if DeviceType.IS_IPHONE_XP
        {
            Scroll.contentSize = CGSize(width : 0, height : 1000)
        }
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        Scroll.addGestureRecognizer(tapGestureRecognizer)


        // Do any additional setup after loading the view.
    }
    
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        
        Line1.frame = CGRect(x: Line1.frame.origin.x, y: Line1.frame.origin.y, width: Line1.frame.width, height: 1)
        Line2.frame = CGRect(x: Line2.frame.origin.x, y: Line2.frame.origin.y, width: Line2.frame.width, height: 1)
        
        self.Scroll.setContentOffset(CGPoint.zero, animated: true)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Reset the scrollview content offset
        
        Line1.frame = CGRect(x: Line1.frame.origin.x, y: Line1.frame.origin.y, width: Line1.frame.width, height: 1)
        Line2.frame = CGRect(x: Line2.frame.origin.x, y: Line2.frame.origin.y, width: Line2.frame.width, height: 1)
        
        self.Scroll.setContentOffset(CGPoint.zero, animated: true)
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == EmailField
        {
            Line1.frame = CGRect(x: Line1.frame.origin.x, y: Line1.frame.origin.y, width: Line1.frame.width, height: 2)
            Line2.frame = CGRect(x: Line2.frame.origin.x, y: Line2.frame.origin.y, width: Line2.frame.width, height: 1)
        }
        else
        {
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
    
    @IBOutlet var LogoutBlaceView: UIView!
    
    @IBAction func LogOutClicked(_ sender: Any) {
        
        LogoutBlaceView.isHidden = false
    }
    
    //MARK: - Mail Composer
    
    func sendEmail(Email : String) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self as MFMailComposeViewControllerDelegate
        // Configure the fields of the interface.
        composeVC.setToRecipients([Email])
         composeVC.setSubject("My Feedback")
        composeVC.setMessageBody(MessageField.text!, isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    
        //self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func Submit(_ sender: Any) {
        
        if MessageField.text == ""
        {
             kAppDelegate.shared.showAlert(self, message: "Enter your feedback message")
            
            return
        }
        
        if !MFMailComposeViewController.canSendMail() {
             kAppDelegate.shared.showAlert(self, message: "Please activate your Mail services in your iPhone to send this message.")
            print("Mail services are not available")
            return
        }
        
        sendEmail(Email: "nmrcafc2@gmail.com")
//
//        if Connectivity.isConnectedToInternet() {
//            print("Yes! internet is available.")
//            // do some tasks..
//        }
//        else
//        {
//            print("No internet.")
//            InternetBlackView.isHidden = false
//
//            return
//        }
//
//        if EmailField.text == ""
//        {
//             kAppDelegate.shared.showAlert(self, message: "Enter your email address")
//        }
//        else if MessageField.text == ""
//        {
//             kAppDelegate.shared.showAlert(self, message: "Enter your feedback message")
//        }
//        else
//        {
//            self.view.endEditing(true)
//
//            sleep(1)
//
//             kAppDelegate.shared.showAlert(self, message: "Your feedback submitted.")
//
//            Back(self)

//
//
//            let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
//            let base64Credentials = credentialData.base64EncodedString(options: [])
//            let headers1 = ["authorization": "Basic \(base64Credentials)"]
//
//            let url = "\(APILink)resend-verfication-code" //
//
//            let parameters: [String: Any] = [
//                //"token" : UserData.current!.token!,
//                "email" : Email.text!
//            ]
//
//            print(parameters)
            
//            sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in

//
//                // print("dataResponse.result.value : \(dataResponse.result.value!)")
//
//                if let dict = dataResponse.result.value as? NSDictionary
//                {
//                    print("dict resend : \(dict)")
//
//                    if let result = dict["resultType"] as? Int
//                    {
//                        print("result : \(result)")
//
//                        if result == 1
//                        {
//                            if let tok = dict["token"] as? String
//                            {
//                                UserData.current!.token! = tok
//
//                                do {
//                            let userData = try JSONEncoder().encode(UserData.current!)
//                                let decoded = try JSONSerialization.jsonObject(with: userData, options: [])
//                                 UserData.current = UserData.current!
                                      //  kAppDelegate.shared.saveLoggedUserdetails(decoded as! NSDictionary)
//                                print(decoded as! NSDictionary)
//                            }catch {
//                               
//                            }
//                            }
//
//                             kAppDelegate.shared.showAlert(self, message: "Your feedback submitted.")
//
//                        }
//                        else
//                        {
//                             kAppDelegate.shared.showAlert(self, message: "Error \n Please try again.")
//                        }
//                    }
//                }
//
//            }
  //      }
        
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
    
    

    //MARK: - Core Data
    
    var people: [NSManagedObject] = []
    
    var AlreadySavedData = NSArray()
    
    func save(arr : NSArray) {
        
        deleteAllRecords()
        
        let StatusDict = NSMutableDictionary()
        
        for dic in arr
        {
            if let dd = dic as? NSDictionary
            {
                if let ticketSerial = dd["ticketSerial"] as? Int
                {
                    if let qrTicketStatus = dd["qrTicketStatus"] as? String
                    {
                        let dict2 = NSMutableDictionary()
                        dict2.setValue(qrTicketStatus, forKey: "Status")
                        dict2.setValue("0", forKey: "EntryCount")
                        dict2.setValue("0", forKey: "ExitCount")
                        StatusDict.setValue(dict2, forKey: "\(ticketSerial)")
                    }
                }
            }
        }
        
        //  print("StatusDict Saving : \(StatusDict)")
        
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
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        ReadData()
        
        //print("People 2 : \(people)")
        
        //   print("Saved data : \(String(describing: person.value(forKeyPath: "ticketstatus")!))")
        
    }
    
    func ReadData()
    {
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
        
        if statusData.count > 0
        {
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
