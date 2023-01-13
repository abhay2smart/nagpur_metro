    //
//  MyTicketsViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 09/08/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
    
import Alamofire
    
import CoreData

var PublicCheckMyTicekts = Int()

var Public_TicketStatusMutableArr = NSMutableArray()

class MyTicketsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tbl: UITableView!
    
    var TicketsArr = NSArray()
        
    var TicketMutableArr2 = NSMutableArray()
    
    var TicketMutableArrYesterday = NSMutableArray()
    
    var TicketMutableArr = NSMutableArray()
    
    var TicketCheckExpire = NSMutableDictionary()
    
     
    
    @IBOutlet var NoTicketsBlackView: UIView!
    
    @IBOutlet var NoInternetBlackView: UIView!
    
    @IBOutlet var btnLogout: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        NoTicketsBlackView.isHidden = true
        
        NoInternetBlackView.isHidden = true
        
        LogoutBlaceView.isHidden = true
        
 
        print("TicketsArr : \(TicketsArr)")
        
        if TicketsArr.count > 0
        {
            TicketsArr = TicketsArr.object(at: 0) as! NSArray
        }
        
        for i in TicketsArr
        {
           if let dic = i as? NSDictionary
           {
            if let qrTicketStatus = dic["qrTicketStatus"] as? String
            {
                if qrTicketStatus == "UNUSED"
                {
                    TicketMutableArr2.add(dic)
                }
            }
            }
            
        }
        
        //print("TicketMutableArr2 : \(TicketMutableArr2)")
        
        for j in TicketMutableArr2
        {
           if let dic = j as? NSDictionary
           {
            if let expirationDate = dic["expirationDate"] as? String
            {
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyyMMddHHmmss"
                let showDate = inputFormatter.date(from: "\(expirationDate)")
                
                inputFormatter.dateFormat = "yyyy-MM-dd"
                
                inputFormatter.dateStyle = .long
                
                inputFormatter.timeStyle = .medium
                
                if  Calendar.current.isDateInToday(showDate!)
                {
                    TicketMutableArrYesterday.add(dic)
                }
            }
            }
           
        }
        
      //  print("TicketMutableArrYesterday Today : \(TicketMutableArrYesterday)")
        
     
       // ExpireActions()
        
        PublicCalculateQRAgain = 1
        
        //timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(MyTicketsViewController.UpdateLabel)), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        ReadData()
        
        TicketMutableArr = NSMutableArray()
        
        for i in TicketMutableArrYesterday
        {
            if let dic = i as? NSDictionary
            {
                if let ticketSerial = dic["ticketSerial"] as? Int
                {
                    if let Dic2 = Public_AlreadySavedTicketStatusData["\(ticketSerial)"] as? NSDictionary
                    {
                        if let Status = Dic2["Status"] as? String
                        {
                            if Status != "EXPIRED"
                            {
                                TicketMutableArr.add(dic)
                            }
                        }
                    }
                }
            }
        }
        
        print("TicketMutableArr : \(TicketMutableArr)")
        
        /////??/////////////////
        
        let SampleDict = NSMutableDictionary()
        
        var IssueDateArr = NSArray()
        
        if let sourceStation1 = TicketMutableArr.value(forKey: "sourceStation1") as? NSArray
        {
            SourceStationArr = sourceStation1
        }
        
        if let destinationStation1 = TicketMutableArr.value(forKey: "destinationStation1") as? NSArray
        {
            DestinationStationArr = destinationStation1
        }
        
        if let expirationDate = TicketMutableArr.value(forKey: "expirationDate") as? NSArray
        {
            ExpirationDateArr = expirationDate
        }
        
        if let purchaseDate = TicketMutableArr.value(forKey: "purchaseDate") as? NSArray
        {
            PurchaseDateArr = purchaseDate
        }
        
        if let price = TicketMutableArr.value(forKey: "price") as? NSArray
        {
            PriceArr = price
        }
        
        if let qrTicketStatus = TicketMutableArr.value(forKey: "qrTicketStatus") as? NSArray
        {
            TicketStatusArr = qrTicketStatus
            
            if Public_TicketStatusMutableArr.count == 0
            {
                Public_TicketStatusMutableArr = NSMutableArray(array:  qrTicketStatus)
            }
        }
        
        if let qrType = TicketMutableArr.value(forKey: "qrType") as? NSArray
        {
            qrTypeArr = qrType
        }
        
        print("qrTypeArr : \(qrTypeArr)")
        
        if let ticketSerial = TicketMutableArr.value(forKey: "ticketSerial") as? NSArray
        {
            TicketSerielArr = ticketSerial
        }
        
        if let ticketContent = TicketMutableArr.value(forKey: "ticketContent") as? NSArray
        {
            TicketContentArr = ticketContent
        }
        
        if let tripsCount = TicketMutableArr.value(forKey: "tripsCount") as? NSArray
        {
            TripsCountArr = tripsCount
        }
        
        
        if SampleDict.count > 0
        {
            SampleDict.removeAllObjects()
        }
        
        if let refnum = TicketMutableArr.value(forKey: "issueDate") as? NSArray
        {
            IssueDateArr = refnum
            
        }
        
        for i in IssueDateArr
        {
            SampleDict.setValue("0", forKey: "\(i)")
            


        }
        
        
        
         print("SampleDict : \(SampleDict)")
        
        if KayValues.count > 0
        {
            KayValues.removeAllObjects()
        }
        
        for j in SampleDict.allKeys
        {
            KayValues.add("\(j)")
        }
        
        print("KayValues : \(KayValues)")
        
        let sortedCapitalArray = KayValues.sorted {($0 as AnyObject).localizedCaseInsensitiveCompare(($1 as AnyObject)as! String) == ComparisonResult.orderedDescending}
        
        print("sortedCapitalArray : \(sortedCapitalArray)")
        
        KayValues = NSMutableArray()
        
        for j in sortedCapitalArray
        {
            KayValues.add(j)
        }
        
        print("KayValues 2 : \(KayValues)")
        
        var IssueDateStringArr = [String]()
        
        for j in IssueDateArr
        {
            IssueDateStringArr.append("\(j)")
        }
        
        
        for k in KayValues
        {
            let abc = IssueDateStringArr.indexes(of: "\(k)")
            
            FinalDict.setValue(abc, forKey: "\(k)")
        }
        
        print("FinalDict : \(FinalDict)")
        
        
        tbl.reloadData()
      
        //timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(MyTicketsViewController.UpdateLabel)), userInfo: nil, repeats: true)
    }
    
   
    
    override func viewDidDisappear(_ animated: Bool) {
        
        timer.invalidate()
    }
    
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if TicketMutableArr.count == 0
        {
            NoTicketsBlackView.isHidden = false
        }
        else
        {
            NoTicketsBlackView.isHidden = true
        }
        
       // return TicketMutableArr.count
    
       // return KayValues.count
        
        return TripsCountArr.count
    }
    
    var qrTypeArr = NSArray()
    
    var PriceArr = NSArray()
    
    var PurchaseDateArr = NSArray()
    
    var ExpirationDateArr = NSArray()
    
    var SourceStationArr = NSArray()
    
    var DestinationStationArr = NSArray()
    
    var TicketSerielArr = NSArray()
    
    var TicketStatusArr = NSArray()
    
    var TicketContentArr = NSArray()
    
    var TripsCountArr = NSArray()
    
     var KayValues = NSMutableArray()
    
    let FinalDict = NSMutableDictionary()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyTicketTableViewCell
        
        
        if let lbl1 = cell.viewWithTag(1) as? UILabel
        {
            lbl1.text = "TICKET NUMBER : \(indexPath.row + 1)"
        }
        
        
                if let Expire = ExpirationDateArr[indexPath.row] as? String
                {
                    let inputFormatter = DateFormatter()
                    inputFormatter.dateFormat = "yyyyMMddHHmmss"
                    
                    var showDate = inputFormatter.date(from: "\(Expire)")
                    
                    showDate = showDate!.adding(minutes: 0)
                    
                    if Date() > showDate!
                    {
                        cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyTicketTableViewCell
                    }
                }
                
                //print("FirstIntex : \(FirstIntex)")
                
                if let lbl2 = cell.viewWithTag(2) as? UILabel
                {
                    if let PassLbl = cell.viewWithTag(9) as? UILabel
                    {
                        if let img1 = cell.viewWithTag(25) as? UIImageView
                        {
                            if let qrType = qrTypeArr[indexPath.row] as? String
                            {

                                if qrType == "SJT"
                                {
                                    lbl2.text = "SINGLE JOURNEY TICKET"

                                    PassLbl.text = "1 Passenger"
                                    
                                   

                                    img1.image = #imageLiteral(resourceName: "RightArrow")
                                }
                                else if qrType == "RJT"
                                {
                                    lbl2.text = "RETURN JOURNEY TICKET"

                                    PassLbl.text = "1 Passenger"
                                 

                                    img1.image = #imageLiteral(resourceName: "DoubleArrowBlack")
                                }
                                else
                                {
                                    lbl2.text = "GROUP JOURNEY TICKET"

                                    PassLbl.text = "\(TripsCountArr[indexPath.row]) Passengers"

                                    img1.image = #imageLiteral(resourceName: "GroupBlack")
                                }

                            }
                        }

                    }

                }
                
                if let PriceLbl = cell.viewWithTag(4) as? UILabel
                {
                    if let price = PriceArr[indexPath.row] as? String
                    {
                        PriceLbl.text = "INR \(price)"
                    }
                }
                
                if let PurLbl = cell.viewWithTag(5) as? UILabel
                {
                    if let Purchase = PurchaseDateArr[indexPath.row] as? String
                    {
                        let inputFormatter = DateFormatter()
                        inputFormatter.dateFormat = "yyyyMMddHHmmss"
                        var showDate = inputFormatter.date(from: "\(Purchase)")
                        
                        showDate = showDate!.adding(minutes: 0)
                        
                        inputFormatter.dateFormat = "yyyy-MM-dd"
                        
                        inputFormatter.dateStyle = .long
                        
                        inputFormatter.timeStyle = .medium
                        
                        let resultString = inputFormatter.string(from: showDate!)
                        
                        PurLbl.text = "Purchased on \(resultString.replacingOccurrences(of: "at", with: ""))"
                    }
                }
                
                if let ExpLbl = cell.viewWithTag(6) as? UILabel
                {
                    if let Expire = ExpirationDateArr[indexPath.row] as? String
                    {
                        let inputFormatter = DateFormatter()
                        inputFormatter.dateFormat = "yyyyMMddHHmmss"
                        
                        var showDate = inputFormatter.date(from: "\(Expire)")
                        
                        showDate = showDate!.adding(minutes: 0)
                        
                        inputFormatter.dateFormat = "yyyy-MM-dd"
                        
                        inputFormatter.dateStyle = .long
                        
                        inputFormatter.timeStyle = .medium
                        
                        let resultString = inputFormatter.string(from: showDate!)
                        
                        
                        ExpLbl.text = "Expiry by \(resultString.replacingOccurrences(of: "at", with: ""))"
                    }
                }
                
                
                
                if let SorceLbl = cell.viewWithTag(7) as? UILabel
                {
                    if let Source = SourceStationArr[indexPath.row] as? Int
                    {
                        if let str1 = PublicLogicalStationIDDict.value(forKey: "\(Source)") as? String
                        {
                            SorceLbl.text = str1
                        }
                    }
                }
                
                if let DestLbl = cell.viewWithTag(8) as? UILabel
                {
                    if let Dest = DestinationStationArr[indexPath.row] as? Int
                    {
                        if let str2 = PublicLogicalStationIDDict.value(forKey: "\(Dest)") as? String
                        {
                            DestLbl.text = str2
                        }
                    }
                    
                }
                
                if let BookLbl = cell.viewWithTag(10) as? UILabel
                {
                    if let seriel = TicketSerielArr[indexPath.row] as? Int
                    {
                        BookLbl.text = "\(seriel)"
                    }
                }
