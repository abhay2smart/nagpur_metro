//
//  BookedTicketsViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 09/08/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit

import Alamofire

class BookedTicketsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tbl: UITableView!
    
    var PurchaseDateArr = NSArray()
    
    var ExpireDateArr = NSArray()
    
    var TicketContentArr = NSArray()
    
    var SorceArr = NSArray()
    
    var DestArr = NSArray()
    
    var TicketsSerialNumber = NSArray()
    
    var CheckCount = 0
    
    var StatusDict = NSMutableDictionary()
    
    var PreviousDict = NSMutableDictionary()
    
  //   
    
    var CheckFirstTime = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbl.backgroundColor = .clear
        
        self.view.backgroundColor = UIColor.hexStr(hexStr: "E9E7E7", alpha: 1)
        
        print("tickets : \(PublicTicketArr)")
        
        if PublicTicketArr.count > 0
        {
           PurchaseDateArr = PublicTicketArr.value(forKey: "purchaseDate") as! NSArray
            
            ExpireDateArr = PublicTicketArr.value(forKey: "expirationDate") as! NSArray
            
            TicketContentArr = PublicTicketArr.value(forKey: "ticketContent") as! NSArray
            
            SorceArr = PublicTicketArr.value(forKey: "sourceStation1") as! NSArray
            
            DestArr = PublicTicketArr.value(forKey: "destinationStation1") as! NSArray
            
            TicketsSerialNumber = PublicTicketArr.value(forKey: "ticketSerial") as! NSArray
            
            GetTransactionList()
        }
        
        print("Brightness value : \(UIScreen.main.brightness)")
        
        UIScreen.main.brightness = 1

        print("Brightness value : \(UIScreen.main.brightness)")
        

        // Do any additional setup after loading the view.
    }
    
    func GetTransactionList()
    {
        if UserData.current?.token != nil {
        if CheckCount > TicketsSerialNumber.count
        {
            CheckCount = 0
        }
        
        PreviousDict = StatusDict
        
        
        let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        let url = "\(APILink)ticket/get-transaction-list"
        
        let parameters: [String: Any] = [
            "token" : UserData.current!.token!,
            "ticketSerial" : TicketsSerialNumber[CheckCount],
            "issueDate": ExpireDateArr[CheckCount]
        ]
        
        print("parameters : \(parameters)")
        
        
        sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            
            print(dataResponse.result.value!)
            
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
                                kAppDelegate.shared.saveLoggedUserdetails(decoded as! NSDictionary)
                                print(decoded as! NSDictionary)
                            }catch {
                               
                            } 
                        }
                        
                        if let status = dict["status"] as? String
                        {
                            self.StatusDict.setValue(status, forKey: "\(self.TicketsSerialNumber[self.CheckCount])")
                            
                            self.CheckCount += 1
                        }
                       
                    }
                }
            }
            
            //self.tbl.reloadData()
            
            if self.PreviousDict != self.StatusDict
            {
                self.tbl.reloadData()
            }

            if self.CheckFirstTime == 0
            {
                self.tbl.reloadData()
                
                self.CheckFirstTime = 1
            }
            
            self.GetTransactionList()
        }
    }
    }
    
    
    // MARK: - Table View
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PurchaseDateArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if let img = cell?.viewWithTag(1) as? UIImageView
        {
            img.image = generateQRCode(from: "\(TicketContentArr[indexPath.row])")
        }
        
        if let vv = cell?.viewWithTag(2) as? UIView
        {
            if DeviceType.IS_IPHONE_5
            {
                vv.frame = CGRect(x: vv.frame.origin.x, y: vv.frame.origin.x, width: vv.frame.width, height: vv.frame.height - 8)
            }
            else if DeviceType.IS_IPHONE_6
            {
                vv.frame = CGRect(x: vv.frame.origin.x, y: vv.frame.origin.x, width: vv.frame.width, height: vv.frame.height - 8)
            }
            else
            {
                vv.frame = CGRect(x: vv.frame.origin.x, y: vv.frame.origin.x, width: vv.frame.width, height: vv.frame.height - 8)
            }
        
        }
        
        if let purchase = cell?.viewWithTag(12) as? UILabel
        {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyyMMddHHmmss"
            let showDate = inputFormatter.date(from: "\(PurchaseDateArr[indexPath.row])")
            
            
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
            let showDate = inputFormatter.date(from: "\(ExpireDateArr[indexPath.row])")
            
            inputFormatter.dateFormat = "yyyy-MM-dd"
            
            inputFormatter.dateStyle = .long
            
            inputFormatter.timeStyle = .medium
            
            let resultString = inputFormatter.string(from: showDate!)
            
            expire.text = "Expires by \(resultString.replacingOccurrences(of: "at", with: ""))"
        }
        
        if let pass = cell?.viewWithTag(14) as? UILabel
        {
            if PurchaseDateArr.count == 1
            {
                pass.text = "\(PurchaseDateArr.count) passenger"
            }
            else
            {
                pass.text = "\(PurchaseDateArr.count) passengers"
            }
        }
        
        if let lbl = cell?.viewWithTag(11) as? UILabel
        {
            lbl.text = "TICKET NUMBER : \(indexPath.row + 1)"
        }
        
        if let sor = cell?.viewWithTag(15) as? UILabel
        {
            if let ii = SorceArr[indexPath.row] as? Int
            {
                sor.text = "\(String(describing: PublicLogicalStationIDDict.value(forKey: "\(ii)")!))"
            }
        }
        
        if let des = cell?.viewWithTag(16) as? UILabel
        {
            if let ii = DestArr[indexPath.row] as? Int
            {
                des.text = "\(String(describing: PublicLogicalStationIDDict.value(forKey: "\(ii)")!))"
            }
        }
        
        if let status = cell?.viewWithTag(17) as? UILabel
        {
            if let sta = StatusDict.value(forKey: "\(TicketsSerialNumber[indexPath.row])") as? String
            {
               status.text = sta
            }
        }
        
        cell?.backgroundColor = .clear
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if DeviceType.IS_IPHONE_5
        {
            return 445
        }
        else if DeviceType.IS_IPHONE_6
        {
            return 470
        }
        else
        {
            return 530
        }
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Back(_ sender: Any) {
        
        var array : [UIViewController] = (self.navigationController?.viewControllers)!
        
        array.remove(at: array.count - 1)
        array.remove(at: array.count - 1)
        array.remove(at: array.count - 1)
        
        self.navigationController?.viewControllers = array
        
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
