//
//  GatesViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 11/03/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit
import Alamofire

class GatesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tbl                   : UITableView!
    @IBOutlet var btnLogout             : UIButton!
    @IBOutlet var StationNameLbl        : UILabel!
    @IBOutlet var LogoutBlaceView       : UIView!
    @IBOutlet var InternetBlackView     : UIView!
    
    var Towards                 = String()
    var StationIDStr_Gate       = String()
    var StationNameStr_Gate     = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        LogoutBlaceView.isHidden = true
        InternetBlackView.isHidden = true
        StationNameLbl.text = StationNameStr_Gate
        if StationNameStr_Gate == "Mihan Khapri" {
            Towards = "Khapri village"
            
        }else if StationNameStr_Gate == "New Airport" {
            Towards = "Purposed new airport"
            
        }else if StationNameStr_Gate == "Airport South" {
            Towards = "Wardha Road"
            
        }else if StationNameStr_Gate == "Nagpur Airport" {
            Towards = "International Airport Road"
            
        }else if StationNameStr_Gate == "Sitaburdi" {
            Towards = "Janki talkies, Mall side, Haldi ram"
        }
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if StationNameStr_Gate == "Sitaburdi" {
        //            return 3
        //        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if let lbl = cell?.viewWithTag(1) as? UILabel {
            lbl.text = "\(indexPath.row + 1)"
        }
        if let lbl2 = cell?.viewWithTag(2) as? UILabel {
            if StationNameStr_Gate == "Sitaburdi" {
                if indexPath.row == 0 {
                    lbl2.text = Towards.components(separatedBy: ",").first!
                }else if indexPath.row == 1 {
                    lbl2.text = "\(Towards.components(separatedBy: ",")[1])"
                }else {
                    lbl2.text = Towards.components(separatedBy: ",").last!
                }
            }else {
                lbl2.text = Towards
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
