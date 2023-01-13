//
//  RegisterViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 24/07/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var TypeField         : UITextField!
    @IBOutlet var FirstName         : UITextField!
    @IBOutlet var FamilyName        : UITextField!
    @IBOutlet var email             : UITextField!
    @IBOutlet var mobilenumber      : UITextField!
    @IBOutlet var password          : UITextField!
    @IBOutlet var repassword        : UITextField!
    @IBOutlet var AadharNumber      : UITextField!
    @IBOutlet var Scroll            : SPKeyBoardAvoiding!
    @IBOutlet var tbl               : UITableView!
    @IBOutlet var TitleButt         : UIButton!
    @IBOutlet var CheckBox          : UIButton!
    @IBOutlet var DOBButt           : UIButton!
    @IBOutlet var DOBVw             : UIView!
    @IBOutlet var datePicker        : UIDatePicker!
    @IBOutlet var RegButt           : UIButton!
    @IBOutlet var TermsButt         : UIButton!
    @IBOutlet var NMRCLl            : UILabel!
    
    var Gender          = 1
    var DOBStr          = "0"
    var TitleNumber     = 1
    let TitleArr        = ["Mr", "Ms", "Miss", "Mrs"]
    
    var tapGestureRecognizer    : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        TypeField.layer.cornerRadius = 7
        TypeField.layer.borderWidth = 2
        TypeField.layer.borderColor = UIColor.hexStr(hexStr: "#d4d4d4", alpha: 1).cgColor
        TypeField.delegate = self
        
        FirstName.layer.cornerRadius = 7
        FirstName.layer.borderWidth = 2
        FirstName.layer.borderColor = UIColor.hexStr(hexStr: "#d4d4d4", alpha: 1).cgColor
        FirstName.delegate = self
        
        FamilyName.layer.cornerRadius = 7
        FamilyName.layer.borderWidth = 2
        FamilyName.layer.borderColor = UIColor.hexStr(hexStr: "#d4d4d4", alpha: 1).cgColor
        FamilyName.delegate = self
        
        DOBButt.layer.cornerRadius = 7
        DOBButt.layer.borderWidth = 2
        DOBButt.layer.borderColor = UIColor.hexStr(hexStr: "#d4d4d4", alpha: 1).cgColor
        
        email.layer.cornerRadius = 7
        email.layer.borderWidth = 2
        email.layer.borderColor = UIColor.hexStr(hexStr: "#d4d4d4", alpha: 1).cgColor
        email.delegate = self
        
        mobilenumber.layer.cornerRadius = 7
        mobilenumber.layer.borderWidth = 2
        mobilenumber.layer.borderColor = UIColor.hexStr(hexStr: "#d4d4d4", alpha: 1).cgColor
        mobilenumber.delegate = self
        
        password.layer.cornerRadius = 7
        password.layer.borderWidth = 2
        password.layer.borderColor = UIColor.hexStr(hexStr: "#d4d4d4", alpha: 1).cgColor
        password.delegate = self
        
        repassword.layer.cornerRadius = 7
        repassword.layer.borderWidth = 2
        repassword.layer.borderColor = UIColor.hexStr(hexStr: "#d4d4d4", alpha: 1).cgColor
        repassword.delegate = self
        
        AadharNumber.layer.cornerRadius = 7
        AadharNumber.layer.borderWidth = 2
        AadharNumber.layer.borderColor = UIColor.hexStr(hexStr: "#d4d4d4", alpha: 1).cgColor
        AadharNumber.delegate = self
        
        let leftView = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: self.TypeField.frame.height))
        leftView.backgroundColor = .clear
        TypeField.leftView = leftView
        TypeField.leftViewMode = .always
        TypeField.contentVerticalAlignment = .center
        
        let leftView1 = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: self.FirstName.frame.height))
        leftView1.backgroundColor = .clear
        FirstName.leftView = leftView1
        FirstName.leftViewMode = .always
        FirstName.contentVerticalAlignment = .center
        
        let leftView2 = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: self.FamilyName.frame.height))
        leftView2.backgroundColor = .clear
        FamilyName.leftView = leftView2
        FamilyName.leftViewMode = .always
        FamilyName.contentVerticalAlignment = .center
        
        let leftView4 = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: self.email.frame.height))
        leftView4.backgroundColor = .clear
        email.leftView = leftView4
        email.leftViewMode = .always
        email.contentVerticalAlignment = .center
        
        
        let leftView5 = UILabel(frame: CGRect(x: 0, y: 0, width: 13, height: self.mobilenumber.frame.height))
        leftView5.backgroundColor = .clear
        mobilenumber.leftView = leftView5
        mobilenumber.leftViewMode = .always
        mobilenumber.contentVerticalAlignment = .center
        
        
        let leftView6 = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: self.password.frame.height))
        leftView6.backgroundColor = .clear
        password.leftView = leftView6
        password.leftViewMode = .always
        password.contentVerticalAlignment = .center
        
        
        let leftView7 = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: self.repassword.frame.height))
        leftView7.backgroundColor = .clear
        repassword.leftView = leftView7
        repassword.leftViewMode = .always
        repassword.contentVerticalAlignment = .center
        
        
        let leftView8 = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: self.AadharNumber.frame.height))
        leftView8.backgroundColor = .clear
        AadharNumber.leftView = leftView8
        AadharNumber.leftViewMode = .always
        AadharNumber.contentVerticalAlignment = .center

        //tbl.setupShadow()
        tbl.isHidden = true
        CheckBox.setBackgroundImage(#imageLiteral(resourceName: "CheckOFF"), for: .normal)
        datePicker.addTarget(self, action: #selector(RegisterViewController.handleDatePicker), for: UIControlEvents.valueChanged)
        DOBVw.isHidden = true
        // datePicker.maximumDate = Date()
        let vals = Calendar.current.date(byAdding: .year, value: -12, to: Date())
        datePicker.maximumDate = vals
        NMRCLl.isHidden = true
        if !DeviceType.IS_IPHONE_5 {
            TermsButt.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 12)
        }
        Scroll.delegate = self
        Scroll.contentSize = CGSize(width : 0, height : 1000)
        if DeviceType.IS_IPHONE_5 {
            Scroll.contentSize = CGSize(width : 0, height : 1200)
        }else if DeviceType.IS_IPHONE_6 {
            Scroll.contentSize = CGSize(width : 0, height : 1300)
        }else if DeviceType.IS_IPHONE_6P {
            Scroll.contentSize = CGSize(width : 0, height : 1400)
        }else if DeviceType.IS_IPHONE_X {
            Scroll.contentSize = CGSize(width : 0, height : 1500)
        }
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        Scroll.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobilenumber {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 10
        }
        //        else if textField == AadharNumber
        //        {
        //            let currentText = textField.text ?? ""
        //            guard let stringRange = Range(range, in: currentText) else { return false }
        //
        //            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        //
        //            return updatedText.count <= 12
        //        }
        //
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Scroll.scrolledToBottom {
            // print("Bottom")
            NMRCLl.isHidden = false
        }
        
        if Scroll.scrolledToTop {
            //print("Top")
            NMRCLl.isHidden = true
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
        TitleNumber = indexPath.row + 1
        TitleButt.setTitle(TitleArr[indexPath.row], for: .normal)
        tbl.isHidden = true
        Scroll.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //MARK: - Button Actions
    @IBAction func TitleClicked(_ sender: Any) {
        if tbl.isHidden == true {
            tbl.isHidden = false
            Scroll.removeGestureRecognizer(tapGestureRecognizer)
        }else {
            tbl.isHidden = true
            
            Scroll.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @IBAction func CheckClickd(_ sender: Any) {
        if CheckBox.backgroundImage(for: .normal) == #imageLiteral(resourceName: "CheckOFF") {
            CheckBox.setBackgroundImage(#imageLiteral(resourceName: "CheckON"), for: .normal)
        }else         {
            CheckBox.setBackgroundImage(#imageLiteral(resourceName: "CheckOFF"), for: .normal)
        }
    }
    
    @IBAction func Done(_ sender: Any) {
        DOBVw.isHidden = true
    }
    
    @IBAction func DOBClicked(_ sender: Any) {
        self.view.endEditing(true)
        if DOBVw.isHidden == true {
            DOBVw.isHidden = false
        }else {
            DOBVw.isHidden = true
        }
    }
    
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let str = dateFormatter.string(from: datePicker.date)
        DOBButt.setTitle(str, for: .normal)
        DOBButt.setTitleColor(.black, for: .normal)
        print("date : \(str)")
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyyMMdd"
        DOBStr = dateFormatter2.string(from: datePicker.date)
    }
    
    
    @IBAction func RegisterClicked(_ sender: Any) {
        if (FirstName.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please give your first name")
        }else if (FamilyName.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please give your sur name")
        }else if DOBStr == "0" {
            kAppDelegate.shared.showAlert(self, message: "Please give your date of birth")
        }else if (email.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please give your email address")
        }else if !(email.text?.isEmail)! {
            kAppDelegate.shared.showAlert(self, message: "Please enter your valid email address")
        }else if (mobilenumber.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please enter your mobile number")
        }else if !(mobilenumber.text?.isPhoneNumber)! {
            kAppDelegate.shared.showAlert(self, message: "Please enter your valid mobile number")
        }else if (password.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please enter your password")
        }else if (repassword.text?.isBlank)! {
            kAppDelegate.shared.showAlert(self, message: "Please re-enter your password")
        }else if (password.text?.count)! < 6 {
            kAppDelegate.shared.showAlert(self, message: "Please enter minimum 6 charecters for password")
        }else if (password.text?.isAlphanumericBoth)! {
            kAppDelegate.shared.showAlert(self, message: "Password must be alphanumeric")
        }else if password.text != repassword.text {
            kAppDelegate.shared.showAlert(self, message: "Passwords do not match")
        }else if CheckBox.backgroundImage(for: .normal) == #imageLiteral(resourceName: "CheckOFF") {
            kAppDelegate.shared.showAlert(self, message: "Please accept terms and conditions")
        }else {
            let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers1 = ["authorization": "Basic \(base64Credentials)"]
            
            let url = "\(APILink)register"
            
            let parameters: [String: Any] = [
                "name" : FirstName.text!,
                "family" : FamilyName.text!,
                "password" : password.text!,
                "emailAddress" : email.text!,
                "mobileNumber" : mobilenumber.text!,
                "birthDate" : DOBStr,
                "titleType" : TitleNumber,
                "gender" : Gender,
                //"socialSecurityNumber" : AadharNumber.text!
            ]
            print(parameters)
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show(withStatus: "Loading...")
            sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                SVProgressHUD.dismiss()
                if let dict = dataResponse.result.value as? NSDictionary {
                    print("Sign in : \(dict)")
                    if let result = dict["resultType"] as? Int {
                        if result == 1 {
                                let veryfyVC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
                                veryfyVC.token = dict["token"] as! String
                                self.navigationController?.pushViewController(veryfyVC, animated: true)
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
                            //kAppDelegate.shared.showAlert(self, message: "User not verified. Please verify.")
                            OTPPageHeading = "Verify OTP"
                                                        let VerifyViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController")
                                                        self.navigationController?.pushViewController(VerifyViewController!, animated: true)
                        }else if result == 24 {
                            kAppDelegate.shared.showAlert(self, message: "Invalid email address or mobile number.")
                        }else if result == 25 {
                            kAppDelegate.shared.showAlert(self, message: "Invalid request. Please try again")
                        }else if result == 10 {
                            kAppDelegate.shared.showAlert(self, message: "Mobile number already exist.")

//
                        }else {
                            kAppDelegate.shared.showAlert(self, message: "Username or Password Incorrect.")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

struct JSONStringArrayEncoding: ParameterEncoding {
    
    private let myString    : String
    
    init(string: String) {
        self.myString = string
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest.urlRequest
        let data = myString.data(using: .utf8)!
        if urlRequest?.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        urlRequest?.httpBody = data
        return urlRequest!
    }
}
