//
//  ViewBookedTicketsViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 13/08/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

/*

import UIKit

import Alamofire

var CheckViewAppear = Int()

class ViewBookedTicketsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var tbl: UITableView!
    
    var Dict = NSDictionary()
    
    var StatusStr = "0"
    
    var PreviousStatusstr = String()
    
    var EnterStr = String()
    
    var ExitStr = String()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Review Ticket Dict : \(Dict)")
        
         CheckViewAppear = 1
        
        GetTransactionList()
        
        
        
        self.view.backgroundColor = UIColor.hexStr(hexStr: "E9E7E7", alpha: 1)
                
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        CheckViewAppear = 0
        
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }

        }
        
    }
    
    func GetTransactionList()
    {
        if CheckViewAppear == 1
        {
     
        
       PreviousStatusstr = StatusStr
        
        let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        let url = "\(APILink)ticket/get-transaction-list"
        
        let parameters: [String: Any] = [
            "token" : UserData.current!.token!,
            "ticketSerial" : "\(Dict["ticketSerial"]!)",
            "issueDate": "\(Dict["expirationDate"]!)"
        ]
        
        print("parameters : \(parameters)")
        
        Alamofire.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            
            print(dataResponse.result.value)
            
            if let dict = dataResponse.result.value as? NSDictionary
            {
                if let result = dict["resultType"] as? Int
                {
                    
                    
                    if result == 1
                    {
                        if let tok = dict["token"] as? String
                        {
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
                        
                        if let status = dict["status"] as? String
                        {
                            self.StatusStr = status
                        }
                        
                        if let entranceCount = dict["entranceCount"] as? String
                        {
                            self.EnterStr = entranceCount
                        }
                        else
                        {
                            self.EnterStr = "0"
                        }
                        
                        if let exitCount = dict["exitCount"] as? String
                        {
                            self.ExitStr = exitCount
                        }
                        else
                        {
                            self.ExitStr = "0"
                        }
                        
                    }
                }
            }
            
            if self.PreviousStatusstr != self.StatusStr
            {
                self.tbl.reloadData()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                self.GetTransactionList()
                
                }
        }
    }
}
    
    
    //MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if let img = cell?.viewWithTag(1) as? UIImageView
        {
            img.image = generateQRCode(from: "\(String(describing: Dict["ticketContent"]))")
        }
        
        if let purchase = cell?.viewWithTag(12) as? UILabel
        {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyyMMddHHmmss"
            
            let showDate = inputFormatter.date(from: "\(Dict["purchaseDate"]!)")
            
            inputFormatter.dateFormat = "yyyy-MM-dd"
            
            inputFormatter.dateStyle = .long
            
            inputFormatter.timeStyle = .medium
            
            let resultString = inputFormatter.string(from: showDate!)
            
            purchase.text = "Purchased on \(resultString.replacingOccurrences(of: "at", with: ""))"
        }
        
        if let expire = cell?.viewWithTag(13) as? UILabel
        {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyyMMddHHmmss"
            let showDate = inputFormatter.date(from: "\(Dict["expirationDate"]!)")
            
            inputFormatter.dateFormat = "yyyy-MM-dd"
            
            inputFormatter.dateStyle = .long
            
            inputFormatter.timeStyle = .medium
            
            let resultString = inputFormatter.string(from: showDate!)
            
            expire.text = "Expires by \(resultString.replacingOccurrences(of: "at", with: ""))"
        }
        
        if let pass = cell?.viewWithTag(14) as? UILabel
        {
            pass.text = "1 passenger"
        }
        
        if let sor = cell?.viewWithTag(15) as? UILabel
        {
            if let ii = Dict["sourceStation1"] as? Int
            {
                sor.text = "\(String(describing: PublicLogicalStationIDDict.value(forKey: "\(ii)")!))"
            }
        }
        
        if let des = cell?.viewWithTag(16) as? UILabel
        {
            if let ii = Dict["destinationStation1"] as? Int
            {
                des.text = "\(String(describing: PublicLogicalStationIDDict.value(forKey: "\(ii)")!))"
            }
        }
        if let status = cell?.viewWithTag(17) as? UILabel
        {
           if StatusStr != "0"
           {
            status.text = "Current status \(StatusStr)"
            }
        }
        
        if let entry = cell?.viewWithTag(11) as? UILabel
        {
            entry.text = "ENTRY COUNT \(EnterStr) / \(String(describing: Dict["tripsCount"]!))"
        }
        
        if let exit = cell?.viewWithTag(21) as? UILabel
        {
            exit.text = "EXIT COUNT \(ExitStr) / \(String(describing: Dict["tripsCount"]!))"
        }
        
        if let img = cell?.viewWithTag(25) as? UIImageView
        {
            if let qrType = Dict["qrType"] as? String
            {
                if qrType == "SJT"
                {
                    img.image = #imageLiteral(resourceName: "RightArrow")
                }
                else if qrType == "RJT"
                {
                    img.image = #imageLiteral(resourceName: "DoubleArrowBlack")
                }
                else
                {
                    img.image = #imageLiteral(resourceName: "GroupBlack")
                }
            }
        }
        
        cell?.backgroundColor = UIColor.white
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if DeviceType.IS_IPHONE_5
        {
            return 475
            
        }
        else if DeviceType.IS_IPHONE_6
        {
            return 475
        }
        else
        {
            return 475
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    
   
    
    @IBAction func Back(_ sender: Any) {
        
        CheckViewAppear = 0
        
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
            
        }
        
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

*/


