//
//  ViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 20/07/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit

import Alamofire

import GoogleMaps

import CoreLocation

import MapKit

import CoreData

var PublicLogicalStationIDDict = NSMutableDictionary()

var PublicPaymentURL = String()

var PublicCalculateQRAgain = Int()

class ViewController: UIViewController, GMSMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager = CLLocationManager()
    
    @IBOutlet var Segment: MXSegmentedControl!
    
    @IBOutlet var Mapiew: GMSMapView!

    
    
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
    
    @IBOutlet var BlackVw: UIView!
    
    @IBOutlet var tbl: UITableView!
    
    @IBOutlet var FromButt: UIButton!
    
    @IBOutlet var ToButt: UIButton!
    
    var ButtCheck = 0
    
    var FromStationStr = String()
    
    var ToStationStr = String()
    
    @IBOutlet var MapBackView: UIView!
    
    @IBOutlet var SearchField: UITextField!
    
    var SearchArr = NSArray()
    
    @IBOutlet var SourceLbl: UILabel!
    
    var DestinationArr = NSMutableArray()
    
    @IBOutlet var BookTicketBackVw: UIView!
    
    //@IBOutlet var BookSegment: MXSegmentedControl!
    
    @IBOutlet var SingleJourneyVw: UIView!
    
    
    @IBOutlet var TimeLbl: UILabel!
    
    @IBOutlet var TicketTypeButt: UIButton!
    
    @IBOutlet var NoofPassButt: UIButton!
    
    @IBOutlet var TotalLbl: UILabel!
    
    @IBOutlet var SignleBookButt: UIButton!
    
    
    @IBOutlet var BookTicketTblBlackVw: UIView!
    
    @IBOutlet var BookTicketTbl: UITableView!
    
    var MaxSaleQR = Int()
    
    var MaxGroupNum = Int()
    
    var MinGroupNum = Int()
    
    var MaxSaleNumbersDisplayed = [Int]()
    
    var GroupNumbersDisplayed = [Int]()
    
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
    
    @IBOutlet var slideUpView: UIView!
    
    @IBOutlet var HidingStartStationLbl: UILabel!
    
    @IBOutlet var HidingDestinationStationLbl: UILabel!
    
    @IBOutlet var HidingStopsLbl: UILabel!
    
    @IBOutlet var HidingStartStationLbl2: UILabel!
    
    @IBOutlet var HidingDestinationStationLbl2: UILabel!
    
    @IBOutlet var HidingStartStationLbl3: UILabel!
    
    @IBOutlet var HidingDestinationStationLbl3: UILabel!
    
    var SlideViewCenterY = CGFloat()
    
    @IBOutlet var SlideUpBookButt: UIButton!
    
    var UserCurrentLocation = CLLocation()
    
    var StationLocationCordinates = [CLLocation]()
    
    @IBOutlet var LogoutBlaceView: UIView!
    
    
    var people: [NSManagedObject] = []
    
    var TicketsArr = NSArray()
    
    var AlreadySavedData = NSArray()
    
    @IBOutlet var SlideStopLbl: UILabel!
    
    
    var SJTLabelArr = NSMutableArray()
    
    var RJTLabelArr = NSMutableArray()
    
    var GroupLabelArr = NSMutableArray()
    
    //MARK: - New Nagpur
    
    @IBOutlet var RechargeBackView: UIView!
    
    @IBOutlet var Recharge_Lbl1: UILabel!
    
    @IBOutlet var KYCView: UIView!
    
    //MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        Segment.append(title: "PLAN A JOURNEY")
