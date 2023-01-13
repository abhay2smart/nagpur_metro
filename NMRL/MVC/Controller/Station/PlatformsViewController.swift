//
//  PlatformsViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 11/03/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class PlatformsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tbl                   : UITableView!
    @IBOutlet var btnLogout             : UIButton!
    @IBOutlet var StationNameLbl        : UILabel!
    @IBOutlet var InternetBlackView     : UIView!
    
    var Towards1                    = String()
    var Towards2                    = String()
    var StationIDStr_Platform       = String()
    var StationNameStr_Platform     = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        LogoutBlaceView.isHidden = true
        InternetBlackView.isHidden = true
        StationNameLbl.text = StationNameStr_Platform
        if StationNameStr_Platform == "Mihan Khapri" {
            Towards1 = "Sitabuldi station"
            Towards2 = "Sitabuldi"
        }else if StationNameStr_Platform == "New Airport" {
            Towards1 = "Sitabuldi station"
            Towards2 = "Mihan Khapri station"
        }else if StationNameStr_Platform == "Airport South" {
            Towards1 = "Sitabuldi station"
            Towards2 = "Mihan Khapri station"
        }else if StationNameStr_Platform == "Nagpur Airport" {
            Towards1 = "Sitabuldi station"
            Towards2 = "Mihan Khapri station"
        }else if StationNameStr_Platform == "Sitaburdi" {
            Towards1 = "Sitabuldi station"
            Towards2 = "Mihan Khapri station"
        }
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if let lbl = cell?.viewWithTag(1) as? UILabel {
            
            lbl.text = "\(indexPath.row + 1)"
        }
        if let lbl2 = cell?.viewWithTag(2) as? UILabel {
            if indexPath.row == 0 {
                lbl2.text = Towards1
            }else {
                lbl2.text = Towards2
            }
        }
        cell?.backgroundColor = UIColor.white
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
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
    
    @IBAction func LogCancel(_ sender: Any) {
        LogoutBlaceView.isHidden = true
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
 }
