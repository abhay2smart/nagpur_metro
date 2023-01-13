//
//  NearestStationViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 25/10/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import GoogleMaps
import CoreData
import GooglePlaces
import CoreLocation

class NearestStationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var tbl                   : UITableView!
    @IBOutlet var btnLogout             : UIButton!
    @IBOutlet var Segment2              : MXSegmentedControl!
    @IBOutlet var ChangeLocButt         : UIButton!
    @IBOutlet var StationNameLbl        : UILabel!
    @IBOutlet var InternetBlackView     : UIView!
    @IBOutlet var LogoutBlaceView       : UIView!
    
    var StationNameArr                  = NSMutableArray()
    var StationNameArr2                 = NSMutableArray()
    var StationLogicalIDArr             = NSArray()
    var SelectedSourceStation           = String()
    var SelectedDestinationStaion       = String()
    var SelectedSourceStationID         = String()
    var SelectedDestinationID           = String()
    var StationLocationCordinatesArray  = [CLLocation]()
    var UsersCurrentLocation            = CLLocation()
    var LatitudeArray                   = NSArray()
    var LongitudeArray                  = NSArray()
    var Distance                        = NSArray()
    var InfoLogicalIDArr                = NSArray()
    let locManager                      = CLLocationManager()
    var DelayCheck                      = 0
    var DistanceIntArr                  = [Int]()
    var DistanceIntArrSorted            = [Int]()
    var DistanceFromUser                = [CLLocationDistance]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserData.current?.customerInfo?.emailAddress != nil {
            btnLogout.isHidden = false
        }else {
            btnLogout.isHidden = true
        }
        GMSPlacesClient.provideAPIKey("AIzaSyAi_OmXeHOVUyKfd3vRzgYiVyU0v1etCFM")
        InternetBlackView.isHidden = true
        Segment2.append(title: "By Location").set(image: #imageLiteral(resourceName: "LocationBlack")).set(image: .top).set(padding: 15).set(image: #imageLiteral(resourceName: "LocationGreen"), for: .selected)
        Segment2.append(title: "By Address").set(image: #imageLiteral(resourceName: "AddressBlack")).set(image: .top).set(padding: 15).set(image: #imageLiteral(resourceName: "AddressGreen"), for: .selected)
        Segment2.textColor = .lightGray
        Segment2.backgroundColor = UIColor.white//UIColor.hexStr(hexStr: "#CC7454", alpha: 1)
        Segment2.indicatorColor = UIColor.hexStr(hexStr: "#FF9300", alpha: 1)
        Segment2.selectedTextColor = UIColor.hexStr(hexStr: "#FF9300", alpha: 1)
        Segment2.addTarget(self, action: #selector(changeIndex(segmentedControl:)), for: .valueChanged)
        Segment2.separatorColor = UIColor.black.withAlphaComponent(0.5)
        Segment2.separatorWidth = 0.5
        Segment2.indicatorHeight = 2
        Segment2.font = UIFont(name: "Montserrat-Bold", size: 17)!
        Segment2.indicator.lineHeight = 3
        tbl.tag = 1
        ChangeLocButt.Underline()
        locManager.requestWhenInUseAuthorization()
        locManager.requestAlwaysAuthorization()
        locManager.requestWhenInUseAuthorization()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        if let stationName = Public_StationInfoMutableArr.value(forKey: "stationName") as? NSArray {
            self.StationNameArr = NSMutableArray(array: stationName)
        }
        if let logicalStationId = Public_StationInfoMutableArr.value(forKey: "logicalStationId") as? NSArray {
            self.StationLogicalIDArr = logicalStationId
        }
        if let latitude = Public_StationInfoMutableArr.value(forKey: "latitude") as? NSArray {
            self.LatitudeArray = latitude
        }
        if let longitude = Public_StationInfoMutableArr.value(forKey: "longitude") as? NSArray {
            self.LongitudeArray = longitude
        }
        LogoutBlaceView.isHidden = true
        if let distance = PublicMobileStationInforArray.value(forKey: "distance") as? NSArray {
            Distance = distance
        }
        if let logicalStationId = PublicMobileStationInforArray.value(forKey: "logicalStationId") as? NSArray {
            InfoLogicalIDArr = logicalStationId
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.DelayCheck = 1
            self.UserNearByStation()
        }
    }
    
    func UserNearByStation() {
        for d in 0 ..< Public_StationInfoMutableArr.count {
            let Dict = Public_StationInfoMutableArr[d] as! NSDictionary
            let latt = Dict["latitude"] as! String
            let long = Dict["longitude"] as! String
            let Coordiante : CLLocation = CLLocation(latitude: Double(latt)!, longitude: Double(long)!)
            StationLocationCordinatesArray.append(Coordiante)
        }
        closestLoc(userLocation: UsersCurrentLocation)
    }
    
    func closestLoc(userLocation:CLLocation) {
        var distances = [CLLocationDistance]()
        DistanceFromUser.removeAll()
        DistanceIntArr.removeAll()
        DistanceIntArrSorted.removeAll()
        for location in StationLocationCordinatesArray {
            let coord = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            distances.append(coord.distance(from: userLocation))
            DistanceFromUser.append(coord.distance(from: userLocation))
        }
        let closest = distances.min()//shortest distance
        let position = distances.index(of: closest!)//index of shortest distance
        let CloseStation = StationLocationCordinatesArray[position!]
        for i in 0 ..< LatitudeArray.count {
            let j = "\(LatitudeArray[i])"
            if j == "\(CloseStation.coordinate.latitude.dollarString)" {
                let ids = StationLogicalIDArr[i]
                _ = InfoLogicalIDArr.index(of: "\(ids)")
            }
        }
        for j in DistanceFromUser {
            let jj = Int(j)
            DistanceIntArr.append(jj)
            DistanceIntArrSorted.append(jj)
        }
        DistanceIntArrSorted = DistanceIntArrSorted.sorted{ $0 < $1 }
        StationNameArr2.removeAllObjects()
        for j in DistanceIntArrSorted {
            let ii = DistanceIntArr.index(of: j)
            StationNameArr2.add(StationNameArr[ii!])
        }
        tbl.reloadData()
    }
    
    //MARK: - Current Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        UsersCurrentLocation = manager.location!
        print("UsersCurrentLocation : \(UsersCurrentLocation)")
        convertLatLongToAddress(latitude: UsersCurrentLocation.coordinate.latitude, longitude: UsersCurrentLocation.coordinate.longitude)
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            UsersCurrentLocation = manager.location!
        }
    }
    
    //MARK: - convertLatLongToAddress
    func convertLatLongToAddress(latitude:Double,longitude:Double){
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            var Str = "a"
            if let locationName = placeMark.location {
                print(locationName)
            }
            if let street = placeMark.thoroughfare {
                Str = street
                print(street)
            }
            if let city = placeMark.subAdministrativeArea {
                print(city)
                if Str != "a" {
                    self.StationNameLbl.text = "\(Str), \(city)."
                }else {
                    self.StationNameLbl.text = "\(city)."
                }
            }
            if let zip = placeMark.isoCountryCode {
                print(zip)
            }
            if let country = placeMark.country {
                print(country)
            }
        })
    }
    
    //MARK: - MX Segmented Control
    @objc func changeIndex(
        segmentedControl: MXSegmentedControl) {
        if segmentedControl == Segment2 {
            switch Segment2.selectedIndex {
            case 0:
                print("Zero")
                closestLoc(userLocation: UsersCurrentLocation)
            case 1:
                let placePickerController = GMSAutocompleteViewController()
                placePickerController.delegate = self
                present(placePickerController, animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DelayCheck == 0 {
            return 0
        }
        return StationNameArr2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if let lbl = cell?.viewWithTag(1) as? UILabel {
            lbl.text = "\(StationNameArr2[indexPath.row])"
        }
        if let lbl2 = cell?.viewWithTag(2) as? UILabel {
            let ii = DistanceIntArrSorted[indexPath.row]/1000
            lbl2.text = "\(ii) KMS"
        }
        cell?.backgroundColor = UIColor.white
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected station  \(StationNameArr2[indexPath.row])")
        let ind = StationNameArr.index(of: "\(StationNameArr2[indexPath.row])")
        print("Index : \(ind)")
        OpenGoogleMaps(lat: "\(LatitudeArray[ind])", long: "\(LongitudeArray[ind])")
    }
    
    func OpenGoogleMaps(lat : String, long : String) {
        if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
            UIApplication.shared.open(url, options: [:])
        }else {
            let url = "http://maps.apple.com/maps?saddr=\(lat),\(long)"
            UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @IBAction func CHangeLocation(_ sender: Any) {
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        present(placePickerController, animated: true, completion: nil)
    }
    
    @IBAction func Confirm(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
        
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


extension NearestStationViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place Location : \(place.coordinate)")
        let center = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        closestLoc(userLocation: center)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        Segment2.select(index: 0, animated: false)
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
