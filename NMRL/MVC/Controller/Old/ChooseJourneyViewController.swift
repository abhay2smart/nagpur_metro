//
//  ChooseJourneyViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 14/09/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit

import Alamofire

class ChooseJourneyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var FromButt: UIButton!
    
    @IBOutlet var ToButt: UIButton!
    
    @IBOutlet var BookSegment: MXSegmentedControl!
    
    @IBOutlet var SingleJourneyVw: UIView!
    
    @IBOutlet var ReturnJourneyVw: UIView!
    
    @IBOutlet var GroupJourneyVw: UIView!
    
    @IBOutlet var Single_TimeLbl: UILabel!
    
    @IBOutlet var Single_ReturnType: UIButton!
    
    
    @IBOutlet var Single_Book: UIButton!
    
    @IBOutlet var Return_TimeLbl: UILabel!
    
    @IBOutlet var Return_TicketType: UIButton!
    
    
    @IBOutlet var Return_Book: UIButton!
    
    @IBOutlet var Group_TimeLbl: UILabel!
    
    @IBOutlet var GroupTicketype: UIButton!
    
    
    @IBOutlet var Group_Book: UIButton!
    
     
    
    
    var Journey_ProductCodeArr = NSArray()
    
    var Journey_MaxSaleNumbersDisplayed = [Int]()
    
    var Journey_GroupNumbersDisplayed = [Int]()
    
    var Journey_SJTLabelArr = NSMutableArray()
    
    var Journey_RJTLabelArr = NSMutableArray()
    
    var Journey_GJLabelArr = NSMutableArray()
    
    
    @IBOutlet var BlackVw: UIView!
    
    @IBOutlet var tbl: UITableView!
    
    @IBOutlet var Single_PassButt: UIButton!
    
    @IBOutlet var Return_PassButt: UIButton!
    
    @IBOutlet var Group_PassButt: UIButton!
    
    @IBOutlet var SingleTotalLbl: UILabel!
    
    @IBOutlet var ReturnTotallLbl: UILabel!
    
    @IBOutlet var GroupTotalLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FromButt.setTitle(Public_SourceStationName, for: .normal)
        
        ToButt.setTitle(Public_DestinationStationName, for: .normal)
        
        BookSegment.append(title: "SINGLE JOURNEY").set(image: #imageLiteral(resourceName: "ArrowBlack")).set(image: .top).set(padding: 10).set(image: #imageLiteral(resourceName: "ArrowGreen"), for: .selected)
        
        BookSegment.append(title: "RETURN JOURNEY").set(image: #imageLiteral(resourceName: "DoubleArrowBlack")).set(image: .top).set(padding: 10).set(image: #imageLiteral(resourceName: "DoubleArrowGreen"), for: .selected)
        
        BookSegment.append(title: "GROUP JOURNEY").set(image: #imageLiteral(resourceName: "GroupBlack")).set(image: .top).set(padding: 10).set(image: #imageLiteral(resourceName: "GroupGreen"), for: .selected)
        
        BookSegment.textColor = .lightGray
        
        BookSegment.indicatorColor = UIColor.hexStr(hexStr: "#CC7454", alpha: 1)
        
        BookSegment.selectedTextColor = UIColor.hexStr(hexStr: "#CC7454", alpha: 1)
        
        BookSegment.addTarget(self, action: #selector(changeIndex(segmentedControl:)), for: .valueChanged)
        
        BookSegment.font = UIFont(name: "Montserrat-Regular", size: 12)!
        
       // BookSegment.DropShadow()
        
        SingleJourneyVw.isHidden = false
        ReturnJourneyVw.isHidden = true
        GroupJourneyVw.isHidden = true
        
        BlackVw.isHidden = true
        
        if Journey_SJTLabelArr.count > 0
        {
            Single_ReturnType.setTitle("\(Journey_SJTLabelArr[0])", for: .normal)
        }
        
        if Journey_MaxSaleNumbersDisplayed.count > 0
        {
            Single_PassButt.setTitle("\(Journey_MaxSaleNumbersDisplayed[0])", for: .normal)
        }
        
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ChooseJourneyViewController.ShowTime)), userInfo: nil, repeats: true)
        
        CalculateQRFare()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Calculate QR Fare
    
    var Journey_ArbitryCodeStr = String()
    
    var Journey_QRTypeStr = String()
    
    var Journey_ProductCodeStr = String()
    
    var Journey_SourceStationIDStr = String()
    
    var Journey_DestinationStationIDStr = String()
    
    var Journey_TripsCountStr = String()
    
    var Journey_TicketsCountStr = String()
    
    
    func CalculateQRFare() {
        if UserData.current?.token != nil {
        let now = Date()
        
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        let dateString = formatter.string(from: now)
        
        //print("dateString : \(dateString)")
        
        //DateStr = dateString
        
        ////////////// New Time Format
        
        formatter.dateFormat = "yyyyMMddhhmmss"
        
        let dateString2 = formatter.string(from: now)
        
        ///////////////////////////////
         
 
        let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        let url = "\(APILink)calculateQRTicket"
        
        
        var parameters1: [String: Any] = [
            "id" : Journey_ArbitryCodeStr,
            "qrType" : Journey_QRTypeStr,
            "productCode" : Journey_ProductCodeStr,
            "sourceStation1" : Journey_SourceStationIDStr,
            "destinationStation1" : Journey_DestinationStationIDStr,
            "sourceStation2" : "0",
            "destinationStation2" : "0",
            "tripsCount" : Journey_TripsCountStr,
            "ticketsCount" : Journey_TicketsCountStr,
            "purchaseDate" : dateString,
            "issueDate" : dateString
        ]
        
        if Journey_QRTypeStr == "2"
        {
            parameters1 = [
                "id" : Journey_ArbitryCodeStr,
                "qrType" : Journey_QRTypeStr,
                "productCode" : Journey_ProductCodeStr,
                "sourceStation1" : Journey_SourceStationIDStr,
                "destinationStation1" : Journey_DestinationStationIDStr,
                "sourceStation2" : Journey_DestinationStationIDStr,
                "destinationStation2" : Journey_SourceStationIDStr,
                "tripsCount" : Journey_TripsCountStr,
                "ticketsCount" : Journey_TicketsCountStr,
                "purchaseDate" : dateString,
                "issueDate" : dateString
                
            ]
        }
        
        if Journey_QRTypeStr == "3"
        {
            parameters1 = [
                "id" : Journey_ArbitryCodeStr,
                "qrType" : Journey_QRTypeStr,
                "productCode" : Journey_ProductCodeStr,
                "sourceStation1" : Journey_SourceStationIDStr,
                "destinationStation1" : Journey_DestinationStationIDStr,
                "sourceStation2" : Journey_DestinationStationIDStr,
                "destinationStation2" : Journey_SourceStationIDStr,
                "tripsCount" : Journey_TripsCountStr,
                "ticketsCount" : Journey_TicketsCountStr,
                "purchaseDate" : dateString,
                "issueDate" : dateString
                
            ]
        }
        
        let params: [String: Any] = [
            "token" : UserData.current!.token!,
            "ticket" : parameters1,
            "clientReferenceNumber" : dateString2
        ]
        
        print("Params : \(params)")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show(withStatus: "Loading...")
        Alamofire.request(url, method : .post, parameters : params, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            SVProgressHUD.dismiss()
            
            //   print("Details 1 : \(dataResponse.result.value)")
            
            if let dict = dataResponse.result.value as? NSDictionary
            {
                print("Details : \(dict)")
                
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
                        
                        if let priceDetails = dict["priceDetails"] as? NSDictionary
                        {
                            if let totalRoundedPrice = priceDetails["totalRoundedPrice"] as? String
                            {
                                print("totalRoundedPrice : \(totalRoundedPrice)")
                                
                                if self.Journey_QRTypeStr == "1"
                                {
                                    self.SingleTotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                                else if self.Journey_QRTypeStr == "2"
                                {
                                    self.ReturnTotallLbl.text = "\(totalRoundedPrice) INR"
                                }
                                else
                                {
                                    self.GroupTotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                            }
                            
                            //self.DetailsDictionary = priceDetails
                        }
                        
                      /*  if let expirationDate1 = dict["expirationDate"] as? String
                        {
                            //self.ExpireDateStr = expirationDate1
                        }*/
                        
                        if let paymentInitializationURL = dict["paymentInitializationURL"] as? String
                        {
                            PublicPaymentURL = paymentInitializationURL
                            
                            //self.TimerSecond = 59
                        }
                    }
                    
                }
            }
          }
    }
    }
    
    //MARK: - MX Segmented Control
    
    @objc func changeIndex(
        segmentedControl: MXSegmentedControl) {
        
        if segmentedControl == BookSegment
        {
            switch BookSegment.selectedIndex {
            case 0:
                
                SingleJourneyVw.isHidden = false
                ReturnJourneyVw.isHidden = true
                GroupJourneyVw.isHidden = true
                
                animation(viewAnimation: SingleJourneyVw)
                
                if Journey_ProductCodeArr.count > 1
                {
                    Journey_ProductCodeStr = "\(Journey_ProductCodeArr[2])"
                }
                
                
                Journey_QRTypeStr = "1"
                
                Journey_ArbitryCodeStr = "100"
                
                self.Single_PassButt.setTitle("1", for: .normal)
                
                self.Journey_TicketsCountStr = "1"
                
                Journey_TripsCountStr = "1"
                
                CalculateQRFare()
                
            case 1:
                
                SingleJourneyVw.isHidden = true
                ReturnJourneyVw.isHidden = false
                GroupJourneyVw.isHidden = true
                
                animation(viewAnimation: ReturnJourneyVw)
                
                if Journey_ProductCodeArr.count > 0
                {
                    Journey_ProductCodeStr = "\(Journey_ProductCodeArr[0])"
                }
                
                Journey_QRTypeStr = "2"
                
                Journey_ArbitryCodeStr = "200"
                
                Journey_TripsCountStr = "2"
                
             
                
                if Journey_MaxSaleNumbersDisplayed.count > 0
                {
                    Return_TicketType.setTitle("\(Journey_RJTLabelArr[0])", for: .normal)
                    
                    Return_PassButt.setTitle("\(Journey_MaxSaleNumbersDisplayed[0])", for: .normal)
                    
                    Journey_TicketsCountStr = "\(Journey_MaxSaleNumbersDisplayed[0])"
                }
                
                CalculateQRFare()
                
            case 2:
            
                SingleJourneyVw.isHidden = true
                ReturnJourneyVw.isHidden = true
                GroupJourneyVw.isHidden = false
                
                animation(viewAnimation: GroupJourneyVw)
                
                if Journey_ProductCodeArr.count > 0
                {
                    Journey_ProductCodeStr = "\(Journey_ProductCodeArr[1])"
                }
                
                Journey_QRTypeStr = "3"
                
                Journey_ArbitryCodeStr = "300"
               
                
                if Journey_GroupNumbersDisplayed.count > 0
                {
                    Group_PassButt.setTitle("\(Journey_GroupNumbersDisplayed[0])", for: .normal)
                    
                    Journey_TicketsCountStr = "\(Journey_GroupNumbersDisplayed[0])"
                }
                
                Journey_TripsCountStr = "\(Journey_GroupNumbersDisplayed[0])"
                
                CalculateQRFare()
                
            default:
                break
            }
        }
        
    }
    
    private func animation(viewAnimation: UIView) {
        UIView.animate(withDuration: 0.07, animations: {
            viewAnimation.frame.origin.x = +viewAnimation.frame.width
        }) { (_) in
            UIView.animate(withDuration: 0.07, delay: 0.05, options: [.curveEaseIn], animations: {
                viewAnimation.frame.origin.x -= viewAnimation.frame.width
            })
            
        }
    }
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tbl.tag == 1
        {
            return Journey_SJTLabelArr.count
        }
        else if tbl.tag == 11
        {
            return Journey_RJTLabelArr.count
        }
        else if tbl.tag == 111
        {
            return Journey_GJLabelArr.count
        }
        
        else if tbl.tag == 2
        {
            return Journey_MaxSaleNumbersDisplayed.count
        }
        else if tbl.tag == 22
        {
            return Journey_MaxSaleNumbersDisplayed.count
        }
        else if tbl.tag == 222
        {
            return Journey_GroupNumbersDisplayed.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if let lbl = cell?.viewWithTag(1) as? UILabel
        {
            if tbl.tag == 1
            {
                lbl.text = "\(Journey_SJTLabelArr[indexPath.row])"
            }
            else if tbl.tag == 11
            {
                lbl.text = "\(Journey_RJTLabelArr[indexPath.row])"
            }
            else if tbl.tag == 111
            {
                lbl.text = "\(Journey_GJLabelArr[indexPath.row])"
            }
            
            else if tbl.tag == 2
            {
                lbl.text = "\(Journey_MaxSaleNumbersDisplayed[indexPath.row])"
            }
            else if tbl.tag == 22
            {
                lbl.text = "\(Journey_MaxSaleNumbersDisplayed[indexPath.row])"
            }
            else if tbl.tag == 222
            {
                lbl.text = "\(Journey_GroupNumbersDisplayed[indexPath.row])"
            }
        }
                
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tbl.tag == 1
        {
            Single_ReturnType.setTitle("\(Journey_SJTLabelArr[indexPath.row])", for: .normal)
        }
        else if tbl.tag == 11
        {
            Return_TicketType.setTitle("\(Journey_RJTLabelArr[indexPath.row])", for: .normal)
        }
        else if tbl.tag == 111
        {
            GroupTicketype.setTitle("\(Journey_GJLabelArr[indexPath.row])", for: .normal)
        }
        
        else if tbl.tag == 2
        {
            Single_PassButt.setTitle("\(Journey_MaxSaleNumbersDisplayed[indexPath.row])", for: .normal)
            
            Journey_TicketsCountStr = "\(Journey_MaxSaleNumbersDisplayed[indexPath.row])"
            
            CalculateQRFare()
        }
        else if tbl.tag == 22
        {
            Return_PassButt.setTitle("\(Journey_MaxSaleNumbersDisplayed[indexPath.row])", for: .normal)
            
            Journey_TicketsCountStr = "\(Journey_MaxSaleNumbersDisplayed[indexPath.row])"
            
            CalculateQRFare()
        }
        else if tbl.tag == 222
        {
            Group_PassButt.setTitle("\(Journey_GroupNumbersDisplayed[indexPath.row])", for: .normal)
            
            Journey_TicketsCountStr = "\(Journey_GroupNumbersDisplayed[indexPath.row])"
            
            CalculateQRFare()
        }
        
        BlackVw.isHidden = true
        
    }
    
    @objc func ShowTime()
    {
        let now = Date()
        
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        
        //formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        formatter.dateFormat = "HH : mm : ss"
        
        formatter.timeStyle = .medium
        
        let dateString = formatter.string(from: now)
        
         Single_TimeLbl.text = dateString
        
        Return_TimeLbl.text = dateString
        
        Group_TimeLbl.text = dateString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func SingleTypeClick(_ sender: Any) {
        
        tbl.tag = 1
        BlackVw.isHidden = false
        tbl.reloadData()
    }
    
    @IBAction func ReturnTypeClick(_ sender: Any) {
        
        tbl.tag = 11
        BlackVw.isHidden = false
        tbl.reloadData()
    }
    
    @IBAction func GroupTypeClick(_ sender: Any) {
        
        tbl.tag = 111
        BlackVw.isHidden = false
        tbl.reloadData()
    }
    
    @IBAction func SignlePassClicked(_ sender: Any) {
        
        tbl.tag = 2
        BlackVw.isHidden = false
        tbl.reloadData()
    }
    
    
    @IBAction func ReturnPassClicked(_ sender: Any) {
        
        tbl.tag = 22
        BlackVw.isHidden = false
        tbl.reloadData()
    }
    
    @IBAction func GroupPassClieked(_ sender: Any) {
        
        tbl.tag = 222
        BlackVw.isHidden = false
        tbl.reloadData()
        
    }
    
    
    @IBAction func SingleBookClick(_ sender: Any) {
        
        let ReviewBookingViewController1 = self.storyboard?.instantiateViewController(withIdentifier: "ReviewBookingViewController") as! ReviewBookingViewController
        
        // Caluculate QR Ticket
        
//        ReviewBookingViewController1.Review_ArbitryCodeStr = self.ArbitryCodeStr
//        ReviewBookingViewController1.Review_QRTypeStr = self.QRTypeStr
//        ReviewBookingViewController1.Review_ProductCodeStr = self.ProductCodeStr
//        ReviewBookingViewController1.Review_SourceStationIDStr = self.SourceStationIDStr
//        ReviewBookingViewController1.Review_DestinationStationIDStr = self.DestinationStationIDStr
//        ReviewBookingViewController1.Review_TripsCountStr = self.TripsCountStr
//        ReviewBookingViewController1.Review_TicketsCountStr = self.TicketsCountStr
//        
//        
//        
//        ReviewBookingViewController1.SourceStation = FromStationStr
//        ReviewBookingViewController1.DestinationStation = ToStationStr
//        // ReviewBookingViewController1.DateStr = DateStr
//        ReviewBookingViewController1.ExpireDateStr = ExpireDateStr
//        ReviewBookingViewController1.ValidityMinuteInt = 30
//    
        
        self.navigationController?.pushViewController(ReviewBookingViewController1, animated: true)
    }
    
    
    @IBAction func ReturnBookClick(_ sender: Any) {
    }
    
    @IBAction func GroupBookClick(_ sender: Any) {
    }
    
    
    @IBAction func HideBlackVw(_ sender: Any) {
        
        BlackVw.isHidden = true
    }
    
    
    @IBAction func Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
