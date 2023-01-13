//
//  SupportTVC.swift
//  NMRL
//
//  Created by Akhil Johny on 09/06/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class SupportTVC: UITableViewController {
    
    @IBOutlet var btnLogout             : UIButton!
    @IBOutlet var btnProfile            : UIButton!
    @IBOutlet var btnChangePassword     : UIButton!
    @IBOutlet var btnBookTickets        : UIButton!
    @IBOutlet var btnHistory            : UIButton!
    @IBOutlet var btnDoDntDo            : UIButton!
    
    var arrayHeight = [Double]()
    var AlreadySavedData = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnProfile.dropShadow()
        btnChangePassword.dropShadow()
        btnBookTickets.dropShadow()
        btnHistory.dropShadow()
        btnDoDntDo.dropShadow()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
           arrayHeight =  [100.0,70,70,70,70]
        }else {
             btnLogout.isHidden = true
             arrayHeight =  [0,0,0,0,100]
        }
        let imgVw = UIImageView()
        imgVw.image = UIImage(named: "SupportTVC")
        self.tableView.backgroundView = imgVw
        AlreadySavedData = kAppDelegate.shared.ReadFromCoreData()
        
    }
    
    @IBAction func buttonProfileTouched(_ sender: UIButton) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }else {
            print("No internet.")
            kAppDelegate.shared.showAlert(self,title: "No Internet Connection", message: "You need to have Mobile Data or wifi connection to access this. Press OK to Exit.")

            return
        }
        let MyProfile2ViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyProfile2ViewController") as! MyProfile2ViewController
        self.navigationController?.pushViewController(MyProfile2ViewController, animated: true)
    }
    
    @IBAction func buttonChangePasswordTouched(_ sender: UIButton) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }else {
            print("No internet.")
            kAppDelegate.shared.showAlert(self,title: "No Internet Connection", message: "You need to have Mobile Data or wifi connection to access this. Press OK to Exit.")
            return
        }
        let ChangePassViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassViewController")
        self.navigationController?.pushViewController(ChangePassViewController!, animated: true)
    }
    
    @IBAction func buttonBookTicketsTouched(_ sender: UIButton) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }else {
            print("No internet.")
            kAppDelegate.shared.showAlert(self,title: "No Internet Connection", message: "You need to have Mobile Data or wifi connection to access this. Press OK to Exit.")

            return
        }
        PublicCheckMyTicekts = 1
        let MyTicketsViewController1 = self.storyboard?.instantiateViewController(withIdentifier: "MyTicketsViewController") as! MyTicketsViewController
        MyTicketsViewController1.TicketsArr = AlreadySavedData
        self.navigationController?.pushViewController(MyTicketsViewController1, animated: true)
        
    }
    
    @IBAction func buttonHistoryTouched(_ sender: UIButton) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }else {
            print("No internet.")
            kAppDelegate.shared.showAlert(self,title: "No Internet Connection", message: "You need to have Mobile Data or wifi connection to access this. Press OK to Exit.")

            return
        }
        
        if AlreadySavedData.count == 0 {
            // AlreadySavedData = PublicAlreadySavedData
            if UserDefaults.standard.value(forKey: "FailedArray") != nil {
                if let abc = UserDefaults.standard.value(forKey: "FailedArray") as? NSArray {
                    if abc.count > 0 {
                        if let email = abc.value(forKey: "email") as? NSArray {
                            print("Email array : \(email)")
                            if email.contains((UserData.current?.customerInfo!.emailAddress)!) {
                                let TransactionHistoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "TransactionHistoryViewController") as! TransactionHistory1ViewController //##
                                TransactionHistoryViewController.TicketsArr = AlreadySavedData
                                self.navigationController?.pushViewController(TransactionHistoryViewController, animated: true)
                                return
                            }
                        }
                    }
                }
            }
        }
        if AlreadySavedData.count > 0 {
            print("AlreadySavedData : \(AlreadySavedData)")
            let TransactionHistoryViewController = self.storyboard?.instantiateViewController(withIdentifier: "TransactionHistoryViewController") as! TransactionHistory1ViewController //##
            TransactionHistoryViewController.TicketsArr = AlreadySavedData
            self.navigationController?.pushViewController(TransactionHistoryViewController, animated: true)
        }else {
            kAppDelegate.shared.showAlert(self, message: "No transaction history available.")
        }
    }
    
    @IBAction func buttonDoAndDontDoTouched(_ sender: UIButton) {
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
        }else {
            print("No internet.")
            kAppDelegate.shared.showAlert(self,title: "No Internet Connection", message: "You need to have Mobile Data or wifi connection to access this. Press OK to Exit.")

            return
        }
        let DosViewController = self.storyboard?.instantiateViewController(withIdentifier: "DosViewController") as! DosViewController
        self.navigationController?.pushViewController(DosViewController, animated: true)
    }
    
    @IBAction func buttonlogoutTouched(_ sender: UIButton) {
        kAppDelegate.shared.showAlert(self, title: "Really Exit?", message: "Are you sure you want to exit?") { (success) in
            if success {
                Public_SourceStationName = String()
                Public_DestinationStationName = String()
                Public_SourceStationName = String()
                Public_DestinationStationName = String()
                kAppDelegate.shared.logoutCurrentUser(completion: { (success) in
                    
                })
            }
        }
    }
    
    @IBAction func buttonBackTouched(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(arrayHeight[indexPath.row])
    }
    
    func logout() {
        Public_SourceStationName = String()
        Public_DestinationStationName = String()
        Public_SourceStationName = String()
        Public_DestinationStationName = String()
        kAppDelegate.shared.logoutCurrentUser { (success) in
        }
    }
}
