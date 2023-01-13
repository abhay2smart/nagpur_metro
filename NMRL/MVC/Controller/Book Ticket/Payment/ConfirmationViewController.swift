//
//  ConfirmationViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 09/08/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import Alamofire

class ConfirmationViewController: UIViewController {
    
    @IBOutlet var TicketButt: UIButton!
    @IBOutlet var ConditionsVw: UIView!
    @IBOutlet var Scroll: UIScrollView!
    
    var TicketsArr = NSArray()
    var AlreadySavedData = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DeviceType.IS_IPHONE_5 {
            Scroll.contentSize = CGSize(width : 0, height : 2120)
        }else if DeviceType.IS_IPHONE_6 {
            Scroll.contentSize = CGSize(width : 0, height : 2220)
        }else if DeviceType.IS_IPHONE_6P {
            Scroll.contentSize = CGSize(width : 0, height : 2420)
        }else if DeviceType.IS_IPHONE_X {
            Scroll.contentSize = CGSize(width : 0, height : 2520)
        }else if DeviceType.IS_IPHONE_XP {
            Scroll.contentSize = CGSize(width : 0, height : 2620)
        }
        ConditionsVw.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AlreadySavedData = kAppDelegate.shared.ReadFromCoreData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ShowConditions(_ sender: Any) {
        ConditionsVw.isHidden = false
    }
    
    @IBAction func HideConditions(_ sender: Any) {
        ConditionsVw.isHidden = true
    }
    
    func TocketHistory() {
        if UserData.current?.token != nil {
            let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers1 = ["authorization": "Basic \(base64Credentials)"]
            
            let url = "\(APILink)ticketHistory"
            
            sessionManager1.request(url, method : .post, parameters : ["token" : UserData.current!.token!,], encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                print(dataResponse.result.value!)
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
                            if let arr = dict["tickets"] as? NSArray {
                                self.TicketsArr = arr
                            }
                        }
                    }
                }
                if self.TicketsArr.count > 0 {
                    kAppDelegate.shared.saveToCoreData(self.TicketsArr)
                }
            }
        }
    }
    
    @IBAction func ViewTucket(sender : Any) {
        PublicCheckMyTicekts = 0
        AlreadySavedData = kAppDelegate.shared.ReadFromCoreData()
        sleep(UInt32(0.1))
        let MyTicketsViewController1 = self.storyboard?.instantiateViewController(withIdentifier: "MyTicketsViewController") as! MyTicketsViewController
        MyTicketsViewController1.TicketsArr = AlreadySavedData
        self.navigationController?.pushViewController(MyTicketsViewController1, animated: true)
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
