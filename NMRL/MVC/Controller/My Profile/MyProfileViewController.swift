//
//  MyProfileViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 13/08/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import Alamofire

class MyProfileViewController: UIViewController {
    
    @IBOutlet var Img                       : UIImageView!
    @IBOutlet var NameLbl                   : UILabel!
    @IBOutlet var MobileLbl                 : UILabel!
    @IBOutlet var DateLbl                   : UILabel!
    @IBOutlet var EmailLbl                  : UILabel!
    @IBOutlet var BackView                  : UIView!
    @IBOutlet var EditBackVw                : UIView!
    @IBOutlet var EditFieldsVw              : UIView!
    @IBOutlet var EditDOBButt               : UIButton!
    @IBOutlet var EditEmailLbl              : UILabel!
    @IBOutlet var UpdateButt                : UIButton!
    @IBOutlet var DateBackVw                : UIView!
    @IBOutlet var DatePicker                : UIDatePicker!
    @IBOutlet var FieldsBackView            : UIView!
    @IBOutlet var EditNameField             : UITextField!
    @IBOutlet var EditFamilyName            : UITextField!
    @IBOutlet var EditMobileNumberField     : UITextField!
    
    var DOBStr      = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FieldsBackView.layer.borderWidth = 2
        FieldsBackView.layer.borderColor = UIColor.lightGray.cgColor
        FieldsBackView.layer.cornerRadius = 5
        FieldsBackView.clipsToBounds = true
        MobileLbl.text = UserData.current?.customerInfo?.mobileNumber!
        DateLbl.text = UserData.current?.customerInfo?.birthDate!
        EmailLbl.text = UserData.current?.customerInfo?.emailAddress!
        NameLbl.text = UserData.current?.customerInfo?.name!
        EditFieldsVw.layer.borderWidth = 2
        EditFieldsVw.layer.borderColor = UIColor.lightGray.cgColor
        EditFieldsVw.layer.cornerRadius = 5
        EditFieldsVw.clipsToBounds = true
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyyMMdd"
        let showDate = inputFormatter.date(from: (UserData.current?.customerInfo?.birthDate!)!)
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.dateStyle = .long
        let resultString = inputFormatter.string(from: showDate!)
        EditMobileNumberField.text = UserData.current?.customerInfo?.mobileNumber!
        EditDOBButt.setTitle("\(resultString)", for: .normal)
        EditEmailLbl.text = UserData.current?.customerInfo?.emailAddress!
        EditNameField.text = UserData.current?.customerInfo?.name!.components(separatedBy: " ").first!
        EditFamilyName.text = UserData.current?.customerInfo?.name!.components(separatedBy: " ").last!
        // UpdateButt.Shadow()
        DatePicker.addTarget(self, action: #selector(MyProfileViewController.handleDatePicker), for: UIControlEvents.valueChanged)
        DatePicker.maximumDate = Date()
        DateBackVw.isHidden = true
        EditBackVw.isHidden = true
        BackView.isHidden = false
        PublicCalculateQRAgain = 1
    }
    
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .long
        let str = dateFormatter.string(from: DatePicker.date)
        EditDOBButt.setTitle(str, for: .normal)
        EditDOBButt.setTitleColor(.black, for: .normal)
        print("date : \(str)")
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyyMMdd"
        DOBStr = dateFormatter2.string(from: DatePicker.date)
        print("DOBStr : \(DOBStr)")
    }
    
    @IBAction func EditDobClicked(_ sender: Any) {
        DateBackVw.isHidden = false
    }
    
    @IBAction func UpdateClicked(_ sender: Any) {
        if (EditNameField.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please give your name")
        }else if (EditFamilyName.text?.isBlank)!  {
            kAppDelegate.shared.showAlert(self, message: "Please give your family name")
        }else if (EditMobileNumberField.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please enter your mobile number")
        }else if !(EditMobileNumberField.text?.isPhoneNumber)! {
            kAppDelegate.shared.showAlert(self, message: "Please enter your valid mobile number")
        }else {
            if UserData.current?.token != nil {
                let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
                let base64Credentials = credentialData.base64EncodedString(options: [])
                let headers1 = ["authorization": "Basic \(base64Credentials)"]
                
                let url = "\(APILink)editProfile"
                
                let parameters: [String: Any] = [
                    "token" : UserData.current!.token!,
                    "name" : EditNameField.text!,
                    "family" : EditFamilyName.text!,
                    "mobileNumber" : EditMobileNumberField.text!,
                    "birthDate" : DOBStr,
                    "titleType" : 3
                ]
                
                Alamofire.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                    print(dataResponse.result.value!)
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
                                }
                                kAppDelegate.shared.showAlert(self, message: "Profile details updated successfully")
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Done(_ sender: Any) {
        DateBackVw.isHidden = true
    }
    
    @IBAction func Edit(_ sender: Any) {
        if BackView.isHidden == false {
            EditBackVw.isHidden = false
            BackView.isHidden = true
            EditNameField.becomeFirstResponder()
        }else {
            BackView.isHidden = false
            EditBackVw.isHidden = true
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
