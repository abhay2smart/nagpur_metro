//
//  ReviewBookingViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 08/08/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit

import Alamofire

var PublicTicketArr = NSArray()

class ReviewBookingViewController: UIViewController {
    
    @IBOutlet var Scroll: SPSignIn!
    
    
    var SourceStation = String()
    
    var DestinationStation = String()
    
    var DateStr = String()
    
    var ExpireDateStr = String()
    
    var ValidityMinuteInt = Int()
    
    
    @IBOutlet var PriceLbl: UILabel!
    
    @IBOutlet var DateLbl: UILabel!
    
    @IBOutlet var SourceLbl: UILabel!
    
    @IBOutlet var DestinationLbl: UILabel!
    
    @IBOutlet var passengerLbl: UILabel!
    
    @IBOutlet var ValidityLbl: UILabel!
    
    @IBOutlet var BasePriceLbl: UILabel!
    
    @IBOutlet var TaxLbl: UILabel!
    
    @IBOutlet var CoefficientLbl: UILabel!
    
    @IBOutlet var OthersLbl: UILabel!
    
    @IBOutlet var QuantityLbl: UILabel!
    
    @IBOutlet var TotalLbl: UILabel!
    
    @IBOutlet var PaymentButt: UIButton!
    
    @IBOutlet var ArrowImg: UIImageView!
    
   // var DetailsDict = NSDictionary()
    
    
    //MARK: - Buy Qr Ticket
    
//    var Buy_ArbitryID = String()
//    
//    var Buy_QRType = String()
//    
//    var Buy_ProductCode = String()
//    
//    var Buy_SorceStationID = String()
//    
//    var Buy_DestinationStationID = String()
//    
//    var Buy_TripsCount = String()
//    
//    var Buy_TicketsCount = String()
    
    @IBOutlet var ConfirmationBlackView: UIView!
    
    var TimerSec = Int()
    
    @IBOutlet var ExpireLbl: UILabel!
    
     
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Scroll.backgroundColor = .clear
        
        SourceLbl.text = SourceStation
        DestinationLbl.text = DestinationStation
        
        Public_FromStationFailed = Review_SourceStationIDStr
        Public_ToStationFailed = Review_DestinationStationIDStr
        
        let now = Date()
        
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        let dateString = formatter.string(from: now)
        
        //print("dateString : \(dateString)")
        
        DateStr = dateString
        
        Public_TimeBookedFailed = DateStr
      
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyyMMddHHmmss"
        let showDate = inputFormatter.date(from: DateStr)
        
        
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        inputFormatter.dateStyle = .long
        
        inputFormatter.timeStyle = .medium
        
        let resultString = inputFormatter.string(from: showDate!)
        
        DateLbl.text = resultString.replacingOccurrences(of: "at", with: "")
        
        let date2 = showDate!.addingTimeInterval(Double(ValidityMinuteInt) * 60.0)
        
        let resultString2 = inputFormatter.string(from: date2)
        
        ValidityLbl.text = "Valid from \(resultString.components(separatedBy: "at").last!) to \(resultString2.components(separatedBy: "at").last!)"
        
        
        ConfirmationBlackView.isHidden = true
        
        PaymentButt.setTitle("Make Payment", for: .normal)
        
        ExpireLbl.text = "Payment expire in \(TimerSec) sec"
        
       // timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ReviewBookingViewController.CaluculatePaymentTimer)), userInfo: nil, repeats: true)
        
        PublicCalculateQRAgain = 1
        
        if Review_ArbitryCodeStr == "100"
        {
            ArrowImg.image = #imageLiteral(resourceName: "RightArrow")
            
            Public_TicketTypeFailed = "SJT"
        }
        else if Review_ArbitryCodeStr == "200"
        {
            ArrowImg.image = #imageLiteral(resourceName: "DoubleArrowBlack")
            
            Public_TicketTypeFailed = "RJT"
        }
        else if Review_ArbitryCodeStr == "300"
        {
            ArrowImg.image = UIImage(named: "GroupBlack")
            
            Public_TicketTypeFailed = "GJT"
        }
        
        
        CalculateQRFare()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Calculate QR Fare
    
    var Review_ArbitryCodeStr = String()
    
    var Review_QRTypeStr = String()
    
    var Review_ProductCodeStr = String()
    
    var Review_SourceStationIDStr = String()
    
    var Review_DestinationStationIDStr = String()
    
    var Review_TripsCountStr = String()
    