//        Segment.append(title: "BOOK TICKET")
        
        Segment.append(title: "BUY & RECHARGE").set(image: #imageLiteral(resourceName: "PlanBlackImage")).set(image: .top).set(padding: 10).set(image: #imageLiteral(resourceName: "PlanImage"), for: .selected)
        
        Segment.append(title: "PLAN A JOURNEY").set(image: #imageLiteral(resourceName: "BookBlackImage")).set(image: .top).set(padding: 10).set(image: #imageLiteral(resourceName: "BookImage"), for: .selected)

        Segment.textColor = .black
        
        Segment.backgroundColor = UIColor.orange//hexStr(hexStr: "#CC7454", alpha: 1)
        
        Segment.indicatorColor = UIColor.white// UIColor.hexStr(hexStr: "#CC7454", alpha: 1)
        
        Segment.selectedTextColor = UIColor.white// UIColor.hexStr(hexStr: "#CC7454", alpha: 1)
        
        Segment.addTarget(self, action: #selector(changeIndex(segmentedControl:)), for: .valueChanged)
        
        Segment.font = UIFont(name: "Montserrat-Regular", size: 13)!
        
       // Segment.select(index: 1, animated: false)
        
        ///////// *********** BOOKING SEGMENT
    /*
        BookSegment.append(title: "SINGLE JOURNEY").set(image: #imageLiteral(resourceName: "ArrowBlack")).set(image: .top).set(padding: 10).set(image: #imageLiteral(resourceName: "ArrowGreen"), for: .selected)
        
        BookSegment.append(title: "RETURN JOURNEY").set(image: #imageLiteral(resourceName: "DoubleArrowBlack")).set(image: .top).set(padding: 10).set(image: #imageLiteral(resourceName: "DoubleArrowGreen"), for: .selected)
        
        BookSegment.append(title: "GROUP JOURNEY").set(image: #imageLiteral(resourceName: "GroupBlack")).set(image: .top).set(padding: 10).set(image: #imageLiteral(resourceName: "GroupGreen"), for: .selected)
        
        BookSegment.textColor = .lightGray
        
        BookSegment.indicatorColor = UIColor.hexStr(hexStr: "#33BB9A", alpha: 1)
        
        BookSegment.selectedTextColor = UIColor.hexStr(hexStr: "#33BB9A", alpha: 1)
        
        BookSegment.addTarget(self, action: #selector(changeIndex(segmentedControl:)), for: .valueChanged)
        
        BookSegment.font = UIFont(name: "Montserrat-Regular", size: 12)!
        
        BookSegment.DropShadow()
        
    */
        
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
        
       // Mapiew.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        
        Mapiew.isMyLocationEnabled = true
        
        SearchField.addTarget(self, action: #selector(ViewController.ChangeValues), for: .editingChanged)
        
        let _ = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.ShowTime)), userInfo: nil, repeats: true)
        
        
        
//        SignleBookButt.Shadow()
//        ReturnBookButt.Shadow()
//        GroupBookButt.Shadow()
     //   SlideUpBookButt.Shadow()
        
        
        
       // BookTicketBackVw.isHidden = false
        
        BlackVw.isHidden = true
        
        BookTicketTblBlackVw.isHidden = true
        
       // ReturnJourneyVw.isHidden = true
        
       // GroupJourneyVw.isHidden = true
        
        LogoutBlaceView.isHidden = true
        
        PublicPaymentURL = "0"
        
        PublicCalculateQRAgain = 0
        
        BackOffice()
        
        ///////////***************** GUESTURE
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.wasDragged(gestureRecognizer:)))
        slideUpView.addGestureRecognizer(gesture)
        slideUpView.isUserInteractionEnabled = true
        gesture.delegate = self
        
        SlideViewCenterY = slideUpView.center.y
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.CaluculatePaymentTimer)), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        MapBackView.isHidden = true
        
        
        //MARK: - Nagpur
        
        Recharge_Lbl1.frame.origin.y = 1
        
        KYCView.layer.borderWidth = 2
        KYCView.layer.borderColor = UIColor.gray.cgColor
        KYCView.layer.cornerRadius = 5
        KYCView.clipsToBounds = true
        
    }
    
    //MARK: - Current Location
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        UserCurrentLocation = manager.location!
        
        
        
        var locationMarker1: GMSMarker!
        
        let aaa = CLLocationCoordinate2D(latitude : UserCurrentLocation.coordinate.latitude, longitude: UserCurrentLocation.coordinate.longitude)
        
        locationMarker1 = GMSMarker(position: aaa)
        locationMarker1.map = Mapiew
        
        locationMarker1.title = "My Position"
        locationMarker1.appearAnimation = .pop
        
        locationMarker1.isFlat = true
        // locationMarker2.snippet = "Its my destination point"
        
        locationMarker1.icon = GMSMarker.markerImage(with: randomColor())
        locationMarker1.opacity = 1
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
       AlreadySavedData =  kAppDelegate.shared.ReadFromCoreData()
        TimerSecond = 60
        if PublicCalculateQRAgain == 1 {
            //**CalculateQRFare()
        }
        
        slideUpView.frame.origin.y = MapBackView.frame.height - 60
        slideUpView.isHidden = true
        
        if Public_SourceStationName != ""
        {
            FromButt.setTitle(Public_SourceStationName, for: .normal)
            ToButt.setTitle(Public_DestinationStationName, for: .normal)
            
            self.FromStationStr = Public_SourceStationName
            self.ToStationStr = Public_DestinationStationName
            
            self.TicketsCountStr = "1"
            
            self.HidingStartStationLbl.text = self.FromStationStr
            self.HidingStartStationLbl2.text = self.FromStationStr
            self.HidingStartStationLbl3.text = self.FromStationStr
            
            self.HidingDestinationStationLbl.text = self.ToStationStr
            self.HidingDestinationStationLbl2.text = self.ToStationStr
            self.HidingDestinationStationLbl3.text = self.ToStationStr
            
            slideUpView.isHidden = false
            
            let ii = Mobile_StationNameArr.index(of: ToStationStr)
            
            DestinationStationIDStr = "\(Mobile_LogicalStationIDArr[ii])"
            
            PointToCordinate(value: ii)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("MyTicket"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ToProfile"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ToHistory"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ToChangePass"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ToLogOut"), object: nil)
    }
    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began || gestureRecognizer.state == UIGestureRecognizerState.changed {
            let translation = gestureRecognizer.translation(in: self.view)
            
            
            
            print(gestureRecognizer.view!.center.y)
            
            
            if(gestureRecognizer.view!.center.y < SlideViewCenterY) {
                
                //  print("UP")
                
                gestureRecognizer.view!.center = CGPoint(x : gestureRecognizer.view!.center.x, y: gestureRecognizer.view!.center.y + translation.y)
                
                
            }else {
                //   print("Down")
            
                gestureRecognizer.view!.center = CGPoint(x : gestureRecognizer.view!.center.x, y:  gestureRecognizer.view!.center.y + translation.y)
               
            }
            
            gestureRecognizer.setTranslation(CGPoint(x : 0,y: 0), in: self.view)
        }
        
        //        self.view.bringSubview(toFront: slideUpView)
        //        let translation = gestureRecognizer.translation(in: self.view)
        //        slideUpView.center = CGPoint(x: slideUpView.center.x + translation.x, y: slideUpView.center.y + translation.y)
        //        gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if gestureRecognizer.state == .ended
        {
            if(gestureRecognizer.view!.center.y < SlideViewCenterY)
            {
                
                SlideViewCenterY = gestureRecognizer.view!.center.y
                
                slideUpView.frame.origin.y = MapBackView.frame.height - slideUpView.frame.height // self.view.frame.height - slideUpView.frame.height
            }
            else
            {
                
                SlideViewCenterY = gestureRecognizer.view!.center.y
                
                slideUpView.frame.origin.y = MapBackView.frame.height - 60 //self.view.frame.height - 100
            }
            
        }
        
    }
    
    @objc func ShowTime() {
        let now = Date()
        
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        
        //formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        formatter.dateFormat = "HH : mm : ss"
        
        formatter.timeStyle = .medium
        
        let dateString = formatter.string(from: now)
        print(dateString)
        
       // TimeLbl.text = dateString
        
        //ReturnTimeLbl.text = dateString
        
        //GroupTimeLbl.text = dateString
    }
    
    //MARK: - Back Office
    
    func BackOffice() {
        if UserData.current?.token != nil {
 
        let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        let url = "\(APILink)backOfficeInfo"
        
        let parameters: [String: Any] = [
            "token" : UserData.current!.token!
        ]
        
       // print(parameters)
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show(withStatus: "Loading...")
        Alamofire.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            SVProgressHUD.dismiss()
            
            if let dict = dataResponse.result.value as? NSDictionary
            {
                print("dict : \(dict)")
                
                if let result = dict["resultType"] as? Int
                {
                    if result == 1
                    {
                        if let tok = dict["token"] as? String
                        {
                            UserData.current?.token = tok
                            do {
                                let userData = try JSONEncoder().encode(UserData.current!)
                                let decoded = try JSONSerialization.jsonObject(with: userData, options: [])
                                 UserData.current = UserData.current!
                                        kAppDelegate.shared.saveLoggedUserdetails(decoded as! NSDictionary)
                                print(decoded as! NSDictionary)
                            }catch {
                                
                            }
                        }
                        
                        if let maxSaleQRPerTransaction = dict["maxSaleQRPerTransaction"] as? Int
                        {
                            self.MaxSaleQR = maxSaleQRPerTransaction
                            
                        }
                        
                        for v in 1 ..< self.MaxSaleQR + 1
                        {
                            self.MaxSaleNumbersDisplayed.append(v)
                        }
                        
                        if let maxGroupNumber = dict["maxGroupNumber"] as? Int
                        {
                            self.MaxGroupNum = maxGroupNumber
                        }
                        
                        if let minGroupNumber = dict["minGroupNumber"] as? Int
                        {
                            self.MinGroupNum = minGroupNumber
                        }
                        
                        for v in self.MinGroupNum ..< self.MaxGroupNum + 1
                        {
                            self.GroupNumbersDisplayed.append(v)
                        }
                       // self.GroupNoofPassButt.setTitle("\(self.GroupNumbersDisplayed[0])", for: .normal)
                        
                        if let mobileLineInfo = dict["mobileLineInfo"] as? NSArray
                        {
                           // print("mobileLineInfo : \(mobileLineInfo)")
                            
                            if let lineDefaultColor = mobileLineInfo.value(forKey: "lineDefaultColor") as? NSArray
                            {
                                self.LineDefaultColoArr = lineDefaultColor
                            }
                            
                            if let lineId = mobileLineInfo.value(forKey: "lineId") as? NSArray
                            {
                                self.LineIDArr = lineId
                            }
                            
                            if let lineName = mobileLineInfo.value(forKey: "lineName") as? NSArray
                            {
                                self.LineNameArr = lineName
                            }
                        }
                        
                        if let mobileLineStationInfo = dict["mobileLineStationInfo"] as? NSArray
                        {
                         //   print("mobileLineStationInfo \(mobileLineStationInfo)")
                            
                            if let distance = mobileLineStationInfo.value(forKey: "distance") as? NSArray
                            {
                                self.Station_DistanceArr = distance
                            }
                            
                            if let lineOrder = mobileLineStationInfo.value(forKey: "lineOrder") as? NSArray
                            {
                                self.Station_LineOrder = lineOrder
                            }
                            
                            if let logicalStationId = mobileLineStationInfo.value(forKey: "logicalStationId") as? NSArray
                            {
                                self.Station_LogicalStationIDArr = logicalStationId
                            }
                        }
                        
                        if let mobileProductInfo = dict["mobileProductInfo"] as? NSArray
                        {
                            print("mobileProductInfo \(mobileProductInfo)")
                            
                            if let code = mobileProductInfo.value(forKey: "code") as? NSArray
                            {
                                self.Product_CodeArr = code
                            }
                            
                            if let label = mobileProductInfo.value(forKey: "label") as? NSArray
                            {
                                self.Product_LabelArr = label
                            }
                            
                            
                            for p in self.Product_LabelArr
                            {
                                if let  str = p as? String
                                {
                                    if str.contains("SJT")
                                    {
                                        self.SJTLabelArr.add(str)
                                    }
                                    else if str.contains("RJT")
                                    {
                                        self.RJTLabelArr.add(str)
                                    }
                                    else
                                    {
                                        self.GroupLabelArr.add(str)
                                    }
                                }
                            }
                            
                            if self.SJTLabelArr.count > 0
                            {
                                //self.TicketTypeButt.setTitle("\(self.SJTLabelArr[0])", for: .normal)
                            }
                            
                            if self.RJTLabelArr.count > 0
                            {
                                //self.ReturnTicketTypeButt.setTitle("\(self.RJTLabelArr[0])", for: .normal)
                            }
                            
                            if self.GroupLabelArr.count > 0
                            {
                                //self.GroupTicketTypeButt.setTitle("\(self.GroupLabelArr[0])", for: .normal)
                            }
                            
                            if let productType = mobileProductInfo.value(forKey: "productType") as? NSArray
                            {
                                self.Product_ProductTypeArr = productType
                            }
                            
                            
                            if let qrTicketType = mobileProductInfo.value(forKey: "qrTicketType") as? NSArray
                            {
                                self.Product_qrTicketTypeArr = qrTicketType
                            }
                            
                            
                            if let validityTime = mobileProductInfo.value(forKey: "validityTime") as? NSArray
                            {
                                self.product_ValidityTime = validityTime
                            }
                        }
                        
                        if let mobileStationInfo = dict["mobileStationInfo"] as? NSArray
                        {
                           // print("mobileStationInfo \(mobileStationInfo)")
                            
                            if let latitude = mobileStationInfo.value(forKey: "latitude") as? NSArray
                            {
                                self.Mobile_LatitudeArr = latitude
                            }
                            
                            if let longitude = mobileStationInfo.value(forKey: "longitude") as? NSArray
                            {
                                self.Mobile_LongitudeArr = longitude
                            }
                            
                            if let logicalStationId = mobileStationInfo.value(forKey: "logicalStationId") as? NSArray
                            {
                                self.Mobile_LogicalStationIDArr = logicalStationId
                            }
                            
                            if let stationName = mobileStationInfo.value(forKey: "stationName") as? NSArray
                            {
                                self.Mobile_StationNameArr = stationName
                            }
                            
                            self.StationInfoMutableArr_2 = NSMutableArray(array: mobileStationInfo)
                            
                            
                            for i in 0 ..< self.Mobile_LogicalStationIDArr.count
                            {
                               PublicLogicalStationIDDict.setValue("\(self.Mobile_StationNameArr[i])", forKey: "\(self.Mobile_LogicalStationIDArr[i])")
                            }
                            
                        }
                        
                      
                        
                       // var IndexArr = [Int]()
                      
                        for k in self.Station_LogicalStationIDArr
                        {
                            let val = k as! Int
                            
                            let index = self.Mobile_LogicalStationIDArr.index(of: val)
                            
                          //  IndexArr.append(index) // 3, 0, 1, 2
                            
                            self.StationInfoMutableArr.add(self.StationInfoMutableArr_2[index])
                            
                            print("Index : \(index)")
                        }
                        
                        //////////
                        
                         print(print("StationInfoMutableArr 00 : \(self.StationInfoMutableArr_2)"))
                        
//                        if let dict2 = self.StationInfoMutableArr[3] as? NSDictionary
//                        {
//                           self.StationInfoMutableArr.removeObject(at: 3)
//
//                            self.StationInfoMutableArr.insert(dict2, at: 0)
//
//                        }
//
                        print(print("StationInfoMutableArr 3 : \(self.StationInfoMutableArr)"))
                        
                    }
                }
                
                if self.Mobile_StationNameArr.count > 0
                {
//                    self.FromStationStr = "\(self.Mobile_StationNameArr[0])"
//
//                    self.FromButt.setTitle("\(self.Mobile_StationNameArr[0])", for: .normal)
//
//                    self.SourceStationIDStr = "\(self.Mobile_LogicalStationIDArr[0])"
//
//                    self.ToStationStr = "\(self.Mobile_StationNameArr[2])"
//
//                    self.ToButt.setTitle("\(self.Mobile_StationNameArr[2])", for: .normal)
//
//
//                    self.DestinationStationIDStr = "\(self.Mobile_LogicalStationIDArr[2])"
                    
                   // self.NoofPassButt.setTitle("1", for: .normal)
                    
                    self.TicketsCountStr = "1"
                    
                    self.HidingStartStationLbl.text = self.FromStationStr
                    self.HidingStartStationLbl2.text = self.FromStationStr
                    self.HidingStartStationLbl3.text = self.FromStationStr
                    
                    self.HidingDestinationStationLbl.text = self.ToStationStr
                    self.HidingDestinationStationLbl2.text = self.ToStationStr
                    self.HidingDestinationStationLbl3.text = self.ToStationStr
                    
                    
                    //**self.CalculateQRFare()
                
                }
                
                self.PinGoogleMaps()
            }
            
            self.BookTicketTbl.reloadData()
             self.GetLastTicket()
        }
        }
    }
    
    //MARK: - MX Segmented Control
    
    @objc func changeIndex(
        segmentedControl: MXSegmentedControl) {
        
        if segmentedControl == Segment
        {
            switch Segment.selectedIndex {
            case 0:
                //Segment.indicator.lineView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.4392156863, blue: 0.3803921569, alpha: 1)
                MapBackView.isHidden = true
                RechargeBackView.isHidden = false
                
               // BookTicketBackVw.isHidden = true
                
                print("RECHARGE")
            case 1:
                //Segment.indicator.lineView.backgroundColor = #colorLiteral(red: 0.2044631541, green: 0.7111002803, blue: 0.898917675, alpha: 1)
                MapBackView.isHidden = false
                RechargeBackView.isHidden = true
                //BookTicketBackVw.isHidden = false
                print("PLAN A JOURNEY")
            default:
                break
            }
        }
        else
        {
 
 
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
    
    //MARK: - Google Maps
    
    func PinGoogleMaps()
    {
        if self.StationInfoMutableArr.count == 0
        {
            return
        }
        
        for d in 0 ..< self.StationInfoMutableArr.count
        {
            let Dict = self.StationInfoMutableArr[d] as! NSDictionary
            
            let latt = Dict["latitude"] as! String
            
            let long = Dict["longitude"] as! String
            
            let stationName = Dict["stationName"] as! String
            
            let mapInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 0.0, right: 0)
            Mapiew.padding = mapInsets
            
//            let camera = GMSCameraPosition.camera(withLatitude: Double(latt)!, longitude: Double(long)!, zoom: 20.0)
//            let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
//            Mapiew = mapView
            
            var locationMarker2: GMSMarker!
            
            let aaa = CLLocationCoordinate2D(latitude : Double(latt)!, longitude: Double(long)!)
            
            locationMarker2 = GMSMarker(position: aaa)
            locationMarker2.map = Mapiew
            
            locationMarker2.title = stationName
            locationMarker2.appearAnimation = .pop
            
            locationMarker2.isFlat = true
            // locationMarker2.snippet = "Its my destination point"
            
            locationMarker2.icon = GMSMarker.markerImage(with: randomColor())
            locationMarker2.opacity = 1
            
        }
        
//        let Dict = self.StationInfoMutableArr[1] as! NSDictionary
//
//        let latt = Dict["latitude"] as! String
//
//        let long = Dict["longitude"] as! String
//
      //  let stationName = Dict["stationName"] as! String
        
        let mapInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 0.0, right: 0)
        Mapiew.padding = mapInsets
        
//        let camera = GMSCameraPosition.camera(withLatitude: Double(latt)!, longitude: Double(long)!, zoom: 12.0)
//        //let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
//        self.Mapiew.animate(to: camera)
        
        drawRectange()
        
      //  locationMarker2.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
    }
    
    func PointToCordinate(value : Int)
    {
        
        let latt = Mobile_LatitudeArr.object(at: value) as! String
        
        let long = Mobile_LongitudeArr.object(at: value) as! String
        
        //  let stationName = Dict["stationName"] as! String
        
        let mapInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 0.0, right: 0)
        Mapiew.padding = mapInsets
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(latt)!, longitude: Double(long)!, zoom: 12.0)
        //let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        self.Mapiew.animate(to: camera)
        
    }
    
    func drawRectange(){
        /* create the path */
        
        for d in 0 ..< self.StationInfoMutableArr.count
        {
            
            let Dict = self.StationInfoMutableArr[d] as! NSDictionary
            
            let latt = Dict["latitude"] as! String
            
            let long = Dict["longitude"] as! String
            
            let path = GMSMutablePath()
            
            path.add(CLLocationCoordinate2D(latitude: Double(latt)!, longitude: Double(long)!))
            
            if d + 1 < self.StationInfoMutableArr.count
            {
                let Dict2 = self.StationInfoMutableArr[d + 1] as! NSDictionary
                
                let latt2 = Dict2["latitude"] as! String
                
                let long2 = Dict2["longitude"] as! String
                
                path.add(CLLocationCoordinate2D(latitude: Double(latt2)!, longitude: Double(long2)!))
                
                let rectangle = GMSPolyline(path: path)
                rectangle.strokeWidth = 5
                let cc = self.LineDefaultColoArr.object(at: 0) as! String
                
                rectangle.strokeColor = UIColor.hexStr(hexStr: "\(cc)" as NSString, alpha: 1)
                
                SlideStopLbl.backgroundColor = UIColor.hexStr(hexStr: "\(cc)" as NSString, alpha: 1)
                
                rectangle.map = Mapiew
            }

        }
        
        NearByStation()
        
//        let path = GMSMutablePath()
//        path.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.0))
//        path.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.0))
//        path.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.2))
//        path.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.2))
//        path.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.0))
//
//        /* show what you have drawn */
//        let rectangle = GMSPolyline(path: path)
//        rectangle.map = Mapiew
    }
    
    func NearByStation()
    {
        
        for d in 0 ..< self.StationInfoMutableArr.count
        {
            
            let Dict = self.StationInfoMutableArr[d] as! NSDictionary
            
            let latt = Dict["latitude"] as! String
            
            let long = Dict["longitude"] as! String
            
            let Coordiante : CLLocation = CLLocation(latitude: Double(latt)!, longitude: Double(long)!)
            
            StationLocationCordinates.append(Coordiante)
        }
        
        closestLoc(userLocation: UserCurrentLocation)
    }
    
    
    func closestLoc(userLocation:CLLocation){
        var distances = [CLLocationDistance]()
        for location in StationLocationCordinates{
            let coord = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            distances.append(coord.distance(from: userLocation))
            
            //print("distance = \(coord.distance(from: userLocation))")
        }

        let closest = distances.min()//shortest distance
        let position = distances.index(of: closest!)//index of shortest distance
        //print("closest = \(closest!), index = \(position!)")
        
        let CloseStation = StationLocationCordinates[position!]
        
                let camera = GMSCameraPosition.camera(withLatitude: CloseStation.coordinate.latitude, longitude: CloseStation.coordinate.longitude, zoom: 12.0)
                //let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
                self.Mapiew.animate(to: camera)
        
        DrawToNearestStation(Loc: CloseStation)
    }
    
    func DrawToNearestStation(Loc : CLLocation)
    {
        let path = GMSMutablePath()
        
        path.add(CLLocationCoordinate2D(latitude: UserCurrentLocation.coordinate.latitude, longitude: UserCurrentLocation.coordinate.longitude))
        path.add(CLLocationCoordinate2D(latitude: Loc.coordinate.latitude, longitude: Loc.coordinate.longitude))
        let line = GMSPolyline(path: path)
        line.strokeWidth = 5
        
        line.strokeColor = UIColor.red
        
        line.map = Mapiew
    }
    
    
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
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
                    
                }
                else
                {
                    FromStationStr = "\(Mobile_StationNameArr[indexPath.row])"
                    
                    FromButt.setTitle("\(Mobile_StationNameArr[indexPath.row])", for: .normal)
                    
                    SourceStationIDStr = "\(Mobile_LogicalStationIDArr[indexPath.row])"
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
                    
                    PointToCordinate(value: ii)
                }
                else
                {
                    ToStationStr = "\(DestinationArr[indexPath.row])"
                    
                    ToButt.setTitle("\(DestinationArr[indexPath.row])", for: .normal)
                    
                    let ii = Mobile_StationNameArr.index(of: ToStationStr)
                    
                    DestinationStationIDStr = "\(Mobile_LogicalStationIDArr[ii])"
                    
                    PointToCordinate(value: ii)
                }
                
               //** CalculateQRFare()
                
            }
            
            self.HidingStartStationLbl.text = self.FromStationStr
            self.HidingStartStationLbl2.text = self.FromStationStr
            self.HidingStartStationLbl3.text = self.FromStationStr
            
            self.HidingDestinationStationLbl.text = self.ToStationStr
            self.HidingDestinationStationLbl2.text = self.ToStationStr
            self.HidingDestinationStationLbl3.text = self.ToStationStr
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
           // ChooseStationViewController.StationNameArr = self.Mobile_StationNameArr
            //ChooseStationViewController.StationLogicalIDArr = self.Mobile_LogicalStationIDArr
            self.navigationController?.pushViewController(ChooseStationViewController, animated: true)
        }
        
        
        
     /*   SearchField.text = ""
        
        SearchArr = NSArray()
        
        ButtCheck = 0
        
        BlackVw.isHidden = false
        
        SourceLbl.text = "Source metro station"
        
        tbl.reloadData()
        
        SearchField.becomeFirstResponder()
        
        */
    }
    
    
    @IBAction func ToClick(_ sender: Any) {
        
        if self.Mobile_StationNameArr.count > 0
        {
            let ChooseStationViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChooseStationViewController") as! ChooseStationViewController
            //ChooseStationViewController.StationNameArr = self.Mobile_StationNameArr
            //ChooseStationViewController.StationLogicalIDArr = self.Mobile_LogicalStationIDArr
            self.navigationController?.pushViewController(ChooseStationViewController, animated: true)
        }
        
       
        /*  SearchField.text = ""
        
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
        
        */
    }
    
    @IBAction func Close(_ sender: Any) {
        
        BlackVw.isHidden = true
    }
    
    
    @IBAction func TicketTypeClicked(_ sender: Any) {
        
        BookTblCheck = 1
        
        BookTicketTblBlackVw.isHidden = false
        
        BookTicketTbl.reloadData()
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
        
//        if TotalLbl.text == ""
//        {
//            return
//        }
        
        let ReviewBookingViewController1 = self.storyboard?.instantiateViewController(withIdentifier: "ReviewBookingViewController") as! ReviewBookingViewController
        
        // Caluculate QR Ticket
        
        ReviewBookingViewController1.Review_ArbitryCodeStr = self.ArbitryCodeStr
        ReviewBookingViewController1.Review_QRTypeStr = self.QRTypeStr
        ReviewBookingViewController1.Review_ProductCodeStr = self.ProductCodeStr
        ReviewBookingViewController1.Review_SourceStationIDStr = Public_SourceStationIDs
        ReviewBookingViewController1.Review_DestinationStationIDStr = Public_DestinationStationIDs
        ReviewBookingViewController1.Review_TripsCountStr = self.TripsCountStr
        ReviewBookingViewController1.Review_TicketsCountStr = self.TicketsCountStr
        
        
//        ReviewBookingViewController1.DetailsDict = DetailsDictionary

        ReviewBookingViewController1.SourceStation = FromStationStr
        ReviewBookingViewController1.DestinationStation = ToStationStr
       // ReviewBookingViewController1.DateStr = DateStr
        ReviewBookingViewController1.ExpireDateStr = ExpireDateStr
        ReviewBookingViewController1.ValidityMinuteInt = 30
      //  ReviewBookingViewController1.TimerSec = TimerSecond
//
//        //Buy QR ticket
//
//        ReviewBookingViewController1.Buy_ArbitryID = ArbitryCodeStr
//        ReviewBookingViewController1.Buy_QRType = QRTypeStr
//        ReviewBookingViewController1.Buy_ProductCode = ProductCodeStr
//        ReviewBookingViewController1.Buy_SorceStationID = SourceStationIDStr
//        ReviewBookingViewController1.Buy_DestinationStationID = DestinationStationIDStr
//        ReviewBookingViewController1.Buy_TripsCount = TripsCountStr
//        ReviewBookingViewController1.Buy_TicketsCount = TicketsCountStr
        
        self.navigationController?.pushViewController(ReviewBookingViewController1, animated: true)
    }
    
    @IBAction func ReturnTicketTypeClicked(_ sender: Any) {
        
        BookTblCheck = 11
        
        BookTicketTblBlackVw.isHidden = false
        
        BookTicketTbl.reloadData()
    }
    
    @IBAction func ReturnNoofPassClicked(_ sender: Any) {
        
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
        
        BookTblCheck = 22
        
        BookTicketTblBlackVw.isHidden = false
        
        BookTicketTbl.reloadData()
            
        }
    }
    
    @IBAction func ReturnBookClicked(_ sender: Any) {
        
     
        
        let ReviewBookingViewController1 = self.storyboard?.instantiateViewController(withIdentifier: "ReviewBookingViewController") as! ReviewBookingViewController
        
        
        ReviewBookingViewController1.Review_ArbitryCodeStr = self.ArbitryCodeStr
        ReviewBookingViewController1.Review_QRTypeStr = self.QRTypeStr
        ReviewBookingViewController1.Review_ProductCodeStr = self.ProductCodeStr
        ReviewBookingViewController1.Review_SourceStationIDStr = self.SourceStationIDStr
        ReviewBookingViewController1.Review_DestinationStationIDStr = self.DestinationStationIDStr
        ReviewBookingViewController1.Review_TripsCountStr = self.TripsCountStr
        ReviewBookingViewController1.Review_TicketsCountStr = self.TicketsCountStr
        
       // ReviewBookingViewController1.DetailsDict = DetailsDictionary
        
        ReviewBookingViewController1.SourceStation = FromStationStr
        ReviewBookingViewController1.DestinationStation = ToStationStr
        //ReviewBookingViewController1.DateStr = DateStr
        ReviewBookingViewController1.ExpireDateStr = ExpireDateStr
        ReviewBookingViewController1.ValidityMinuteInt = 35
        //ReviewBookingViewController1.TimerSec = TimerSecond
        //Buy QR ticket
        
//        ReviewBookingViewController1.Buy_ArbitryID = ArbitryCodeStr
//        ReviewBookingViewController1.Buy_QRType = QRTypeStr
//        ReviewBookingViewController1.Buy_ProductCode = ProductCodeStr
//        ReviewBookingViewController1.Buy_SorceStationID = SourceStationIDStr
//        ReviewBookingViewController1.Buy_DestinationStationID = DestinationStationIDStr
//        ReviewBookingViewController1.Buy_TripsCount = TripsCountStr
//        ReviewBookingViewController1.Buy_TicketsCount = TicketsCountStr
        
        
        self.navigationController?.pushViewController(ReviewBookingViewController1, animated: true)
        
    }
    
    @IBAction func GroupTicketTypeClicked(_ sender: Any) {
        
        BookTblCheck = 111
        
        BookTicketTblBlackVw.isHidden = false
        
        BookTicketTbl.reloadData()
    }
    
    @IBAction func GroupNoofPassClicked(_ sender: Any) {
        
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
            
        
        BookTblCheck = 222
        
        BookTicketTblBlackVw.isHidden = false
        
        BookTicketTbl.reloadData()
            
        }
    }
    
    @IBAction func SlideUpBookClicked(_ sender: Any) {
        
        let ChooseJourneyViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChooseJourneyViewController") as! ChooseJourneyViewController
        
        ChooseJourneyViewController.Journey_ArbitryCodeStr = self.ArbitryCodeStr
        ChooseJourneyViewController.Journey_QRTypeStr = self.QRTypeStr
        ChooseJourneyViewController.Journey_ProductCodeStr = self.ProductCodeStr
        ChooseJourneyViewController.Journey_SourceStationIDStr = Public_SourceStationIDs
        ChooseJourneyViewController.Journey_DestinationStationIDStr = Public_DestinationStationIDs
        ChooseJourneyViewController.Journey_TripsCountStr = self.TripsCountStr
        ChooseJourneyViewController.Journey_TicketsCountStr = self.TicketsCountStr
        
        ChooseJourneyViewController.Journey_ProductCodeArr = self.Product_CodeArr
        ChooseJourneyViewController.Journey_MaxSaleNumbersDisplayed = self.MaxSaleNumbersDisplayed
        ChooseJourneyViewController.Journey_GroupNumbersDisplayed = self.GroupNumbersDisplayed
        
        ChooseJourneyViewController.Journey_SJTLabelArr = self.SJTLabelArr
        ChooseJourneyViewController.Journey_RJTLabelArr = self.RJTLabelArr
        ChooseJourneyViewController.Journey_SJTLabelArr = self.GroupLabelArr
        
        self.navigationController?.pushViewController(ChooseJourneyViewController, animated: true)
        
       // Segment.select(index: 1, animated: true)
        
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
        
     
        
        let ReviewBookingViewController1 = self.storyboard?.instantiateViewController(withIdentifier: "ReviewBookingViewController") as! ReviewBookingViewController
        
      //  ReviewBookingViewController1.DetailsDict = DetailsDictionary
        
        
        ReviewBookingViewController1.Review_ArbitryCodeStr = self.ArbitryCodeStr
        ReviewBookingViewController1.Review_QRTypeStr = self.QRTypeStr
        ReviewBookingViewController1.Review_ProductCodeStr = self.ProductCodeStr
        ReviewBookingViewController1.Review_SourceStationIDStr = self.SourceStationIDStr
        ReviewBookingViewController1.Review_DestinationStationIDStr = self.DestinationStationIDStr
        ReviewBookingViewController1.Review_TripsCountStr = self.TripsCountStr
        ReviewBookingViewController1.Review_TicketsCountStr = self.TicketsCountStr
        
        ReviewBookingViewController1.SourceStation = FromStationStr
        ReviewBookingViewController1.DestinationStation = ToStationStr
       // ReviewBookingViewController1.DateStr = DateStr
        ReviewBookingViewController1.ExpireDateStr = ExpireDateStr
        ReviewBookingViewController1.ValidityMinuteInt = 35
      //  ReviewBookingViewController1.TimerSec = TimerSecond
        
        //Buy QR ticket
        
//        ReviewBookingViewController1.Buy_ArbitryID = ArbitryCodeStr
//        ReviewBookingViewController1.Buy_QRType = QRTypeStr
//        ReviewBookingViewController1.Buy_ProductCode = ProductCodeStr
//        ReviewBookingViewController1.Buy_SorceStationID = SourceStationIDStr
//        ReviewBookingViewController1.Buy_DestinationStationID = DestinationStationIDStr
//        ReviewBookingViewController1.Buy_TripsCount = TripsCountStr
//        ReviewBookingViewController1.Buy_TicketsCount = TicketsCountStr
//
        
        self.navigationController?.pushViewController(ReviewBookingViewController1, animated: true)
    }
    
    @IBAction func HideBookTblBlackVw(_ sender: Any) {
        
        BookTicketTblBlackVw.isHidden = true
        
    }
    
    //MARK: - Change values
    
    @objc func ChangeValues()
    {
        let searchPredicate = NSPredicate(format: "SELF BEGINSWITH[c] %@", SearchField.text!)
        
        SearchArr = (self.Mobile_StationNameArr as NSArray).filtered(using: searchPredicate) as NSArray
        

        tbl.reloadData()
    }
    
    //MARK: - Calculate QR Fare
    
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
                                
                                if self.QRTypeStr == "1"
                                {
                                    self.TotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                                else if self.QRTypeStr == "2"
                                {
                                    self.ReturnTotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                                else
                                {
                                    self.GroupTotalLbl.text = "\(totalRoundedPrice) INR"
                                }
                            }
                            
                            self.DetailsDictionary = priceDetails
                        }
                        
                        if let expirationDate1 = dict["expirationDate"] as? String
                        {
                            self.ExpireDateStr = expirationDate1
                        }
                        
                        if let paymentInitializationURL = dict["paymentInitializationURL"] as? String
                        {
                            PublicPaymentURL = paymentInitializationURL
                            
                            self.TimerSecond = 59
                        }
                    }
                    
                }
            }
            
         }
    }
    }
    
    var timer = Timer()
    
    var TimerSecond = 60
    
    
    
    @objc func CaluculatePaymentTimer()
    {
        if TimerSecond == 0
        {
            
        }
        else
        {
            TimerSecond -= 1
        }
        
    }
    
  
    
    
   
    
    @objc func ToLogOut() {
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        
        Alamofire.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            
            //print(dataResponse.result.value!)
            
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
                            UserDefaults.standard.synchronize()
                        }
                        if let Last = dict["lastTicketSerial"] as? Int
                        {
                            print("Last ticket no: \(Last)")
                            
                            if self.AlreadySavedData.count > 0
                            {
                                if let arr1 = self.AlreadySavedData.value(forKey: "ticketSerial") as? NSArray
                                {
                                    if let arr2 = arr1.object(at: 0) as? NSArray
                                    {
                                        if arr2.count > 0
                                        {
                                            if let Saved = ((self.AlreadySavedData.value(forKey: "ticketSerial") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as? Int
                                            {
                                                print("Last Saved ticket no: \(Saved)")
                                                
                                                if Saved != Last
                                                {
                                                    print("Not Match")
                                                    
                                                    self.TocketHistory()
                                                }
                                                else
                                                {
                                                    print("Match")
                                                }
                                            }
                                        }
                                        else
                                        {
                                            self.TocketHistory()
                                        }
                                    }
                                    else
                                    {
                                        self.TocketHistory()
                                    }
                                }
                                else
                                {
                                    self.TocketHistory()
                                }
                            }
                            else
                            {
                                self.TocketHistory()
                            }
                            
                        }
                    }
                }
                
            }
            
        }
    }
    }
    
    func TocketHistory()
    {
        if UserData.current?.token != nil {
        
        let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        let url = "\(APILink)ticketHistory"
        
        let parameters: [String: Any] = [
            "token" : UserData.current!.token!,
            ]
        
        
        Alamofire.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            
            //print(dataResponse.result.value!)
            
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
                        
                        if let arr = dict["tickets"] as? NSArray
                        {
                            self.TicketsArr = arr
                            
                        }
                    }
                }
                
            }
        
            if self.TicketsArr.count > 0
            {
                kAppDelegate.shared.saveToCoreData(self.TicketsArr)
            }
        }
    }
    }
    
    //MARK: - My Tickets Count
    
    var MyTicketsCountArr = NSArray()
    
    var TicketMutableArr2 = NSMutableArray()
    
    var TicketMutableArrYesterday = NSMutableArray()
    
    var TicketMutableArr = NSMutableArray()
    
    func CheckMyTicketsCount()
    {
        if AlreadySavedData.count > 0
        {
            MyTicketsCountArr = AlreadySavedData.object(at: 0) as! NSArray
        }
        
        for i in MyTicketsCountArr
        {
            let dic = i as! NSDictionary
            
            if let qrTicketStatus = dic["qrTicketStatus"] as? String
            {
                if qrTicketStatus == "UNUSED"
                {
                    TicketMutableArr2.add(dic)
                }
            }
        }
        
        // print("TicketMutableArr2 : \(TicketMutableArr2)")
        
        for j in TicketMutableArr2
        {
            let dic = j as! NSDictionary
            
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
        
        ExpireActions()
    }
    
    //MARK: - Expire Actions
    
    func ExpireActions()
    {
        TicketMutableArr.removeAllObjects()
        
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
            
            print("Minutes : \(Date().minutes(from: showDate!))")
            
            print("Seconds : \(Date().seconds(from: showDate!))")
            
            let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Date().seconds(from: showDate!))
            print("Hour : \(h), Minutes : \(m), Seonds : \(s)")
            
            if m < 0 || s < 0
            {
                print("Still Running")
                
                TicketMutableArr.add(dic)
            }
            else
            {
                print("Expired")
            }
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    //MARK: - Nagpur Actions
    
    
    @IBAction func FromButtClick(_ sender: Any) {
    }
 }

