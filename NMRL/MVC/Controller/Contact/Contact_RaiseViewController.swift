//
//  Contact_RaiseViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 10/04/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices

class Contact_RaiseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {

    @IBOutlet var tbl                       : UITableView!
    @IBOutlet var Scroll                    : SPSignIn!
    @IBOutlet var WhiteVw                   : UIView!
    @IBOutlet var btnLogout                 : UIButton!
    @IBOutlet var DescField                 : UITextField!
    @IBOutlet var ReachButt                 : UIButton!
    @IBOutlet var StationButt               : UIButton!
    @IBOutlet var RemoveButt                : UIButton!
    @IBOutlet var FileNameLbl               : UILabel!
    @IBOutlet var LocationField             : UITextField!
    @IBOutlet var ContentTypeButt           : UIButton!
    @IBOutlet var InternetBlackView         : UIView!
    @IBOutlet var ServiceRequestLbl         : UILabel!
    @IBOutlet var ComplaintSubTypeButt      : UIButton!
    @IBOutlet var ServiceSuccessBlackVw     : UIView!
    
    var ComplaintListSrnoArr        = NSArray()
    var ComplaintListTextArr        = NSArray()
    var SubComplaintSrnoArr         = NSArray()
    var SubComplaintTextArr         = NSArray()
    var ReachDescArr                = NSArray()
    var ReachRiskArr                = NSArray()
    var ComplaintValueStr           = "00"
    var StationFullName             = "00"
    var SubComplaintValueStr        = "00"
    var ReachValueStr               = "00"
    var StationValueStr             = "00"
    var ImageValue                  = UIImage()
    var ImageVw                     = UIImageView()
    var StationTArr                 = NSArray()
    var StationSRArr                = NSArray()
    var TblHeight                   = CGFloat()
    
