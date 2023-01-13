//
//  StationContactDrtailsViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 11/03/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI

class StationContactDrtailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var tbl                   : UITableView!
    @IBOutlet var Email                 : UILabel!
    @IBOutlet var btnLogout             : UIButton!
    @IBOutlet var AltNumber             : UILabel!
    @IBOutlet var MobileNumber          : UILabel!
    @IBOutlet var StationNameLbl        : UILabel!
    @IBOutlet var LogoutBlaceView       : UIView!
    @IBOutlet var InternetBlackView     : UIView!
    
    var StationIDStr_Contact        = String()
    var StationNameStr_Contact      = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        LogoutBlaceView.isHidden = true
        InternetBlackView.isHidden = true
        StationNameLbl.text = StationNameStr_Contact
        if StationNameStr_Contact == "Khapri" {
            MobileNumber.text = "07122982026"
            AltNumber.text = "0712-2982006"
            Email.text = "scr.khapri@mahametro.org"
        }else if StationNameStr_Contact == "New Airport" {
            MobileNumber.text = "07122982024"
            AltNumber.text = "0712-2982024"
            Email.text = "scr.southairport@mahametro.org"
        }else if StationNameStr_Contact == "Airport South" {
            MobileNumber.text = "07122982025"
            AltNumber.text = "0712-2982025"
            Email.text = "scr.southairport@mahametro.org"
        }else if StationNameStr_Contact == "Nagpur Airport" {
            MobileNumber.text = "07122812242"
            AltNumber.text = "0712-2982025"
            Email.text = "scr.airport@mahametro.org"
        }else if StationNameStr_Contact == "Sitaburdi" {
            MobileNumber.text = "07122812247"
            AltNumber.text = "0712-2982025"
            Email.text = "scr.sitabuldi@mahametro.org"
        }
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        /*if let lbl = cell?.viewWithTag(1) as? UILabel {
            // lbl.text = "\(indexPath.row + 1)"
        }
        if let lbl2 = cell?.viewWithTag(2) as? UILabel {
            // lbl2.text = "Station \(indexPath.row + 1)"
        }*/
        cell?.backgroundColor = UIColor.white
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    @IBAction func MobileClicked(_ sender: Any) {
        if StationNameStr_Contact == "Khapri" {
            CallNumber(number: "07122982026")
        }else if StationNameStr_Contact == "New Airport" {
            CallNumber(number: "07122982024")
            
        }else if StationNameStr_Contact == "Airport South" {
            CallNumber(number: "07122982025")
        }else if StationNameStr_Contact == "Nagpur Airport" {
            CallNumber(number: "07122812242")
        }else if StationNameStr_Contact == "Sitaburdi" {
            CallNumber(number: "07122812247")
        }
    }
    
    @IBAction func AltMobileClicked(_ sender: Any) {
        if StationNameStr_Contact == "Khapri" {
            CallNumber(number: "0712-2982006")
        }else if StationNameStr_Contact == "New Airport" {
            
            CallNumber(number: "0712-2982024")
        }else if StationNameStr_Contact == "Airport South" {
            CallNumber(number: "0712-2982025")
            
        }else if StationNameStr_Contact == "Nagpur Airport" {
            CallNumber(number: "0712-2982025")
            
        }else if StationNameStr_Contact == "Sitaburdi" {
            CallNumber(number: "0712-2982025")
        }
    }
    
    @IBAction func EmailClicked(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            kAppDelegate.shared.showAlert(self, message: "Please activate your Mail services in your iPhone to send this message.")
            print("Mail services are not available")
            return
        }
        if StationNameStr_Contact == "Khapri"  {
            sendEmail(Email: "scr.khapri@mahametro.org")
        }else if StationNameStr_Contact == "New Airport" {
            sendEmail(Email: "scr.newairport@mahametro.org")
        }else if StationNameStr_Contact == "Airport South" {
            sendEmail(Email: "scr.southairport@mahametro.org")
        }else if StationNameStr_Contact == "Nagpur Airport" {
            sendEmail(Email: "scr.airport@mahametro.org")
        }else if StationNameStr_Contact == "Sitaburdi" {
            sendEmail(Email: "scr.sitabuldi@mahametro.org")
        }
    }
    
    //MARK: - Mail Composer
    func sendEmail(Email : String) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self as MFMailComposeViewControllerDelegate
        composeVC.setToRecipients([Email])
        composeVC.setSubject("Contact")
        composeVC.setMessageBody("", isHTML: false)
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Call Phone
    func CallNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
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
