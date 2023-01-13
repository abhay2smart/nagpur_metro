//
//  BookTicketViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 24/10/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import CoreLocation
import MapKit
import CoreData

var Public_BackOfficeDataDict               = NSDictionary()
var PublicAlreadySavedData                  = NSArray()
var Public_PositionSourceStation            = String()
var Public_PositionDestinationStation       = String()
var Public_AlreadySavedTicketStatusData     = NSDictionary()
var Public_StationNameListingArr            = NSArray()
var Public_StationLogicalIDListingArr       = NSArray()

class BookTicketViewController: UIViewController, GMSMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
 
    @IBOutlet var Segment: MXSegmentedControl!
    @IBOutlet var BlackVw: UIView!
    @IBOutlet var tbl: UITableView!
    @IBOutlet var FromButt: UIButton!
    @IBOutlet var ToButt: UIButton!
    @IBOutlet var SearchField: UITextField!
    @IBOutlet var SourceLbl: UILabel!
    @IBOutlet var BookTicketBackVw: UIView!
    @IBOutlet var BookSegment: MXSegmentedControl!
    @IBOutlet var SingleJourneyVw: UIView!
    @IBOutlet var TimeLbl: UILabel!
    @IBOutlet var TicketTypeButt: UIButton!
    @IBOutlet var NoofPassButt: UIButton!
    @IBOutlet var TotalLbl: UILabel!
    @IBOutlet var SignleBookButt: UIButton!
    @IBOutlet var BookTicketTblBlackVw: UIView!
    @IBOutlet var BookTicketTbl: UITableView!
    @IBOutlet var ReturnJourneyVw: UIView!
    @IBOutlet var ReturnTimeLbl: UILabel!
    @IBOutlet var ReturnTicketTypeButt: UIButton!
    @IBOutlet var ReturnNoofPassButt: UIButton!
    @IBOutlet var ReturnTotalLbl: UILabel!
    @IBOutlet var ReturnBookButt: UIButton!
    @IBOutlet var GroupJourneyVw: UIView!
    @IBOutlet var GroupTimeLbl: UILabel!
    @IBOutlet var GroupTicketTypeButt: UIButton!
    @IBOutlet var GroupNoofPassButt: UIButton!
    @IBOutlet var GroupTotalLbl: UILabel!
    @IBOutlet var GroupBookButt: UIButton!
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var SingleDownImage: UIImageView!
    @IBOutlet var ReturnDownImage: UIImageView!
    @IBOutlet var GroupDownImage: UIImageView!
    @IBOutlet var ScrollVw: UIScrollView!
    @IBOutlet var ConditionsBlackVw: UIView!
    @IBOutlet var SinglePriceLbl: UILabel!
    @IBOutlet var ReturnPriceLbl: UILabel!
    @IBOutlet var GroupPriceLbl: UILabel!
    @IBOutlet var SlideUpBookButt: UIButton!
    @IBOutlet var LogoutBlaceView: UIView!
    @IBOutlet var SlideStopLbl: UILabel!
    @IBOutlet var InternetBlackView: UIView!

    var BookTblCheck = 0
    var ArbitryCodeStr = "100"
    var ProductCodeStr = "10"
    var QRTypeStr = "1"
    var SourceStationIDStr = "00"
    var DestinationStationIDStr = "00"
    var TicketsCountStr = "1"
    var TripsCountStr = "1"
    var DetailsDictionary = NSDictionary()
    var DateStr = String()
    var ExpireDateStr = String()
    var RJTFirstTime = 0
    var GroupFirstTime = 0
    var MaxSaleQR = Int()
    var MaxGroupNum = Int()
    var MinGroupNum = Int()
    var MaxSaleNumbersDisplayed = [Int]()
    var GroupNumbersDisplayed = [Int]()
    var SlideViewCenterY = CGFloat()
    var ButtCheck = 0
    var FromStationStr = String()
    var ToStationStr = String()
    var SearchArr = NSArray()
    var DestinationArr = NSMutableArray()
    var UserCurrentLocation = CLLocation()
    var StationLocationCordinates = [CLLocation]()
    var people: [NSManagedObject] = []
    var TicketsArr = NSArray()
    var AlreadySavedData = NSArray()
    var SJTLabelArr = NSMutableArray()
    var RJTLabelArr = NSMutableArray()
    var GroupLabelArr = NSMutableArray()
    var FromStationLocation = CLLocation()
    var ToStationLocation = CLLocation()
    var FromGreenLongitude = String()
    var FromGreenLatitude = String()
    var ToGreenLongitude = String()
    var ToGreenLatitude = String()
    var SourceStationIntexSelected = String()
    var DestinationStationIntexSelected = String()
    var SinglePrice = String()
    var ReturnPrice = String()
    var GroupPrice = String()
    var SinglePaymentUrl = String()
    var ReturnPaymentUrl = String()
    var GroupPaymentUrl = String()
    var SingleValueCheck = 0
    var SingleCount = "1"
    var ReturnCount = "1"
    var GroupCount = "1"
    var locationManager = CLLocationManager()
    var LineDefaultColoArr = NSArray()
    var LineIDArr = NSArray()
    var LineNameArr = NSArray()
    var Station_DistanceArr = NSArray()
    var Station_LineOrder = NSArray()
    var Station_LogicalStationIDArr = NSArray()
    var Product_CodeArr = NSArray()
    var Product_LabelArr = NSArray()
    var Product_ProductTypeArr = NSArray()
    var Product_qrTicketTypeArr = NSArray()
    var product_ValidityTime = NSArray()
    var Mobile_LatitudeArr = NSArray()
    var Mobile_LongitudeArr = NSArray()
    var Mobile_LogicalStationIDArr = NSArray()
    var Mobile_StationNameArr = NSArray()
    var StationInfoMutableArr = NSMutableArray()
    var StationInfoMutableArr_2 = NSMutableArray()

    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        InternetBlackView.isHidden = true
        LogoutBlaceView.isHidden = true
        GMSServices.provideAPIKey("AIzaSyAi_OmXeHOVUyKfd3vRzgYiVyU0v1etCFM")
        Segment.append(title: "PLAN A JOURNEY").set(image: #imageLiteral(resourceName: "PlanBlackImage")).set(image: .top).set(padding: 10).set(image: #imageLiteral(resourceName: "PlanImage"), for: .selected)
        Segment.append(title: "BOOK TICKET").set(image: #imageLiteral(resourceName: "BookBlackImage")).set(image: .top).set(padding: 10).set(image: #imageLiteral(resourceName: "BookImage"), for: .selected)
        Segment.textColor = .black
        Segment.indicatorColor = UIColor.hexStr(hexStr: "#FF9300", alpha: 1) //
        Segment.selectedTextColor = UIColor.hexStr(hexStr: "#FF9300", alpha: 1)
        Segment.addTarget(self, action: #selector(changeIndex(segmentedControl:)), for: .valueChanged)
        Segment.font = UIFont(name: "Montserrat-Regular", size: 13)!
        Segment.select(index: 1, animated: false)
        ///////// *********** BOOKING SEGMENT
        BookSegment.append(title: "Single Journey").set(image: #imageLiteral(resourceName: "ArrowBlack")).set(image: .top).set(padding: 15).set(image: #imageLiteral(resourceName: "ArrowGreen"), for: .selected)
        BookSegment.append(title: "Return Journey").set(image: #imageLiteral(resourceName: "DoubleArrowBlack")).set(image: .top).set(padding: 15).set(image: #imageLiteral(resourceName: "DoubleArrowGreen"), for: .selected)
        BookSegment.append(title: "Group Journey").set(image: #imageLiteral(resourceName: "GroupBlack")).set(image: .top).set(padding: 15).set(image: #imageLiteral(resourceName: "GroupGreen"), for: .selected)
        BookSegment.indicator.lineHeight = 3
        BookSegment.textColor = .lightGray
        BookSegment.indicatorColor = UIColor.hexStr(hexStr: "#FF9300", alpha: 1)
        BookSegment.selectedTextColor = UIColor.hexStr(hexStr: "#FF9300", alpha: 1)
        BookSegment.addTarget(self, action: #selector(changeIndex(segmentedControl:)), for: .valueChanged)
        BookSegment.font = UIFont(name: "Montserrat-Bold", size: 15)!
        BookSegment.separatorColor = UIColor.black.withAlphaComponent(0.5)
        BookSegment.indicatorHeight = 2
        BookSegment.separatorWidth = 0.5
      //  BookSegment.DropShadow()
        
        
        ////////************ GOOGLE MAPS
        
        //        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        //        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        //        self.Mapiew.animate(to: camera)
        //        // Creates a marker in the center of the map.
        //        let marker = GMSMarker()
        //        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        //        marker.title = "Sydney"
        //        marker.snippet = "Australia"
        //        marker.map = mapView
        
        //////////******************************** CURRENT LOCATION
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        //        if (CLLocationManager.locationServicesEnabled())
        //        {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        //}
        SearchField.addTarget(self, action: #selector(ViewController.ChangeValues), for: .editingChanged)
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.ShowTime)), userInfo: nil, repeats: true)
        InternetBlackView.isHidden = true
        FromButt.layer.cornerRadius = 8
        FromButt.clipsToBounds = true
        ToButt.layer.cornerRadius = 8
        ToButt.clipsToBounds = true
        BookTicketBackVw.isHidden = false
        BlackVw.isHidden = true
        BookTicketTblBlackVw.isHidden = true
        ReturnJourneyVw.isHidden = true
        GroupJourneyVw.isHidden = true
        LogoutBlaceView.isHidden = true
        PublicPaymentURL = "0"
        PublicCalculateQRAgain = 0
         ConditionsBlackVw.isHidden = true
        BackOfficeDict()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.CaluculatePaymentTimer)), userInfo: nil, repeats: true)
        if DeviceType.IS_IPHONE_5 {
            ScrollVw.contentSize = CGSize(width : 0, height : 2120)
        }else if DeviceType.IS_IPHONE_6 {
            ScrollVw.contentSize = CGSize(width : 0, height : 2220)
        }else if DeviceType.IS_IPHONE_6P {
            ScrollVw.contentSize = CGSize(width : 0, height : 2420)
        }else if DeviceType.IS_IPHONE_X {
            ScrollVw.contentSize = CGSize(width : 0, height : 2520)
        }else if DeviceType.IS_IPHONE_XP {
            ScrollVw.contentSize = CGSize(width : 0, height : 2620)
        }
}
    
    //MARK: - Current Location
    override func viewWillAppear(_ animated: Bool) {
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        ReadData()
        TimerSecond = 60
        if PublicCalculateQRAgain == 1 {
            //**CalculateQRFare()
        }
        
        if Public_SourceStationName != "" {
            FromButt.setTitle(Public_SourceStationName, for: .normal)
             ToButt.setTitle(Public_DestinationStationName, for: .normal)
             self.SourceStationIDStr = Public_SourceStationIDs
             self.DestinationStationIDStr = Public_DestinationStationIDs
             self.FromStationStr = Public_SourceStationName
             self.ToStationStr = Public_DestinationStationName
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                 self.SingleValueCheck = 0
                 let ind = self.Product_qrTicketTypeArr.index(of: "SJT")
                if UserData.current?.token != nil {
                self.CalculateQRTicketSingle(Arbitry: "100", QRType: "1", ProdCode: "\(self.Product_CodeArr[ind])", Count: "1")
                }
                }
         }else {
            FromButt.setTitle("Select Source Station", for: .normal)
            
            ToButt.setTitle("Select Destination Station", for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         NotificationCenter.default.removeObserver(self, name: Notification.Name("MyTicket"), object: nil)
         NotificationCenter.default.removeObserver(self, name: Notification.Name("ToProfile"), object: nil)
         NotificationCenter.default.removeObserver(self, name: Notification.Name("ToHistory"), object: nil)
         NotificationCenter.default.removeObserver(self, name: Notification.Name("ToChangePass"), object: nil)
         NotificationCenter.default.removeObserver(self, name: Notification.Name("ToLogOut"), object: nil)
    }
    
    
    @objc func ShowTime() {
        let now = Date()
         let formatter = DateFormatter()
         formatter.timeZone = TimeZone.current
         //formatter.dateFormat = "yyyy-MM-dd HH:mm"
         formatter.dateFormat = "HH : mm : ss"
         formatter.timeStyle = .medium
         let dateString = formatter.string(from: now)
         TimeLbl.text = dateString
         ReturnTimeLbl.text = dateString
        GroupTimeLbl.text = dateString
    }
    
    //MARK: - Back Office Data Dict
    func BackOfficeDict() {
         let dict = Public_BackOfficeDataDict
         print("dict Back office : \(dict)")
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
                    UserDefaults.standard.synchronize()
                }
                
                if let maxSaleQRPerTransaction = dict["maxSaleQRPerTransaction"] as? Int {
                    self.MaxSaleQR = maxSaleQRPerTransaction
                 }
                 for v in 1 ..< self.MaxSaleQR + 1 {
                    self.MaxSaleNumbersDisplayed.append(v)
                }
                 if let maxGroupNumber = dict["maxGroupNumber"] as? Int {
                    self.MaxGroupNum = maxGroupNumber
                }
                 if let minGroupNumber = dict["minGroupNumber"] as? Int {
                    self.MinGroupNum = minGroupNumber
                }
                 for v in self.MinGroupNum ..< self.MaxGroupNum + 1 {
                    self.GroupNumbersDisplayed.append(v)
                }
                self.GroupNoofPassButt.setTitle("\(self.GroupNumbersDisplayed[0])", for: .normal)
                self.GroupCount = "\(self.GroupNumbersDisplayed[0])"
                
                if let mobileLineInfo = dict["mobileLineInfo"] as? NSArray {
                     print("mobileLineInfo : \(mobileLineInfo)")
                     if let lineDefaultColor = mobileLineInfo.value(forKey: "lineDefaultColor") as? NSArray {
                        self.LineDefaultColoArr = lineDefaultColor
                    }
                     if let lineId = mobileLineInfo.value(forKey: "lineId") as? NSArray {
                        self.LineIDArr = lineId
                    }
                     if let lineName = mobileLineInfo.value(forKey: "lineName") as? NSArray {
                        self.LineNameArr = lineName
                    }
                }
                 if let mobileLineStationInfo = dict["mobileLineStationInfo"] as? NSArray {
                      if let distance = mobileLineStationInfo.value(forKey: "distance") as? NSArray {
                        self.Station_DistanceArr = distance
                    }
                     if let lineOrder = mobileLineStationInfo.value(forKey: "lineOrder") as? NSArray {
                        self.Station_LineOrder = lineOrder
                    }
                     if let logicalStationId = mobileLineStationInfo.value(forKey: "logicalStationId") as? NSArray {
                        self.Station_LogicalStationIDArr = logicalStationId
                    }
                }
                 if let mobileProductInfo = dict["mobileProductInfo"] as? NSArray {
                     if let code = mobileProductInfo.value(forKey: "code") as? NSArray {
                        self.Product_CodeArr = code
                    }
                     if let label = mobileProductInfo.value(forKey: "label") as? NSArray {
                        self.Product_LabelArr = label
                    }
                     for p in self.Product_LabelArr {
                        if let  str = p as? String {
                            if str.contains("Single") || str.contains("SJT") {
                                self.SJTLabelArr.add(str)
                            }else if str.contains("Return") || str.contains("RJT") {
                                self.RJTLabelArr.add(str)
                            }else {
                                self.GroupLabelArr.add(str)
                            }
                        }
                    }
                     if self.SJTLabelArr.count > 0 {
                        self.TicketTypeButt.setTitle("\(self.SJTLabelArr[0])", for: .normal)
                    }
                     if self.RJTLabelArr.count > 0 {
                        self.ReturnTicketTypeButt.setTitle("\(self.RJTLabelArr[0])", for: .normal)
                    }
                     if self.GroupLabelArr.count > 0 {
                        self.GroupTicketTypeButt.setTitle("\(self.GroupLabelArr[0])", for: .normal)
                    }
                     if let productType = mobileProductInfo.value(forKey: "productType") as? NSArray {
                        self.Product_ProductTypeArr = productType
                    }
                     if let qrTicketType = mobileProductInfo.value(forKey: "qrTicketType") as? NSArray {
                        self.Product_qrTicketTypeArr = qrTicketType
                    }
                     let ind = self.Product_qrTicketTypeArr.index(of: "SJT")
                     self.ProductCodeStr = "\(Product_CodeArr[ind])"
                     print("self.ProductCodeStr : \(self.ProductCodeStr)")
                     if let validityTime = mobileProductInfo.value(forKey: "validityTime") as? NSArray {
                        self.product_ValidityTime = validityTime
                    }
                }
                 if let mobileStationInfo = dict["mobileStationInfo"] as? NSArray {
                     if let latitude = mobileStationInfo.value(forKey: "latitude") as? NSArray {
                        self.Mobile_LatitudeArr = latitude
                    }
                     if let longitude = mobileStationInfo.value(forKey: "longitude") as? NSArray {
                        self.Mobile_LongitudeArr = longitude
                    }
                     if let logicalStationId = mobileStationInfo.value(forKey: "logicalStationId") as? NSArray {
                        self.Mobile_LogicalStationIDArr = logicalStationId
                    }
                     if let stationName = mobileStationInfo.value(forKey: "stationName") as? NSArray {
                        self.Mobile_StationNameArr = stationName
                    }
                     self.StationInfoMutableArr_2 = NSMutableArray(array: mobileStationInfo)
                     for i in 0 ..< self.Mobile_LogicalStationIDArr.count {
                        PublicLogicalStationIDDict.setValue("\(self.Mobile_StationNameArr[i])", forKey: "\(self.Mobile_LogicalStationIDArr[i])")
                    }
                 }
 
                // var IndexArr = [Int]()
                
                for k in self.Station_LogicalStationIDArr {
                    let val = k as! Int
                     let index = self.Mobile_LogicalStationIDArr.index(of: val)
                     //  IndexArr.append(index) // 3, 0, 1, 2
                     self.StationInfoMutableArr.add(self.StationInfoMutableArr_2[index])
                     print("Index : \(index)")
                }
 
                //////////
                 print(print("StationInfoMutableArr 00 : \(self.StationInfoMutableArr_2)"))
                 print(print("StationInfoMutableArr 3 : \(self.StationInfoMutableArr)"))
                 Public_StationNameListingArr = NSArray()
                 if let StationNameArr = self.StationInfoMutableArr.value(forKey: "stationName") as? NSArray {
                    print("StationNameArr : \(StationNameArr)")
                     Public_StationNameListingArr = StationNameArr
                }
                 Public_StationLogicalIDListingArr = NSArray()
                 if let logicalStationId = self.StationInfoMutableArr.value(forKey: "logicalStationId") as? NSArray {
                    print("logicalStationId : \(logicalStationId)")
                     Public_StationLogicalIDListingArr = logicalStationId
                }
                
            }else if result == 16 {
                self.LogOK(AnyClass.self)
            }
        }
          if self.Mobile_StationNameArr.count > 0 {
            var ss = 0
            var dd = 2
            if Public_PositionSourceStation != "" {
                ss = Int(Public_PositionSourceStation)!
                 dd = Int(Public_PositionDestinationStation)!
            }
            
            print("ss : \(ss)")
            print("dd : \(dd)")
            
            self.FromStationStr = "\(self.Mobile_StationNameArr[ss])"
             self.FromButt.setTitle("\(self.Mobile_StationNameArr[ss])", for: .normal)
             self.SourceStationIDStr = "\(self.Mobile_LogicalStationIDArr[ss])"
             if let dic1 = self.StationInfoMutableArr[ss] as? NSDictionary {
                let longitude = dic1["longitude"] as! String
                 let latitude = dic1["latitude"] as! String
                 print("Longitude : \(longitude)")
                 print("latitude : \(latitude)")
                 self.FromGreenLongitude = longitude
                self.FromGreenLatitude = latitude
             }
             if self.Mobile_StationNameArr.count > 1 {
                self.ToStationStr = "\(self.Mobile_StationNameArr[dd])"
                 self.ToButt.setTitle("\(self.Mobile_StationNameArr[dd])", for: .normal)
                 self.DestinationStationIDStr = "\(self.Mobile_LogicalStationIDArr[dd])"
                 if let dic1 = self.StationInfoMutableArr[dd] as? NSDictionary {
                    let longitude = dic1["longitude"] as! String
                     let latitude = dic1["latitude"] as! String
                     print("Longitude : \(longitude)")
                     print("latitude : \(latitude)")
                     self.ToGreenLongitude = longitude
                    self.ToGreenLatitude = latitude
                }
            }
             self.NoofPassButt.setTitle("1", for: .normal)
             self.TicketsCountStr = "1"
             //**self.CalculateQRFare()
         }
         if SJTLabelArr.count > 1 {
            SingleDownImage.isHidden = false
        }else {
            SingleDownImage.isHidden = true
        }
        if RJTLabelArr.count > 1 {
            ReturnDownImage.isHidden = false
        }else {
            ReturnDownImage.isHidden = true
        }
         if GroupLabelArr.count > 1 {
            GroupDownImage.isHidden = false
        }else {
            GroupDownImage.isHidden = true
        }
    }

    //MARK: - MX Segmented Control
    @objc func changeIndex(segmentedControl: MXSegmentedControl) {
         if segmentedControl == Segment {
            switch Segment.selectedIndex {
            case 0:
                 BookTicketBackVw.isHidden = true
                 print("Plan A Journey")
            case 1:
                 BookTicketBackVw.isHidden = false
                print("Book Ticket")
            default:
                break
            }
        }else {
            switch BookSegment.selectedIndex {
            case 0:
                print("Single Journey")
                 if QRTypeStr == "1" {
                    return
                }
                SingleJourneyVw.isHidden = false
                ReturnJourneyVw.isHidden = true
                GroupJourneyVw.isHidden = true
                 animation(viewAnimation: SingleJourneyVw)
                 print("Product_qrTicketTypeArr : \(Product_qrTicketTypeArr)")
                 let ind = Product_qrTicketTypeArr.index(of: "SJT")
                 print("ind : \(ind)")
                 ProductCodeStr = "\(Product_CodeArr[ind])"
                 //                if Product_CodeArr.count > 0
                //                {
                //                    ProductCodeStr = "\(Product_CodeArr[0])"
                //                }
                 print("ProductCodeStr : \(ProductCodeStr)")
                 QRTypeStr = "1"
                 ArbitryCodeStr = "100"
                 self.NoofPassButt.setTitle(SingleCount, for: .normal)
                 self.TicketsCountStr = "1"
                 TripsCountStr = "1"
                 if SJTLabelArr.count > 1 {
                    SingleDownImage.isHidden = false
                    
                 }else {
                    SingleDownImage.isHidden = true
                }
                 if SinglePrice != "" {
                   SinglePriceLbl.text = SinglePrice
                }
                 //**CalculateQRFare()
             case 1:
                 print("Return Journey")
                 if QRTypeStr == "2" {
                    return
                }
                 SingleJourneyVw.isHidden = true
                ReturnJourneyVw.isHidden = false
                GroupJourneyVw.isHidden = true
                
                animation(viewAnimation: ReturnJourneyVw)
                
                let ind = Product_qrTicketTypeArr.index(of: "RJT")
                
                print("ind : \(ind)")
                
                ProductCodeStr = "\(Product_CodeArr[ind])"
                
                //                if Product_CodeArr.count > 1
                //                {
                //                    ProductCodeStr = "\(Product_CodeArr[1])"
                //                }
                
                print("ProductCodeStr : \(ProductCodeStr)")
                
                QRTypeStr = "2"
                
                ArbitryCodeStr = "200"
                
                TripsCountStr = "2"
                
                if RJTFirstTime == 0
                {
                    
                }
                
                if MaxSaleNumbersDisplayed.count > 0
                {
                    ReturnNoofPassButt.setTitle(ReturnCount, for: .normal)
                    
                    TicketsCountStr = "\(MaxSaleNumbersDisplayed[0])"
                }
                
                RJTFirstTime = 1
                
                if RJTLabelArr.count > 1
                {
                    ReturnDownImage.isHidden = false
                }
                else
                {
                    ReturnDownImage.isHidden = true
                }
                
                if ReturnPrice != ""
                {
                    ReturnPriceLbl.text = ReturnPrice
                }
               
                //**CalculateQRFare()
                
            case 2:
                
                print("Group Journey")
                
                if QRTypeStr == "3"
                {
                    return
                }
                
                SingleJourneyVw.isHidden = true
                ReturnJourneyVw.isHidden = true
                GroupJourneyVw.isHidden = false
                
                animation(viewAnimation: GroupJourneyVw)
                
                let ind = Product_qrTicketTypeArr.index(of: "GROUP")
                
                print("ind : \(ind)")
                
                ProductCodeStr = "\(Product_CodeArr[ind])"
                
                //                if Product_CodeArr.count > 1
                //                {
                //                    ProductCodeStr = "\(Product_CodeArr[2])"
                //                }
                
                print("ProductCodeStr : \(ProductCodeStr)")
                
                QRTypeStr = "3"
                
                ArbitryCodeStr = "300"
                
                if GroupFirstTime == 0
                {
                }
                
                if GroupNumbersDisplayed.count > 0
                {
                    GroupNoofPassButt.setTitle(GroupCount, for: .normal)
                    
                    TicketsCountStr = "\(GroupNumbersDisplayed[0])"
                }
                
                TripsCountStr = TicketsCountStr
                
                GroupFirstTime = 1
                
                if GroupLabelArr.count > 1
                {
                    GroupDownImage.isHidden = false
                }
                else
                {
                    GroupDownImage.isHidden = true
                }
                
                if GroupPrice != ""
                {
                    GroupPriceLbl.text = GroupPrice
                }
                
                //**CalculateQRFare()
                
                
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
    
    //MARK: - Calculate QR Ticket
    
    func CalculateQRTicketSingle(Arbitry : String, QRType : String, ProdCode : String, Count : String) {
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
        
        
        let parameters1: [String: Any] = [
            "id" : Arbitry,
            "qrType" : QRType,
            "productCode" : ProdCode,
            "sourceStation1" : SourceStationIDStr,
            "destinationStation1" : DestinationStationIDStr,
            "sourceStation2" : "0",
            "destinationStation2" : "0",
            "tripsCount" : "1",
            "ticketsCount" : Count,
            "purchaseDate" : dateString,
            "issueDate" : dateString
        ]
        
      /*  if QRTypeStr == "2"
        {
            parameters1 = [
                "id" : ArbitryCodeStr,
                "qrType" : QRTypeStr,
                "productCode" : ProductCodeStr,
                "sourceStation1" : SourceStationIDStr,
                "destinationStation1" : DestinationStationIDStr,
                "sourceStation2" : DestinationStationIDStr,
                "destinationStation2" : SourceStationIDStr,
                "tripsCount" : TripsCountStr,
                "ticketsCount" : TicketsCountStr,
                "purchaseDate" : dateString,
                "issueDate" : dateString
                
            ]
        }
        
        if QRTypeStr == "3"
        {
            parameters1 = [
                "id" : ArbitryCodeStr,
                "qrType" : QRTypeStr,
                "productCode" : ProductCodeStr,
                "sourceStation1" : SourceStationIDStr,
                "destinationStation1" : DestinationStationIDStr,
                "sourceStation2" : DestinationStationIDStr,
                "destinationStation2" : SourceStationIDStr,
                "tripsCount" : TripsCountStr,
                "ticketsCount" : TicketsCountStr,
                "purchaseDate" : dateString,
                "issueDate" : dateString
                
            ]
        }
        
        */
        
        let params: [String: Any] = [
            "token" : UserData.current!.token!,
            "ticket" : parameters1,
            "clientReferenceNumber" : dateString2
        ]
        
        print("Params : \(params)")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show(withStatus: "Loading...")
        sessionManager1.request(url, method : .post, parameters : params, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            SVProgressHUD.dismiss()
            self.SinglePrice = ""
            self.SinglePriceLbl.text = "0 INR"
            
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
                                
                                if self.QRTypeStr == "1"
                                {
                                    // self.TotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                                else if self.QRTypeStr == "2"
                                {
                                    //self.ReturnTotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                                else
                                {
                                    //self.GroupTotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                            }
                            
                            /*if let basePrice = priceDetails["basePrice"] as? String
                            {
                                //self.BasePriceLbl.text = "\(basePrice) INR"
                            }
                            
                            if let coefficient = priceDetails["coefficient"] as? String
                            {
                               // self.CoefficientLbl.text = coefficient
                            }
                            */
                            if let count = priceDetails["count"] as? Int
                            {
                                //self.QuantityLbl.text = "\(count)"
                                
                                if count == 1
                                {
                                 //   self.passengerLbl.text = "1 passenger"
                                    
                                    Public_PassengerCountFailed = "1"
                                }
                                else
                                {
                                    //self.passengerLbl.text = "\(count) passengers"
                                    Public_PassengerCountFailed = "\(count)"
                                }
                            }
                            
                           /* if let roundingDifference = priceDetails["roundingDifference"] as? String
                            {
                               // self.OthersLbl.text = "\(roundingDifference) INR"
                            }
                            
                            if let tax = priceDetails["tax"] as? String
                            {
                               // self.TaxLbl.text = "\(self.forTrailingZero(temp: Double(tax)!)) INR"
                            }
                            */
                            if let totalRoundedPrice = priceDetails["totalExactPrice"] as? String
                            {
                               /* if let roundedPrice = priceDetails["roundedPrice"] as? String
                                {
                                    //self.TotalLbl.text = "\(self.QuantityLbl.text!) * \(roundedPrice) = \(totalRoundedPrice) INR"
                                }
                                */
                                //self.PriceLbl.text = "\(totalRoundedPrice) INR"
                                
                                print("totalRoundedPrice : \(totalRoundedPrice)")
                                
                                Public_PriceFailed = totalRoundedPrice
                                
                                self.SinglePrice = totalRoundedPrice
                                self.SinglePriceLbl.text = "\(totalRoundedPrice) INR"
                            }
                            
                            
                            
                        }
                        
                       /* if let expirationDate1 = dict["expirationDate"] as? String
                        {
                           // self.ExpireDateStr = expirationDate1
                        }
                        */
                        if let paymentInitializationURL = dict["paymentInitializationURL"] as? String
                        {
                            self.SinglePaymentUrl = paymentInitializationURL
                            
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
                        
                       // self.Back(self)
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
                        
                      //  self.Back(self)
                    }
                        
                    else if result == 19
                    {
                         kAppDelegate.shared.showAlert(self, message: "Business time over. Please try again.")
                        
                       // self.Back(self)
                    }
                        
                    else if result == 21
                    {
                         kAppDelegate.shared.showAlert(self, message: "Invalid product code. Please try again.")
                        
                        //self.Back(self)
                    }
                    else if result == 25
                    {
                         kAppDelegate.shared.showAlert(self, message: "Invalid request. Please try again.")
                        
                        //self.Back(self)
                    }
                    
                }
            }
            
            if self.SingleValueCheck == 0 {
                let ind = self.Product_qrTicketTypeArr.index(of: "RJT")
                
                print("Product code : \("\(self.Product_CodeArr[ind])")")
                 if UserData.current?.token != nil {
                self.CalculateQRTicketReturn(Arbitry: "200", QRType: "2", ProdCode: "\(self.Product_CodeArr[ind])", Count: "1")
                }
                 }
            else {
             }
            
            
           // self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ReviewBookingViewController.CaluculatePaymentTimer)), userInfo: nil, repeats: true)
        }
    }
    }
    
    //MARK: - Calculate QR Ticket Return
    
    func CalculateQRTicketReturn(Arbitry : String, QRType : String, ProdCode : String, Count : String) {
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
        
        
            let parameters1: [String: Any] = [
                "id" : Arbitry,
                "qrType" : QRType,
                "productCode" : ProdCode,
                "sourceStation1" : SourceStationIDStr,
                "destinationStation1" : DestinationStationIDStr,
                "sourceStation2" : DestinationStationIDStr,
                "destinationStation2" : SourceStationIDStr,
                "tripsCount" : "2",
                "ticketsCount" : Count,
                "purchaseDate" : dateString,
                "issueDate" : dateString
                
            ]
        
        if QRTypeStr == "2"
        {
        }
        
     /*   var parameters1: [String: Any] = [
            "id" : ArbitryCodeStr,
            "qrType" : QRTypeStr,
            "productCode" : ProductCodeStr,
            "sourceStation1" : SourceStationIDStr,
            "destinationStation1" : DestinationStationIDStr,
            "sourceStation2" : "0",
            "destinationStation2" : "0",
            "tripsCount" : TripsCountStr,
            "ticketsCount" : TicketsCountStr,
            "purchaseDate" : dateString,
            "issueDate" : dateString
        ]
        
       
        
        if QRTypeStr == "3"
        {
            parameters1 = [
                "id" : ArbitryCodeStr,
                "qrType" : QRTypeStr,
                "productCode" : ProductCodeStr,
                "sourceStation1" : SourceStationIDStr,
                "destinationStation1" : DestinationStationIDStr,
                "sourceStation2" : DestinationStationIDStr,
                "destinationStation2" : SourceStationIDStr,
                "tripsCount" : TripsCountStr,
                "ticketsCount" : TicketsCountStr,
                "purchaseDate" : dateString,
                "issueDate" : dateString
                
            ]
        }
       */
        let params: [String: Any] = [
            "token" : UserData.current!.token!,
            "ticket" : parameters1,
            "clientReferenceNumber" : dateString2
        ]
        
        print("Params : \(params)")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show(withStatus: "Loading...")
        sessionManager1.request(url, method : .post, parameters : params, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            SVProgressHUD.dismiss()
            self.ReturnPrice = ""
            self.ReturnPriceLbl.text = "0 INR"
            
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
                                
                                if self.QRTypeStr == "1"
                                {
                                    // self.TotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                                else if self.QRTypeStr == "2"
                                {
                                    //self.ReturnTotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                                else
                                {
                                    //self.GroupTotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                            }
                            
                           /* if let basePrice = priceDetails["basePrice"] as? String
                            {
                                //self.BasePriceLbl.text = "\(basePrice) INR"
                            }
                            
                            if let coefficient = priceDetails["coefficient"] as? String
                            {
                                // self.CoefficientLbl.text = coefficient
                            }
                            */
                            if let count = priceDetails["count"] as? Int
                            {
                                //self.QuantityLbl.text = "\(count)"
                                
                                if count == 1
                                {
                                    //   self.passengerLbl.text = "1 passenger"
                                    
                                    Public_PassengerCountFailed = "1"
                                }
                                else
                                {
                                    //self.passengerLbl.text = "\(count) passengers"
                                    Public_PassengerCountFailed = "\(count)"
                                }
                            }
                            
                           /* if let roundingDifference = priceDetails["roundingDifference"] as? String
                            {
                                // self.OthersLbl.text = "\(roundingDifference) INR"
                            }
                            
                            if let tax = priceDetails["tax"] as? String
                            {
                                // self.TaxLbl.text = "\(self.forTrailingZero(temp: Double(tax)!)) INR"
                            }
                            */
                            if let totalRoundedPrice = priceDetails["totalExactPrice"] as? String
                            {
                               /* if let roundedPrice = priceDetails["roundedPrice"] as? String
                                {
                                    //self.TotalLbl.text = "\(self.QuantityLbl.text!) * \(roundedPrice) = \(totalRoundedPrice) INR"
                                }
                                */
                                //self.PriceLbl.text = "\(totalRoundedPrice) INR"
                                
                                print("totalRoundedPrice : \(totalRoundedPrice)")
                                
                                Public_PriceFailed = totalRoundedPrice
                                
                                self.ReturnPrice = totalRoundedPrice
                                self.ReturnPriceLbl.text = "\(totalRoundedPrice) INR"
                                
                            }
                            
                            
                            
                        }
                        
                       /* if let expirationDate1 = dict["expirationDate"] as? String
                        {
                            // self.ExpireDateStr = expirationDate1
                        }
                        */
                        if let paymentInitializationURL = dict["paymentInitializationURL"] as? String
                        {
                            self.ReturnPaymentUrl = paymentInitializationURL
                            
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
                        
                        // self.Back(self)
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
                        
                        //  self.Back(self)
                    }
                        
                    else if result == 19
                    {
                         kAppDelegate.shared.showAlert(self, message: "Business time over. Please try again.")
                        
                        // self.Back(self)
                    }
                        
                    else if result == 21
                    {
                         kAppDelegate.shared.showAlert(self, message: "Invalid product code. Please try again.")
                        
                        //self.Back(self)
                    }
                    else if result == 25
                    {
                         kAppDelegate.shared.showAlert(self, message: "Invalid request. Please try again.")
                        
                        //self.Back(self)
                    }
                    
                }
            }
            
            if self.SingleValueCheck == 0 {
                if self.GroupNumbersDisplayed.count > 0 {
                    let ind = self.Product_qrTicketTypeArr.index(of: "GROUP")
                     if UserData.current?.token != nil {
                    self.CalculateQRTicketGroup(Arbitry: "300", QRType: "3", ProdCode: "\(self.Product_CodeArr[ind])", Count: "\(self.GroupNumbersDisplayed[0])")
                    }
                }
            }else {
             }
            
        
            //
            // self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ReviewBookingViewController.CaluculatePaymentTimer)), userInfo: nil, repeats: true)
        }
    }
    }
    
    //MARK: - Calculate QR Ticket Group
    
    func CalculateQRTicketGroup(Arbitry : String, QRType : String, ProdCode : String, Count : String)
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
        
        
      /*
         var parameters1: [String: Any] = [
            "id" : ArbitryCodeStr,
            "qrType" : QRTypeStr,
            "productCode" : ProductCodeStr,
            "sourceStation1" : SourceStationIDStr,
            "destinationStation1" : DestinationStationIDStr,
            "sourceStation2" : "0",
            "destinationStation2" : "0",
            "tripsCount" : TripsCountStr,
            "ticketsCount" : TicketsCountStr,
            "purchaseDate" : dateString,
            "issueDate" : dateString
        ]
        
        if QRTypeStr == "2"
        {
            parameters1 = [
                "id" : ArbitryCodeStr,
                "qrType" : QRTypeStr,
                "productCode" : ProductCodeStr,
                "sourceStation1" : SourceStationIDStr,
                "destinationStation1" : DestinationStationIDStr,
                "sourceStation2" : DestinationStationIDStr,
                "destinationStation2" : SourceStationIDStr,
                "tripsCount" : TripsCountStr,
                "ticketsCount" : TicketsCountStr,
                "purchaseDate" : dateString,
                "issueDate" : dateString
                
            ]
        }
        */
        
            let parameters1: [String: Any] = [
                "id" : Arbitry,
                "qrType" : QRType,
                "productCode" : ProdCode,
                "sourceStation1" : SourceStationIDStr,
                "destinationStation1" : DestinationStationIDStr,
                "sourceStation2" : DestinationStationIDStr,
                "destinationStation2" : SourceStationIDStr,
                "tripsCount" : Count,
                "ticketsCount" : Count,
                "purchaseDate" : dateString,
                "issueDate" : dateString
                
            ]
        
        if QRTypeStr == "3"
        {
            
        }
        
        let params: [String: Any] = [
            "token" : UserData.current!.token!,
            "ticket" : parameters1,
            "clientReferenceNumber" : dateString2
        ]
        
        print("Params : \(params)")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show(withStatus: "Loading...")
        sessionManager1.request(url, method : .post, parameters : params, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            SVProgressHUD.dismiss()
            self.GroupPrice = ""
            self.GroupPriceLbl.text = "0 INR"
            
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
                                
                                if self.QRTypeStr == "1"
                                {
                                    // self.TotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                                else if self.QRTypeStr == "2"
                                {
                                    //self.ReturnTotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                                else
                                {
                                    //self.GroupTotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                            }
                            
                           /* if let basePrice = priceDetails["basePrice"] as? String
                            {
                                //self.BasePriceLbl.text = "\(basePrice) INR"
                            }
                            
                            if let coefficient = priceDetails["coefficient"] as? String
                            {
                                // self.CoefficientLbl.text = coefficient
                            }
                            */
                            
                            if let count = priceDetails["count"] as? Int
                            {
                                //self.QuantityLbl.text = "\(count)"
                                
                                if count == 1
                                {
                                    //   self.passengerLbl.text = "1 passenger"
                                    
                                    Public_PassengerCountFailed = "1"
                                }
                                else
                                {
                                    //self.passengerLbl.text = "\(count) passengers"
                                    Public_PassengerCountFailed = "\(count)"
                                }
                            }
                            
                           /* if let roundingDifference = priceDetails["roundingDifference"] as? String
                            {
                                // self.OthersLbl.text = "\(roundingDifference) INR"
                            }*/
                            
                           /* if let tax = priceDetails["tax"] as? String
                            {
                                // self.TaxLbl.text = "\(self.forTrailingZero(temp: Double(tax)!)) INR"
                            }*/
                            
                            if let totalRoundedPrice = priceDetails["totalExactPrice"] as? String
                            {
                               /* if let roundedPrice = priceDetails["roundedPrice"] as? String
                                {
                                    //self.TotalLbl.text = "\(self.QuantityLbl.text!) * \(roundedPrice) = \(totalRoundedPrice) INR"
                                }*/
                                
                                //self.PriceLbl.text = "\(totalRoundedPrice) INR"
                                
                                print("totalRoundedPrice : \(totalRoundedPrice)")
                                
                                Public_PriceFailed = totalRoundedPrice
                                
                                self.GroupPrice = totalRoundedPrice
                                self.GroupPriceLbl.text = "\(totalRoundedPrice) INR"
                            }
                            
                        }
                        
                       /* if let expirationDate1 = dict["expirationDate"] as? String
                        {
                            // self.ExpireDateStr = expirationDate1
                        }*/
                        
                        if let paymentInitializationURL = dict["paymentInitializationURL"] as? String
                        {
                            self.GroupPaymentUrl = paymentInitializationURL
                            
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
                        
                        // self.Back(self)
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
                        
                        //  self.Back(self)
                    }
                        
                    else if result == 19
                    {
                         kAppDelegate.shared.showAlert(self, message: "Business time over. Please try again.")
                        
                        // self.Back(self)
                    }
                        
                    else if result == 21
                    {
                         kAppDelegate.shared.showAlert(self, message: "Invalid product code. Please try again.")
                        
                        //self.Back(self)
                    }
                    else if result == 25
                    {
                         kAppDelegate.shared.showAlert(self, message: "Invalid request. Please try again.")
                        
                        //self.Back(self)
                    }
                    
                }
            }
            
            // self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ReviewBookingViewController.CaluculatePaymentTimer)), userInfo: nil, repeats: true)
        }
    }
    }
    
    //MARK: - Invalid Token Logout
    
    func LogOutTokenInvalid() {
        timer.invalidate()
            kAppDelegate.shared.logoutCurrentUser { (success) in
                self.LogoutBlaceView.isHidden = true
            }
    }
    
    
    //MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tbl
        {
            if ButtCheck == 0
            {
                if SearchArr.count > 0
                {
                    return SearchArr.count
                }
                
                return self.Mobile_StationNameArr.count
            }
            else
            {
                if SearchArr.count > 0
                {
                    return SearchArr.count
                }
                
                return DestinationArr.count
            }
        }
        else if tableView == BookTicketTbl
        {
            if BookTblCheck == 1
            {
                return SJTLabelArr.count
            }
            else if BookTblCheck == 2
            {
                return MaxSaleNumbersDisplayed.count
            }
            else if BookTblCheck == 11
            {
                return RJTLabelArr.count
            }
            else if BookTblCheck == 22
            {
                return MaxSaleNumbersDisplayed.count
            }
                
            else if BookTblCheck == 111
            {
                return GroupLabelArr.count
            }
            else if BookTblCheck == 222
            {
                return GroupNumbersDisplayed.count
            }
            
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if tableView == tbl
        {
            if let lbl = cell?.viewWithTag(1) as? UILabel
            {
                if ButtCheck == 0
                {
                    if SearchArr.count > 0
                    {
                        if let str = SearchArr[indexPath.row] as? String
                        {
                            lbl.text = str
                        }
                    }
                    else
                    {
                        if let str = Mobile_StationNameArr[indexPath.row] as? String
                        {
                            lbl.text = str
                        }
                    }
                }
                else
                {
                    if SearchArr.count > 0
                    {
                        if let str = SearchArr[indexPath.row] as? String
                        {
                            lbl.text = str
                        }
                    }
                    else
                    {
                        if let str = DestinationArr[indexPath.row] as? String
                        {
                            lbl.text = str
                        }
                    }
                }
                
            }
        }
            
        else if tableView == BookTicketTbl
        {
            if let lbl = cell?.viewWithTag(1) as? UILabel
            {
                if BookTblCheck == 1
                {
                    lbl.text = "\(SJTLabelArr[indexPath.row])"
                }
                else if BookTblCheck == 2
                {
                    lbl.text = "\(MaxSaleNumbersDisplayed[indexPath.row])"
                }
                    
                else if BookTblCheck == 11
                {
                    lbl.text = "\(RJTLabelArr[indexPath.row])"
                }
                else if BookTblCheck == 22
                {
                    lbl.text = "\(MaxSaleNumbersDisplayed[indexPath.row])"
                }
                    
                else if BookTblCheck == 111
                {
                    lbl.text = "\(GroupLabelArr[indexPath.row])"
                }
                else if BookTblCheck == 222
                {
                    lbl.text = "\(GroupNumbersDisplayed[indexPath.row])"
                }
                
            }
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        
        if tableView == tbl
        {
            if ButtCheck == 0
            {
                if SearchArr.count > 0
                {
                    FromStationStr = "\(SearchArr[indexPath.row])"
                    
                    FromButt.setTitle("\(SearchArr[indexPath.row])", for: .normal)
                    
                    let ii = Mobile_StationNameArr.index(of: FromStationStr)
                    
                    SourceStationIDStr = "\(Mobile_LogicalStationIDArr[ii])"
                    
                    print("From station coordinate : \(StationLocationCordinates[ii])")
                    
                    FromStationLocation = StationLocationCordinates[ii]
                    
                    FromGreenLatitude = FromStationLocation.coordinate.latitude.dollarString
                    
                    FromGreenLongitude = FromStationLocation.coordinate.longitude.dollarString
                    
                    
                }
                else
                {
                    FromStationStr = "\(Mobile_StationNameArr[indexPath.row])"
                    
                    FromButt.setTitle("\(Mobile_StationNameArr[indexPath.row])", for: .normal)
                    
                    SourceStationIDStr = "\(Mobile_LogicalStationIDArr[indexPath.row])"
                    
                    print("From station coordinate : \(StationLocationCordinates[indexPath.row])")
                    
                    FromStationLocation = StationLocationCordinates[indexPath.row]
                    
                    FromGreenLatitude = FromStationLocation.coordinate.latitude.dollarString
                    
                    FromGreenLongitude = FromStationLocation.coordinate.longitude.dollarString
                    
                    
                }
                
                //** CalculateQRFare()
            }
            else
            {
                if SearchArr.count > 0
                {
                    ToStationStr = "\(SearchArr[indexPath.row])"
                    
                    ToButt.setTitle("\(SearchArr[indexPath.row])", for: .normal)
                    
                    let ii = Mobile_StationNameArr.index(of: ToStationStr)
                    
                    DestinationStationIDStr = "\(Mobile_LogicalStationIDArr[ii])"
                    
                    
                    
                    ToStationLocation = StationLocationCordinates[ii]
                    
                    ToGreenLatitude = ToStationLocation.coordinate.latitude.dollarString
                    
                    ToGreenLongitude = ToStationLocation.coordinate.longitude.dollarString
                    
                    
                }
                else
                {
                    ToStationStr = "\(DestinationArr[indexPath.row])"
                    
                    ToButt.setTitle("\(DestinationArr[indexPath.row])", for: .normal)
                    
                    let ii = Mobile_StationNameArr.index(of: ToStationStr)
                    
                    DestinationStationIDStr = "\(Mobile_LogicalStationIDArr[ii])"
                    
                    
                    
                    ToStationLocation = StationLocationCordinates[ii]
                    
                    ToGreenLatitude = ToStationLocation.coordinate.latitude.dollarString
                    
                    ToGreenLongitude = ToStationLocation.coordinate.longitude.dollarString
                    
                }
                
                //** CalculateQRFare()
                
            }
            
            
        }
            
        else if tableView == BookTicketTbl
        {
            
            if BookTblCheck == 1
            {
                TicketTypeButt.setTitle("\(SJTLabelArr[indexPath.row])", for: .normal)
            }
            else if BookTblCheck == 2
            {
                NoofPassButt.setTitle("\(MaxSaleNumbersDisplayed[indexPath.row])", for: .normal)
                
                TicketsCountStr = "\(MaxSaleNumbersDisplayed[indexPath.row])"
                
                SingleValueCheck = 1
                
                SingleCount = "\(MaxSaleNumbersDisplayed[indexPath.row])"
                
                let ind = self.Product_qrTicketTypeArr.index(of: "SJT")
                if UserData.current?.token != nil {
                self.CalculateQRTicketSingle(Arbitry: "100", QRType: "1", ProdCode: "\(self.Product_CodeArr[ind])", Count: "\(MaxSaleNumbersDisplayed[indexPath.row])")
                }
                //**CalculateQRFare()
            }
                
            else if BookTblCheck == 11
            {
                ReturnTicketTypeButt.setTitle("\(RJTLabelArr[indexPath.row])", for: .normal)
            }
            else if BookTblCheck == 22
            {
                ReturnNoofPassButt.setTitle("\(MaxSaleNumbersDisplayed[indexPath.row])", for: .normal)
                
                TicketsCountStr = "\(MaxSaleNumbersDisplayed[indexPath.row])"
                
                SingleValueCheck = 1
                
                ReturnCount = "\(MaxSaleNumbersDisplayed[indexPath.row])"
                
                let ind = self.Product_qrTicketTypeArr.index(of: "RJT")
                
                print("Product code : \("\(self.Product_CodeArr[ind])")")
                 if UserData.current?.token != nil {
                self.CalculateQRTicketReturn(Arbitry: "200", QRType: "2", ProdCode: "\(self.Product_CodeArr[ind])", Count: "\(MaxSaleNumbersDisplayed[indexPath.row])")
                }
                //**CalculateQRFare()
            }
                
            else if BookTblCheck == 111
            {
                GroupTicketTypeButt.setTitle("\(GroupLabelArr[indexPath.row])", for: .normal)
            }
            else if BookTblCheck == 222
            {
                GroupNoofPassButt.setTitle("\(GroupNumbersDisplayed[indexPath.row])", for: .normal)
                
                TicketsCountStr = "\(GroupNumbersDisplayed[indexPath.row])"
                
                TripsCountStr = TicketsCountStr
                
                SingleValueCheck = 1
                
                GroupCount = "\(GroupNumbersDisplayed[indexPath.row])"
                
                let ind = self.Product_qrTicketTypeArr.index(of: "GROUP")
                 if UserData.current?.token != nil {
                self.CalculateQRTicketGroup(Arbitry: "300", QRType: "3", ProdCode: "\(self.Product_CodeArr[ind])", Count: "\(self.GroupNumbersDisplayed[indexPath.row])")
                }
                //**CalculateQRFare()
            }
            
        }
        
        BookTicketTblBlackVw.isHidden = true
        
        BlackVw.isHidden = true
    }
    
    
    //MARK: - IB Actions
    
    @IBAction func FromClick(_ sender: Any) {
        
        if self.Mobile_StationNameArr.count > 0
        {
            let ChooseStationViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChooseStationViewController") as! ChooseStationViewController
            //ChooseStationViewController.StationNameArr = self.Mobile_StationNameArr
            //ChooseStationViewController.StationLogicalIDArr = self.Mobile_LogicalStationIDArr
            self.navigationController?.pushViewController(ChooseStationViewController, animated: true)
        }
        
        return
            
            
            SearchField.text = ""
        
        SearchArr = NSArray()
        
        ButtCheck = 0
        
        BlackVw.isHidden = false
        
        SourceLbl.text = "Source metro station"
        
        tbl.reloadData()
        
        SearchField.becomeFirstResponder()
    }
    
    
    @IBAction func ToClick(_ sender: Any) {
        
        if self.Mobile_StationNameArr.count > 0
        {
            let ChooseStationViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChooseStationViewController") as! ChooseStationViewController
            //ChooseStationViewController.StationNameArr = self.Mobile_StationNameArr
            //ChooseStationViewController.StationLogicalIDArr = self.Mobile_LogicalStationIDArr
            self.navigationController?.pushViewController(ChooseStationViewController, animated: true)
        }
        
        return
            
            SearchField.text = ""
        
        SearchArr = NSArray()
        
        DestinationArr.removeAllObjects()
        
        for i in Mobile_StationNameArr
        {
            if let str = i as? String
            {
                if str != FromStationStr
                {
                    DestinationArr.add(str)
                }
            }
        }
        
        ButtCheck = 1
        
        BlackVw.isHidden = false
        
        tbl.reloadData()
        
        SourceLbl.text = "Destination station"
        
        SearchField.becomeFirstResponder()
    }
    
    @IBAction func Close(_ sender: Any) {
        
        BlackVw.isHidden = true
    }
    
    
    @IBAction func TicketTypeClicked(_ sender: Any) {
        
        if SJTLabelArr.count > 1
        {
            BookTblCheck = 1
            
            BookTicketTblBlackVw.isHidden = false
            
            BookTicketTbl.reloadData()
        }
       
    }
    
    @IBAction func NoofPassClicked(_ sender: Any) {
        
        if SourceStationIDStr == "00"
        {
             kAppDelegate.shared.showAlert(self, message: "Please select source station")
        }
        else if DestinationStationIDStr == "00"
        {
             kAppDelegate.shared.showAlert(self, message: "Please select destination station")
        }
        else
        {
            BookTblCheck = 2
            
            BookTicketTblBlackVw.isHidden = false
            
            BookTicketTbl.reloadData()
        }
        
    }
    
    @IBAction func SignleBookClicked(_ sender: Any) {
        
        if UserData.current != nil {
            
            //        if TotalLbl.text == ""
            //        {
            //            return
            //        }
            
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
            
            
            
            if FromButt.titleLabel?.text == "Select Source Station"
            {
                kAppDelegate.shared.showAlert(self, message: "Please Select Source Station.")
                return
            }
            else if ToButt.titleLabel?.text == "Select Destination Station"
            {
                kAppDelegate.shared.showAlert(self, message: "Please Select Destination Station.")
                
                return
            }
            
            //        let ReviewBookingViewController1 = self.storyboard?.instantiateViewController(withIdentifier: "ReviewBookingViewController") as! ReviewBookingViewController
            //
            //        // Caluculate QR Ticket
            //
            //        ReviewBookingViewController1.Review_ArbitryCodeStr = self.ArbitryCodeStr
            //        ReviewBookingViewController1.Review_QRTypeStr = self.QRTypeStr
            //        ReviewBookingViewController1.Review_ProductCodeStr = self.ProductCodeStr
            //        ReviewBookingViewController1.Review_SourceStationIDStr = self.SourceStationIDStr
            //        ReviewBookingViewController1.Review_DestinationStationIDStr = self.DestinationStationIDStr
            //        ReviewBookingViewController1.Review_TripsCountStr = self.TripsCountStr
            //        ReviewBookingViewController1.Review_TicketsCountStr = self.TicketsCountStr
            //
            //
            //        //        ReviewBookingViewController1.DetailsDict = DetailsDictionary
            //
            //        ReviewBookingViewController1.SourceStation = FromStationStr
            //        ReviewBookingViewController1.DestinationStation = ToStationStr
            //        // ReviewBookingViewController1.DateStr = DateStr
            //        ReviewBookingViewController1.ExpireDateStr = ExpireDateStr
            //        ReviewBookingViewController1.ValidityMinuteInt = 30
            //        //  ReviewBookingViewController1.TimerSec = TimerSecond
            //
            //
            //        self.navigationController?.pushViewController(ReviewBookingViewController1, animated: true)
            
            if self.SinglePriceLbl.text == "0 INR"
            {
                return
            }
            
            Public_PassengerCountFailed = SingleCount
            
            Public_PriceFailed = SinglePrice
            
            PublicPaymentURL = SinglePaymentUrl
            
            Public_TimeBookedFailed = DateStr
            
            let cc = self.storyboard?.instantiateViewController(withIdentifier: "WebPaymentViewController")
            self.navigationController?.pushViewController(cc!, animated: true)
        }else {
            kAppDelegate.shared.showAlert(self, title: Alert.kTitle, message: Alert.kLoginMessage) { (success) in
                if success  {
                    let landingVC = kStoryBoard.instantiateViewController(withIdentifier: StoryBoardIds.kLandingVC) as! LandingViewController
                    self.navigationController?.pushViewController(landingVC, animated: true)
                }
            }
        }
    }
    
    ///////////////////////
    @IBAction func ReturnTicketTypeClicked(_ sender: Any) {
        if RJTLabelArr.count > 1 {
            BookTblCheck = 11
            BookTicketTblBlackVw.isHidden = false
            BookTicketTbl.reloadData()
        }
    }
    
    @IBAction func ReturnNoofPassClicked(_ sender: Any) {
         if SourceStationIDStr == "00" {
             kAppDelegate.shared.showAlert(self, message: "Please select source station")
        }else if DestinationStationIDStr == "00" {
             kAppDelegate.shared.showAlert(self, message: "Please select destination station")
        }else {
             BookTblCheck = 22
             BookTicketTblBlackVw.isHidden = false
             BookTicketTbl.reloadData()
         }
    }
    
    @IBAction func ReturnBookClicked(_ sender: Any) {
         if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }else {
            print("No internet.")
            InternetBlackView.isHidden = false
             return
        }
        
        if FromButt.titleLabel?.text == "Select Source Station" {
             kAppDelegate.shared.showAlert(self, message: "Please Select Source Station.")
            return
        }else if ToButt.titleLabel?.text == "Select Destination Station" {
             kAppDelegate.shared.showAlert(self, message: "Please Select Destination Station.")
             return
        }
        
//        let ReviewBookingViewController1 = self.storyboard?.instantiateViewController(withIdentifier: "ReviewBookingViewController") as! ReviewBookingViewController
//
//        ReviewBookingViewController1.Review_ArbitryCodeStr = self.ArbitryCodeStr
//        ReviewBookingViewController1.Review_QRTypeStr = self.QRTypeStr
//        ReviewBookingViewController1.Review_ProductCodeStr = self.ProductCodeStr
//        ReviewBookingViewController1.Review_SourceStationIDStr = self.SourceStationIDStr
//        ReviewBookingViewController1.Review_DestinationStationIDStr = self.DestinationStationIDStr
//        ReviewBookingViewController1.Review_TripsCountStr = self.TripsCountStr
//        ReviewBookingViewController1.Review_TicketsCountStr = self.TicketsCountStr
//
//        // ReviewBookingViewController1.DetailsDict = DetailsDictionary
//
//        ReviewBookingViewController1.SourceStation = FromStationStr
//        ReviewBookingViewController1.DestinationStation = ToStationStr
//        //ReviewBookingViewController1.DateStr = DateStr
//        ReviewBookingViewController1.ExpireDateStr = ExpireDateStr
//        ReviewBookingViewController1.ValidityMinuteInt = 35
//        //ReviewBookingViewController1.TimerSec = TimerSecond
//
//
//        self.navigationController?.pushViewController(ReviewBookingViewController1, animated: true)
        
        if self.ReturnPriceLbl.text == "0 INR" {
            return
        }
         if UserData.current != nil {
        Public_PassengerCountFailed = ReturnCount
         Public_PriceFailed = ReturnPrice
         PublicPaymentURL = ReturnPaymentUrl
         Public_TimeBookedFailed = DateStr
         let cc = self.storyboard?.instantiateViewController(withIdentifier: "WebPaymentViewController")
        self.navigationController?.pushViewController(cc!, animated: true)
        }else {
            kAppDelegate.shared.showAlert(self, title: Alert.kTitle, message: Alert.kLoginMessage) { (success) in
                if success  {
                    let landingVC = kStoryBoard.instantiateViewController(withIdentifier: StoryBoardIds.kLandingVC) as! LandingViewController
                    self.navigationController?.pushViewController(landingVC, animated: true)
                }
            }
        }
        
    }
    
    @IBAction func GroupTicketTypeClicked(_ sender: Any) {
         if GroupLabelArr.count > 1 {
            BookTblCheck = 111
             BookTicketTblBlackVw.isHidden = false
             BookTicketTbl.reloadData()
        }
    }
    
    @IBAction func GroupNoofPassClicked(_ sender: Any) {
        if SourceStationIDStr == "00" {
             kAppDelegate.shared.showAlert(self, message: "Please select source station")
        }else if DestinationStationIDStr == "00" {
             kAppDelegate.shared.showAlert(self, message: "Please select destination station")
        }else {
            BookTblCheck = 222
            BookTicketTblBlackVw.isHidden = false
            BookTicketTbl.reloadData()
        }
    }
    
    @IBAction func SlideUpBookClicked(_ sender: Any) {
        Segment.select(index: 1, animated: true)
        
        /*
         
         if QRTypeStr == "1"
         {
         
         if TotalLbl.text == ""
         {
         return
         }
         
         let ReviewBookingViewController1 = self.storyboard?.instantiateViewController(withIdentifier: "ReviewBookingViewController") as! ReviewBookingViewController
         
         ReviewBookingViewController1.DetailsDict = DetailsDictionary
         
         ReviewBookingViewController1.SourceStation = FromStationStr
         ReviewBookingViewController1.DestinationStation = ToStationStr
         ReviewBookingViewController1.DateStr = DateStr
         ReviewBookingViewController1.ExpireDateStr = ExpireDateStr
         ReviewBookingViewController1.ValidityMinuteInt = 30
         
         
         //Buy QR ticket
         
         ReviewBookingViewController1.Buy_ArbitryID = ArbitryCodeStr
         ReviewBookingViewController1.Buy_QRType = QRTypeStr
         ReviewBookingViewController1.Buy_ProductCode = ProductCodeStr
         ReviewBookingViewController1.Buy_SorceStationID = SourceStationIDStr
         ReviewBookingViewController1.Buy_DestinationStationID = DestinationStationIDStr
         ReviewBookingViewController1.Buy_TripsCount = TripsCountStr
         ReviewBookingViewController1.Buy_TicketsCount = TicketsCountStr
         
         self.navigationController?.pushViewController(ReviewBookingViewController1, animated: true)
         }
         else if QRTypeStr == "2"
         {
         
         if ReturnTotalLbl.text == ""
         {
         return
         }
         
         let ReviewBookingViewController1 = self.storyboard?.instantiateViewController(withIdentifier: "ReviewBookingViewController") as! ReviewBookingViewController
         
         ReviewBookingViewController1.DetailsDict = DetailsDictionary
         
         ReviewBookingViewController1.SourceStation = FromStationStr
         ReviewBookingViewController1.DestinationStation = ToStationStr
         ReviewBookingViewController1.DateStr = DateStr
         ReviewBookingViewController1.ExpireDateStr = ExpireDateStr
         ReviewBookingViewController1.ValidityMinuteInt = 35
         
         //Buy QR ticket
         
         ReviewBookingViewController1.Buy_ArbitryID = ArbitryCodeStr
         ReviewBookingViewController1.Buy_QRType = QRTypeStr
         ReviewBookingViewController1.Buy_ProductCode = ProductCodeStr
         ReviewBookingViewController1.Buy_SorceStationID = SourceStationIDStr
         ReviewBookingViewController1.Buy_DestinationStationID = DestinationStationIDStr
         ReviewBookingViewController1.Buy_TripsCount = TripsCountStr
         ReviewBookingViewController1.Buy_TicketsCount = TicketsCountStr
         
         
         self.navigationController?.pushViewController(ReviewBookingViewController1, animated: true)
         
         }
         else
         {
         
         if GroupTotalLbl.text == ""
         {
         return
         }
         
         let ReviewBookingViewController1 = self.storyboard?.instantiateViewController(withIdentifier: "ReviewBookingViewController") as! ReviewBookingViewController
         
         ReviewBookingViewController1.DetailsDict = DetailsDictionary
         
         ReviewBookingViewController1.SourceStation = FromStationStr
         ReviewBookingViewController1.DestinationStation = ToStationStr
         ReviewBookingViewController1.DateStr = DateStr
         ReviewBookingViewController1.ExpireDateStr = ExpireDateStr
         ReviewBookingViewController1.ValidityMinuteInt = 35
         
         
         //Buy QR ticket
         
         ReviewBookingViewController1.Buy_ArbitryID = ArbitryCodeStr
         ReviewBookingViewController1.Buy_QRType = QRTypeStr
         ReviewBookingViewController1.Buy_ProductCode = ProductCodeStr
         ReviewBookingViewController1.Buy_SorceStationID = SourceStationIDStr
         ReviewBookingViewController1.Buy_DestinationStationID = DestinationStationIDStr
         ReviewBookingViewController1.Buy_TripsCount = TripsCountStr
         ReviewBookingViewController1.Buy_TicketsCount = TicketsCountStr
         
         
         self.navigationController?.pushViewController(ReviewBookingViewController1, animated: true)
         }
         
         */
    }
    
    @IBAction func GroupBookClicked(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }else {
            print("No internet.")
            InternetBlackView.isHidden = false
            return
        }
        
        if FromButt.titleLabel?.text == "Select Source Station" {
             kAppDelegate.shared.showAlert(self, message: "Please Select Source Station.")
            return
        }else if ToButt.titleLabel?.text == "Select Destination Station" {
             kAppDelegate.shared.showAlert(self, message: "Please Select Destination Station.")
            
            return
        }
        
