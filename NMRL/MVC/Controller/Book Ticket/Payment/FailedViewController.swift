//
//  FailedViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 02/09/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import Alamofire

var Public_PriceFailed              = String()
var Public_ToStationFailed          = String()
var Public_TicketTypeFailed         = String()
var Public_TimeBookedFailed         = String()
var Public_FromStationFailed        = String()
var Public_PassengerCountFailed     = String()

class FailedViewController: UIViewController {
    
    var FailedMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogoutBlaceView.isHidden = true
        let TemporaryMutableArr = NSMutableArray()
        if UserDefaults.standard.value(forKey: "FailedArray") != nil {
            if let arr = UserDefaults.standard.value(forKey: "FailedArray") as? NSArray {
                if arr.count > 0 {
                    for i in arr {
                        if let j = i as? NSDictionary {
                            TemporaryMutableArr.add(j)
                        }
                    }
                }
            }
        }
        let Dict = NSMutableDictionary()
        Dict["email"] = UserData.current?.customerInfo?.emailAddress!
        Dict["qrTicketStatus"] = "Failed"
        Dict["price"] = Public_PriceFailed
        Dict["Count"] = Public_PassengerCountFailed
        Dict["Time"] = Public_TimeBookedFailed
        Dict["sourceStation1"] = Int(Public_FromStationFailed)
        Dict["destinationStation1"] = Int(Public_ToStationFailed)
        Dict["TicketType"] = Public_TicketTypeFailed
        Dict["ticketSerial"] = 123
        Dict["purchaseDate"] = Public_TimeBookedFailed
        FailedMutableArray.add(Dict)
        TemporaryMutableArr.add(Dict)
        UserDefaults.standard.set(TemporaryMutableArr, forKey: "FailedArray")
        UserDefaults.standard.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    @IBAction func Back(_ sender: Any) {
        var array : [UIViewController] = (self.navigationController?.viewControllers)!
        array.remove(at: array.count - 1)
        array.remove(at: array.count - 1)
        array.remove(at: array.count - 1)
        self.navigationController?.viewControllers = array
        self.navigationController?.popViewController(animated: true)
    }
}