//
//  ViewBookedTicketsViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 13/08/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

var CheckViewAppear = Int()

class ViewBookedTicketsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tbl               : UITableView!
    @IBOutlet var btnLogout         : UIButton!
    @IBOutlet var LogoutBlaceView   : UIView!
    
    var Dict                = NSDictionary()
    var StatusDict          = NSDictionary()
    var StatusStr           = "0"
    var ExpiredStatusStr    = "0"
    var PreviousStatusstr   = String()
    var EnterStr            = String()
    var ColorValue          = Int()
    var ExitStr             = String()
    var TicketSerialNumber  = Int()
    var BrightnessValue     = UIScreen.main.brightness
    var PassengerCount      = String()
    var ValueIndex          = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        TicketSerialNumber = Dict["ticketSerial"] as! Int
        StatusDict = Public_AlreadySavedTicketStatusData["\(TicketSerialNumber)"] as! NSDictionary
        CheckViewAppear = 1
        LogoutBlaceView.isHidden = true
        if let Expire = Dict["expirationDate"] as? String {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyyMMddHHmmss"
            var showDate = inputFormatter.date(from: "\(Expire)")
            showDate = showDate!.adding(minutes: 0)
            if Date() > showDate! {
                print("Expired")
                ExpiredStatusStr = "1"
                Public_TicketStatusMutableArr.replaceObject(at: self.ValueIndex, with: "EXPIRED")
            }
        }
        PassengerCount = "1"
        GetTransactionList()
        self.view.backgroundColor = UIColor.hexStr(hexStr: "E9E7E7", alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        UIScreen.main.brightness = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        CheckViewAppear = 0
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
        UIScreen.main.brightness = BrightnessValue
    }
    
    //MARK: - Get Transaction List
    func GetTransactionList() {
        if UserData.current?.token != nil {
            if CheckViewAppear == 1 {
                PreviousStatusstr = StatusStr
                let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
                let base64Credentials = credentialData.base64EncodedString(options: [])
                let headers1 = ["authorization": "Basic \(base64Credentials)"]
                
                let url = "\(APILink)ticket/get-transaction-list"
                
                let parameters: [String: Any] = [
                    "token" : UserData.current!.token!,
                    "ticketSerial" : "\(Dict["ticketSerial"]!)",
                    "issueDate": "\(Dict["expirationDate"]!)"
                ]
                
                sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                    if let dict = dataResponse.result.value as? NSDictionary {
                        print("get-transaction-list : \(dict)")
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
                                let dict2 = NSMutableDictionary()
                                if let status = dict["status"] as? String {
                                    self.StatusStr = status
                                    dict2.setValue(status, forKey: "Status")
                                    if let abc = Public_TicketStatusMutableArr.object(at: self.ValueIndex) as? String {
                                        if abc != "EXPIRED" {
                                            Public_TicketStatusMutableArr.replaceObject(at: self.ValueIndex, with: status)
                                        }
                                    }
                                }
                                if let entranceCount = dict["entranceCount"] as? String {
                                    self.EnterStr = entranceCount
                                    dict2.setValue(entranceCount, forKey: "EntryCount")
                                }else {
                                    self.EnterStr = "0"
                                    dict2.setValue("0", forKey: "EntryCount")
                                }
                                if let exitCount = dict["exitCount"] as? String {
                                    self.ExitStr = exitCount
                                    dict2.setValue(exitCount, forKey: "ExitCount")
                                }else {
                                    self.ExitStr = "0"
                                    dict2.setValue("0", forKey: "ExitCount")
                                }
                                if let color = dict["color"] as? Int {
                                    print("Color = \(color)")
                                    self.ColorValue = color
                                }
                                Public_AlreadySavedTicketStatusData.setValue(dict2, forKey: "\(self.TicketSerialNumber)")
                            }
                        }
                    }
                    print("self.PreviousStatusstr : \(self.PreviousStatusstr)")
                    print("self.StatusStr : \(self.StatusStr)")
                    if self.PreviousStatusstr != self.StatusStr {
                        self.tbl.reloadData()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.GetTransactionList()
                    }
                }
            }
        }
    }
    
    //MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if let img = cell?.viewWithTag(1) as? UIImageView {
            img.image = generateQRCode(from: "\(String(describing: Dict["ticketContent"]!))")
            img.layer.borderWidth = 5
            img.layer.cornerRadius = 5
            img.clipsToBounds = true
            if ColorValue == 0 {
                img.layer.borderColor = UIColor.white.cgColor
            }else if ColorValue == 1 {
                img.layer.borderColor = UIColor.white.cgColor
            }else {
                img.layer.borderColor = UIColor.white.cgColor
            }
        }
        if let purchase = cell?.viewWithTag(12) as? UILabel {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyyMMddHHmmss"
            let showDate = inputFormatter.date(from: "\(Dict["purchaseDate"]!)")
            inputFormatter.dateFormat = "yyyy-MM-dd"
            inputFormatter.dateStyle = .long
            inputFormatter.timeStyle = .medium
            let resultString = inputFormatter.string(from: showDate!)
            purchase.text = "Purchased on \(resultString.replacingOccurrences(of: "at", with: ""))"
        }
        if let expire = cell?.viewWithTag(13) as? UILabel {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyyMMddHHmmss"
            let showDate = inputFormatter.date(from: "\(Dict["expirationDate"]!)")
            inputFormatter.dateFormat = "yyyy-MM-dd"
            inputFormatter.dateStyle = .long
            inputFormatter.timeStyle = .medium
            let resultString = inputFormatter.string(from: showDate!)
            expire.text = "Expires by \(resultString.replacingOccurrences(of: "at", with: ""))"
        }
        if let pass = cell?.viewWithTag(14) as? UILabel {
            if PassengerCount == "1" {
                pass.text = "\(PassengerCount) passenger"
            }else {
                pass.text = "\(PassengerCount) passengers"
            }
        }
        if let sor = cell?.viewWithTag(15) as? UILabel {
            if let ii = Dict["sourceStation1"] as? Int {
                if let str1 = PublicLogicalStationIDDict.value(forKey: "\(ii)") as? String {
                    sor.text = str1
                }
                //sor.text = "\(String(describing: PublicLogicalStationIDDict.value(forKey: "\(ii)")!))"
            }
        }
        if let des = cell?.viewWithTag(16) as? UILabel {
            if let ii = Dict["destinationStation1"] as? Int {
                if let str1 = PublicLogicalStationIDDict.value(forKey: "\(ii)") as? String {
                    des.text = str1
                }
                //des.text = "\(String(describing: PublicLogicalStationIDDict.value(forKey: "\(ii)")!))"
            }
        }
        if let entry = cell?.viewWithTag(11) as? UILabel {
            entry.text = "ENTRY COUNT   :   \(EnterStr) / \(String(describing: Dict["tripsCount"]!))"
        }
        
        if let exit = cell?.viewWithTag(21) as? UILabel {
            exit.text = "EXIT COUNT   :   \(ExitStr) / \(String(describing: Dict["tripsCount"]!))"
        }
        if let img = cell?.viewWithTag(25) as? UIImageView {
            if let qrType = Dict["qrType"] as? String {
                if qrType == "SJT" {
                    img.image = #imageLiteral(resourceName: "RightArrow")
                }else if qrType == "RJT" {
                    img.image = #imageLiteral(resourceName: "DoubleArrowBlack")
                }else {
                    img.image = #imageLiteral(resourceName: "GroupBlack")
                }
            }
        }
        if let colorLbl = cell?.viewWithTag(20) as? UILabel {
            if ColorValue == 0 {
                colorLbl.backgroundColor = UIColor.hexStr(hexStr: "CDCDCD", alpha: 1) //CDCDCD
            }else if ColorValue == 1 {
                colorLbl.backgroundColor = UIColor.hexStr(hexStr: "4BC6A8", alpha: 1)
            }else {
                colorLbl.backgroundColor = .red
                
            }
            if ExpiredStatusStr == "1" {
                colorLbl.backgroundColor = .red
            }
            if StatusStr == "EXPIRED" {
                colorLbl.backgroundColor = .red
            }
        }
        if let colorLbl2 = cell?.viewWithTag(30) as? UILabel {
            if ColorValue == 0 {
                colorLbl2.backgroundColor = UIColor.hexStr(hexStr: "CDCDCD", alpha: 1)
            }else if ColorValue == 1 {
                colorLbl2.backgroundColor = UIColor.hexStr(hexStr: "4BC6A8", alpha: 1)
            }else {
                colorLbl2.backgroundColor = .red
            }
            colorLbl2.layer.cornerRadius = 10
            colorLbl2.clipsToBounds = true
            print("Table view : \(StatusStr)")
            if let status = cell?.viewWithTag(17) as? UILabel {
                if StatusStr != "0" {
                    status.text = "CURRENT STATUS : \(StatusStr)".uppercased()
                    status.textColor = UIColor.hexStr(hexStr: "FF9300", alpha: 1)
                    if StatusStr == "UNUSED" {
                        status.text = "CURRENT STATUS : TICKET NOT USED"
                    }
                    if StatusStr == "USED" {
                        status.text = "CURRENT STATUS : TICKET USED FOR ENTRY"
                        status.textColor = .green
                    }
                    if StatusStr == "USABLE_FOR_EXIT" {
                        status.text = "CURRENT STATUS : TICKET CAN BE USED FOR EXIT"
                        status.textColor = .green
                    }
                    if StatusStr == "IN_USE" {
                        status.text = "CURRENT STATUS : TICKET CURRENTLY IN USE"
                        status.textColor = .green
                    }
                    if ExpiredStatusStr == "1" {
                        status.text = "CURRENT STATUS : THIS TICKET IS EXPIRED"
                        status.textColor = .red
                        colorLbl2.backgroundColor = .red
                    }
                    
                    if StatusStr == "EXPIRED" {
                        status.text = "CURRENT STATUS : THIS TICKET IS EXPIRED"
                        status.textColor = .red
                        colorLbl2.backgroundColor = .red
                    }
                }
            }
        }
        cell?.backgroundColor = UIColor.white
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if DeviceType.IS_IPHONE_5 {
            return 475
        }else if DeviceType.IS_IPHONE_6 {
            return 540
        }else {
            return 550
        }
    }
    
    //MARK: - Log Out View
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
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    @IBAction func Back(_ sender: Any) {
        CheckViewAppear = 0
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
