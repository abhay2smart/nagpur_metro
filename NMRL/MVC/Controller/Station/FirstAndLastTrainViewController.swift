//
//  FirstAndLastTrainViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 11/03/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class FirstAndLastTrainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var Segment2              : MXSegmentedControl!
    @IBOutlet var InternetBlackView     : UIView!
    @IBOutlet var tbl                   : UITableView!
    @IBOutlet var btnLogout             : UIButton!
    @IBOutlet var StationLbl            : UILabel!
    
    var Station1            = String()
    var Time1               = String()
    var Station2            = String()
    var Time2               = String()
    var StationName_First   = String()
    
    let timingDict : [String:Any] = ["Mihan Khapri":["inbound":["8:41:42","10:11:42","16:11:42","19:11:42"],"outbound":["8:45:00","11:45:00","17:00:00","19:15:00"]],"New Airport":["inbound":["8:32:18","10:02:18","16:02:18","19:02:18"],"outbound":["8:54:24","11:54:24","17:22:24","19:24:24"]],"Airport South":["inbound":["8:25:12","9:55:12","15:55:12","18:55:12"],"outbound":["9:01:30","12:01:30","17:25:12","19:31:30"]],"Nagpur Airport":["inbound":["8:22:24","9:52:24","15:52:24","18:52:24"],"outbound":["9:04:18","12:04:18","17:32:18","19:34:18"]],"Sitaburdi":["inbound":["8:00:00","9:30:00","15:30:00","18:30:00"],"outbound":["9:26:42","12:26:42","17:41:42","19:56:42"]]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        LogoutBlaceView.isHidden = true
        InternetBlackView.isHidden = true
        Segment2.append(title: "In Bound").set(image: #imageLiteral(resourceName: "TrainBlack")).set(image: .top).set(padding: 15).set(image: #imageLiteral(resourceName: "TrainOrange"), for: .selected)
        Segment2.append(title: "Out Bound").set(image: #imageLiteral(resourceName: "TrainBlack")).set(image: .top).set(padding: 15).set(image: #imageLiteral(resourceName: "TrainOrange"), for: .selected)
        Segment2.textColor = .lightGray
        Segment2.backgroundColor = UIColor.white//UIColor.hexStr(hexStr: "#CC7454", alpha: 1)
        Segment2.indicatorColor = UIColor.hexStr(hexStr: "#FF9300", alpha: 1)
        Segment2.selectedTextColor = UIColor.hexStr(hexStr: "#FF9300", alpha: 1)
        Segment2.addTarget(self, action: #selector(changeIndex(segmentedControl:)), for: .valueChanged)
        // Segment2.separatorColor = UIColor.black.withAlphaComponent(0.5)
        // Segment2.separatorWidth = 0.5
        Segment2.indicatorHeight = 2
        Segment2.font = UIFont(name: "Montserrat-Bold", size: 17)!
        Segment2.indicator.lineHeight = 2
        tbl.tag = 1
        StationLbl.text = StationName_First
        if StationName_First == "Mihan Khapri" {
            Station1 = "Mihan Khapri station"
            Time1 = "6:00 AM"
            Station2 = "Mihan Khapri station"
            Time2 = "10:30 PM"
        }else if StationName_First == "New Airport" {
            Station1 = "New Airport station"
            Time1 = "6:00 AM"
            Station2 = "New Airport station"
            Time2 = "10:35 PM"
        }else if StationName_First == "Airport South" {
            Station1 = "Airport South station"
            Time1 = "6:00 AM"
            Station2 = "Airport South station"
            Time2 = "10:40 PM"
        }else if StationName_First == "Nagpur Airport" {
            Station1 = "Nagpur Airport station"
            Time1 = "6:00 AM"
            Station2 = "Nagpur Airport station"
            Time2 = "10:45 PM"
        }else if StationName_First == "Sitaburdi" {
            Station1 = "Sitabuldi station"
            Time1 = "6:00 AM"
            Station2 = "Sitabuldi station"
            Time2 = "12:05 PM"
        }
        
    }
    
    //MARK: - MX Segmented Control
    @objc func changeIndex(
        segmentedControl: MXSegmentedControl) {
        if segmentedControl == Segment2 {
            switch Segment2.selectedIndex {
            case 0:
                print("Zero")
                tbl.tag = 1
                tbl.reloadData()
            case 1:
                tbl.tag = 2
                tbl.reloadData()
                print("One")
            default:
                break
            }
        }
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tbl.tag == 1 {
            return ((timingDict[StationName_First] as! NSDictionary)["inbound"] as! NSArray).count
        }else {
            return ((timingDict[StationName_First] as! NSDictionary)["outbound"] as! NSArray).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if tbl.tag == 1 {
            if let lbl = cell?.viewWithTag(1) as? UILabel {
                lbl.text = Station1
            }
            if let lbl2 = cell?.viewWithTag(2) as? UILabel {
                lbl2.text = (((timingDict[StationName_First] as! NSDictionary)["inbound"] as! NSArray)[indexPath.row] as! String)
                //Time1
            }
        }else {
            if let lbl = cell?.viewWithTag(1) as? UILabel {
                
                lbl.text = Station2
            }
            if let lbl2 = cell?.viewWithTag(2) as? UILabel {
                
                lbl2.text = (((timingDict[StationName_First] as! NSDictionary)["outbound"] as! NSArray)[indexPath.row] as! String)
                //Time2
            }
        }
        cell?.backgroundColor = UIColor.white
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: - Log Out View
    @IBOutlet var LogoutBlaceView: UIView!
    
    @IBAction func LogOutClicked(_ sender: Any) {
        LogoutBlaceView.isHidden = false
    }
    
    @IBAction func InternetOK(_ sender: Any) {
        InternetBlackView.isHidden = true
    }
    
    @IBAction func LogOK(_ sender: Any) {
        kAppDelegate.shared.logoutCurrentUser { (success) in
            self.LogoutBlaceView.isHidden = true
            self.navigationController?.popToRootViewController(animated: true)
        }
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
        }catch {
            print ("There was an error")
        }
    }
    
    @IBAction func LogCancel(_ sender: Any) {
        LogoutBlaceView.isHidden = true
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
