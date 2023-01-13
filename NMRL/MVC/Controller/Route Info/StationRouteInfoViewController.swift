//
//  StationRouteInfoViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 25/10/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import Alamofire
import GoogleMaps
import CoreLocation

class StationRouteInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GMSMapViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet var Segment2              : MXSegmentedControl!
    @IBOutlet var tbl                   : UITableView!
    @IBOutlet var ConfirmButt           : UIButton!
    @IBOutlet var Station1              : UILabel!
    @IBOutlet var Station2              : UILabel!
    @IBOutlet var MapVw                 : GMSMapView!
    @IBOutlet var KmLbl                 : UILabel!
    @IBOutlet var StationLbl            : UILabel!
    @IBOutlet var InterchangeLbl        : UILabel!
    @IBOutlet var InternetBlackView     : UIView!
    @IBOutlet var PriceLbl              : UILabel!
    @IBOutlet var btnLogout             : UIButton!
    
    var SelectedSourceStation           = String()
    var SelectedDestinationStaion       = String()
    var SelectedSourceStationID         = String()
    var SelectedDestinationID           = String()
    var UserSelectedStations            = NSMutableArray()
    var AllStationNames                 = NSArray()
    var AllLatitudeArr                  = NSArray()
    var AllLongitudeArr                 = NSArray()
    var DistanceArr                     = NSArray()
    var LogicalIDArr                    = NSArray()
    var StationInfoLogicalIDArr         = NSArray()
    var LatitudeArray                   = NSMutableArray()
    var LongitudeArray                  = NSMutableArray()
    var SelectedDistanceMeters          = NSMutableArray()
    var StationLogicalIDArr             = NSArray()
    //  var StationNameArr = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        InternetBlackView.isHidden = true
        Segment2.append(title: "Route Info").set(image: #imageLiteral(resourceName: "InfoBlack")).set(image: .top).set(padding: 15).set(image: #imageLiteral(resourceName: "InfoGreen"), for: .selected)
        Segment2.append(title: "Google Map").set(image: #imageLiteral(resourceName: "LocationBlack")).set(image: .top).set(padding: 15).set(image: #imageLiteral(resourceName: "LocationGreen"), for: .selected)
        Segment2.textColor = .lightGray
        Segment2.backgroundColor = UIColor.white//UIColor.hexStr(hexStr: "#CC7454", alpha: 1)
        Segment2.indicatorColor = UIColor.hexStr(hexStr: "#FF9300", alpha: 1)
        Segment2.selectedTextColor = UIColor.hexStr(hexStr: "#FF9300", alpha: 1)
        Segment2.addTarget(self, action: #selector(changeIndex(segmentedControl:)), for: .valueChanged)
        //Segment2.separatorColor = UIColor.black.withAlphaComponent(0.5)
        //  Segment2.separatorWidth = 0.5
        Segment2.indicatorHeight = 2
        Segment2.font = UIFont(name: "Montserrat-Bold", size: 17)!
        // Segment2.indicator.lineHeight = 3
        LogoutBlaceView.isHidden = true
        Station1.text = SelectedSourceStation
        Station2.text = SelectedDestinationStaion
        print("PublicMobileStationInforArray : \(PublicMobileStationInforArray)")
        print("Public_StationInfoMutableArr : \(Public_StationInfoMutableArr)")
        MapVw.isHidden = true
        if let distance = PublicMobileStationInforArray.value(forKey: "distance") as? NSArray {
            DistanceArr = distance
            print("DistanceArr : \(DistanceArr)")
        }
        if let logicalStationId = PublicMobileStationInforArray.value(forKey: "logicalStationId") as? NSArray {
            LogicalIDArr = logicalStationId
        }
        if let logical = Public_StationInfoMutableArr.value(forKey: "logicalStationId") as? NSArray {
            StationInfoLogicalIDArr = logical
            // print("StationInfoLogicalIDArr : \(StationInfoLogicalIDArr)")
        }
        if let stationName = Public_StationInfoMutableArr.value(forKey: "stationName") as? NSArray {
            AllStationNames = stationName
        }
        if let latitude = Public_StationInfoMutableArr.value(forKey: "latitude") as? NSArray {
            AllLatitudeArr = latitude
        }
        if let longitude = Public_StationInfoMutableArr.value(forKey: "longitude") as? NSArray {
            AllLongitudeArr = longitude
        }
        for i in UserSelectedStations {
            let index = AllStationNames.index(of: "\(i)")
            LatitudeArray.add("\(AllLatitudeArr[index])")
            LongitudeArray.add("\(AllLongitudeArr[index])")
            SelectedDistanceMeters.add("\(DistanceArr[index])")
        }
        var meters = Int("\(SelectedDistanceMeters[0])")!
        for i in 1 ..< SelectedDistanceMeters.count {
            meters = meters + Int("\(SelectedDistanceMeters[i])")!
        }
        print("Meters : \(meters/1000)")
        print("KMS : \(average(number: meters))")
        KmLbl.text = "\(average(number: meters))" //"\(meters/1000)"
        StationLbl.text = "\(LatitudeArray.count - 2)"
        DropPins()
        let ind = Public_Product_qrTicketTypeArr.index(of: "SJT")
        self.CalculateQRTicketSingle(Arbitry: "100", QRType: "1", ProdCode: "\(Public_Product_CodeArr[ind])", Count: "1")
    }
    
    func average(number: Int) -> Float {
        return Float(number)/1000
    }
    
    //MARK: - MX Segmented Control
    @objc func changeIndex(
        segmentedControl: MXSegmentedControl) {
        if segmentedControl == Segment2 {
            switch Segment2.selectedIndex {
            case 0:
                tbl.isHidden = false
                MapVw.isHidden = true
            case 1:
                tbl.isHidden = true
                MapVw.isHidden = false
            default:
                break
            }
        }
    }
    
    func DropPins() {
        for i in 0 ..< LatitudeArray.count {
            let latt = "\(LatitudeArray[i])"
            let long = "\(LongitudeArray[i])"
            let stationname = "\(UserSelectedStations[i])"
            let mapInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 0.0, right: 0)
            MapVw.padding = mapInsets
            let camera = GMSCameraPosition.camera(withLatitude: Double(latt)!, longitude: Double(long)!, zoom: 12.0)
            self.MapVw.animate(to: camera)
            var locationMarker2: GMSMarker!
            let aaa = CLLocationCoordinate2D(latitude : Double(latt)!, longitude: Double(long)!)
            locationMarker2 = GMSMarker(position: aaa)
            locationMarker2.map = MapVw
            locationMarker2.title = stationname
            locationMarker2.appearAnimation = .pop
            locationMarker2.isFlat = true
            // locationMarker2.snippet = "Its my destination point"
            if i == LatitudeArray.count - 1 {
                //  locationMarker2.icon = GMSMarker.markerImage(with: UIColor.red) // red
            }else {
                // locationMarker2.icon = GMSMarker.markerImage(with: UIColor.green) //Green
            }
            // locationMarker2.icon = GMSMarker.markerImage(with: UIColor.hexStr(hexStr: "#FF9300", alpha: 1))
            // locationMarker2.icon = GMSMarker.markerImage(with: UIColor.orange)
            locationMarker2.icon = #imageLiteral(resourceName: "LocationBig")
            locationMarker2.opacity = 1
        }
        DrawLines()
    }
    
    func DrawLines() {
        /* create the path */
        for i in 0 ..< LatitudeArray.count {
            let latt = "\(LatitudeArray[i])"
            let long = "\(LongitudeArray[i])"
            let path = GMSMutablePath()
            path.add(CLLocationCoordinate2D(latitude: Double(latt)!, longitude: Double(long)!))
            if i + 1 < self.LatitudeArray.count {
                let latt2 = "\(LatitudeArray[i + 1])"
                let long2 = "\(LongitudeArray[i + 1])"
                path.add(CLLocationCoordinate2D(latitude: Double(latt2)!, longitude: Double(long2)!))
                let rectangle = GMSPolyline(path: path)
                rectangle.strokeWidth = 5
                rectangle.strokeColor = .green
                rectangle.map = MapVw
            }
        }
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserSelectedStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if let lbl = cell?.viewWithTag(1) as? UILabel {
            lbl.text = "\(UserSelectedStations[indexPath.row])"
        }
        if let lbl2 = cell?.viewWithTag(2) as? UILabel {
            lbl2.text = ""
        }
        cell?.backgroundColor = UIColor.white
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
            ////////////// New Time Format
            formatter.dateFormat = "yyyyMMddhhmmss"
            let dateString2 = formatter.string(from: now)
            let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers1 = ["authorization": "Basic \(base64Credentials)"]
            let url = "\(APILink)calculateQRTicket"
            
            let parameters1: [String: Any] = [
                "id" : Arbitry,
                "qrType" : QRType,
                "productCode" : ProdCode,
                "sourceStation1" : SelectedSourceStationID,
                "destinationStation1" : SelectedDestinationID,
                "sourceStation2" : "0",
                "destinationStation2" : "0",
                "tripsCount" : Count,
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
                if let dict = dataResponse.result.value as? NSDictionary {
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
                            }
                            if let priceDetails = dict["priceDetails"] as? NSDictionary {
                                if let totalRoundedPrice = priceDetails["totalRoundedPrice"] as? String {
                                    self.PriceLbl.text = "\(totalRoundedPrice)"
                                }
                            }
                        }
                    }
                }
            }
        }
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
    
    //MARK: - Core Data
    var people: [NSManagedObject] = []
    var AlreadySavedData = NSArray()
    
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
        
        //MARK:- Saving Data
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TicketData",in: managedContext)!
        let person = NSManagedObject(entity: entity,insertInto: managedContext)
        person.setValue(arr, forKeyPath: "tickets")
        person.setValue(StatusDict, forKeyPath: "ticketstatus2")
        do {
            try managedContext.save()
            people.append(person)
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        ReadData()
    }
    
    func ReadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TicketData")
        do {
            people = try managedContext.fetch(fetchRequest)
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        let db = people.map { $0.value(forKey: "tickets") as! NSArray}
        AlreadySavedData = db as NSArray
        let statusData = people.map { $0.value(forKey: "ticketstatus2") as! NSDictionary}
        if statusData.count > 0 {
            Public_AlreadySavedTicketStatusData = NSDictionary()
            Public_AlreadySavedTicketStatusData = statusData[0]
        }
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
    
    
    @IBAction func Confirm(_ sender: Any) {
        if UserData.current != nil {
            if Connectivity.isConnectedToInternet() {
                print("Yes! internet is available.")
            }else {
                print("No internet.")
                InternetBlackView.isHidden = false
                return
            }
            Public_SourceStationName = self.SelectedSourceStation
            Public_DestinationStationName = self.SelectedDestinationStaion
            Public_SourceStationIDs = self.SelectedSourceStationID
            Public_DestinationStationIDs = self.SelectedDestinationID
            let BookTicketViewController = self.storyboard?.instantiateViewController(withIdentifier: "BookTicketViewController") as! BookTicketViewController
            self.navigationController?.pushViewController(BookTicketViewController, animated: true)
        }else {
            kAppDelegate.shared.showAlert(self, title: Alert.kTitle, message: Alert.kLoginMessage) { (success) in
                if success  {
                    let landingVC = kStoryBoard.instantiateViewController(withIdentifier: StoryBoardIds.kLandingVC) as! LandingViewController
                    self.navigationController?.pushViewController(landingVC, animated: true)
                }
            }
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
