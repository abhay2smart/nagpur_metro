//
//  Contact_FeedbackViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 12/04/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit

import Alamofire
import CoreData

import MobileCoreServices

class Contact_FeedbackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {
 
    @IBOutlet var Scroll: SPSignIn!
    
     
    
    @IBOutlet var InternetBlackView: UIView!
    
    @IBOutlet var Location: UITextField!
    
    @IBOutlet var OccupationField: UITextField!
    
    @IBOutlet var StationButt: UIButton!
    
    @IBOutlet var ReachButt: UIButton!
    
    @IBOutlet var ExperienceButt: UIButton!
    
    @IBOutlet var tbl: UITableView!

    @IBOutlet var RemoveButt: UIButton!
    
    @IBOutlet var FileNameLbl: UILabel!
    
    @IBOutlet var WhiteVw: UIView!
    
    var ReachDescArr = NSArray()
    
    var ReachRiskArr = NSArray()
    
    var ReachValueStr = "00"
    
    var StationValueStr = "00"
    
    let ExperienceArr = ["Excellent", "Very Good", "Good", "Satisfactory", "Need Improvement"]
    
    var ExperienceValueStr = "00"
    
    var ImageValue = UIImage()
    
    var ImageVw = UIImageView()
    
    var StationTxtArr = NSArray()
    
    var StationSRNOArr = NSArray()
    
    @IBOutlet var UserName: UILabel!
    
    @IBOutlet var UserEmail: UILabel!
    
    @IBOutlet var ServiceSuccessBlackVw: UIView!

    @IBOutlet var ServiceRequestLbl: UILabel!
    
    @IBOutlet var CheckBox: UIButton!
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    var TblHeight = CGFloat()

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
        
        ServiceSuccessBlackVw.isHidden = true
        
        TblHeight = tbl.frame.height
   
        
        tbl.isHidden = true
        
        tbl.layer.borderWidth = 0.5
        tbl.layer.borderColor = UIColor.black.cgColor
        
        tbl.layer.cornerRadius = 5
        tbl.clipsToBounds = true
        
        WhiteVw.layer.borderWidth = 0.5
        WhiteVw.layer.borderColor = UIColor.black.cgColor
        
        WhiteVw.layer.cornerRadius = 5
        WhiteVw.clipsToBounds = true
        
        RemoveButt.isHidden = true
        
        Location.delegate = self
        OccupationField.delegate = self
        
        Location.addDoneButtonOnKeyboard()
        OccupationField.addDoneButtonOnKeyboard()
        
        Scroll.contentSize = CGSize(width : 0, height : 1000)
        
        if DeviceType.IS_IPHONE_5
        {
            Scroll.contentSize = CGSize(width : 0, height : 1250)
        }
        else if DeviceType.IS_IPHONE_6
        {
            Scroll.contentSize = CGSize(width : 0, height : 1350)
        }
        else if DeviceType.IS_IPHONE_6P
        {
            Scroll.contentSize = CGSize(width : 0, height : 1500)
        }
        else if DeviceType.IS_IPHONE_X
        {
            Scroll.contentSize = CGSize(width : 0, height : 1650)
        }
        else if DeviceType.IS_IPHONE_XP
        {
            Scroll.contentSize = CGSize(width : 0, height : 1750)
        }
        
        // Do any additional setup after loading the view.
        
        UserName.text = UserData.current?.customerInfo?.name!
        UserEmail.text = UserData.current?.customerInfo?.emailAddress!
        
        ExperienceButt.setTitle(ExperienceArr[0], for: .normal)
        
        ExperienceValueStr = "\(ExperienceArr[0])"
        