//        let ReviewBookingViewController1 = self.storyboard?.instantiateViewController(withIdentifier: "ReviewBookingViewController") as! ReviewBookingViewController
//
//        //  ReviewBookingViewController1.DetailsDict = DetailsDictionary
//        ReviewBookingViewController1.Review_ArbitryCodeStr = self.ArbitryCodeStr
//        ReviewBookingViewController1.Review_QRTypeStr = self.QRTypeStr
//        ReviewBookingViewController1.Review_ProductCodeStr = self.ProductCodeStr
//        ReviewBookingViewController1.Review_SourceStationIDStr = self.SourceStationIDStr
//        ReviewBookingViewController1.Review_DestinationStationIDStr = self.DestinationStationIDStr
//        ReviewBookingViewController1.Review_TripsCountStr = self.TripsCountStr
//        ReviewBookingViewController1.Review_TicketsCountStr = self.TicketsCountStr
//
//        ReviewBookingViewController1.SourceStation = FromStationStr
//        ReviewBookingViewController1.DestinationStation = ToStationStr
//        // ReviewBookingViewController1.DateStr = DateStr
//        ReviewBookingViewController1.ExpireDateStr = ExpireDateStr
//        ReviewBookingViewController1.ValidityMinuteInt = 35
//        //  ReviewBookingViewController1.TimerSec = TimerSecond
//
//        self.navigationController?.pushViewController(ReviewBookingViewController1, animated: true)
         if UserData.current != nil {
        if self.GroupPriceLbl.text == "0 INR" {
            return
        }
         Public_PassengerCountFailed = GroupCount
         Public_PriceFailed = GroupPrice
         PublicPaymentURL = GroupPaymentUrl
         Public_TimeBookedFailed = DateStr
         let cc = self.storyboard?.instantiateViewController(withIdentifier: "WebPaymentViewController")
        self.navigationController?.pushViewController(cc!, animated: true)
         }else {
            kAppDelegate.shared.showAlert(self, title: Alert.kTitle, message: Alert.kLoginMessage) { (success) in
                if success  {
                    let landingVC = kStoryBoard.instantiateViewController(withIdentifier: StoryBoardIds.kLandingVC) as! LandingViewController
                    self.navigationController?.pushViewController(landingVC, animated: true)
                }
            }
        }
    }
    
    @IBAction func HideBookTblBlackVw(_ sender: Any) {
         BookTicketTblBlackVw.isHidden = true
     }
    
    @IBAction func InternetOK(_ sender: Any) {
         InternetBlackView.isHidden = true
    }
    
    
    @IBAction func SwapClick(_ sender: Any) {
        
//        if FromButt.titleLabel?.text == "Select Source Station"
//        {
//             kAppDelegate.shared.showAlert(self, message: "Please Select Source Station.")
//            return
//        }
//        else if ToButt.titleLabel?.text == "Select Destination Station"
//        {
//             kAppDelegate.shared.showAlert(self, message: "Please Select Destination Station.")
//
//            return
//        }
//
//
//
//        let source = self.FromStationStr
//
//        let Dest = self.ToStationStr
//
//        let SorceID = self.SourceStationIDStr
//
//        let DestID = self.DestinationStationIDStr
//
//        self.FromStationStr = Dest
//
//        self.SourceStationIDStr = DestID
//
//        self.ToStationStr = source
//
//        self.DestinationStationIDStr = SorceID
//
//        Public_SourceStationName = self.FromStationStr
//        Public_SourceStationIDs = self.SourceStationIDStr
//
//        Public_DestinationStationName = self.ToStationStr
//        Public_DestinationStationIDs = self.DestinationStationIDStr
        
        Public_SourceStationName = ""
        Public_DestinationStationName = ""
         self.FromStationStr = ""
        self.ToStationStr = ""
         self.FromButt.setTitle("Select Source Station", for: .normal)
         self.ToButt.setTitle("Select Destination Station", for: .normal)
         SinglePriceLbl.text = "0 INR"
        ReturnPriceLbl.text = "0 INR"
        GroupPriceLbl.text = "0 INR"
         SinglePrice = ""
        ReturnPrice = ""
        GroupPrice = ""
    }
    
    
    //MARK: - Change values
     @objc func ChangeValues() {
        let searchPredicate = NSPredicate(format: "SELF BEGINSWITH[c] %@", SearchField.text!)
         SearchArr = (self.Mobile_StationNameArr as NSArray).filtered(using: searchPredicate) as NSArray
         tbl.reloadData()
    }
    
    //MARK: - Calculate QR Fare
    func CalculateQRFare() {
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
 
            var parameters1: [String: Any] = ["id" : ArbitryCodeStr, "qrType" : QRTypeStr, "productCode" : ProductCodeStr, "sourceStation1" : SourceStationIDStr, "destinationStation1" : DestinationStationIDStr, "sourceStation2" : "0", "destinationStation2" : "0", "tripsCount" : TripsCountStr, "ticketsCount" : TicketsCountStr, "purchaseDate" : dateString, "issueDate" : dateString]
            
            if QRTypeStr == "2" {
                parameters1 = ["id" : ArbitryCodeStr, "qrType" : QRTypeStr, "productCode" : ProductCodeStr, "sourceStation1" : SourceStationIDStr, "destinationStation1" : DestinationStationIDStr, "sourceStation2" : DestinationStationIDStr, "destinationStation2" : SourceStationIDStr, "tripsCount" : TripsCountStr, "ticketsCount" : TicketsCountStr, "purchaseDate" : dateString, "issueDate" : dateString]
            }
            
            if QRTypeStr == "3" {
                parameters1 = [ "id" : ArbitryCodeStr, "qrType" : QRTypeStr, "productCode" : ProductCodeStr, "sourceStation1" : SourceStationIDStr, "destinationStation1" : DestinationStationIDStr,"sourceStation2" : DestinationStationIDStr, "destinationStation2" : SourceStationIDStr, "tripsCount" : TripsCountStr, "ticketsCount" : TicketsCountStr, "purchaseDate" : dateString, "issueDate" : dateString ]
            }
            
            let params: [String: Any] = ["token" : UserData.current!.token!, "ticket" : parameters1, "clientReferenceNumber" : dateString2]
            
            print("Params : \(params)")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show(withStatus: "Loading...")
            sessionManager1.request(url, method : .post, parameters : params, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                if let dict = dataResponse.result.value as? NSDictionary {
                    SVProgressHUD.dismiss()
                    print("Details : \(dict)")
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
                                UserDefaults.standard.synchronize()
                            }
                            
                            if let priceDetails = dict["priceDetails"] as? NSDictionary {
                                if let totalRoundedPrice = priceDetails["totalRoundedPrice"] as? String {
                                    print("totalRoundedPrice : \(totalRoundedPrice)")
                                    if self.QRTypeStr == "1" {
                                        //self.TotalLbl.text = "\(totalRoundedPrice) INR"
                                    }else if self.QRTypeStr == "2" {
                                        //self.ReturnTotalLbl.text = "\(totalRoundedPrice) INR"
                                    }else {
                                        // self.GroupTotalLbl.text = "\(totalRoundedPrice) INR"
                                    }
                                }
                                
                                self.DetailsDictionary = priceDetails
                            }
                             if let expirationDate1 = dict["expirationDate"] as? String {
                                self.ExpireDateStr = expirationDate1
                            }
                             if let paymentInitializationURL = dict["paymentInitializationURL"] as? String {
                                PublicPaymentURL = paymentInitializationURL
                                
                                self.TimerSecond = 59
                            }
                        }
                     }
                }
              }
        }
    }
    
    var timer           = Timer()
    var TimerSecond     = 60
    
    @objc func CaluculatePaymentTimer() {
        if TimerSecond == 0 {
        }else {
            TimerSecond -= 1
        }
    }
    
    @objc func ToLogOut() {
        LogoutBlaceView.isHidden = false
    }
    
    @IBAction func LogOutClicked(_ sender: Any) {
         ConditionsBlackVw.isHidden = false
      }
    
    @IBAction func HideConditionsVw(_ sender: Any) {
         ConditionsBlackVw.isHidden = true
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
    
    @IBAction func Back(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     }
    
    //MARK: - Ticket History
    
    func GetLastTicket() {
        if UserData.current?.token != nil {
        let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        let url = "\(APILink)ticket/get-last-ticket" //ticketHistory
        
        let parameters: [String: Any] = [
            "token" : UserData.current!.token!,
            ]
 
        sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
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
                        if let Last = dict["lastTicketSerial"] as? Int {
                            print("Last ticket no: \(Last)")
                             if self.AlreadySavedData.count > 0 {
                                if let arr1 = self.AlreadySavedData.value(forKey: "ticketSerial") as? NSArray {
                                    if let arr2 = arr1.object(at: 0) as? NSArray {
                                        if arr2.count > 0 {
                                            if let Saved = ((self.AlreadySavedData.value(forKey: "ticketSerial") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as? Int {
                                                print("Last Saved ticket no: \(Saved)")
                                                
                                                if Saved != Last {
                                                    print("Not Match")
                                                    
                                                    self.TocketHistory()
                                                }else {
                                                    print("Match")
                                                }
                                            }
                                        }else {
                                            self.TocketHistory()
                                        }
                                    }else {
                                        self.TocketHistory()
                                    }
                                }else {
                                    self.TocketHistory()
                                }
                            }else {
                                self.TocketHistory()
                            }
                            
                        }
                    }
                }
                
            }
            
        }
    }
    }
    
    func TocketHistory() {
        if UserData.current?.token != nil {
        let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        let url = "\(APILink)ticketHistory"
        
        let parameters: [String: Any] = [
            "token" : UserData.current!.token!,
            ]
 
        sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
             if let dict = dataResponse.result.value as? NSDictionary {
                print("Ticket history : \(dict)")
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
                            self.TicketsArr = arr
                        }
                    }
                }
             }
             if self.TicketsArr.count > 0 {
                self.save(arr: self.TicketsArr)
            }
        }
    }
    }
    
    //MARK: - My Tickets Count
    
    var MyTicketsCountArr = NSArray()
    
    var TicketMutableArr2 = NSMutableArray()
    
    var TicketMutableArrYesterday = NSMutableArray()
    
    var TicketMutableArr = NSMutableArray()
    
    func CheckMyTicketsCount() {
        if AlreadySavedData.count > 0 {
            MyTicketsCountArr = AlreadySavedData.object(at: 0) as! NSArray
        }
        
        for i in MyTicketsCountArr {
            let dic = i as! NSDictionary
            if let qrTicketStatus = dic["qrTicketStatus"] as? String {
                if qrTicketStatus == "UNUSED" {
                    TicketMutableArr2.add(dic)
                     // TicketMutableArr.add(dic)
                }
            }
        }
 
        for j in TicketMutableArr2 {
            let dic = j as! NSDictionary
            if let expirationDate = dic["expirationDate"] as? String {
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyyMMddHHmmss"
                let showDate = inputFormatter.date(from: "\(expirationDate)")
                 inputFormatter.dateFormat = "yyyy-MM-dd"
                 inputFormatter.dateStyle = .long
                 inputFormatter.timeStyle = .medium
                 if  Calendar.current.isDateInToday(showDate!) {
                    TicketMutableArrYesterday.add(dic)
                }
            }
        }
         ExpireActions()
    }

    //MARK: - Expire Actions
     func ExpireActions() {
        TicketMutableArr.removeAllObjects()
         for j in TicketMutableArrYesterday {
            let dic = j as! NSDictionary
             let ExpireDate = dic["expirationDate"] as! String
             let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyyMMddHHmmss"
            let showDate = inputFormatter.date(from: "\(ExpireDate)")
             inputFormatter.dateFormat = "HH:mm:ss"
             let resultString = inputFormatter.string(from: showDate!)
             print("Expirey date : \(resultString)")
             print("Minutes : \(Date().minutes(from: showDate!))")
             print("Seconds : \(Date().seconds(from: showDate!))")
             let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Date().seconds(from: showDate!))
            print("Hour : \(h), Minutes : \(m), Seonds : \(s)")
             if m < 0 || s < 0 {
                print("Still Running")
                 TicketMutableArr.add(dic)
            }else {
                print("Expired")
            }
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    //MARK: - Core Data
    
    func save(arr : NSArray) {
         deleteAllRecords()
         let StatusDict = NSMutableDictionary()
         for dic in arr {
            if let dd = dic as? NSDictionary {
                if let ticketSerial = dd["ticketSerial"] as? Int {
                    if let qrTicketStatus = dd["qrTicketStatus"] as? String {
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
     }
    
    func ReadData() {
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
        
        if statusData.count > 0 {
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

extension Double {
    var dollarString:String {
        return String(format: "%.6f", self)
    }
}
