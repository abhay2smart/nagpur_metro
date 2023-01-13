//
//  StationInfoViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 06/03/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class StationInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tbl                   : UITableView!
    @IBOutlet var btnLogout             : UIButton!
    @IBOutlet var InternetBlackView     : UIView!
    @IBOutlet var LogoutBlaceView       : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        InternetBlackView.isHidden = true
        LogoutBlaceView.isHidden = true
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Public_StationNameListingArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if let lbl = cell?.viewWithTag(1) as? UILabel {
            lbl.text = "\(Public_StationNameListingArr[indexPath.row])"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let StationInformationViewController = self.storyboard?.instantiateViewController(withIdentifier: "StationInformationViewController") as! StationInformationViewController
        StationInformationViewController.StationNameStr = "\(Public_StationNameListingArr[indexPath.row])"
        StationInformationViewController.StationIDStr = "\(Public_StationLogicalIDListingArr[indexPath.row])"
        self.navigationController?.pushViewController(StationInformationViewController, animated: true)
    }
    
    //MARK: - Log Out View
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
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