        CheckBox.setBackgroundImage(#imageLiteral(resourceName: "CheckON"), for: .normal)
        
        GetReachList()
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func AddGuesture()
    {
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
//        if DeviceType.IS_IPHONE_5
//        {
//            Scroll.contentSize = CGSize(width : 0, height : 1400)
//        }
//        else if DeviceType.IS_IPHONE_6
//        {
//            Scroll.contentSize = CGSize(width : 0, height : 1500)
//        }
//        else if DeviceType.IS_IPHONE_6P
//        {
//            Scroll.contentSize = CGSize(width : 0, height : 1600)
//        }
//        else if DeviceType.IS_IPHONE_X
//        {
//            Scroll.contentSize = CGSize(width : 0, height : 1700)
//        }
//        else if DeviceType.IS_IPHONE_XP
//        {
//            Scroll.contentSize = CGSize(width : 0, height : 1800)
//        }
    }
    
    func RemoveGuesture()
    {
        self.view.removeGestureRecognizer(tapGestureRecognizer)
        
//        if DeviceType.IS_IPHONE_5
//        {
//            Scroll.contentSize = CGSize(width : 0, height : 1250)
//        }
//        else if DeviceType.IS_IPHONE_6
//        {
//            Scroll.contentSize = CGSize(width : 0, height : 1350)
//        }
//        else if DeviceType.IS_IPHONE_6P
//        {
//            Scroll.contentSize = CGSize(width : 0, height : 1450)
//        }
//        else if DeviceType.IS_IPHONE_X
//        {
//            Scroll.contentSize = CGSize(width : 0, height : 1550)
//        }
//        else if DeviceType.IS_IPHONE_XP
//        {
//            Scroll.contentSize = CGSize(width : 0, height : 1650)
//        }
        
    }
    
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        
    }
    
    //MARK: - Get Reach List
    
