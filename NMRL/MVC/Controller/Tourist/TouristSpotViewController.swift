//
//  TouristSpotViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 17/04/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit
import Alamofire

class TouristSpotViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tbl                   : UITableView!
    @IBOutlet var btnLogout             : UIButton!
    @IBOutlet var InternetBlackView     : UIView!
    @IBOutlet var LogoutBlaceView       : UIView!
    
    // let ImgArr = [#imageLiteral(resourceName: "Lake"), #imageLiteral(resourceName: "Fort"), #imageLiteral(resourceName: "Zoo")]
    
    //let NameArr = ["AMBAZARI LAKE", "SITABULDI FORT", "MAHARAJBAGH ZOO"]
    
    //let DescArr = ["Ambazari lake is situated near the south west border of Nagpur. In the state of Maharashtra. The lake also has a garden located just beside it known as Ambazari garden. The garden was established in 1958 on an area of 18 acres of land. Public garden on Ambazaari lake featuring walking paths, excercise stations & speakers playing music.", "Sitabuldi Fort, site of the Battle of Sitabuldi in 1817, is located atop a hillock in central Nagpur, Maharashtra, India. The fort was built by Mudhoji II Bhonsle, also known as Appa Sahib Bhosle, of the Kingdom of Nagpur, just before he fought against the British East India Company during the Third Anglo-Maratha War", "Maharajbagh zoo is the central zoo of Nagpur, India. The zoo is located in the heart of the city and has been built on the garden of the Bhonsle and Maratha rulers of the city. The zoo comes under the Central Zoo Authority of India and is maintained by the Panjabrao Deshmukh Krishi Vidyapeeth of Nagpur."]
    
    
    //let NearestStationArr = ["Subhas Ngr", "Sitabuldi Station", "Institution of Engineers"]
    
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
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Arrays.touristPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let obj =  Arrays.touristPlaces[indexPath.row] as NSDictionary
        if let img = cell?.viewWithTag(1) as? UIImageView {
            img.image = UIImage(named: obj["name"] as! String)
        }
        if let name = cell?.viewWithTag(2) as? UILabel {
            name.text = (obj["name"] as! String)
        }
        if let desc = cell?.viewWithTag(3) as? UILabel {
            desc.text = (obj["description"] as! String)
        }
        if let station = cell?.viewWithTag(4) as? UILabel {
            station.text = "Nearest station : \(obj["nearest"] as! String)"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
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
