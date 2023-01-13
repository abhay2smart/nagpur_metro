//
//  RouteInfoViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 25/10/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class RouteInfoViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var tbl                   : UITableView!
    @IBOutlet var btnLogout             : UIButton!
    @IBOutlet var OriginButt            : UIButton!
    @IBOutlet var ConfirmButt           : UIButton!
    @IBOutlet var Segment2              : MXSegmentedControl!
    @IBOutlet var InternetBlackView     : UIView!
    @IBOutlet var DestinationButt       : UIButton!
    
    //var StationNameArr = NSArray()
    //var StationLogicalIDArr = NSArray()
    var SelectedSourceStation           = String()
    var SelectedDestinationStaion       = String()
    var SelectedSourceStationID         = String()
    var SelectedDestinationID           = String()
    var SourceStationIntex              = 0
    var DestinationStationIntex         = 0
    var NumberArr                       = NSMutableArray()
    var SelcetedStationsArray           = NSMutableArray()
    var PositionSourceStation           = String()
    var PositionDestinationStation      = String()
    var StationIndexArr                 = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        InternetBlackView.isHidden = true
        Segment2.append(title: "ORIGIN")
        Segment2.append(title: "DESTINATION")
        Segment2.textColor = .lightGray
        Segment2.backgroundColor = UIColor.white//UIColor.hexStr(hexStr: "#CC7454", alpha: 1)
        Segment2.indicatorColor = UIColor.hexStr(hexStr: "#FF9300", alpha: 1)
        Segment2.selectedTextColor = UIColor.hexStr(hexStr: "#FF9300", alpha: 1)
        Segment2.addTarget(self, action: #selector(changeIndex(segmentedControl:)), for: .valueChanged)
        Segment2.separatorColor = UIColor.black.withAlphaComponent(0.5)
        Segment2.separatorWidth = 0.5
        Segment2.indicatorHeight = 2
        Segment2.font = UIFont(name: "Montserrat-Bold", size: 17)!
        Segment2.indicator.lineHeight = 3
        OriginButt.layer.cornerRadius = 8
        OriginButt.clipsToBounds = true
        OriginButt.layer.borderWidth = 2
        OriginButt.layer.borderColor = UIColor.lightGray.cgColor
        DestinationButt.layer.cornerRadius = 8
        DestinationButt.clipsToBounds = true
        DestinationButt.layer.borderWidth = 2
        DestinationButt.layer.borderColor = UIColor.lightGray.cgColor
        LogoutBlaceView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        if BBC.count > 0 {
            BBC.removeAllObjects()
        }
    }
    
    //MARK: - MX Segmented Control
    @objc func changeIndex(
        segmentedControl: MXSegmentedControl) {
        if segmentedControl == Segment2 {
            switch Segment2.selectedIndex {
            case 0:
                tbl.tag = 1
                tbl.reloadData()
            case 1:
                tbl.tag = 2
                tbl.reloadData()
            default:
                break
            }
        }
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Public_StationNameListingArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if let lbl = cell?.viewWithTag(1) as? UILabel {
            lbl.text = "\(Public_StationNameListingArr[indexPath.row])"
            if let lbl2 = cell?.viewWithTag(2) as? UILabel {
                if lbl.text == "\(SelectedSourceStation)" {
                    lbl2.text = "START"
                }else if lbl.text == SelectedDestinationStaion {
                    lbl2.text = "END"
                }else {
                    lbl2.text = ""
                }
            }
        }
        if StationIndexArr.contains(indexPath.row) {
            cell?.backgroundColor = UIColor.hexStr(hexStr: "#FFC87D", alpha: 1)
        }else {
            cell?.backgroundColor = UIColor.white
        }
        return cell!
    }
    
    var OriginValueIntex = Int()
    var SecondOriginValueIntex = 2000
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // SelectedSourceStation = "\(StationNameArr[indexPath.row])"
        // SelectedSourceStationID = "\(StationLogicalIDArr[indexPath.row])"
        if ii == 0 {
            if SelectedDestinationStaion != "\(Public_StationNameListingArr[indexPath.row])" {
                OriginButt.setTitle("\(Public_StationNameListingArr[indexPath.row])", for: .normal)
                SelectedSourceStation = "\(Public_StationNameListingArr[indexPath.row])"
                SelectedSourceStationID = "\(Public_StationLogicalIDListingArr[indexPath.row])"
                Public_PositionSourceStation = "\(indexPath.row)"
                SourceStationIntex = Public_StationNameListingArr.index(of: SelectedSourceStation)
                ii = 1
                StationIndexArr = [Int]()
                OriginValueIntex = indexPath.row
                StationIndexArr.insert(indexPath.row, at: 0)
                if SecondOriginValueIntex != 2000 {
                    StationIndexArr.insert(SecondOriginValueIntex, at: 1)
                }
                if StationIndexArr.count > 1 {
                    print("SelectedIndexesArr : \(StationIndexArr)")
                    var One = StationIndexArr[0]
                    var Two = StationIndexArr[1]
                    if Two > One {
                        StationIndexArr = [Int]()
                        for i in One ..< Two + 1 {
                            StationIndexArr.append(i)
                        }
                    }else {
                        StationIndexArr.append(OriginValueIntex)
                        One = StationIndexArr.min()!
                        Two = StationIndexArr.max()!
                        Two += 1
                        StationIndexArr.removeAll()
                        for i in One ..< Two {
                            StationIndexArr.append(i)
                        }
                    }
                }
                tbl.reloadData()
                return
            }
        }else if ii == 1 {
            if SelectedSourceStation != "\(Public_StationNameListingArr[indexPath.row])" {
                DestinationButt.setTitle("\(Public_StationNameListingArr[indexPath.row])", for: .normal)
                SelectedDestinationStaion = "\(Public_StationNameListingArr[indexPath.row])"
                SelectedDestinationID = "\(Public_StationLogicalIDListingArr[indexPath.row])"
                Public_PositionDestinationStation = "\(indexPath.row)"
                DestinationStationIntex = Public_StationNameListingArr.index(of: SelectedDestinationStaion)
                ii = 0
                SecondOriginValueIntex = indexPath.row
                StationIndexArr.removeAll()
                StationIndexArr.append(OriginValueIntex)
                if StationIndexArr.count == 0 {
                    StationIndexArr.insert(indexPath.row, at: 0)
                }else {
                    StationIndexArr.insert(indexPath.row, at: 1)
                }
                print("StationIndexArr 0 : \(StationIndexArr)")
                if StationIndexArr.count > 1 {
                    print("SelectedIndexesArr : \(StationIndexArr)")
                    var One = StationIndexArr[0]
                    var Two = StationIndexArr[1]
                    if Two > One {
                        StationIndexArr = [Int]()
                        for i in One ..< Two + 1 {
                            StationIndexArr.append(i)
                        }
                    }else {
                        StationIndexArr.append(OriginValueIntex)
                        One = StationIndexArr.min()!
                        Two = StationIndexArr.max()!
                        Two += 1
                        StationIndexArr.removeAll()
                        for i in One ..< Two {
                            StationIndexArr.append(i)
                        }
                    }
                }
                tbl.reloadData()
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    var ii = 0
    
    @IBAction func Confirm(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
        }else {
            print("No internet.")
            InternetBlackView.isHidden = false
            return
        }
        if SelectedSourceStation == "" {
            kAppDelegate.shared.showAlert(self, message: "Please select source station")
            return
        }else if SelectedDestinationStaion == ""{
            kAppDelegate.shared.showAlert(self, message: "Please select destination station")
            return
        }
        let StationRouteInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "StationRouteInfoViewController") as! StationRouteInfoViewController
        StationRouteInfoViewController.StationLogicalIDArr = Public_StationLogicalIDListingArr
        StationRouteInfoViewController.SelectedSourceStation = self.SelectedSourceStation
        StationRouteInfoViewController.SelectedDestinationStaion = self.SelectedDestinationStaion
        StationRouteInfoViewController.SelectedSourceStationID = self.SelectedSourceStationID
        StationRouteInfoViewController.SelectedDestinationID = self.SelectedDestinationID
        if SourceStationIntex > DestinationStationIntex {
            NumberArr = NSMutableArray()
            SelcetedStationsArray = NSMutableArray()
            for j in DestinationStationIntex ..< SourceStationIntex + 1 {
                NumberArr.add(j)
                SelcetedStationsArray.add("\(Public_StationNameListingArr[j])")
            }
        }else {
            NumberArr = NSMutableArray()
            SelcetedStationsArray = NSMutableArray()
            for i in SourceStationIntex ..< DestinationStationIntex + 1 {
                print("i is : \(i)")
                NumberArr.add(i)
                SelcetedStationsArray.add("\(Public_StationNameListingArr[i])")
            }
        }
        Public_SourceStationName = SelectedSourceStation
        Public_DestinationStationName = SelectedDestinationStaion
        Public_SourceStationIDs = SelectedSourceStationID
        Public_DestinationStationIDs = SelectedDestinationID
        print("SelcetedStationsArray : \(SelcetedStationsArray)")
        if SelcetedStationsArray.count > 0 {
            if let ff = SelcetedStationsArray[0] as? String {
                if ff == SelectedSourceStation {
                    if BBC.count > 0 {
                        BBC.removeAllObjects()
                    }
                    BBC = SelcetedStationsArray
                }else {
                    let abc = SelcetedStationsArray
                    print("abc : \(abc)")
                    if BBC.count > 0 {
                        BBC.removeAllObjects()
                    }
                    for name in SelcetedStationsArray {
                        BBC.insert("\(name)", at: 0)
                    }
                    print("BBC : \(BBC)")
                }
            }
            print("SelcetedStationsArray 2 : \(SelcetedStationsArray)")
            StationRouteInfoViewController.UserSelectedStations = self.BBC
            self.navigationController?.pushViewController(StationRouteInfoViewController, animated: true)
        }
    }
    
    var BBC = NSMutableArray()
    
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
                if let ticketSerial = dd["ticketSerial"] as? Int  {
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
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
        } catch let error as NSError {
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
        }catch {
            print ("There was an error")
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