    var Review_TicketsCountStr = String()
    
    
    func CalculateQRFare()
    {
        if UserData.current?.token != nil {
        let now = Date()
        
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        let dateString = formatter.string(from: now)
        
        //print("dateString : \(dateString)")
        
        DateStr = dateString
        
        ////////////// New Time Format
        
        formatter.dateFormat = "yyyyMMddhhmmss"
        
        let dateString2 = formatter.string(from: now)
        
        ///////////////////////////////
        
 
        let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        let url = "\(APILink)calculateQRTicket"
        
        
        var parameters1: [String: Any] = [
            "id" : Review_ArbitryCodeStr,
            "qrType" : Review_QRTypeStr,
            "productCode" : Review_ProductCodeStr,
            "sourceStation1" : Review_SourceStationIDStr,
            "destinationStation1" : Review_DestinationStationIDStr,
            "sourceStation2" : "0",
            "destinationStation2" : "0",
            "tripsCount" : Review_TripsCountStr,
            "ticketsCount" : Review_TicketsCountStr,
            "purchaseDate" : dateString,
            "issueDate" : dateString
        ]
        
        if Review_QRTypeStr == "2"
        {
            parameters1 = [
                "id" : Review_ArbitryCodeStr,
                "qrType" : Review_QRTypeStr,
                "productCode" : Review_ProductCodeStr,
                "sourceStation1" : Review_SourceStationIDStr,
                "destinationStation1" : Review_DestinationStationIDStr,
                "sourceStation2" : Review_DestinationStationIDStr,
                "destinationStation2" : Review_SourceStationIDStr,
                "tripsCount" : Review_TripsCountStr,
                "ticketsCount" : Review_TicketsCountStr,
                "purchaseDate" : dateString,
                "issueDate" : dateString
                
            ]
        }
        
        if Review_QRTypeStr == "3"
        {
            parameters1 = [
                "id" : Review_ArbitryCodeStr,
                "qrType" : Review_QRTypeStr,
                "productCode" : Review_ProductCodeStr,
                "sourceStation1" : Review_SourceStationIDStr,
                "destinationStation1" : Review_DestinationStationIDStr,
                "sourceStation2" : Review_DestinationStationIDStr,
                "destinationStation2" : Review_SourceStationIDStr,
                "tripsCount" : Review_TripsCountStr,
                "ticketsCount" : Review_TicketsCountStr,
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
                                
                                if self.Review_QRTypeStr == "1"
                                {
                                   // self.TotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                                else if self.Review_QRTypeStr == "2"
                                {
                                    //self.ReturnTotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                                else
                                {
                                    //self.GroupTotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                            }
                            
                            if let basePrice = priceDetails["basePrice"] as? String
                            {
                                self.BasePriceLbl.text = "\(basePrice) INR"
                            }
                            
                            if let coefficient = priceDetails["coefficient"] as? String
                            {
                                self.CoefficientLbl.text = coefficient
                            }
                            
                            if let count = priceDetails["count"] as? Int
                            {
                                self.QuantityLbl.text = "\(count)"
                                
                                if count == 1
                                {
                                    self.passengerLbl.text = "1 passenger"
                                    
                                    Public_PassengerCountFailed = "1"
                                }
                                else
                                {
                                    self.passengerLbl.text = "\(count) passengers"
                                    Public_PassengerCountFailed = "\(count)"
                                }
                            }
                            
                            if let roundingDifference = priceDetails["roundingDifference"] as? String
                            {
                                self.OthersLbl.text = "\(roundingDifference) INR"
                            }
                            
                            if let tax = priceDetails["tax"] as? String
                            {
                                self.TaxLbl.text = "\(self.forTrailingZero(temp: Double(tax)!)) INR"
                            }
                            
                            if let totalRoundedPrice = priceDetails["totalRoundedPrice"] as? String
                            {
                                if let roundedPrice = priceDetails["roundedPrice"] as? String
                                {
                                    self.TotalLbl.text = "\(self.QuantityLbl.text!) * \(roundedPrice) = \(totalRoundedPrice) INR"
                                }
                                
                                self.PriceLbl.text = "\(totalRoundedPrice) INR"
                                
                                Public_PriceFailed = totalRoundedPrice
                            }
                            
                        }
                        
                        if let expirationDate1 = dict["expirationDate"] as? String
                        {
                            self.ExpireDateStr = expirationDate1
                        }
                        
                        if let paymentInitializationURL = dict["paymentInitializationURL"] as? String
                        {
                            PublicPaymentURL = paymentInitializationURL
                            
                            //self.TimerSecond = 59
                        }
                    }
                    else if result == 4
                    {
                         kAppDelegate.shared.showAlert(self, message: "Session expired. Please login again.")
                        
                        self.LogOutTokenInvalid()
                        return
                    }
                    else if result == 6
                    {
                         kAppDelegate.shared.showAlert(self, message: "Internal server error. Please try again.")
                        
                        self.Back(self)
                    }
                        
                    else if result == 14
                    {
                         kAppDelegate.shared.showAlert(self, message: "Invalid action.")
                        self.LogOutTokenInvalid()
                        return
                    }
                    else if result == 15
                    {
                         kAppDelegate.shared.showAlert(self, message: "User logged in another device. Please login again.")
                        self.LogOutTokenInvalid()
                        return
                    }
                    else if result == 16
                    {
                         kAppDelegate.shared.showAlert(self, message: "Invalid token. Please login again.")
                        self.LogOutTokenInvalid()
                        return
                    }
                    else if result == 17
                    {
                         kAppDelegate.shared.showAlert(self, message: "Invalid booking. Please try again.")
                        
                        self.Back(self)
                    }
                    else if result == 18
                    {
                         kAppDelegate.shared.showAlert(self, message: "Booking devide mismatch. Please try again.")
                        
                        self.Back(self)
                    }
                        
                    else if result == 19
                    {
                         kAppDelegate.shared.showAlert(self, message: "Business time over. Please try again.")
                        
                        self.Back(self)
                    }
                        
                    else if result == 21
                    {
                         kAppDelegate.shared.showAlert(self, message: "Invalid product code. Please try again.")
                        
                        self.Back(self)
                    }
                    else if result == 25
                    {
                         kAppDelegate.shared.showAlert(self, message: "Invalid request. Please try again.")
                        
                        self.Back(self)
                    }
                    
                }
            }
            
             self.TimerSec = 60
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ReviewBookingViewController.CaluculatePaymentTimer)), userInfo: nil, repeats: true)
        }
    }
    }
    
    //MARK: - Timer
    
    var timer = Timer()
    
    @objc func CaluculatePaymentTimer()
    {
        if TimerSec == 0
        {
            PaymentButt.setTitle("Replan", for: .normal)
            
            ExpireLbl.text = "Expired"
        }
        else
        {
            TimerSec -= 1            
            ExpireLbl.text = "Payment expire in \(TimerSec) sec"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func forTrailingZero(temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    
    @IBAction func MakePayment(_ sender: Any)
    {
        if TimerSec == 0
        {
            timer.invalidate()
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            ConfirmationBlackView.isHidden = false
        }
        
    }
    
    @IBAction func ConfirmOK(_ sender: Any)
    {
        self.ConfirmationBlackView.isHidden = true
        let cc = self.storyboard?.instantiateViewController(withIdentifier: "WebPaymentViewController")
        self.navigationController?.pushViewController(cc!, animated: true)

     /*   return
        
        let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        let url = "\(APILink)buyQRTicket"
        
        
        var parameters1: [String: Any] = [
            "id" : self.Buy_ArbitryID,
            "qrType" : self.Buy_QRType,
            "productCode" : self.Buy_ProductCode,
            "sourceStation1" : self.Buy_SorceStationID,
            "destinationStation1" : self.Buy_DestinationStationID,
            "sourceStation2" : "0",
            "destinationStation2" : "0",
            "tripsCount" : self.Buy_TripsCount,
            "ticketsCount" : self.Buy_TicketsCount,
            "purchaseDate" : self.DateStr,
            "issueDate" : self.DateStr
        ]
        
        if "QRTypeStr" == "2"
        {
            parameters1 = [
                "id" : self.Buy_ArbitryID,
                "qrType" : self.Buy_QRType,
                "productCode" : self.Buy_ProductCode,
                "sourceStation1" : self.Buy_SorceStationID,
                "destinationStation1" : self.Buy_DestinationStationID,
                "sourceStation2" : self.Buy_DestinationStationID,
                "destinationStation2" : self.Buy_SorceStationID,
                "tripsCount" : self.Buy_TripsCount,
                "ticketsCount" : self.Buy_TicketsCount,
                "purchaseDate" : self.DateStr,
                "issueDate" : self.DateStr
            ]
        }
        
        let params: [String: Any] = [
            "token" : UserData.current!.token!,
            "ticket" : parameters1,
            "clientRefrenceNumber" : self.DateStr
        ]
        
        
        print(params)
        
        Alamofire.request(url, method : .post, parameters : params, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            
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
                                 UserData.current = UserData.current!
                                        kAppDelegate.shared.saveLoggedUserdetails(decoded as! NSDictionary)
                                print(decoded as! NSDictionary)
                            }catch {
                               
                            } 
                        }
                        
                        if let tickets = dict["tickets"] as? NSArray
                        {
                            PublicTicketArr = tickets
                        }
                        
                    }
                    
                }
            }
            
            self.ConfirmationBlackView.isHidden = true
            
            let ConfirmationViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmationViewController")
            
            self.navigationController?.pushViewController(ConfirmationViewController!, animated: true)
            
        }
        
        //////////
        */
    }
    
    @IBAction func ConfirmCancel(_ sender: Any) {
        
        self.ConfirmationBlackView.isHidden = true
    }
    
    @IBAction func Back(_ sender: Any) {
        
        timer.invalidate()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func LogOutTokenInvalid() {
            kAppDelegate.shared.logoutCurrentUser { (success) in
            }
    }
}