    var tapGestureRecognizer        : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        TblHeight = tbl.frame.height
        InternetBlackView.isHidden = true
        LogoutBlaceView.isHidden = true
        ServiceSuccessBlackVw.isHidden = true
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
        LocationField.delegate = self
        DescField.delegate = self
        LocationField.addDoneButtonOnKeyboard()
        DescField.addDoneButtonOnKeyboard()
        Scroll.contentSize = CGSize(width : 0, height : 1000)
        if DeviceType.IS_IPHONE_5 {
            Scroll.contentSize = CGSize(width : 0, height : 1100)
        }else if DeviceType.IS_IPHONE_6 {
            Scroll.contentSize = CGSize(width : 0, height : 1200)
        }else if DeviceType.IS_IPHONE_6P {
            Scroll.contentSize = CGSize(width : 0, height : 1300)
        }else if DeviceType.IS_IPHONE_X {
            Scroll.contentSize = CGSize(width : 0, height : 1450)
        }else if DeviceType.IS_IPHONE_XP {
            Scroll.contentSize = CGSize(width : 0, height : 1550)
        }
        GetComplaintList()
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
   func AddGuesture() {
       self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func RemoveGuesture() {
       self.view.removeGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: - Text field delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if DeviceType.IS_IPHONE_5 {
            Scroll.contentSize = CGSize(width : 0, height : 1250)
        }else if DeviceType.IS_IPHONE_6 {
            Scroll.contentSize = CGSize(width : 0, height : 1350)
        }else if DeviceType.IS_IPHONE_6P {
            Scroll.contentSize = CGSize(width : 0, height : 1500)
        }else if DeviceType.IS_IPHONE_X {
            Scroll.contentSize = CGSize(width : 0, height : 1700)
        }else if DeviceType.IS_IPHONE_XP {
            Scroll.contentSize = CGSize(width : 0, height : 1750)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if DeviceType.IS_IPHONE_5 {
            Scroll.contentSize = CGSize(width : 0, height : 1100)
        }else if DeviceType.IS_IPHONE_6 {
            Scroll.contentSize = CGSize(width : 0, height : 1200)
        }else if DeviceType.IS_IPHONE_6P {
            Scroll.contentSize = CGSize(width : 0, height : 1300)
        }else if DeviceType.IS_IPHONE_X {
            Scroll.contentSize = CGSize(width : 0, height : 1450)
        }else if DeviceType.IS_IPHONE_XP  {
            Scroll.contentSize = CGSize(width : 0, height : 1550)
        }
    }
    
    //MARK: - Get complaint List
    func GetComplaintList()
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
        
        let url = "http://220.226.100.106:8000/saprestapi/PG_Complaint_ValueGet?sap-client=120"
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading...")
        Alamofire.request(url, method : .get, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            SVProgressHUD.dismiss()
            if let dict = dataResponse.result.value as? NSDictionary
            {
                
                print("Complaint list : \(dict)")
                
                if let RETURN_MSG = dict["RETURN_MSG"] as? String
                {
                    if RETURN_MSG == "SUCCESS"
                    {
                        if let T_VALUES = dict["T_VALUES"] as? NSArray
                        {
                            if let SRNO = T_VALUES.value(forKey: "SRNO") as? NSArray
                            {
                                self.ComplaintListSrnoArr = SRNO
                            }
                            
                            if let TEXT = T_VALUES.value(forKey: "TEXT") as? NSArray
                            {
                                self.ComplaintListTextArr = TEXT
                            }
                        }
                    }
                }
                
            }
            
            if self.ComplaintListTextArr.count > 0
            {
                self.ContentTypeButt.setTitle("\(self.ComplaintListTextArr[0])", for: .normal)
            }
            
            if self.ComplaintListSrnoArr.count > 0
            {
                self.ComplaintValueStr = "\(self.ComplaintListSrnoArr[0])"
                
                self.GetSubComplaintList(val: "\(self.ComplaintListSrnoArr[0])")
                
            }
            
            
          //  self.GetSubListComplaint()
            
        }
    }
    
    //MARK: - Get Sub List Complaint
    
    func GetSubComplaintList(val : String)
    {
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://220.226.100.106:8000/saprestapi/PG_Comp_FilterGet?sap-client=120")! as URL)
        request.httpMethod = "POST"
        
        let ValueDic = NSMutableDictionary()
        
        ValueDic["cat_id"] = val
        
        let FinalDict = NSMutableDictionary()
        
        FinalDict["create_comp_api"] = ValueDic
        
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
                    
                    print("Sub complaint List : \(responseJSON)")
                    
                    if let RETURN_MSG = responseJSON["RETURN_MSG"] as? String
                    {
                        if RETURN_MSG == "SUCCESS"
                        {
                            if let T_VALUES = responseJSON["T_VALUES"] as? NSArray
                            {
                                if let TEXT = T_VALUES.value(forKey: "TEXT") as? NSArray
                                {
                                    self.SubComplaintTextArr = TEXT
                                }

                                if let SRNO = T_VALUES.value(forKey: "SRNO") as? NSArray
                                {
                                    self.SubComplaintSrnoArr = SRNO
                                }
                                
                                
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        if self.SubComplaintTextArr.count > 0
                        {
                            self.ComplaintSubTypeButt.setTitle("\(self.SubComplaintTextArr[0])", for: .normal)
                        }
                        
                        if self.SubComplaintSrnoArr.count > 0
                        {
                            self.SubComplaintValueStr = "\(self.SubComplaintSrnoArr[0])"
                        }
                        
                        // self.tbl.reloadData()
 
                        self.GetReachList()
                    }
                }
            }
            catch {
                print("Error -> \(error)")
            }
            
        }
        
        
        task.resume()
        
    }
    
