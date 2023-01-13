//
//  StationInformationViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 06/03/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class StationInformationViewController: UIViewController {
    
    @IBOutlet var FirstAndLastButt          : UIButton!
    @IBOutlet var PlatformButt              : UIButton!
    @IBOutlet var GatesAndDirectionsButt    : UIButton!
    @IBOutlet var ContactDetailsButt        : UIButton!
    @IBOutlet var TouristSportsButt         : UIButton!
    @IBOutlet var ParkingButt               : UIButton!
    @IBOutlet var FeederButt                : UIButton!
    @IBOutlet var LiftAndEscalatorButt      : UIButton!
    @IBOutlet var DirectionsButt            : UIButton!
    @IBOutlet var InternetBlackView         : UIView!
    @IBOutlet var StationNameLbl            : UILabel!
    @IBOutlet var ToastBlackVw              : UIView!
    @IBOutlet var RedHeading                : UILabel!
    @IBOutlet var LabelValue                : UILabel!
    @IBOutlet var btnLogout                 : UIButton!
    @IBOutlet var LogoutBlaceView           : UIView!
    
    var StationNameStr  = String()
    var StationIDStr    = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        LogoutBlaceView.isHidden = true
        StationNameLbl.text = StationNameStr
        InternetBlackView.isHidden = true
        ToastBlackVw.isHidden = true
        if StationNameStr == "Sitaburdi" {
            TouristSportsButt.setBackgroundImage(#imageLiteral(resourceName: "StationInfo_Tourist"), for: .normal)
        }else {
            TouristSportsButt.setBackgroundImage(#imageLiteral(resourceName: "StationInfo_TouristGray"), for: .normal)
        }
    }
    
    @IBAction func FirstANdLastClicked(_ sender: Any) {
        let FirstAndLastTrainViewController = self.storyboard?.instantiateViewController(withIdentifier: "FirstAndLastTrainViewController") as! FirstAndLastTrainViewController
        FirstAndLastTrainViewController.StationName_First = self.StationNameStr
        self.navigationController?.pushViewController(FirstAndLastTrainViewController, animated: true)
        //  kAppDelegate.shared.showAlert(self, message: "First and last train details not available now.")
    }
    
    @IBAction func PlatformsClicked(_ sender: Any) {
        let PlatformsViewController = self.storyboard?.instantiateViewController(withIdentifier: "PlatformsViewController") as! PlatformsViewController
        PlatformsViewController.StationNameStr_Platform = self.StationNameStr
        PlatformsViewController.StationIDStr_Platform = self.StationIDStr
        self.navigationController?.pushViewController(PlatformsViewController, animated: true)
        //  kAppDelegate.shared.showAlert(self, message: "Platforms details not available now.")
    }
    
    @IBAction func GatesAndDirectionsClicked(_ sender: Any) {
        let GatesViewController = self.storyboard?.instantiateViewController(withIdentifier: "GatesViewController") as! GatesViewController
        GatesViewController.StationNameStr_Gate = self.StationNameStr
        GatesViewController.StationIDStr_Gate = self.StationIDStr
        self.navigationController?.pushViewController(GatesViewController, animated: true)
        //  kAppDelegate.shared.showAlert(self, message: "Gates and directions details not available now.")
    }
    
    @IBAction func ContactDetailsClicked(_ sender: Any) {
        let StationContactDrtailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "StationContactDrtailsViewController") as! StationContactDrtailsViewController
        StationContactDrtailsViewController.StationNameStr_Contact = self.StationNameStr
        StationContactDrtailsViewController.StationIDStr_Contact = self.StationIDStr
        self.navigationController?.pushViewController(StationContactDrtailsViewController, animated: true)
        //   kAppDelegate.shared.showAlert(self, message: "Contact details not available now.")
    }
    
    @IBAction func TouristSpotsClicked(_ sender: Any) {
        if StationNameStr == "Sitaburdi"  {
            let SitaburdiTouristSpotViewController = self.storyboard?.instantiateViewController(withIdentifier: "SitaburdiTouristSpotViewController") as! SitaburdiTouristSpotViewController
            self.navigationController?.pushViewController(SitaburdiTouristSpotViewController, animated: true)
        }
        //  kAppDelegate.shared.showAlert(self, message: "Tourist spot details not available now.")
    }
    
    @IBAction func ParkingClicked(_ sender: Any) {
        RedHeading.text = "Parking"
        LabelValue.text = "Coming soon"
        ToastBlackVw.isHidden = false
        //  kAppDelegate.shared.showAlert(self, message: "Parking details not available now.")
    }
    
    @IBAction func FeederClicked(_ sender: Any) {
        RedHeading.text = "Feeder bus"
        LabelValue.text = "Coming soon"
        ToastBlackVw.isHidden = false
        //    kAppDelegate.shared.showAlert(self, message: "Feeder details not available now.")
    }
    
    @IBAction func LiftAndEscalatorsClicked(_ sender: Any) {
        RedHeading.text = "Escalator"
        LabelValue.text = "Escalator is available"
        ToastBlackVw.isHidden = false
        //   kAppDelegate.shared.showAlert(self, message: "Lift and escalators details not available now.")
    }
    
    @IBAction func DirectionsClicked(_ sender: Any) {
        kAppDelegate.shared.showAlert(self, message: "Directions details not available now.")
    }
    
    @IBAction func HideTostVw(_ sender: Any) {
        ToastBlackVw.isHidden = true
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
        kAppDelegate.shared.deleteAllRecordsFromCoreData()
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
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
