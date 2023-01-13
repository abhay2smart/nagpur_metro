//
//  CardsViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 09/04/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit

import Alamofire

import CoreData

class CardsViewController: UIViewController {

    @IBOutlet var Scroll: SPSignIn!
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
     
    
    @IBOutlet var InternetBlackView: UIView!
    
//    @IBOutlet var CardButt1: UIButton!
//    @IBOutlet var CardButt2: UIButton!
//    @IBOutlet var CardButt3: UIButton!
    
    @IBOutlet var btnLogout: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        InternetBlackView.isHidden = true
        
        LogoutBlaceView.isHidden = true
   
        
//        CardButt1.setBackgroundImage(#imageLiteral(resourceName: "RadioON"), for: .normal)
//        CardButt2.setBackgroundImage(#imageLiteral(resourceName: "RadioOFF"), for: .normal)
//        CardButt3.setBackgroundImage(#imageLiteral(resourceName: "RadioOFF"), for: .normal)

        // Do any additional setup after loading the view.
    }
    
    //MARK: - ACTIONS
    
    @IBAction func Card1(_ sender: Any) {
        
        
//        CardButt1.setBackgroundImage(#imageLiteral(resourceName: "RadioON"), for: .normal)
//        CardButt2.setBackgroundImage(#imageLiteral(resourceName: "RadioOFF"), for: .normal)
//        CardButt3.setBackgroundImage(#imageLiteral(resourceName: "RadioOFF"), for: .normal)
    }
    
    @IBAction func Card2(_ sender: Any) {
//        CardButt1.setBackgroundImage(#imageLiteral(resourceName: "RadioOFF"), for: .normal)
//        CardButt2.setBackgroundImage(#imageLiteral(resourceName: "RadioON"), for: .normal)
//        CardButt3.setBackgroundImage(#imageLiteral(resourceName: "RadioOFF"), for: .normal)
    }
    
    @IBAction func Card3(_ sender: Any) {
//        CardButt1.setBackgroundImage(#imageLiteral(resourceName: "RadioOFF"), for: .normal)
//        CardButt2.setBackgroundImage(#imageLiteral(resourceName: "RadioOFF"), for: .normal)
//        CardButt3.setBackgroundImage(#imageLiteral(resourceName: "RadioON"), for: .normal)
    }
    
    @IBAction func InternetOK(_ sender: Any) {
        
        InternetBlackView.isHidden = true
    }
    
    @IBAction func LogCancel(_ sender: Any) {
        
        LogoutBlaceView.isHidden = true
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

}