 /*   func GetSubListComplaint()
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
        
        let url = "http://220.226.100.106:8000/saprestapi/PG_CompSubType_ValueGet?sap-client=120"
        
        Alamofire.request(url, method : .get, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            
            if let dict = dataResponse.result.value as? NSDictionary
            {
                
                print("Sub list Complaint : \(dict)")
                
                if let RETURN_MSG = dict["RETURN_MSG"] as? String
                {
                    if RETURN_MSG == "SUCCESS"
                    {
                        if let T_VALUES = dict["T_VALUES"] as? NSArray
                        {
                            if let SRNO = T_VALUES.value(forKey: "SRNO") as? NSArray
                            {
                                self.SubComplaintSrnoArr = SRNO
                            }
                            
                            if let TEXT = T_VALUES.value(forKey: "TEXT") as? NSArray
                            {
                                self.SubComplaintTextArr = TEXT
                            }
                        }
                    }
                }
                
                
            }
            
            self.GetReachList()
            
        }
    }
    
    */
    
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
                                    self.StationTArr = TEXT
                                }
                                
                                if let SRNO = T_VALUES.value(forKey: "SRNO") as? NSArray
                                {
                                    self.StationSRArr = SRNO
                                }
                                
                                
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        if self.StationTArr.count > 0
                        {
                            self.StationButt.setTitle("\(self.StationTArr[0])", for: .normal)
                            
                            self.StationFullName = "\(self.StationTArr[0])"
                        }
                        
                        if self.StationSRArr.count > 0
                        {
                            self.StationValueStr = "\(self.StationSRArr[0])"
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
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tbl.tag == 1
        {
            return ComplaintListTextArr.count
        }
        else if tbl.tag == 2
        {
            return SubComplaintTextArr.count
        }
        else if tbl.tag == 3
        {
            return ReachDescArr.count
        }
        else if tbl.tag == 4
        {
            return StationTArr.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if let lbl = cell?.viewWithTag(1) as? UILabel
        {
            if tbl.tag == 1
            {
                if let str = ComplaintListTextArr[indexPath.row] as? String
                {
                    lbl.text = str
                }
            }
            else if tbl.tag == 2
            {
                if let str = SubComplaintTextArr[indexPath.row] as? String
                {
                    lbl.text = str
                }
            }
            else if tbl.tag == 3
            {
                if let str = ReachDescArr[indexPath.row] as? String
                {
                    lbl.text = str
                }
            }
            else if tbl.tag == 4
            {
                if let str = StationTArr[indexPath.row] as? String
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
            if let str = ComplaintListTextArr[indexPath.row] as? String
            {
                ContentTypeButt.setTitle(str, for: .normal)
                
                ComplaintValueStr = "\(ComplaintListSrnoArr[indexPath.row])"
                
                GetSubComplaintList(val: ComplaintValueStr)
            }
        }
        else if tbl.tag == 2
        {
            if let str = SubComplaintTextArr[indexPath.row] as? String
            {
                ComplaintSubTypeButt.setTitle(str, for: .normal)
                
                SubComplaintValueStr = "\(SubComplaintSrnoArr[indexPath.row])"
            }
        }
        else if tbl.tag == 3
        {
            if let str = ReachDescArr[indexPath.row] as? String
            {
                ReachButt.setTitle(str, for: .normal)
                
                ReachValueStr = "\(ReachRiskArr[indexPath.row])"
                
                GetStationList(val: ReachValueStr)
                
            }
        }
        else if tbl.tag == 4
        {
            if let str = StationTArr[indexPath.row] as? String
            {
                StationButt.setTitle(str, for: .normal)
                
                StationValueStr = "\(StationSRArr[indexPath.row])"
                
                StationFullName = str
            }
        }
        
        tbl.isHidden = true
        AddGuesture()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 55
    }
    
    
    
    //MARK: - Actions Buttons
    
    @IBAction func ComplaintClicked(_ sender: Any) {
        
        if tbl.isHidden == true
        {
            tbl.isHidden = false
            
            tbl.frame.origin.y = ContentTypeButt.frame.maxY + 2
            
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
    
    @IBAction func SubComplaintClicked(_ sender: Any) {
        
        if tbl.isHidden == true
        {
            tbl.isHidden = false
            
            tbl.frame.origin.y = ComplaintSubTypeButt.frame.maxY + 2
            
            tbl.tag = 2
            
            tbl.reloadData()
            
            RemoveGuesture()
            
            if SubComplaintTextArr.count < 5
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
    
    @IBAction func StationNameClicked(_ sender: Any) {
        
        if tbl.isHidden == true
        {
            tbl.isHidden = false
            
            tbl.frame.origin.y = StationButt.frame.maxY + 2
            
            tbl.tag = 4
            
            tbl.reloadData()
            
            
            RemoveGuesture()
            
            if StationTArr.count == 3
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
    
    func PickDocument(){
        
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func ImagePicker()
    {
        ImagePickerManager().pickImage(self){ image in
            //here is the image
            //  self.ImageButt.setBackgroundImage(image, for: .normal)
            
            // print("Base 64 string \n \(self.ConvertImageToBase64(image: image))")
            
            self.ImageValue = image
            
            self.ImageVw.image = image
            
            // self.RemoveButt.isHidden = false
            
            self.FileNameLbl.text = "IMG256.png"
        }
        
    }
    
    //MARK: - Document Picker
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        
        print("import result : \(myURL)")
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func RemoveAttachments(_ sender: Any) {
    }
    
    
    
    //MARK: - Submit
    
    @IBAction func Submit(_ sender: Any)
    {
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }
        else
        {
            print("No internet.")
            //  InternetBlackView.isHidden = false
            
            return
        }
        
      
        
        if ComplaintValueStr == "00"
        {
             kAppDelegate.shared.showAlert(self, message: "Please select your complaint")
        }
        else if SubComplaintValueStr == "00"
        {
             kAppDelegate.shared.showAlert(self, message: "Please select your sub complaint")
        }
        else if ReachValueStr == "00"
        {
             kAppDelegate.shared.showAlert(self, message: "Please select your reach type")
        }
        else if StationValueStr == "00"
        {
             kAppDelegate.shared.showAlert(self, message: "Please select your station name")
        }
//        else if ImageVw.image == nil
//        {
//             kAppDelegate.shared.showAlert(self, message: "Please select your file")
//        }
        else
        {
        
           
            
            
            // print("Base 64 \n \(ImgB64)")
            
            
            self.Scroll.setContentOffset(CGPoint.zero, animated: true)
            self.view.endEditing(true)
            
            
            let credentialData = "hbtabap:hbtabap".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers1 = ["authorization": "Basic \(base64Credentials)"]
            print(headers1)
            let url = "http://220.226.100.106:8000/saprestapi/CustomerComplaint_Create?sap-client=120"
            
            let ValueDic = NSMutableDictionary()
            
            ValueDic["i_first_name"] = UserData.current?.customerInfo?.name!.components(separatedBy: " ").first!
            ValueDic["i_last_name"] = UserData.current?.customerInfo?.name!.components(separatedBy: " ").last!
            ValueDic["i_phone_no"] = UserData.current?.customerInfo?.mobileNumber!
            ValueDic["i_email_id"] = UserData.current?.customerInfo?.emailAddress!
            ValueDic["i_reach"] = ReachValueStr
            ValueDic["i_station"] = StationValueStr
            ValueDic["i_location"] = StationValueStr
            ValueDic["i_complaint"] = ComplaintValueStr
            
            ValueDic["i_comp_subtype"] = SubComplaintValueStr
            
            ValueDic["i_country"] = "IN"
            
            if ImageVw.image != nil
            {
                let ImgB64 = ConvertImageToBase64(image: ImageValue)
                
                ValueDic["i_attachment"] = ImgB64
                
                let ImageMimeType = UIImagePNGRepresentation(ImageValue)?.mimeType
                
                print("Mimie type : \(ImageMimeType!)")
                
                ValueDic["i_mimetype"] = ImageMimeType!//.replacingOccurrences(of: "\/", with: "/")
                
                ValueDic["i_filename"] = "fileImg.png"
                
                print("Image name : \(ImageValue.description)")
            }
            
            // "JVBERi0xLjMNCiXi48/TDQolUlNUWFBEg0KMDAwMDAyMjQzMiAwMDAwMCBuDQp0cmFpbGVyDQo8PA0KL1NpemUgMTINCi9Sb290IDExIDAgUg0KL0luZm8gMTAgMCBSDQo+Pg0Kc3RhcnR4cmVmDQoyMjUwOA0KJSVFT0YNCg==" //ImgB64
            
            
            
            let ArrMutable = NSMutableArray()
            
            let TDict = NSMutableDictionary()
            
            TDict["tdline"] = DescField.text!
            
            ArrMutable.add(TDict)
            
//            TDict["tdline"] = "Hello 2"
//
//            ArrMutable.add(TDict)
            
            ValueDic["t_remark"] = ArrMutable
            
            let FinalDict = NSMutableDictionary()
            
            FinalDict["create_cc_api"] = ValueDic
            

            let Str = Convert(dict: FinalDict)
            

            SubmitRequest(url: url, Str: Str)
            
        }
        
    }
    
    //MARK: - Submit Request
    
    func SubmitRequest(url : String, Str : String)
    {
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        
        let postString = Str
        
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = postString.data(using: String.Encoding.utf8)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            SVProgressHUD.dismiss()
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error= \(String(describing: error?.localizedDescription))")
                return
            }
            
            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: data!) as? NSDictionary{
                    print(responseJSON)
                    
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

                print("Error -> \(error.localizedDescription)")
            }
            
        }
        
        task.resume()
        
    }
    
    //MARK: - Image to Base 64
    
    func ConvertImageToBase64(image: UIImage) -> String {
        let imageData = UIImagePNGRepresentation(image)!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    func Convert(dict : NSMutableDictionary) -> String
    {
        let dictionary = dict
        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        //print(jsonString)
        return jsonString!
    }
    
    //MARK: - Hide Service Vw
    
    @IBAction func HideServiceVw(_ sender: Any) {
        
        Back(self)
        ServiceSuccessBlackVw.isHidden = true
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
}
