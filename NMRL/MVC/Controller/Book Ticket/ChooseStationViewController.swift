//
//  ChooseStationViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 14/09/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit

var Public_SourceStationIDs         = String()
var Public_SourceStationName        = String()
var Public_DestinationStationIDs    = String()
var Public_DestinationStationName   = String()

class ChooseStationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tbl           : UITableView!
    @IBOutlet var Segment2      : MXSegmentedControl!
    @IBOutlet var ConfirmButt   : UIButton!
    
    var SelectedSourceStation       = String()
    var SelectedDestinationStaion   = String()
    var SelectedSourceStationID     = String()
    var SelectedDestinationID       = String()
    var SelectedIndexesArr          = [Int]()
    var OriginValueIntex            = Int()
    // var StationNameArr = NSArray()
    // var StationLogicalIDArr = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Segment2.append(title: "BUY & RECHARGE").set(image: #imageLiteral(resourceName: "PlanBlackImage")).set(image: .top).set(padding: 10).set(image: #imageLiteral(resourceName: "PlanImage"), for: .selected)
        // Segment2.append(title: "PLAN A JOURNEY").set(image: #imageLiteral(resourceName: "BookBlackImage")).set(image: .top).set(padding: 10).set(image: #imageLiteral(resourceName: "BookImage"), for: .selected)
        Segment2.append(title: "ORIGIN")
        Segment2.append(title: "DESTINATION")
        Segment2.textColor = .lightGray
        Segment2.backgroundColor = UIColor.white//UIColor.hexStr(hexStr: "#CC7454", alpha: 1)
        Segment2.indicatorColor = UIColor.hexStr(hexStr: "#CC7454", alpha: 1)
        Segment2.selectedTextColor = UIColor.black
        Segment2.addTarget(self, action: #selector(changeIndex(segmentedControl:)), for: .valueChanged)
        Segment2.font = UIFont(name: "Montserrat-Regular", size: 13)!
        tbl.tag = 1
        // tbl.backgroundColor = UIColor.lightGray
    }
    
    //MARK: - MX Segmented Control
    @objc func changeIndex(
        segmentedControl: MXSegmentedControl) {
        if segmentedControl == Segment2 {
            switch Segment2.selectedIndex {
            case 0:
                tbl.tag = 1
                tbl.reloadData()
            case 1:
                tbl.tag = 2
                tbl.reloadData()
            default:
                break
            }
        }
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Public_StationNameListingArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if tbl.tag == 1 {
            if let lbl = cell?.viewWithTag(1) as? UILabel {
                lbl.text = "\(Public_StationNameListingArr[indexPath.row])"
            }
            if let lbl2 = cell?.viewWithTag(2) as? UILabel {
                lbl2.text = ""
            }
            cell?.backgroundColor = UIColor.white
        }else {
            if let lbl = cell?.viewWithTag(1) as? UILabel {
                lbl.text = "\(Public_StationNameListingArr[indexPath.row])"
                if let lbl2 = cell?.viewWithTag(2) as? UILabel {
                    if SelectedSourceStation == lbl.text! {
                        lbl2.text = "START"
                        lbl2.textColor = .black
                        cell?.backgroundColor = UIColor.green
                    }else {
                        lbl2.text = ""
                        // cell?.backgroundColor = UIColor.white
                    }
                    if lbl2.text != "START" {
                        if SelectedDestinationStaion == lbl.text! {
                            lbl2.text = "END"
                            lbl2.textColor = .black
                            //  cell?.backgroundColor = UIColor.green
                        }else {
                            lbl2.text = ""
                            // cell?.backgroundColor = UIColor.white
                        }
                    }
                    if SelectedIndexesArr.contains(indexPath.row) {
                        cell?.backgroundColor = UIColor.hexStr(hexStr: "#FFC87D", alpha: 1)
                    }else {
                        cell?.backgroundColor = UIColor.white
                    }
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tbl.tag == 1 {
            SelectedSourceStation = "\(Public_StationNameListingArr[indexPath.row])"
            SelectedSourceStationID = "\(Public_StationLogicalIDListingArr[indexPath.row])"
            // Public_SourceStationIDs = SelectedSourceStationID
            tbl.tag = 2
            SelectedIndexesArr = [Int]()
            SelectedDestinationStaion = String()
            OriginValueIntex = indexPath.row
            SelectedIndexesArr.insert(indexPath.row, at: 0)
            Segment2.select(index: 1, animated: true)
        }else {
            if SelectedSourceStation == "" {
                Segment2.select(index: 0, animated: true)
                kAppDelegate.shared.showAlert(self, message: "Please select origin station")
                return
            }
            SelectedIndexesArr.removeAll()
            SelectedIndexesArr.append(OriginValueIntex)
            if SelectedSourceStation != "\(Public_StationNameListingArr[indexPath.row])" {
                SelectedDestinationStaion = "\(Public_StationNameListingArr[indexPath.row])"
                SelectedDestinationID = "\(Public_StationLogicalIDListingArr[indexPath.row])"
                //  Public_DestinationStationIDs = SelectedDestinationID
                if SelectedIndexesArr.count == 0 {
                    SelectedIndexesArr.insert(indexPath.row, at: 0)
                }else {
                    SelectedIndexesArr.insert(indexPath.row, at: 1)
                }
                print("SelectedIndexesArr 0 : \(SelectedIndexesArr)")
                if SelectedIndexesArr.count > 1 {
                    print("SelectedIndexesArr : \(SelectedIndexesArr)")
                    var One = SelectedIndexesArr[0]
                    var Two = SelectedIndexesArr[1]
                    if Two > One {
                        SelectedIndexesArr = [Int]()
                        for i in One ..< Two + 1 {
                            SelectedIndexesArr.append(i)
                        }
                    }else {
                        SelectedIndexesArr.append(OriginValueIntex)
                        One = SelectedIndexesArr.min()!
                        Two = SelectedIndexesArr.max()!
                        Two += 1
                        SelectedIndexesArr.removeAll()
                        for i in One ..< Two {
                            SelectedIndexesArr.append(i)
                        }
                    }
                }
            }
        }
        tbl.reloadData()
    }
    
    @IBAction func Confirm(_ sender: Any) {
        if SelectedSourceStation == "" {
            kAppDelegate.shared.showAlert(self, message: "Please select source station.")
        }else if SelectedDestinationStaion == "" {
            kAppDelegate.shared.showAlert(self, message: "Please select destination station.")
        }else {
            Public_SourceStationName = SelectedSourceStation
            Public_DestinationStationName = SelectedDestinationStaion
            Public_SourceStationIDs = SelectedSourceStationID
            Public_DestinationStationIDs = SelectedDestinationID
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