//                if let Lbl1 = cell.viewWithTag(11) as? UILabel
//                {
//                    if let seriel = TicketStatusArr[indexPath.row] as? Int
//                    {
//                        Lbl1.text = "\(seriel)"
//                    }
//                }
        
            
        if let Lbl1 = cell.viewWithTag(11) as? UILabel
        {
            if let value = Public_TicketStatusMutableArr[indexPath.row] as? String
            {
                //Lbl1.text = "\(seriel)"
                
                if value == "UNUSED"
                {
                    Lbl1.text = "CURRENT STATUS : TICKET NOT USED"
                }
                
                if value == "USED"
                {
                    Lbl1.text = "CURRENT STATUS : TICKET USED FOR ENTRY"
                    Lbl1.textColor = .green
                }
                
                if value == "USABLE_FOR_EXIT"
                {
                    Lbl1.text = "CURRENT STATUS : TICKET CAN BE USED FOR EXIT"
                    Lbl1.textColor = .green
                }
                
                if value == "IN_USE"
                {
                    Lbl1.text = "CURRENT STATUS : TICKET CURRENTLY IN USE"
                    Lbl1.textColor = .green
                }
                
                
                
                if value == "EXPIRED"
                {
                    Lbl1.text = "CURRENT STATUS : THIS TICKET IS EXPIRED"
                    Lbl1.textColor = .red
                    
                }
            }
        }
        
        
        
        
        
    /*    var inde = indexPath.row
        
        if inde > TicketMutableArr.count
        {
            inde = TicketMutableArr.count - 2
        }
        
        if let lbl2 = cell.viewWithTag(2) as? UILabel
        {
            if let PassLbl = cell.viewWithTag(9) as? UILabel
            {
                if let qrTypeArr = TicketMutableArr.value(forKey: "qrType") as? NSArray
                {
                    if let qrType = qrTypeArr.object(at: inde) as? String
                    {
                        if let img1 = cell.viewWithTag(25) as? UIImageView
                        {
                            if qrType == "SJT"
                            {
                                lbl2.text = "SINGLE JOURNEY TICKET"
                                
                                PassLbl.text = "1 Passenger"
                                
                                img1.image = #imageLiteral(resourceName: "RightArrow")
                            }
                            else if qrType == "RJT"
                            {
                                lbl2.text = "RETURN JOURNEY TICKET"
                                
                                PassLbl.text = "1 Passenger"
                                
                                img1.image = #imageLiteral(resourceName: "DoubleArrowBlack")
                            }
                            else
                            {
                                lbl2.text = "GROUP JOURNEY TICKET"
                                
                                PassLbl.text = "1 Passenger"
                                
                                img1.image = #imageLiteral(resourceName: "GroupBlack")
                            }
                        }
                    }
                    
                }
            }
        }
        
        if let PriceLbl = cell.viewWithTag(4) as? UILabel
        {
            if let priceArr = TicketMutableArr.value(forKey: "price") as? NSArray
            {
                if let price = priceArr.object(at: inde) as? String
                {
                    PriceLbl.text = "INR \(price)"
                }
                
            }
        }
        
        if let PurLbl = cell.viewWithTag(5) as? UILabel
        {
            if let purchaseDate = TicketMutableArr.value(forKey: "purchaseDate") as? NSArray
            {
                if let dat = purchaseDate.object(at: inde) as? String
                {
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
        
        if let ExpLbl = cell.viewWithTag(6) as? UILabel
        {
            if let ExpireDate = TicketMutableArr.value(forKey: "expirationDate") as? NSArray
            {
                if let dat = ExpireDate.object(at: inde) as? String
                {
                    let inputFormatter = DateFormatter()
                    inputFormatter.dateFormat = "yyyyMMddHHmmss"
                    
                    let showDate = inputFormatter.date(from: "\(dat)")
                    
                    inputFormatter.dateFormat = "yyyy-MM-dd"
                    
                    inputFormatter.dateStyle = .long
                    
                    inputFormatter.timeStyle = .medium
                    
                    let resultString = inputFormatter.string(from: showDate!)
                    
                   // print("resultString : \(resultString)")
                    
                    ExpLbl.text = "Expiry by \(resultString.replacingOccurrences(of: "at", with: ""))"
                
                    if var min = TicketCheckExpire.value(forKey: dat) as? String
                    {
                        
                        if min == "Expired"
                        {
                            cell.ExpiryLbl.isHidden = true
                        }
                        else
                        {
                            cell.ExpiryLbl.isHidden = false
                            
                            min = min.components(separatedBy: " ").first!
                            min = min.replacingOccurrences(of: "-", with: "")
                            
                            var sec = TicketCheckExpire.value(forKey: dat) as! String
                            sec = sec.components(separatedBy: " ").last!
                            sec = sec.replacingOccurrences(of: "-", with: "")
                            
                            cell.ExpiryLbl.text = "Expire in \(min) mins \(sec) seconds"
                        }

                    }
                }
            }
        }
        
        if let SorceLbl = cell.viewWithTag(7) as? UILabel
        {
            if let idsArr = TicketMutableArr.value(forKey: "sourceStation1") as? NSArray
            {
                if let ids = idsArr.object(at: inde) as? Int
                {
                    
                    if let str1 = PublicLogicalStationIDDict.value(forKey: "\(ids)") as? String
                    {
                        SorceLbl.text = str1
                    }
                    
                }
            }
        }
        
        if let DestLbl = cell.viewWithTag(8) as? UILabel
        {
            if let idsArr = TicketMutableArr.value(forKey: "destinationStation1") as? NSArray
            {
                if let ids = idsArr.object(at: inde) as? Int
                {
                    if let str2 = PublicLogicalStationIDDict.value(forKey: "\(ids)") as? String
                    {
                        DestLbl.text = str2
                    }
                    
                    //DestLbl.text = "\(String(describing: PublicLogicalStationIDDict.value(forKey: "\(ids)")!))"
                }
                
            }
        }
        
        if let BookLbl = cell.viewWithTag(10) as? UILabel
        {
            if let idsArr = TicketMutableArr.value(forKey: "ticketSerial") as? NSArray
            {
                if let ids = idsArr.object(at: inde) as? Int
                {
                    BookLbl.text = "\(ids)"
                }
                
            }
        }
        
        if let Lbl1 = cell.viewWithTag(11) as? UILabel
        {
            if let idsArr = TicketMutableArr.value(forKey: "qrTicketStatus") as? NSArray
            {
                if let ids = idsArr.object(at: inde) as? String
                {
                    Lbl1.text = "\(ids)"
                }
            }
        }
      */
        cell.ViewButt.tag = indexPath.row
        
        if cell.ExpiryLbl.text == "Expired"
        {
           // cell.ViewButt.isHidden = true
        }
        else
        {
          // cell.ViewButt.isHidden = false
        }
        
        cell.ViewButt.addTarget(self, action: #selector(ViewButtCliked(sender:)), for: .touchUpInside)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 395
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    //MARK: - Expire Actions
    
    func ExpireActions()
    {
        for j in TicketMutableArrYesterday
        {
           let dic = j as! NSDictionary
            
            let ExpireDate = dic["expirationDate"] as! String
            
            
                    let inputFormatter = DateFormatter()
                    inputFormatter.dateFormat = "yyyyMMddHHmmss"
                    let showDate = inputFormatter.date(from: "\(ExpireDate)")
                    
                    inputFormatter.dateFormat = "HH:mm:ss"
                    
                    let resultString = inputFormatter.string(from: showDate!)
                    
                    print("Expirey date : \(resultString)")
                    
                   // print("Minutes : \(Date().minutes(from: showDate!))")
                    
                    //print("Seconds : \(Date().seconds(from: showDate!))")
                    
                    let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Date().seconds(from: showDate!))
                    print("Hour : \(h), Minutes : \(m), Seonds : \(s)")
                    
                    if m < 0 || s < 0
                    {
                       // print("Still Running")
                        
                        TicketMutableArr.add(dic)
                    }
                    else
                    {
                       // print("Expired")
                        
                    }
        }
        
    }
    
    var timer = Timer()
    
    @objc func UpdateLabel()
    {
        UpdateLabel3()
        
        return
        
        if TicketMutableArr.count == 0
        {
            timer.invalidate()
        }
        
        for j in 0 ..< TicketMutableArr.count
        {
            let dic = TicketMutableArr[j] as! NSDictionary
            
            let ExpireDate = dic["expirationDate"] as! String
            
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyyMMddHHmmss"
            let showDate = inputFormatter.date(from: "\(ExpireDate)")
            
            inputFormatter.dateFormat = "HH:mm:ss"
            
          //  let resultString = inputFormatter.string(from: showDate!)
            
//            print("Expirey date : \(resultString)")
//
//            print("Minutes : \(Date().minutes(from: showDate!))")
//
//            print("Seconds : \(Date().seconds(from: showDate!))")
//
            let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Date().seconds(from: showDate!))
            print("Hour : \(h), Minutes : \(m), Seonds : \(s)")
            
          //  NotificationCenter.default.post(name: NSNotification.Name("userUpdate"), object: self, userInfo: ["name": "\(h) \(m) \(s)"])
            
            if m < 0
            {
                TicketCheckExpire.setValue("\(m) \(s)", forKey: "\(ExpireDate)")
            }
            if s < 0
            {
                TicketCheckExpire.setValue("\(m) \(s)", forKey: "\(ExpireDate)")
            }
            else
            {
               //TicketCheckExpire.setValue("Expired", forKey: "\(ExpireDate)")
                
               if m == 0 && s == 0 || m > 0 && s > 0
               {
                
                     TicketMutableArr.removeObject(at: j)
                    
                    if TicketMutableArr.count > 0
                    {
                        tbl.reloadData()
                    }
                    
                }
//               else if m > 0 && s > 0
//               {
//                   TicketMutableArr.removeObject(at: j)
//
//                   if TicketMutableArr.count > 0
//                   {
//                      tbl.reloadData()
//                   }
//               }
            }
        }
        
        if TicketMutableArr.count == 0
        {
            timer.invalidate()
            tbl.reloadData()
        }
        else
        {
            for i in 0 ..< TicketMutableArr.count
            {
                let indexPath = IndexPath(row: i, section: 0)
                UIView.performWithoutAnimation {
                    self.tbl.reloadRows(at: [indexPath], with: .none)
                }
            }
        }

    }
    
    @objc func UpdateLbl2()
    {
        if TicketMutableArr.count == 0
        {
            timer.invalidate()
        }
        
        
        for j in 0 ..< TicketMutableArr.count
        {
            let dic = TicketMutableArr[j] as! NSDictionary
            
            var ExpireDate = dic["expirationDate"] as! String
            
            ExpireDate = "20180919173650"
            
           // print("ExpireDate : \(ExpireDate)")
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyyMMddHHmmss"
            let showDate = inputFormatter.date(from: "\(ExpireDate)")
            
            inputFormatter.dateFormat = "HH:mm:ss"
            
              let resultString = inputFormatter.string(from: showDate!)

              print("Expirey date : \(resultString)")
            
        
            let (_,m,s) = secondsToHoursMinutesSeconds(seconds: Date().seconds(from: showDate!))
            
            print("Minute  : \(m)")
            
            print("Second  : \(s)")
            
           
            if m < 0
            {
                TicketCheckExpire.setValue("\(m) \(s)", forKey: "\(ExpireDate)")
            }
            if s < 0
            {
                TicketCheckExpire.setValue("\(m) \(s)", forKey: "\(ExpireDate)")
            }
            else
            {
                print("TicketMutableArr Count 0 : \(TicketMutableArr.count)")
                
                if m == 0 && s == 0
                {
                    
                    TicketMutableArr.removeObject(at: j)
                    
                    tbl.reloadData()
                    
                }
                else if  m == 0 && s > 0
                {
                    print("TicketMutableArr Count 1 : \(TicketMutableArr.count)")
                    
                    print("J is : \(j)")
                    
                    TicketMutableArr.removeObject(at: j)
                    
                    print("TicketMutableArr Count 2 : \(TicketMutableArr.count)")
                    
                    tbl.reloadData()
                    
                }
                
            }
        }
        
        
        
        print("TicketMutableArr Count 3 : \(TicketMutableArr.count)")
        
        if TicketMutableArr.count == 0
        {
            timer.invalidate()
            tbl.reloadData()
        }
        else
        {
          //  tbl.reloadData()
            
            for i in 0 ..< TicketMutableArr.count
            {
                let indexPath = IndexPath(row: i, section: 0)
                UIView.performWithoutAnimation {
                    self.tbl.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
    
    //MARK: - Update 3
    
    
    @objc func UpdateLabel3() {
         if TicketMutableArr.count == 0 {
            timer.invalidate()
        }
         for j in 0 ..< TicketMutableArr.count {
            let dic = TicketMutableArr[j] as! NSDictionary
             let ExpireDate = dic["expirationDate"] as! String
             let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyyMMddHHmmss"
            let showDate = inputFormatter.date(from: "\(ExpireDate)")
             inputFormatter.dateFormat = "HH:mm:ss"
          let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Date().seconds(from: showDate!))
            print("Hour : \(h), Minutes : \(m), Seonds : \(s)")
            
            //  NotificationCenter.default.post(name: NSNotification.Name("userUpdate"), object: self, userInfo: ["name": "\(h) \(m) \(s)"])
            if m < 0 {
                TicketCheckExpire.setValue("\(m) \(s)", forKey: "\(ExpireDate)")
            }
            if s < 0 {
                TicketCheckExpire.setValue("\(m) \(s)", forKey: "\(ExpireDate)")
            }else {
                TicketCheckExpire.setValue("Expired", forKey: "\(ExpireDate)")
                
//                if m == 0 && s == 0 || m > 0 && s > 0
//                {
//
//                    TicketMutableArr.removeObject(at: j)
//
//                    if TicketMutableArr.count > 0
//                    {
//                        tbl.reloadData()
//                    }
//
//                }
//                else if m == 0 && s > 0
//                {
//                  TicketMutableArr.removeObject(at: j)
//
//                  if TicketMutableArr.count > 0
//                  {
//                    tbl.reloadData()
//
//                    }
//                }
            }
        }
        if TicketMutableArr.count == 0 {
            timer.invalidate()
            tbl.reloadData()
        }else {
            for i in 0 ..< TicketMutableArr.count {
                let indexPath = IndexPath(row: i, section: 0)
                UIView.performWithoutAnimation {
                    self.tbl.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func NoInternetOK(_ sender: Any) {
        
        NoInternetBlackView.isHidden = true
    }
    
    @objc func ViewButtCliked(sender : UIButton)
    {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }
        else
        {
            print("No internet.")
            NoInternetBlackView.isHidden = false
            
            return
        }
        
                let ViewBookedTicketsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewBookedTicketsViewController") as! ViewBookedTicketsViewController
                ViewBookedTicketsViewController.Dict = TicketMutableArr.object(at: sender.tag) as! NSDictionary
               // ViewBookedTicketsViewController.PassengerCount = "\(TripsCountArr[sender.tag])"
        //ViewBookedTicketsViewController.PassengerCount = "\(TripsCountArr[sender.tag])"
        ViewBookedTicketsViewController.ValueIndex = sender.tag
                self.navigationController?.pushViewController(ViewBookedTicketsViewController, animated: true)
            
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func NoTicketsOK(_ sender: Any) {
        
        NoTicketsBlackView.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func Back(_ sender: Any) {
        
        timer.invalidate()
        
        if PublicCheckMyTicekts == 0
        {
            var array : [UIViewController] = (self.navigationController?.viewControllers)!
            
            array.remove(at: array.count - 1)
            array.remove(at: array.count - 1)
            array.remove(at: array.count - 1)
            array.remove(at: array.count - 1)
            
            self.navigationController?.viewControllers = array
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
    
    extension Date
    {
        
        func dateAt(hours: Int, minutes: Int) -> Date
        {
            let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            
            //get the month/day/year componentsfor today's date.
            
            
            var date_components = calendar.components(
                [NSCalendar.Unit.year,
                 NSCalendar.Unit.month,
                 NSCalendar.Unit.day],
                from: self)
            
            //Create an NSDate for the specified time today.
            date_components.hour = hours
            date_components.minute = minutes
            date_components.second = 0
            
            let newDate = calendar.date(from: date_components)!
            return newDate
        }
        
        func adding(minutes: Int) -> Date {
            return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
        }
        
        func minutes(from date: Date) -> Int {
            return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
        }
        
        func hours(from date: Date) -> Int {
            return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
        }
        
        func seconds(from date: Date) -> Int {
            return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
        }
        
    }


    extension Array where Element: Equatable {
        
        func indexes(of item: Element) -> [Int]  {
            return enumerated().compactMap { $0.element == item ? $0.offset : nil }
        }
    }
