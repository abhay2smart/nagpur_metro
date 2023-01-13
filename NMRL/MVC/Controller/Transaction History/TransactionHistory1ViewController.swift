//
//  TransactionHistoryViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 25/10/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class TransactionHistory1ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tbl: UITableView!
    
    var PurchaseArr = NSArray()
    var ExpireArr = NSArray()
    
    var SorceStationArr = NSArray()
    var DestStationArr = NSArray()
    
    var TicketsArr = NSArray()
    
    var PurchaseDateArr = NSMutableArray()
    
    var priceArr = NSArray()
    
    var TimeArr = NSMutableArray()
    
    var TicketBookingIDArr = NSArray()
    
    @IBOutlet var InternetBlackView: UIView!
    
    var DateKeys = NSMutableArray()
    
    let FinalDict = NSMutableDictionary()
    
    var NewPurchaseDateStringArray = [String]()
    
    var NewPurchaseTimeArray = NSMutableArray()
    
    var NewPriceArray = NSArray()
    
    var NewZoneArr = NSArray()
    
    var FromStationArr = NSArray()
    
    var ToStationArr = NSArray()
    
    var QRStatusArr = NSArray()
    
    
    
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
        
        
        
        if TicketsArr.count > 0
        {
            if let aa = TicketsArr.object(at: 0) as? NSArray
            {
                TicketsArr = aa //TicketsArr.object(at: 0) as! NSArray
            }
        }
        
          print("TicketsArr : \(TicketsArr)")
        
        /////////********************
        
        let TempMutableArr = NSMutableArray()
        
        for k in TicketsArr
        {
            if let j = k as? NSDictionary
            {
                TempMutableArr.add(j)
            }
        }
        
        if UserDefaults.standard.value(forKey: "FailedArray") != nil
        {
            if let temp = UserDefaults.standard.value(forKey: "FailedArray") as? NSArray
            {
                for q in temp
                {
                    if let dic = q as? NSDictionary
                    {
                        if let email = dic["email"] as? String
                        {
                            if email == UserData.current?.customerInfo?.emailAddress!
                            {
                                TempMutableArr.add(dic)
                            }
                        }
                    }
                }
            }
        }
        
        print("TempMutableArr : \(TempMutableArr)")
        
        TicketsArr = NSArray()
        
        TicketsArr = TempMutableArr as NSArray
        
        ////////*********************
        
        if let purchaseDate1 = TicketsArr.value(forKey: "purchaseDate") as? NSArray
        {
            
            for j in purchaseDate1
            {
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyyMMddHHmmss"
                let showDate = inputFormatter.date(from: "\(j)")
                
                inputFormatter.dateFormat = "yyyy-MM-dd"
                
                inputFormatter.dateStyle = .long
                
                inputFormatter.timeStyle = .medium
                
                let resultString = inputFormatter.string(from: showDate!)
                
                // print("resultString 3 : \(resultString)")
                
                let dd = resultString.components(separatedBy: "at").first!
                
                NewPurchaseDateStringArray.append(dd)
            }
            
            print("NewPurchaseDateStringArray : \(NewPurchaseDateStringArray)")
            
            print("NewPurchaseDateStringArray : \(NewPurchaseDateStringArray.removeDuplicates())")
            
            for i in purchaseDate1
            {
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyyMMddHHmmss"
                let showDate = inputFormatter.date(from: "\(i)")
                
                inputFormatter.dateFormat = "yyyy-MM-dd"
                
                inputFormatter.dateStyle = .long
                
                inputFormatter.timeStyle = .medium
                
                let resultString = inputFormatter.string(from: showDate!)
                
                // print("resultString : \(resultString)")
                
                let time = resultString.components(separatedBy: "at").last!
                
             //   let dd = resultString.components(separatedBy: "at").first!
                
              //  PurchaseDateArr.add(dd)
                
              //  TimeArr.add(time)
                
                NewPurchaseTimeArray.add(time)
                
                // PurLbl.text = "Purchased on \(resultString.replacingOccurrences(of: "at", with: ""))"
            }
            
            print("NewPurchaseTimeArray : \(NewPurchaseTimeArray)")
            
        }
        
        
        
        ///////////////////********************* REMOVE DUPLICATED GROUPS
        
        
         var CheckPurchaseArr = NSMutableArray()
        
        if let purchaseDate = TicketsArr.value(forKey: "purchaseDate") as? NSArray
        {
            CheckPurchaseArr = NSMutableArray(array: purchaseDate)
        }
        
        print("CheckPurchaseArr : \(CheckPurchaseArr)")
        
        var arrayOfInts = [Int]()
        
        for name in CheckPurchaseArr{
            
            print(CheckPurchaseArr.index(of: name))
            arrayOfInts.append(CheckPurchaseArr.index(of: name))
        }
        
        print("arrayOfInts : \(arrayOfInts)")

        let SameInts = arrayOfInts//.removeDuplicates() ##
        
        print("SameInts : \(SameInts)")
        
        let UpdatedArray = NSMutableArray()
        
        for v in SameInts
        {
            UpdatedArray.add(TicketsArr[v])
        }
        
        print("Updated Array : \(UpdatedArray)")
        
        TicketsArr = NSArray()
        
        TicketsArr = UpdatedArray as NSArray
        
        if let ticketSerial = TicketsArr.value(forKey: "ticketSerial") as? NSArray
        {
            TicketBookingIDArr = ticketSerial
        }
        
        ////???///////////////******************
        
        var PurDate = NSArray()
        
        if let purchaseDate = TicketsArr.value(forKey: "purchaseDate") as? NSArray
        {
            PurDate = purchaseDate
        }
        
        
        
        for i in PurDate
        {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyyMMddHHmmss"
            let showDate = inputFormatter.date(from: "\(i)")
            
            inputFormatter.dateFormat = "yyyy-MM-dd"
            
            inputFormatter.dateStyle = .long
            
            inputFormatter.timeStyle = .medium
            
            let resultString = inputFormatter.string(from: showDate!)
            
            // print("resultString : \(resultString)")
            
            let time = resultString.components(separatedBy: "at").last!
            
            let dd = resultString.components(separatedBy: "at").first!
            
            PurchaseDateArr.add(dd)
            
            TimeArr.add(time)
            
            // PurLbl.text = "Purchased on \(resultString.replacingOccurrences(of: "at", with: ""))"
        }
        
        
        print("PurchaseDateArr : \(PurchaseDateArr)")
        
        print("TimeArr : \(TimeArr)")
        
        let SampleDict = NSMutableDictionary()
        
        var PurchaseString = [String]()
        
        for i in PurchaseDateArr
        {
            PurchaseString.append("\(i)")
            
            SampleDict.setValue("0", forKey: "\(i)")
        }
        
        
        for j in SampleDict.allKeys
        {
            DateKeys.add("\(j)")
        }
        
        print("DateKeys : \(DateKeys)")
        
        let sortedCapitalArray = DateKeys.sorted {($0 as AnyObject).localizedCaseInsensitiveCompare(($1 as AnyObject)as! String) == ComparisonResult.orderedDescending}
        
        print("sortedCapitalArray : \(sortedCapitalArray)")
        
        ///////////************************************************** Checking *********** SORTING
        
        var convertedArray3: [Date] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyyy"
        

        
        for dat in sortedCapitalArray {
            
            if var dat1 = dat as? String
            {
                dat1 = dat1.replacingOccurrences(of: " ", with: "")
                dat1 = dat1.replacingOccurrences(of: ",", with: "")
                //dateFormatter.dateFormat = "MMMMddyyyy"
                var date = dateFormatter.date(from: dat1)
                date = date?.adding(minutes: 1440)
                
                convertedArray3.append(date!)
            }
            
        }
        
        convertedArray3.sort(){$0 > $1}
        
        //Approach : 2
        _ = convertedArray3.sorted(by: {$0.timeIntervalSince1970 < $1.timeIntervalSince1970})
        
        print("convertedArray3 : \(convertedArray3)")
        
        var PurchaseStringDateArr = [String]()
        
        for j in convertedArray3
        {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
            let showDate = inputFormatter.date(from: "\(j)")
            
            inputFormatter.dateFormat = "yyyy-MM-dd"
            
            inputFormatter.dateStyle = .long
            
            inputFormatter.timeStyle = .medium
            
            let resultString = inputFormatter.string(from: showDate!)
            
           // print("resultString 3 : \(resultString)")
            
            let dd = resultString.components(separatedBy: "at").first!
            
            PurchaseStringDateArr.append(dd)
        }
        
        print("PurchaseStringDateArr : \(PurchaseStringDateArr)")
        
        ////////////***********//////////***##############################################################################
        
        DateKeys = NSMutableArray()
        
        for j in PurchaseStringDateArr// ** sortedCapitalArray
        {
            DateKeys.add(j)
        }
        
        print("PurchaseString : \(PurchaseString)")
        
        print("PurchaseStringDateArr : \(PurchaseStringDateArr)")
        
        for k in DateKeys
        {
            print("k is : \(k)")
            
            let abc = PurchaseString.indexes(of: "\(k)")
            
            print("abc : \(abc)")
            
            FinalDict.setValue(abc, forKey: "\(k)")
        }
        
        print("FinalDict : \(FinalDict)")
        
        
        if let price = TicketsArr.value(forKey: "price") as? NSArray
        {
            self.priceArr = price
        }
        
        if let purchaseDate = TicketsArr.value(forKey: "purchaseDate") as? NSArray
        {
            PurchaseArr = purchaseDate
        }
        
        if let expirationDate = TicketsArr.value(forKey: "expirationDate") as? NSArray
        {
            ExpireArr = expirationDate
        }
        
        if let zone = TicketsArr.value(forKey: "zone") as? NSArray
        {
            NewZoneArr = zone
        }
        
        if let sourceStation1 = TicketsArr.value(forKey: "sourceStation1") as? NSArray
        {
            FromStationArr = sourceStation1
        }
        
        if let destinationStation1 = TicketsArr.value(forKey: "destinationStation1") as? NSArray
        {
            ToStationArr = destinationStation1
        }
        
        if let QR = TicketsArr.value(forKey: "qrTicketStatus") as? NSArray
        {
            QRStatusArr = QR
        }
        
        //////////////////////***********************************************************           pod 'Alamofire', '~> 4.7'
        
       
        //////////////////////*******************************//////////////////// Grouping
        
 /*
        let SampleDict2 = NSMutableDictionary()
        
        var IssueDateArr = NSArray()
        
        if let sourceStation1 = TicketsArr.value(forKey: "sourceStation1") as? NSArray
        {
            SourceStationArr2 = sourceStation1
        }
        
        if let destinationStation1 = TicketsArr.value(forKey: "destinationStation1") as? NSArray
        {
            DestinationStationArr2 = destinationStation1
        }
        
        if let expirationDate = TicketsArr.value(forKey: "expirationDate") as? NSArray
        {
            ExpirationDateArr2 = expirationDate
        }
        
        if let purchaseDate = TicketsArr.value(forKey: "purchaseDate") as? NSArray
        {
            PurchaseDateArr2 = purchaseDate
        }
        
        if let price = TicketsArr.value(forKey: "price") as? NSArray
        {
            PriceArr2 = price
        }
        
        if let qrTicketStatus = TicketsArr.value(forKey: "qrTicketStatus") as? NSArray
        {
            TicketStatusArr2 = qrTicketStatus
        }
        
        if let qrType = TicketsArr.value(forKey: "qrType") as? NSArray
        {
            qrTypeArr2 = qrType
        }
        
        if let ticketSerial = TicketsArr.value(forKey: "ticketSerial") as? NSArray
        {
            TicketSerielArr2 = ticketSerial
        }
        
        if SampleDict2.count > 0
        {
            SampleDict2.removeAllObjects()
        }
        
        if let refnum = TicketsArr.value(forKey: "issueDate") as? NSArray
        {
            print("refNum : \(refnum)")
            
            IssueDateArr = refnum
            
            for i in refnum
            {
                SampleDict2.setValue("0", forKey: "\(i)")
            }
        }
        
        print("SampleDict2 : \(SampleDict2)")
        
        if KayValues2.count > 0
        {
            KayValues2.removeAllObjects()
        }
        
        for j in SampleDict2.allKeys
        {
            KayValues2.add("\(j)")
        }
        
        print("KayValues : \(KayValues2)")
        
        let sortedCapitalArray2 = KayValues2.sorted {($0 as AnyObject).localizedCaseInsensitiveCompare(($1 as AnyObject)as! String) == ComparisonResult.orderedDescending}
        
        print("sortedCapitalArray 2 : \(sortedCapitalArray2)")
        
        KayValues2 = NSMutableArray()
        
        for j in sortedCapitalArray2
        {
            KayValues2.add(j)
        }
        
        print("KayValues 2 : \(KayValues2)")
        
        var IssueDateStringArr = [String]()
        
        for j in IssueDateArr
        {
            IssueDateStringArr.append("\(j)")
        }
        
        
        
        for k in KayValues2
        {
            let abc = IssueDateStringArr.indexes(of: "\(k)")
            
            print("abc : \(abc)")
            
            FinalDict2.setValue(abc, forKey: "\(k)")
        }
        
        print("FinalDict 2 : \(FinalDict2)")
        */
        
        // Do any additional setup after loading the view.
    }
    
    var qrTypeArr2 = NSArray()
    
    var PriceArr2 = NSArray()
    
    var PurchaseDateArr2 = NSArray()
    
    var ExpirationDateArr2 = NSArray()
    
    var SourceStationArr2 = NSArray()
    
    var DestinationStationArr2 = NSArray()
    
    var TicketSerielArr2 = NSArray()
    
    var TicketStatusArr2 = NSArray()
    
    var KayValues2 = NSMutableArray()
    
    let FinalDict2 = NSMutableDictionary()
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return FinalDict.count
        //        return PurchaseDateArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if let dd = FinalDict.value(forKey: "\(DateKeys[section])") as? [Int] {
              return dd.count
        }
         return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if let dd = FinalDict.value(forKey: "\(DateKeys[indexPath.section])") as? [Int] {
            let ind = dd[indexPath.row]
            //   print("Ind : \(ind)")
            if let qr = QRStatusArr[ind] as? String {
                if qr == "Failed" {
                    cell = tableView.dequeueReusableCell(withIdentifier: "CellExpire")
                }
            }
            if let lbl1 = cell?.viewWithTag(1) as? UILabel {
                lbl1.text = "\(TimeArr[ind])"
            }
            if let lbl4 = cell?.viewWithTag(4) as? UILabel {
                lbl4.text = "INR \(priceArr[ind])"
            }
            if let lbl5 = cell?.viewWithTag(5) as? UILabel {
                lbl5.text = "\(TicketBookingIDArr[ind])"
            }
            if let SorceLbl = cell?.viewWithTag(6) as? UILabel {
                if let Source = FromStationArr[ind] as? Int {
                    
                    if let str1 = PublicLogicalStationIDDict.value(forKey: "\(Source)") as? String {
                        SorceLbl.text = "\(str1)"
                    }
                }
            }
            if let DestLbl = cell?.viewWithTag(7) as? UILabel {
                if let des = ToStationArr[ind] as? Int {
                    if let str1 = PublicLogicalStationIDDict.value(forKey: "\(des)") as? String {
                        DestLbl.text = "\(str1)"
                    }
                }
            }
            if let lbl2 = cell?.viewWithTag(2) as? UILabel {
                lbl2.text = "QR Ticket Purchased"
                if let qr = QRStatusArr[ind] as? String {
                    if qr == "Failed" {
                        lbl2.text = "QR Ticket Purchase Failed"
                    }
                }
                
            }
            if let lbl3 = cell?.viewWithTag(3) as? UILabel {
                
                lbl3.text = "Transaction Successful"
                if let qr = QRStatusArr[ind] as? String {
                    if qr == "Failed" {
                        lbl3.text = "Transaction Failed"
                    }
                }
            }
            
            
            //            if let zone = NewZoneArr[indexPath.section] as? Int
            //            {
            //                print("Zone : \(zone)")
            //
            //                if let price = priceArr[ind] as? String
            //                {
            //                    let ii = (price as NSString).integerValue
            //
            //                    let val = ii * zone
            //
            //
            //                    if let lbl4 = cell?.viewWithTag(4) as? UILabel
            //                    {
            //                        lbl4.text = "\(val)"
            //
            //                        if !lbl4.text!.contains(".")
            //                        {
            //                            lbl4.text = "\(val).00"
            //                        }
            //                    }
            //
            //                }
            //            }
            
            //        if let dd = FinalDict.value(forKey: "\(DateKeys[indexPath.section])") as? [Int]
            //            {
            //
            //                print("dd : \(dd)")
            //
            //                let count = dd.count + 1
            //
            //                print("count : \(count)")
            //
            //                if let price = priceArr[ind] as? String
            //                {
            //                    let ii = (price as NSString).integerValue
            //
            //                    let val = ii * count
            //
            //
            //                    if let lbl4 = cell?.viewWithTag(4) as? UILabel
            //                    {
            //                        lbl4.text = "\(val)"
            //
            //                        if !lbl4.text!.contains(".")
            //                        {
            //                            lbl4.text = "\(val).00"
            //                        }
            //                    }
            //
            //                }
            //
            //            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vv = UIView()
        let lbl1 = UILabel()
        lbl1.frame = CGRect(x: 20, y: 0, width: 320, height: 50)
        if DeviceType.IS_IPHONE_X {
            lbl1.frame = CGRect(x: 20, y: 0, width: 375, height: 50)
        }
        if DeviceType.IS_IPHONE_XP {
            lbl1.frame = CGRect(x: 20, y: 0, width: 375, height: 50)
        }
        
        
        //        if let val = DateKeys[section] as? String
        //        {
        //             lbl1.text = val
        //        }
        
        //        for i in DateKeys
        //        {
        //            let inputFormatter = DateFormatter()
        //
        //            inputFormatter.dateFormat = "MMM dd, yyyy "
        //
        //            let showDate = inputFormatter.date(from: "\(i)")
        //
        //           // inputFormatter.dateStyle = .long
        //
        //            print("i is : \(i)")
        //
        //            print("Show date : \(showDate!)")
        //
        //            let resultString = inputFormatter.string(from: showDate!)
        //
        //           // lbl1.text = "\(i)"
        //
        //        }
        lbl1.text = "\(DateKeys[section])"
        //        let dateFormatter = DateFormatter()
        //
        //        let date = dateFormatter.date(from: "\(DateKeys[section])")
        //        dateFormatter.dateFormat = "dd MMMM, yyyy"
        //
        //        //dateFormatter.dateFormat = "EEEE, dd MMMM, yyyy"
        //        let currentDateString: String = dateFormatter.string(from: date!)
        //        print("Current date is \(currentDateString)")
        lbl1.textColor = .black
        lbl1.font = UIFont(name: "Montserrat-Bold", size: 17)
        vv.backgroundColor = UIColor.hexStr(hexStr: "#C0C0C0", alpha: 1)
        vv.addSubview(lbl1)
        return vv
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if DeviceType.IS_IPHONE_5 {
            return 210
        }else if DeviceType.IS_IPHONE_6 {
            return 217
        }else if DeviceType.IS_IPHONE_6P {
            return 220
        }else if DeviceType.IS_IPHONE_X {
            return 230
        }else if DeviceType.IS_IPHONE_XP {
            return 230
        }
        return 115
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
    
    @IBAction func InternetOK(_ sender: Any) {
        InternetBlackView.isHidden = true
    }
    
   @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
 }


extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