    func GetReachList()
    {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }
        else
        {
            print("No internet.")
            InternetBlackView.isHidden = false
            
            return
        }
        
        
        self.Scroll.setContentOffset(CGPoint.zero, animated: true)
        self.view.endEditing(true)
        
 
        let credentialData = "hbtabap:hbtabap".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        let url = "http://220.226.100.106:8000/saprestapi/PG_Reach_ValueGet?sap-client=120"
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading...")
        Alamofire.request(url, method : .get, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            SVProgressHUD.dismiss()
            if let dict = dataResponse.result.value as? NSDictionary
            {
                
                print("Reach list : \(dict)")
                
                
                if let RETURN_MSG = dict["RETURN_MSG"] as? String
                {
                    if RETURN_MSG == "SUCCESS"
                    {
                        if let T_REACH = dict["T_REACH"] as? NSArray
                        {
                            if let DESCRIPTION = T_REACH.value(forKey: "DESCRIPTION") as? NSArray
                            {
                                self.ReachDescArr = DESCRIPTION
                            }
                            
                            if let RISK = T_REACH.value(forKey: "RISK") as? NSArray
                            {
                                self.ReachRiskArr = RISK
                            }
                            
                            
                        }
                    }
                }
                
            }
            
 
            if self.ReachDescArr.count > 0
            {
                self.ReachButt.setTitle("\(self.ReachDescArr[0])", for: .normal)
            }
            
            if self.ReachRiskArr.count > 0
            {
                self.ReachValueStr = "\(self.ReachRiskArr[0])"
                self.GetStationList(val: "\(self.ReachRiskArr[0])")
            }
        }
    }
    
    //MARK: - Get Station List
    
    func GetStationList(val : String){
        
 
        let request = NSMutableURLRequest(url: NSURL(string: "http://220.226.100.106:8000/saprestapi/PG_Station_FilterGet?sap-client=120")! as URL)
        request.httpMethod = "POST"
        
        let ValueDic = NSMutableDictionary()
        
        ValueDic["reach"] = val
        
        let FinalDict = NSMutableDictionary()
        
        FinalDict["create_station_api"] = ValueDic
        
        print("Final dict : \(FinalDict)")
        
        let Str = Convert(dict: FinalDict)
        
        print("Str : \(Str)")
        
        let postString = Str
        print(postString)
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = postString.data(using: String.Encoding.utf8)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
           SVProgressHUD.dismiss()
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error!.localizedDescription)")
                return
            }
            
            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: data!) as? NSDictionary{
                    
                    print("Station List : \(responseJSON)")
                    
                    if let RETURN_MSG = responseJSON["RETURN_MSG"] as? String
                    {
                        if RETURN_MSG == "SUCCESS"
                        {
                            if let T_VALUES = responseJSON["T_VALUES"] as? NSArray
                            {
                                if let TEXT = T_VALUES.value(forKey: "TEXT") as? NSArray
                                {
                                    self.StationTxtArr = TEXT
                                }
                                
                                if let SRNO = T_VALUES.value(forKey: "SRNO") as? NSArray
                                {
                                    self.StationSRNOArr = SRNO
                                }
                                
                                
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        if self.StationTxtArr.count > 0
                        {
                            self.StationButt.setTitle("\(self.StationTxtArr[0])", for: .normal)
                        }
                        
                        if self.StationSRNOArr.count > 0
                        {
                            self.StationValueStr = "\(self.StationSRNOArr[0])"
                        }
                        
                       // self.tbl.reloadData()
                     }
                }
            }
            catch {
                print("Error -> \(error)")
            }
            
        }
        
        
        task.resume()
        
    }
    
    //MARK: - Text field delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if DeviceType.IS_IPHONE_5
        {
            Scroll.contentSize = CGSize(width : 0, height : 1400)
        }
        else if DeviceType.IS_IPHONE_6
        {
            Scroll.contentSize = CGSize(width : 0, height : 1500)
        }
        else if DeviceType.IS_IPHONE_6P
        {
            Scroll.contentSize = CGSize(width : 0, height : 1700)
        }
        else if DeviceType.IS_IPHONE_X
        {
            Scroll.contentSize = CGSize(width : 0, height : 1900)
        }
        else if DeviceType.IS_IPHONE_XP
        {
            Scroll.contentSize = CGSize(width : 0, height : 2000)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        if DeviceType.IS_IPHONE_5
        {
            Scroll.contentSize = CGSize(width : 0, height : 1250)
        }
        else if DeviceType.IS_IPHONE_6
        {
            Scroll.contentSize = CGSize(width : 0, height : 1350)
        }
        else if DeviceType.IS_IPHONE_6P
        {
            Scroll.contentSize = CGSize(width : 0, height : 1500)
        }
        else if DeviceType.IS_IPHONE_X
        {
            Scroll.contentSize = CGSize(width : 0, height : 1650)
        }
        else if DeviceType.IS_IPHONE_XP
        {
            Scroll.contentSize = CGSize(width : 0, height : 1750)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func ExperiecneClicked(_ sender: Any) {
        
        if tbl.isHidden == true
        {
            tbl.isHidden = false
            
            tbl.frame.origin.y = ExperienceButt.frame.maxY + 2
            
            tbl.tag = 1
            
            tbl.reloadData()
            
            RemoveGuesture()
            
            tbl.frame = CGRect(x: tbl.frame.origin.x, y: tbl.frame.origin.y, width: tbl.frame.width, height: TblHeight)
        }
        else
        {
            tbl.isHidden = true
            
            AddGuesture()
        }
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func ReachClicked(_ sender: Any) {
        
        if tbl.isHidden == true
        {
            tbl.isHidden = false
            
            tbl.frame.origin.y = ReachButt.frame.maxY + 2
            
            tbl.tag = 3
            
            tbl.reloadData()
            
            RemoveGuesture()
            
            tbl.frame = CGRect(x: tbl.frame.origin.x, y: tbl.frame.origin.y, width: tbl.frame.width, height: TblHeight)
        }
        else
        {
            tbl.isHidden = true
            
            AddGuesture()
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func StationClicked(_ sender: Any) {
        
        if tbl.isHidden == true
        {
            tbl.isHidden = false
            
            tbl.frame.origin.y = StationButt.frame.maxY + 2
            
            tbl.tag = 4
            
            tbl.reloadData()
            
            RemoveGuesture()
            
            if StationTxtArr.count == 3
            {
                tbl.frame = CGRect(x: tbl.frame.origin.x, y: tbl.frame.origin.y, width: tbl.frame.width, height: 170)
            }
            else
            {
                tbl.frame = CGRect(x: tbl.frame.origin.x, y: tbl.frame.origin.y, width: tbl.frame.width, height: TblHeight)
            }
        }
        else
        {
            tbl.isHidden = true
            
            AddGuesture()
        }
        
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func AddAttachemnts(_ sender: Any) {
        self.view.endEditing(true)
        

        let alert = UIAlertController(title: "Hello user", message: "Please select your media", preferredStyle: UIAlertController.Style.actionSheet)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Photos", style: UIAlertAction.Style.default, handler: { action in
            
            // do something like...
            self.ImagePicker()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Files", style: UIAlertAction.Style.default, handler: { action in
            
            // do something like...
            self.PickDocument()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    
        
    }
    
    //MARK: = Pick Document
    func PickDocument() {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: UIDocumentPickerMode.import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func ImagePicker() {
        ImagePickerManager().pickImage(self){ image in
            self.ImageValue = image
            self.ImageVw.image = image
            self.FileNameLbl.text = "IMG256.png"
        }
    }
    
    @IBAction func RemoveAttachments(_ sender: Any) {
    }
    
    
    //MARK: - Submit
    @IBAction func SubmitClicked(_ sender: Any) {
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }else {
            print("No internet.")
            //  InternetBlackView.isHidden = false
            
            return
        }
        
        
        if ExperienceValueStr == "00"
        {
             kAppDelegate.shared.showAlert(self, message: "Please select your experience value")
        }
      
        else if ReachValueStr == "00"
        {
             kAppDelegate.shared.showAlert(self, message: "Please select your reach type")
        }
        else if StationValueStr == "00"
        {
             kAppDelegate.shared.showAlert(self, message: "Please select your station name")
        }
//        else if Location.text == ""
//        {
//             kAppDelegate.shared.showAlert(self, message: "Please enter your location")
//        }
//        else if ImageVw.image == nil
//        {
//             kAppDelegate.shared.showAlert(self, message: "Please select your file")
//        }
        else
        {
        
       
        
            
//            let ImgB64 = ConvertImageToBase64(image: ImageValue)
//            
//            let ImageMimeType = UIImagePNGRepresentation(ImageValue)?.mimeType
//            
//            print("Mimie type : \(ImageMimeType!)")
        
        
        self.Scroll.setContentOffset(CGPoint.zero, animated: true)
        self.view.endEditing(true)
        
        
        let credentialData = "hbtabap:hbtabap".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        print(headers1)
            
        let url = "http://220.226.100.106:8000/saprestapi/Feedback_Create?sap-client=120"
        
        let ValueDic = NSMutableDictionary()
        
        ValueDic["i_first_name"] = UserData.current?.customerInfo?.name!.components(separatedBy: " ").first!
            ValueDic["i_last_name"] = UserData.current?.customerInfo?.name!.components(separatedBy: " ").last!
        ValueDic["i_phone_no"] = UserData.current?.customerInfo?.mobileNumber!
        ValueDic["i_email_id"] = UserData.current?.customerInfo?.emailAddress!
        ValueDic["i_reach"] = ReachValueStr
        ValueDic["i_age"] = "29"
        ValueDic["i_sex"] = UserData.current?.customerInfo?.gender!
        ValueDic["i_station"] = StationValueStr
        ValueDic["i_location"] = Location.text!
        ValueDic["i_occupation"] = OccupationField.text!
            
            if CheckBox.backgroundImage(for: .normal) == #imageLiteral(resourceName: "CheckON")
            {
                ValueDic["i_travelinmetro"] = "Yes"
            }
            else
            {
                ValueDic["i_travelinmetro"] = "No"
            }
        
        
        ValueDic["i_overallexp"] = ExperienceValueStr
            
            if ImageVw.image != nil
            {
                let ImgB64 = ConvertImageToBase64(image: ImageValue)
                
                ValueDic["i_attachment"] = ImgB64
                
                let ImageMimeType = UIImagePNGRepresentation(ImageValue)?.mimeType
                
                         //   print("Mimie type : \(ImageMime
                
                ValueDic["i_mimetype"] = ImageMimeType!//.replacingOccurrences(of: "\/", with: "/")
                
                ValueDic["i_filename"] = "fileImg.png"
            }
        
        //ValueDic["i_attachment"] = ImgB64//"dcvjhewvchwevchvwhdvhjeqvcghjvwejhcwjhgvchjgsvdchvqshcvqhjsdvchjgqdvsjhcgvq"
        
        ValueDic["i_country"] = "IN"
        
       
        
        let ArrMutable = NSMutableArray()
        
        let TDict = NSMutableDictionary()
        
        TDict["tdline"] = ""
        
        ArrMutable.add(TDict)
        
//        TDict["tdline"] = "Customer Feedback"
//
//        ArrMutable.add(TDict)
        
        ValueDic["t_remark"] = ArrMutable
        
        let FinalDict = NSMutableDictionary()
        
        FinalDict["create_fb_api"] = ValueDic
        
        
        let Str = Convert(dict: FinalDict)
        
        
        SubmitCall(link: url, Str: Str)
            
        }
    }
    
    func SubmitCall(link : String, Str : String)
    {
        
        let request = NSMutableURLRequest(url: NSURL(string: link)! as URL)
        request.httpMethod = "POST"
        
        let postString = Str
        
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = postString.data(using: String.Encoding.utf8)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            SVProgressHUD.dismiss()
            guard error == nil && data != nil else {// check for fundamental networking error
                
                self.view.isUserInteractionEnabled = true
                print("error=\(error!.localizedDescription)")
                return
            }
            
            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: data!) as? NSDictionary{
                    print("Feed back : \(responseJSON)")
                    
                    DispatchQueue.main.async {
                        
                        if let RETURN_MSG = responseJSON["RETURN_MSG"] as? String
                        {
                            if RETURN_MSG == "SUCCESS"
                            {
                                if let RETURN_VALUE = responseJSON["RETURN_VALUE"] as? String
                                {
                                    self.ServiceSuccessBlackVw.isHidden = false
                                    
                                    self.ServiceRequestLbl.text = RETURN_VALUE
                                }
                                
                            }
                            else
                            {
                                 kAppDelegate.shared.showAlert(self, message: "Service Request Creation Failed")
                            }
                        }
                        
                       
                     }
                    
                }
            }
            catch {
                self.view.isUserInteractionEnabled = true
                print("Error -> \(error)")
            }
            
        }
        
        task.resume()
        
    }
        
        func Convert(dict : NSMutableDictionary) -> String
        {
            let dictionary = dict
            let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            //print(jsonString)
            return jsonString!
        }
    
    //MARK: - Image to Base 64
    
    func ConvertImageToBase64(image: UIImage) -> String {
        let imageData = UIImagePNGRepresentation(image)!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    //MARK: - Hide Service Vw
    
    @IBAction func HideServiceVw(_ sender: Any) {
        
        Back(self)
        ServiceSuccessBlackVw.isHidden = true
    }
    
    @IBAction func CheckBoxClicked(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if CheckBox.backgroundImage(for: .normal) == #imageLiteral(resourceName: "CheckON")
        {
            CheckBox.setBackgroundImage(#imageLiteral(resourceName: "CheckOFF"), for: .normal)
        }
        else
        {
            CheckBox.setBackgroundImage(#imageLiteral(resourceName: "CheckON"), for: .normal)
        }
    }
    
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tbl.tag == 1
        {
            return ExperienceArr.count
        }
        else if tbl.tag == 3
        {
            return ReachDescArr.count
        }
        else if tbl.tag == 4
        {
            return StationTxtArr.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if let lbl = cell?.viewWithTag(1) as? UILabel
        {
            if tbl.tag == 1
            {
                if let str = ExperienceArr[indexPath.row]  as? String
                {
                    lbl.text = str
                }
            }

             if tbl.tag == 3
            {
                if let str = ReachDescArr[indexPath.row] as? String
                {
                    lbl.text = str
                }
            }
            else if tbl.tag == 4
            {
                if let str = StationTxtArr[indexPath.row] as? String
                {
                    lbl.text = str
                }
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tbl.tag == 1
        {
            if let str = ExperienceArr[indexPath.row] as? String
            {
                ExperienceButt.setTitle(str, for: .normal)

                ExperienceValueStr = "\(ExperienceArr[indexPath.row])"
            }
        }

         if tbl.tag == 3
        {
            if let str = ReachDescArr[indexPath.row] as? String
            {
                ReachButt.setTitle(str, for: .normal)

                ReachValueStr = "\(ReachRiskArr[indexPath.row])"
                
                GetStationList(val: "\(ReachRiskArr[indexPath.row])")
            }
        }
        else if tbl.tag == 4
        {
            if let str = StationTxtArr[indexPath.row] as? String
            {
                StationButt.setTitle(str, for: .normal)

                StationValueStr = "\(StationSRNOArr[indexPath.row])"
            }
        }
        
        AddGuesture()
        
        tbl.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 55
    }
    
    //MARK: - Document Picker
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        
        print("import result : \(myURL)")
        
        PdfToBase64(str: myURL)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func PdfToBase64(str : URL)
    {
        //let url1 = Bundle.main.url(forResource: "pdffilename without extension", withExtension: "pdf")
        let one1 = NSData(contentsOf: str)
        let pdfstring:String = one1!.base64EncodedString(options: .endLineWithLineFeed)
       print(pdfstring)
    }
    
    
    //MARK: - Internet
    
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
}

extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
