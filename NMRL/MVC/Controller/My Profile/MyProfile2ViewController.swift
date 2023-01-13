//
//  MyProfileViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 13/08/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class MyProfile2ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var Img                   : UIImageView!
    @IBOutlet var NameLbl               : UILabel!
    @IBOutlet var MobileLbl             : UILabel!
    @IBOutlet var DateLbl               : UILabel!
    @IBOutlet var EmailLbl              : UILabel!
    @IBOutlet var BackView              : UIView!
    @IBOutlet var FieldsBackView        : UIView!
    @IBOutlet var EditBackVw            : UIView!
    @IBOutlet var EditFieldsVw          : UIView!
    @IBOutlet var EditNameField         : UITextField!
    @IBOutlet var EditFamilyName        : UITextField!
    @IBOutlet var EditMobileNumberField : UITextField!
    @IBOutlet var EditDOBButt           : UIButton!
    @IBOutlet var EditEmailLbl          : UILabel!
    @IBOutlet var UpdateButt            : UIButton!
    @IBOutlet var DateBackVw            : UIView!
    @IBOutlet var DatePicker            : UIDatePicker!
    @IBOutlet var titleButt             : UIButton!
    @IBOutlet var tbl                   : UITableView!
    @IBOutlet var NoInternetBlackView   : UIView!
    @IBOutlet var Scroll                : SPSignInSignInPage!
    @IBOutlet var NameLabel             : UILabel!
    @IBOutlet var EditButt              : UIButton!
    @IBOutlet var btnLogout             : UIButton!
    //@IBOutlet var EditAadharField     : UITextFievar
    //@IBOutlet var AadharLbl           : UILabel!
    
    var DOBStr                  = String()
    let TitleArr                = ["Mr", "Ms", "Miss", "Mrs"]
    var tapGestureRecognizer    = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        //        AadharLbl.isHidden = true
        //        EditAadharField.isHidden = true
        LogoutBlaceView.isHidden = true
        NoInternetBlackView.isHidden = true
        FieldsBackView.layer.borderWidth = 2
        FieldsBackView.layer.borderColor = UIColor.lightGray.cgColor
        FieldsBackView.layer.cornerRadius = 5
        FieldsBackView.clipsToBounds = true
        MobileLbl.text = UserData.current?.customerInfo!.mobileNumber!
        DateLbl.text = UserData.current?.customerInfo!.birthDate!
        EmailLbl.text = UserData.current?.customerInfo?.emailAddress!
        NameLabel.text = UserData.current?.customerInfo?.name!
        EditMobileNumberField.delegate = self
        //        EditAadharField.delegate = self
        
        //**  let abc = TitleArr[PublicUserTitleType - 1]
        //
        //        NameLbl.text = "\(abc) \(PublicNameStr)"
        //
        //        titleButt.setTitle(abc, for: .normal)
        
        EditFieldsVw.layer.borderWidth = 2
        EditFieldsVw.layer.borderColor = UIColor.lightGray.cgColor
        EditFieldsVw.layer.cornerRadius = 5
        EditFieldsVw.clipsToBounds = true
        DOBStr = (UserData.current?.customerInfo?.birthDate!)!
        if (UserData.current?.customerInfo?.birthDate!.contains("-"))! {
            DateLbl.text = UserData.current?.customerInfo?.birthDate!
            EditDOBButt.setTitle(UserData.current?.customerInfo?.birthDate!, for: .normal)
        }else {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyyMMdd"
            let showDate = inputFormatter.date(from: (UserData.current?.customerInfo?.birthDate!)!)
            inputFormatter.dateFormat = "yyyy-MM-dd"
            inputFormatter.dateStyle = .long
            let resultString = inputFormatter.string(from: showDate!)
            DateLbl.text = "\(resultString)"
            EditDOBButt.setTitle("\(resultString)", for: .normal)
        }
        EditMobileNumberField.text = UserData.current?.customerInfo?.mobileNumber
        EditEmailLbl.text = UserData.current?.customerInfo?.emailAddress!
        EditNameField.text = UserData.current?.customerInfo!.name!.components(separatedBy: " ").first!
        EditFamilyName.text = UserData.current?.customerInfo!.name!.components(separatedBy: " ").last!
        if UserData.current?.customerInfo?.gender! == 1 {
            Img.image = #imageLiteral(resourceName: "Male")
            
        }else if UserData.current?.customerInfo?.gender! == 2 {
            Img.image = #imageLiteral(resourceName: "Female")
        }else {
            Img.image = #imageLiteral(resourceName: "Female")
        }
        
        DatePicker.addTarget(self, action: #selector(MyProfileViewController.handleDatePicker), for: UIControlEvents.valueChanged)
        let vals = Calendar.current.date(byAdding: .year, value: -12, to: Date())
        DatePicker.maximumDate = vals
        DateBackVw.isHidden = true
        EditBackVw.isHidden = true
        BackView.isHidden = false
        PublicCalculateQRAgain = 1
        Scroll.contentSize = CGSize(width : 0, height : 1000)
        if DeviceType.IS_IPHONE_5 {
            Scroll.contentSize = CGSize(width : 0, height : 850)
        }else if DeviceType.IS_IPHONE_6 {
            Scroll.contentSize = CGSize(width : 0, height : 850)
        }else if DeviceType.IS_IPHONE_6P {
            Scroll.contentSize = CGSize(width : 0, height : 950)
        }else if DeviceType.IS_IPHONE_X {
            Scroll.contentSize = CGSize(width : 0, height : 1050)
        }else if DeviceType.IS_IPHONE_XP {
            Scroll.contentSize = CGSize(width : 0, height : 1150)
        }
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
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
    
    //MARK: - Tect Field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == EditMobileNumberField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 10
        }
        //        else if textField == EditAadharField {
        //            let currentText = textField.text ?? ""
        //            guard let stringRange = Range(range, in: currentText) else { return false }
        //            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        //            return updatedText.count <= 12
        //        }
        return true
    }
    
    @IBAction func EditDobClicked(_ sender: Any) {
        self.view.endEditing(true)
        DateBackVw.isHidden = false
    }
    
    @IBAction func NoInternetOK(_ sender: Any) {
        NoInternetBlackView.isHidden = true
    }
    
    @IBAction func UpdateClicked(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
        }else {
            print("No internet.")
            NoInternetBlackView.isHidden = false
            return
        }
        
        if (EditNameField.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please give your name")
        }else if (EditFamilyName.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please give your surname")
        }else if (EditMobileNumberField.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please enter your mobile number")
        }else if !(EditMobileNumberField.text?.isPhoneNumber)! {
            kAppDelegate.shared.showAlert(self, message: "Please enter your valid mobile number")
        }else {
            if UserData.current?.token != nil {
                self.view.endEditing(true)
                
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
                    "titleType" : (UserData.current?.customerInfo?.titleType!)!,
                    "socialSecurityNumber" : ""
                ]
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.show(withStatus: "Loading...")
                
                sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                    SVProgressHUD.dismiss()
                    if let dict = dataResponse.result.value as? NSDictionary {
                        print("details : \(dict)")
                        if let result = dict["resultType"] as? Int {
                            if result == 1 {
//                                let coder = JSONDecoder()
//                                do {
//                                    let responseData = try coder.decode(UserData.self, from: CommonFunctions().getSerializedData(response: dataResponse))
//                                    UserData.current = responseData
//                                    CommonFunctions().saveLoggedUserdetails(dict)
//                                    self.NameLbl.text = "\(self.TitleArr[(UserData.current?.customerInfo?.titleType!)! - 1]) \(self.EditNameField.text!) \(self.EditFamilyName.text!)"
//                                    self.MobileLbl.text = self.EditMobileNumberField.text!
//                                    //PublicNameStr = "\(self.EditNameField.text!) \(self.EditFamilyName.text!)"
//                                    self.NameLabel.text = UserData.current?.customerInfo?.name!
                                    //PublicMobileNumber = self.MobileLbl.text!
                                    //self.AadharLbl.text = self.EditAadharField.text!
                                    // PublicUserSocialSecurity = self.EditAadharField.text!
                                    //PublicDOBStr = self.DOBStr
                                    self.EditBackVw.isHidden = true
                                    self.BackView.isHidden = false
                                    self.EditButt.isHidden = false
                                    self.view.endEditing(true)
                                    kAppDelegate.shared.showAlert(self, message: "Profile details updated successfully")
//                                }catch let error {
//                                    print(error.localizedDescription)
//                                }
                            }else if result == 16 {
                                self.LogOutTokenInvalid()
                            }else {
                                self.EditBackVw.isHidden = true
                                self.BackView.isHidden = false
                                self.EditButt.isHidden = false
                                self.view.endEditing(true)
                                kAppDelegate.shared.showAlert(self, message: "Profile not updated. \nPlease try after sometime.")
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
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TitleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if let lbl = cell?.viewWithTag(1) as? UILabel {
            lbl.text = TitleArr[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.addGestureRecognizer(tapGestureRecognizer)
        //CHANGE
        //PublicUserTitleType = indexPath.row + 1
        titleButt.setTitle(TitleArr[indexPath.row], for: .normal)
        tbl.isHidden = true
    }
    
    @IBAction func Done(_ sender: Any) {
        DateBackVw.isHidden = true
    }
    
    
    @IBAction func Edit(_ sender: Any) {
        if BackView.isHidden == false {
            EditBackVw.isHidden = false
            BackView.isHidden = true
            tbl.isHidden = true
            EditButt.isHidden = true
            EditNameField.becomeFirstResponder()
        }else {
            self.view.endEditing(true)
            BackView.isHidden = false
            EditButt.isHidden = false
            EditBackVw.isHidden = true
        }
    }
    
    @IBAction func titleClicked(_ sender: Any) {
        self.view.endEditing(true)
        if tbl.isHidden == true {
            self.view.removeGestureRecognizer(tapGestureRecognizer)
            tbl.isHidden = false
        }else {
            self.view.addGestureRecognizer(tapGestureRecognizer)
            tbl.isHidden = true
        }
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
    
    
    func LogOutTokenInvalid() {
        kAppDelegate.shared.logoutCurrentUser { (success) in
            self.LogoutBlaceView.isHidden = true
        }
    }
    
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

