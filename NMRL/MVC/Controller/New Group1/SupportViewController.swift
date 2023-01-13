//
//  SupportViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 26/10/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import Alamofire

class SupportViewController: UIViewController {
    
    @IBOutlet var btnLogout             : UIButton!
    @IBOutlet var LogoutBlaceView       : UIView!
    @IBOutlet var InternetBlackView     : UIView!
    
    //var TicketsArr = NSArray()
    var alreadySavedData = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        LogoutBlaceView.isHidden = true
        InternetBlackView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        alreadySavedData = kAppDelegate.shared.ReadFromCoreData()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
    }
    
    @IBAction func Profile(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
        }else {
            print("No internet.")
            InternetBlackView.isHidden = false
            return
        }
        let MyProfile2ViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyProfile2ViewController") as! MyProfile2ViewController
        self.navigationController?.pushViewController(MyProfile2ViewController, animated: true)
    }
    
    @IBAction func Password(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
        }else {
            print("No internet.")
            InternetBlackView.isHidden = false
            return
        }
        let ChangePassViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassViewController")
        self.navigationController?.pushViewController(ChangePassViewController!, animated: true)
    }
    
    @IBAction func BookedTickets(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
        }else {
            print("No internet.")
            InternetBlackView.isHidden = false
            return
        }
        PublicCheckMyTicekts = 1
        let MyTicketsViewController1 = self.storyboard?.instantiateViewController(withIdentifier: "MyTicketsViewController") as! MyTicketsViewController
        MyTicketsViewController1.TicketsArr = alreadySavedData
        self.navigationController?.pushViewController(MyTicketsViewController1, animated: true)
    }
    
    @IBAction func TransactionHistory(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
        }else {
            print("No internet.")
            InternetBlackView.isHidden = false
            return
        }
        if alreadySavedData.count == 0 {
            // AlreadySavedData = PublicAlreadySavedData
            if UserDefaults.standard.value(forKey: "FailedArray") != nil {
                if let abc = UserDefaults.standard.value(forKey: "FailedArray") as? NSArray {
                    if abc.count > 0 {
                        if let email = abc.value(forKey: "email") as? NSArray {
                            print("Email array : \(email)")
                            if let currentEmail = UserData.current?.customerInfo?.emailAddress {
                                if email.contains(currentEmail) {
                                    let TransactionHistoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "TransactionHistoryViewController") as! TransactionHistory1ViewController //##
                                    TransactionHistoryViewController.TicketsArr = alreadySavedData
                                    self.navigationController?.pushViewController(TransactionHistoryViewController, animated: true)
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        if alreadySavedData.count > 0 {
            print("AlreadySavedData : \(alreadySavedData)")
            let TransactionHistoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "TransactionHistoryViewController") as! TransactionHistory1ViewController //##
            TransactionHistoryViewController.TicketsArr = alreadySavedData
            self.navigationController?.pushViewController(TransactionHistoryViewController, animated: true)
        }else {
            kAppDelegate.shared.showAlert(self, message: "No transaction history available.")
        }
    }
    
    @IBAction func ContactUs(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
        }else {
            print("No internet.")
            InternetBlackView.isHidden = false
            return
        }
        let SupportCenterViewController = self.storyboard?.instantiateViewController(withIdentifier: "SupportCenterViewController") as! SupportCenterViewController
        self.navigationController?.pushViewController(SupportCenterViewController, animated: true)
    }
    
    @IBAction func Dos(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
        }else {
            print("No internet.")
            InternetBlackView.isHidden = false
            return
        }
        let DosViewController = self.storyboard?.instantiateViewController(withIdentifier: "DosViewController") as! DosViewController
        self.navigationController?.pushViewController(DosViewController, animated: true)
    }
    
    //MARK: - Log Out View
    @IBAction func LogOutClicked(_ sender: Any) {
        LogoutBlaceView.isHidden = false
    }
    
    @IBAction func LogCancel(_ sender: Any) {
        LogoutBlaceView.isHidden = true
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
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
