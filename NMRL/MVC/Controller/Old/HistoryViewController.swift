//
//  HistoryViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 13/08/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import Alamofire

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tbl   : UITableView!
    
    var ExpireArr       = NSArray()
    var TicketsArr      = NSArray()
    var PurchaseArr     = NSArray()
    var SorceStationArr = NSArray()
    var DestStationArr  = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if TicketsArr.count > 0 {
            TicketsArr = TicketsArr.object(at: 0) as! NSArray
        }else {
            TicketHistory()
        }
        PublicCalculateQRAgain = 1
    }
    
    func TicketHistory() {
        if UserData.current?.token != nil {
            let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers1 = ["authorization": "Basic \(base64Credentials)"]
            let url = "\(APILink)ticketHistory"
            
            sessionManager1.request(url, method : .post, parameters : ["token" : UserData.current!.token!,], encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
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
                            if let arr = dict["tickets"] as? NSArray {
                                if let pur = arr.value(forKey: "purchaseDate") as?NSArray {
                                    self.PurchaseArr = pur
                                }
                                if let expirationDate = arr.value(forKey: "expirationDate") as?NSArray {
                                    self.ExpireArr = expirationDate
                                }
                                if let sourceStation1 = arr.value(forKey: "sourceStation1") as?NSArray {
                                    self.SorceStationArr = sourceStation1
                                }
                                if let destinationStation1 = arr.value(forKey: "destinationStation1") as? NSArray {
                                    self.DestStationArr = destinationStation1
                                }
                            }
                        }
                    }
                }
                self.tbl.reloadData()
            }
        }
    }
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TicketsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyTicketTableViewCell
        if let PurLbl = cell.viewWithTag(1) as? UILabel {
            if let purchaseDate = TicketsArr.value(forKey: "purchaseDate") as? NSArray {
                if let dat = purchaseDate.object(at: indexPath.row) as? String {
                    let inputFormatter = DateFormatter()
                    inputFormatter.dateFormat = "yyyyMMddHHmmss"
                    let showDate = inputFormatter.date(from: "\(dat)")
                    inputFormatter.dateFormat = "yyyy-MM-dd"
                    inputFormatter.dateStyle = .long
                    inputFormatter.timeStyle = .medium
                    let resultString = inputFormatter.string(from: showDate!)
                    PurLbl.text = "Purchased on \(resultString.replacingOccurrences(of: "at", with: ""))"
                }
            }
        }
        if let ExpLbl = cell.viewWithTag(2) as? UILabel {
            if let purchaseDate = TicketsArr.value(forKey: "expirationDate") as? NSArray {
                if let dat = purchaseDate.object(at: indexPath.row) as? String {
                    let inputFormatter = DateFormatter()
                    inputFormatter.dateFormat = "yyyyMMddHHmmss"
                    let showDate = inputFormatter.date(from: "\(dat)")
                    inputFormatter.dateFormat = "yyyy-MM-dd"
                    inputFormatter.dateStyle = .long
                    inputFormatter.timeStyle = .medium
                    let resultString = inputFormatter.string(from: showDate!)
                    ExpLbl.text = "Expiry by \(resultString.replacingOccurrences(of: "at", with: ""))"
                }
            }
        }
        if let SorceLbl = cell.viewWithTag(3) as? UILabel {
            if let ids = (TicketsArr.value(forKey: "sourceStation1") as! NSArray).object(at: indexPath.row) as? Int {
                SorceLbl.text = "\(String(describing: PublicLogicalStationIDDict.value(forKey: "\(ids)")!))"
            }
        }
        if let DestLbl = cell.viewWithTag(4) as? UILabel {
            if let ids = (TicketsArr.value(forKey: "destinationStation1") as! NSArray).object(at: indexPath.row) as? Int {
                DestLbl.text = "\(String(describing: PublicLogicalStationIDDict.value(forKey: "\(ids)")!))"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if DeviceType.IS_IPHONE_5 {
            return 185
        }
        return 220
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
