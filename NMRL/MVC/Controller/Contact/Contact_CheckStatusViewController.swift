//
//  Contact_CheckStatusViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 11/04/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit
import Alamofire

class Contact_CheckStatusViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var Scroll: SPSignIn!
    
     
    
    @IBOutlet var InternetBlackView: UIView!
    
    @IBOutlet var tbl: UITableView!
    
    @IBOutlet var tbl2: UITableView!
    
    @IBOutlet var StatusBlackVw: UIView!
    
    var StatusStrArr = NSMutableArray()
    
    let StausArr = ["Good", "Bad", "Average", "Not Helpful", "Rude"]
    
    var SupportButtTag = 0
    
    var SaveComplaintArr = NSArray()
    
    var SaveSubComplaintArr = NSArray()
    
    var CommonComplaintArr = NSMutableArray()
    
    var CommonSRNoArr = NSMutableArray()
    
    var E_ComplaintTypeArr = NSArray()
    
    var E_SubComplaintArr = NSArray()
    
    var E_DateArr = NSArray()
    
    var E_LocationArr = NSArray()
    
    var E_StationArr = NSArray()
    
    var E_StatusArr = NSArray()
    
    var E_DescriptionArr = NSArray()
    
    var E_RequestArr = NSArray()
    
    
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
        
        
        
        StatusBlackVw.isHidden = true
        
        for _ in 0 ..< 10
        {
            StatusStrArr.add("00")
        }
                
        if UserDefaults.standard.value(forKey: "SaveComplaintArr") == nil
        {
            SaveComplaintList()
        }
        else
        {
            SaveComplaintArr = UserDefaults.standard.value(forKey: "SaveComplaintArr") as! NSArray
            
            for i in SaveComplaintArr
            {
                if let k = i as? NSDictionary
                {
                    if let TEXT = k["TEXT"] as? String
                    {
                        CommonComplaintArr.add(TEXT)
                    }
                    
                    if let SRNO = k["SRNO"] as? String
                    {
                        CommonSRNoArr.add(SRNO)
                    }
                }
            }
            
            print("SaveComplaintArr : \(SaveComplaintArr)")
        }
        
        if UserDefaults.standard.value(forKey: "SaveSubComplaintArr") == nil
        {
           SaveSubComplaintList()
        }
        else
        {
            SaveSubComplaintArr = UserDefaults.standard.value(forKey: "SaveSubComplaintArr") as! NSArray
            
            print("SaveSubComplaintArr : \(SaveSubComplaintArr)")
            
            for i in SaveSubComplaintArr
            {
                if let k = i as? NSDictionary
                {
                    if let TEXT = k["TEXT"] as? String
                    {
                        CommonComplaintArr.add(TEXT)
                    }
                    
                    if let SRNO = k["SRNO"] as? String
                    {
                        CommonSRNoArr.add(SRNO)
                    }
                }
            }
        }
        
        Requests()
        
        
        // Do any additional setup after loading the view.
    }
    
    func SaveComplaintList()
    {
     
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
                           self.SaveComplaintArr = T_VALUES
                        }
                    }
                }
                
            }
            
            if self.SaveComplaintArr.count > 0
            {
                UserDefaults.standard.set(self.SaveComplaintArr, forKey: "SaveComplaintArr")
                UserDefaults.standard.synchronize()
            }
            
            for i in self.SaveComplaintArr
            {
                if let k = i as? NSDictionary
                {
                    if let TEXT = k["TEXT"] as? String
                    {
                        self.CommonComplaintArr.add(TEXT)
                    }
                    
                    if let SRNO = k["SRNO"] as? String
                    {
                        self.CommonSRNoArr.add(SRNO)
                    }
                }
            }
            
            
        }
    }
    
    func SaveSubComplaintList() {
        
        self.view.endEditing(true)
        
        
        let credentialData = "hbtabap:hbtabap".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        let url = "http://220.226.100.106:8000/saprestapi/PG_CompSubType_ValueGet?sap-client=120"
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading...")
        Alamofire.request(url, method : .get, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            SVProgressHUD.dismiss()
            if let dict = dataResponse.result.value as? NSDictionary
            {
                
                print("Sub complaint list : \(dict)")
                
                if let RETURN_MSG = dict["RETURN_MSG"] as? String
                {
                    if RETURN_MSG == "SUCCESS"
                    {
                        if let T_VALUES = dict["T_VALUES"] as? NSArray
                        {
                            self.SaveSubComplaintArr = T_VALUES
                        }
                    }
                }
                
            }
            
            if self.SaveSubComplaintArr.count > 0
            {
                UserDefaults.standard.set(self.SaveSubComplaintArr, forKey: "SaveSubComplaintArr")
                UserDefaults.standard.synchronize()
            }
            
            for i in self.SaveSubComplaintArr
            {
                if let k = i as? NSDictionary
                {
                    if let TEXT = k["TEXT"] as? String
                    {
                        self.CommonComplaintArr.add(TEXT)
                    }
                    
                    if let SRNO = k["SRNO"] as? String
                    {
                        self.CommonSRNoArr.add(SRNO)
                    }
                }
            }
            
            
        }
    }
    
    //MARK: - Requests
    
    func Requests()
    {
        self.view.endEditing(true)
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }
        else
        {
            print("No internet.")
             kAppDelegate.shared.showAlert(self, message: "Internet connectivity not available.")
            self.Back(self)
            //InternetBlackView.isHidden = false
            
            return
        }
        
       // self.Scroll.setContentOffset(CGPoint.zero, animated: true)
        
       
        
        let credentialData = "hbtabap:hbtabap".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        print(headers1)
        
        let ValueDic = NSMutableDictionary() //
        
        ValueDic["e_request_no"] = "" //PG8000000143
        ValueDic["e_first_name"] = ""//PublicNameStr.components(separatedBy: " ").first!
        ValueDic["e_last_name"] = ""//PublicNameStr.components(separatedBy: " ").last!
        ValueDic["e_phone_no"] = UserData.current?.customerInfo?.mobileNumber!
        ValueDic["e_email_id"] = ""//PublicEmailAddres
       
        ValueDic["e_complaint"] = ""
        ValueDic["e_comp_subtype"] = ""
        ValueDic["e_location"] = ""
        ValueDic["e_station"] = ""
     
        ValueDic["e_date_from"] = ""
        ValueDic["e_date_to"] = ""
        
        
        let FinalDict = NSMutableDictionary()
        
        FinalDict["create_pg_api"] = ValueDic
        
        print("Final Dict : \(FinalDict)")
        
        let Str = Convert(dict: FinalDict)
        
        SubmitRequest(val: Str)
        
    }
    
    func SubmitRequest(val : String)
    {
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://220.226.100.106:8000/saprestapi/PG_ServiceStatus_ValueGet?sap-client=120")! as URL)
        request.httpMethod = "POST"
        
        let postString = val
        
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = postString.data(using: String.Encoding.utf8)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading...")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            SVProgressHUD.dismiss()
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error!.localizedDescription)")
                return
            }
            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: data!) as? NSDictionary{
                    print("Status List : \(responseJSON)")
                    
                    DispatchQueue.main.async {
                        
                        if let RETURN_MSG = responseJSON["RETURN_MSG"] as? String
                        {
                            if RETURN_MSG == "SUCCESS"
                            {
                                if let T_VALUES = responseJSON["T_VALUES"] as? NSArray
                                {
                                    if let E_COMPLAINT = T_VALUES.value(forKey: "E_COMPLAINT") as? NSArray
                                    {
                                        self.E_ComplaintTypeArr = E_COMPLAINT
                                    }
                                    
                                    if let E_COMP_SUBTYPE = T_VALUES.value(forKey: "E_COMP_SUBTYPE") as? NSArray
                                    {
                                        self.E_SubComplaintArr = E_COMP_SUBTYPE
                                    }
                                    
                                    if let E_DATE = T_VALUES.value(forKey: "E_DATE") as? NSArray
                                    {
                                        self.E_DateArr = E_DATE
                                    }
                                    
                                    if let E_LOCATION = T_VALUES.value(forKey: "E_LOCATION") as? NSArray
                                    {
                                        self.E_LocationArr = E_LOCATION
                                    }
                                    
                                    if let E_STATION = T_VALUES.value(forKey: "E_STATION") as? NSArray
                                    {
                                        self.E_StationArr = E_STATION
                                    }
                                    
                                    if let E_STATUS = T_VALUES.value(forKey: "E_STATUS") as? NSArray
                                    {
                                        self.E_StatusArr = E_STATUS
                                    }
                                    
                                    if let E_REQUEST_NO = T_VALUES.value(forKey: "E_REQUEST_NO") as? NSArray
                                    {
                                        self.E_RequestArr = E_REQUEST_NO
                                    }
                                    
                                    if let E_DESCRIPTION = T_VALUES.value(forKey: "E_DESCRIPTION") as? NSArray
                                    {
                                        self.E_DescriptionArr = E_DESCRIPTION
                                        
//                                        if E_DESCRIPTION.count > 0
//                                        {
//                                            if let dic = E_DESCRIPTION.object(at: 0) as? NSDictionary
//                                            {
//                                                if let TDLINE = dic["TDLINE"] as? String
//                                                {
//
//                                                }
//                                            }
//                                        }
                                        
                                    }
                                }
                                
                            }
                            else
                            {
                                if let RETURN_LOG = responseJSON["RETURN_LOG"] as? NSArray
                                {
                                    if RETURN_LOG.count > 0
                                    {
                                        if let dik = RETURN_LOG.object(at: 0) as? NSDictionary
                                        {
                                            if let str = dik["RETURN_MSG"] as? String
                                            {
                                                 kAppDelegate.shared.showAlert(self, message: str)
                                            }
                                            else
                                            {
                                                 kAppDelegate.shared.showAlert(self, message: "Status list fetch failed.")
                                            }
                                        }
                                        else
                                        {
                                             kAppDelegate.shared.showAlert(self, message: "Status list fetch failed.")
                                        }
                                    }
                                    else
                                    {
                                         kAppDelegate.shared.showAlert(self, message: "Status list fetch failed.")
                                    }
                                }
                                else
                                {
                                     kAppDelegate.shared.showAlert(self, message: "Status list fetch failed.")
                                }
                                
                                self.Back(self)
                            }
                        }
                        
                        self.tbl.reloadData()
                    }
                    
                }
            }
            catch {
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
    
    
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tbl
        {
            return E_StatusArr.count
        }
        
        return StausArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tbl
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
            
            if let Vw = cell?.viewWithTag(5)
            {
                Vw.layer.borderWidth = 0.5
                Vw.layer.borderColor = UIColor.black.cgColor
                
                Vw.layer.cornerRadius = 5
                Vw.clipsToBounds = true
            }
            
            if let open = cell?.viewWithTag(4) as? UILabel
            {
                open.layer.borderWidth = 0.5
                open.layer.borderColor = UIColor.black.cgColor
                
                open.layer.cornerRadius = 5
                open.clipsToBounds = true
            }
            
            if let dat = cell?.viewWithTag(1) as? UILabel
            {
                dat.text = "\(E_DateArr[indexPath.row])"
            }
            
            if let heading = cell?.viewWithTag(2) as? UILabel
            {
                if let DesArr = E_DescriptionArr[indexPath.row] as? NSArray
                {
                    if DesArr.count > 0
                    {
                        if let dic = DesArr.object(at: 0) as? NSDictionary
                        {
                            if let str = dic["TDLINE"] as? String
                            {
                              heading.text = str
                            }
                            if heading.text == ""
                            {
                                heading.text = "No description provided"
                            }
                        }
                    }
                    else
                    {
                        heading.text = "No description provided"
                    }
                }
            }
            
            if let station = cell?.viewWithTag(3) as? UILabel
            {
                station.text = "\(E_StationArr[indexPath.row])"
            }
            
            
            if let Status = E_StatusArr[indexPath.row] as? String
            {
                if Status != "Open"
                {
                    
                        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2") as! Contact_CheckStatus_ClosedCellTableViewCell
                        
                        cell2.Vw.layer.borderWidth = 0.5
                        cell2.Vw.layer.borderColor = UIColor.black.cgColor
                        cell2.Vw.layer.cornerRadius = 5
                        cell2.Vw.clipsToBounds = true
                        
                        
                        cell2.ClosedLbl.layer.borderWidth = 0.5
                        cell2.ClosedLbl.layer.borderColor = UIColor.black.cgColor
                        cell2.ClosedLbl.layer.cornerRadius = 5
                        cell2.ClosedLbl.clipsToBounds = true
                        
                        cell2.SupportButt.layer.borderWidth = 0.5
                        cell2.SupportButt.layer.borderColor = UIColor.black.cgColor
                        cell2.SupportButt.tag = indexPath.row
                        
                        if !DeviceType.IS_IPHONE_5
                        {
                            cell2.SupportHeadingLbl.font = UIFont(name: "Montserrat-Bold", size: 14)
                        }
                        
                        if let abc = StatusStrArr[indexPath.row] as? String
                        {
                            if abc != "00"
                            {
                                cell2.SupportButt.setTitle(abc, for: .normal)
                            }
                            else
                            {
                                cell2.SupportButt.setTitle("", for: .normal)
                            }
                        }
                        
                        //                    if "\(StatusStrArr[indexPath.row])" != "00"
                        //                    {
                        //
                        //                    }
                        
                        return cell2
                    
                }
            }
            
        
       return cell!
            
        }
            
        else
        {
            let cell3 = tbl2.dequeueReusableCell(withIdentifier: "cell3")
            
            if let lbl = cell3?.viewWithTag(1) as? UILabel
            {
                lbl.text = StausArr[indexPath.row]
            }
            
            return cell3!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tbl2
        {
            StatusStrArr.replaceObject(at: SupportButtTag, with: "\(StausArr[indexPath.row])")
            
            print("SupportButtTag : \(SupportButtTag)")
            
            print("StatusStrArr : \(StatusStrArr)")
            
            let indexPath = IndexPath(row: SupportButtTag, section: 0)
            UIView.performWithoutAnimation {
                self.tbl.reloadRows(at: [indexPath], with: .none)
            }

            
            StatusBlackVw.isHidden = true
        }
        else
        {
            let Contact_ComplaintDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "Contact_ComplaintDetailsViewController") as! Contact_ComplaintDetailsViewController
            
            if let DesArr = E_DescriptionArr[indexPath.row] as? NSArray
            {
                if DesArr.count > 0
                {
                    if let dic = DesArr.object(at: 0) as? NSDictionary
                    {
                        if let str = dic["TDLINE"] as? String
                        {
                            Contact_ComplaintDetailsViewController.HeadingStr = str
                            
                            Contact_ComplaintDetailsViewController.ComplaintDescStr = str
                        }
                    }
                }
            }
            
            if let str1 = E_ComplaintTypeArr[indexPath.row] as? String
            {
                print("Str 1 : \(str1)")
                
                if str1 != ""
                {
                    let ind1 = CommonSRNoArr.index(of: str1)
                    
                    Contact_ComplaintDetailsViewController.ComplaintStr = "\(CommonComplaintArr[ind1])"
                }
                
            }
            
            if let str2 = E_SubComplaintArr[indexPath.row] as? String
            {
                print("str2 : \(str2)")
                
                if str2 != ""
                {
                    let ind2 = CommonSRNoArr.index(of: str2)
                    
                    Contact_ComplaintDetailsViewController.SubComplaintStr = "\(CommonComplaintArr[ind2])"
                }
                
            }
 
            
            Contact_ComplaintDetailsViewController.RequestStr = "\(E_RequestArr[indexPath.row])"
            
            Contact_ComplaintDetailsViewController.StatusStr = "\(E_StatusArr[indexPath.row])"
            
            Contact_ComplaintDetailsViewController.DateStr = "\(E_DateArr[indexPath.row])"
            
            Contact_ComplaintDetailsViewController.LocationStr = "\(E_LocationArr[indexPath.row])"
            
            Contact_ComplaintDetailsViewController.StationStr = "\(E_LocationArr[indexPath.row])"
            
            print("E_LocationArr : \(E_LocationArr)")
            
            self.navigationController?.pushViewController(Contact_ComplaintDetailsViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tbl
        {
            if let Status = E_StatusArr[indexPath.row] as? String
            {
                if Status != "Open"
                {
                    return 280
                }
            }
            
            return 160
        }
        else
        {
            return 55
        }
       
    }
    
    
    @IBAction func SupportClicked(_ sender: Any) {
        
        SupportButtTag = (sender as AnyObject).tag
        
        print("SupportButtTag : \(SupportButtTag)")
        
        StatusBlackVw.isHidden = false
    }
    
    @IBAction func HideSupportVw(_ sender: Any) {
        
        StatusBlackVw.isHidden = true
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
