//
//  ViewController2.swift
//  NMRL
//
//  Created by Akhil Johny on 05/03/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit
import Fabric
import Alamofire
import CoreData
import Crashlytics

var Public_Product_CodeArr          = NSArray()
var PublicMobileStationInforArray   = NSArray()
var Public_Product_qrTicketTypeArr  = NSArray()
var Public_StationInfoMutableArr    = NSMutableArray()
    
class ViewController2: UIViewController, CPSliderDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        @IBOutlet var btnLogout             : UIButton!
        @IBOutlet var LogoutBlaceView       : UIView!
        @IBOutlet var Scroll                : SPSignIn!
        @IBOutlet var ImageSlider           : CPImageSlider!
        @IBOutlet var PageControl           : UIPageControl!
        @IBOutlet var Coll                  : UICollectionView!
        @IBOutlet var ButtonsWhiteVw        : UIView!
        
        var BannerImages                   = NSArray()
        var CollY                          = CGFloat()
        var PageY                          = CGFloat()
        var ButtonsY                       = CGFloat()
        var people: [NSManagedObject]      = []
        var AlreadySavedData               = NSArray()
        var TicketsArr                     = NSArray()
        var Station_LogicalStationIDArr    = NSArray()
        var Mobile_LogicalStationIDArr     = NSArray()
        var Mobile_StationNameArr          = NSArray()
        var StationInfoMutableArr          = NSMutableArray()
        var StationInfoMutableArr_2        = NSMutableArray()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.navigationController?.navigationBar.isHidden = true
            CollY = Coll.frame.origin.y
            PageY = PageControl.frame.origin.y
            ButtonsY = ButtonsWhiteVw.frame.origin.y
            let imageArr = ["Welcome", "Welcome1", "Welcome2"]
            ImageSlider.images = imageArr
            ImageSlider.delegate = self
            ImageSlider.enablePageIndicator = false
            // PageControl.numberOfPages = imageArr.count
            PageControl.currentPage = 0
            // ImageSlider.autoSrcollEnabled = true
            LogoutBlaceView.isHidden = true
            Scroll.contentSize = CGSize(width : 0, height : 1000)
            if DeviceType.IS_IPHONE_5 {
                Scroll.contentSize = CGSize(width : 0, height : 1000)
            }else if DeviceType.IS_IPHONE_6 {
                Scroll.contentSize = CGSize(width : 0, height : 1100)
            }else if DeviceType.IS_IPHONE_6P {
                Scroll.contentSize = CGSize(width : 0, height : 1200)
            }else if DeviceType.IS_IPHONE_X {
                Scroll.contentSize = CGSize(width : 0, height : 1100)
            }else if DeviceType.IS_IPHONE_XP {
                Scroll.contentSize = CGSize(width : 0, height : 1200)
            }
            let vals = getDict()
            print("vals : \(vals)")
            if vals.count > 0 {
                Public_BackOfficeDataDict = vals
            }
            BackOffice()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.GetBannerImages()
            }
            self.logUser()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            if UserData.current?.customerInfo?.emailAddress != nil {
                btnLogout.isHidden = false
            }else {
                btnLogout.isHidden = true
            }
            ReadData()
            Public_SourceStationName = ""
            Public_DestinationStationName = ""
            NotificationCenter.default.addObserver(self, selector: #selector(ChangeIndex(not:)), name: Notification.Name("GetIndexValue"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(BannerImagesReceived(not:)), name: Notification.Name("GotBannerImages"), object: nil)
        }
        
        func logUser() {
            Crashlytics.sharedInstance().setUserEmail(UserData.current?.customerInfo?.emailAddress!)
            Crashlytics.sharedInstance().setUserIdentifier(UserData.current?.customerInfo?.mobileNumber!)
            Crashlytics.sharedInstance().setUserName(UserData.current?.customerInfo?.name!)
        }
        
        func sliderImageTapped(slider: CPImageSlider, index: Int) {
            
        }
        
        @objc func ChangeIndex(not : NSNotification) {
            PageControl.currentPage = not.object as! Int
        }
        
        @objc func BannerImagesReceived(not : NSNotification) {
            if BannerImages.count == 0 {
                GetBannerImages()
            }
        }
        
        //MARK: - Get Banner Images
        func GetBannerImages() {
            print("Banner data : \(PublicBannerImages)")
            let Imgs = self.GetArrayBanner()
            if Imgs.count > 0 {
                BannerImages = Imgs
            }
            if PublicBannerImages.count > 0 {
                if let imageURL = PublicBannerImages.value(forKey: "imageURL") as? NSArray {
                    BannerImages = NSArray()
                    BannerImages = imageURL
                    print("Banner Images : \(BannerImages)")
                    self.SetArrayBanner(dict: BannerImages)
                }
            }
            
            if BannerImages.count > 0 {
                Coll.isHidden = false
                PageControl.isHidden = false
                ButtonsWhiteVw.frame.origin.y = ButtonsY
                Coll.reloadData()
                PageControl.numberOfPages = BannerImages.count
                let _ = Timer.scheduledTimer(timeInterval: 2, target: self,   selector: (#selector(ViewController2.autoScroll)), userInfo: nil, repeats: true)
            }else {
                Coll.isHidden = true
                PageControl.isHidden = true
                ButtonsWhiteVw.frame.origin.y = CollY
            }
        }
        
        var x = 1
        
        @objc func autoScroll() {
            if self.x < self.BannerImages.count {
                let indexPath = IndexPath(item: x, section: 0)
                self.Coll.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                PageControl.currentPage = self.x
                self.x = self.x + 1
            }else {
                self.x = 0
                self.Coll.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                PageControl.currentPage = self.x
            }
        }
        
        @objc func updateBannerImage() {
        }
        
        //MARK: - Collection View
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return BannerImages.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = Coll.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: Coll.frame.width, height: cell.frame.height)
            if let img = cell.viewWithTag(1) as? UIImageView {
                var str = "\(BannerImages[indexPath.row])"
                str = str.replacingOccurrences(of: " ", with: "%20")
                let url = URL.init(string: str)
                img.sd_setImage(with: url , placeholderImage: #imageLiteral(resourceName: "PlaceHolder"))
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: Coll.frame.width, height: Coll.frame.height)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 20
        }
        
        //MARK: - Back Office
        func BackOffice() {
            if Connectivity.isConnectedToInternet() {
                print("Yes! internet is available.")
                
                // do some tasks..
            }else {
                print("No internet.")
                self.BackOfficeOfflineData()
                //InternetBlackView.isHidden = false
                
                return
            }
            
            let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers1 = ["authorization": "Basic \(base64Credentials)"]
            
            let url = "\(APILink)backOfficeInfo2"
            
            // print("url : \(url)") "\(APILink)backOfficeInfo"
            
            // let parameters: [String: Any] = [ "token" : UserData.current!.token! ]
            
            // print(parameters)
            if Public_BackOfficeDataDict.count <= 0 {
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
                SVProgressHUD.show(withStatus: "Loading...")
            }
            sessionManager1.request(url, method : .post, parameters : nil, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                if Public_BackOfficeDataDict.count <= 0 {
                    SVProgressHUD.dismiss()
                }
                dataResponse.result.ifFailure {
                    self.BackOfficeOfflineData()
                }
                
                if let dict = dataResponse.result.value as? NSDictionary {
                    print("dict Back office : \(dict)")
                    Public_BackOfficeDataDict = dict
                    self.setDict(dict: Public_BackOfficeDataDict)
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
                            if let mobileProductInfo = dict["mobileProductInfo"] as? NSArray {
                                if let qrTicketType = mobileProductInfo.value(forKey: "qrTicketType") as? NSArray {
                                    Public_Product_qrTicketTypeArr = qrTicketType
                                }
                                if let code = mobileProductInfo.value(forKey: "code") as? NSArray {
                                    Public_Product_CodeArr = code
                                }
                            }
                            
                            if let mobileLineStationInfo = dict["mobileLineStationInfo"] as? NSArray {
                                if let logicalStationId = mobileLineStationInfo.value(forKey: "logicalStationId") as? NSArray {
                                    self.Station_LogicalStationIDArr = logicalStationId
                                }
                            }
                            
                            if let mobileLineStationInfo = dict["mobileLineStationInfo"] as? NSArray {
                                //   print("mobileLineStationInfo \(mobileLineStationInfo)")
                                PublicMobileStationInforArray = mobileLineStationInfo
                            }
                            
                            if let mobileStationInfo = dict["mobileStationInfo"] as? NSArray {
                                // print("mobileStationInfo \(mobileStationInfo)")
                                if let logicalStationId = mobileStationInfo.value(forKey: "logicalStationId") as? NSArray {
                                    self.Mobile_LogicalStationIDArr = logicalStationId
                                }
                                
                                if let stationName = mobileStationInfo.value(forKey: "stationName") as? NSArray {
                                    self.Mobile_StationNameArr = stationName
                                }
                                
                                self.StationInfoMutableArr_2 = NSMutableArray(array: mobileStationInfo)
                                
                                for i in 0 ..< self.Mobile_LogicalStationIDArr.count {
                                    PublicLogicalStationIDDict.setValue("\(self.Mobile_StationNameArr[i])", forKey: "\(self.Mobile_LogicalStationIDArr[i])")
                                }
                            }
                            
                            // var IndexArr = [Int]()
                            for k in self.Station_LogicalStationIDArr {
                                let val = k as! Int
                                let index = self.Mobile_LogicalStationIDArr.index(of: val)
                                //  IndexArr.append(index) // 3, 0, 1, 2
                                self.StationInfoMutableArr.add(self.StationInfoMutableArr_2[index])
                                Public_StationInfoMutableArr = self.StationInfoMutableArr
                                print("Index : \(index)")
                            }
                            //////////
                            
                            print(print("StationInfoMutableArr 00 : \(self.StationInfoMutableArr_2)"))
                            print(print("StationInfoMutableArr 3 : \(self.StationInfoMutableArr)"))
                            Public_StationNameListingArr = NSArray()
                            if let StationNameArr = self.StationInfoMutableArr.value(forKey: "stationName") as? NSArray {
                                print("StationNameArr : \(StationNameArr)")
                                Public_StationNameListingArr = StationNameArr
                            }
                            Public_StationLogicalIDListingArr = NSArray()
                            if let logicalStationId = self.StationInfoMutableArr.value(forKey: "logicalStationId") as? NSArray {
                                print("logicalStationId : \(logicalStationId)")
                                Public_StationLogicalIDListingArr = logicalStationId
                            }
                        }else if result == 16 {
                            self.LogOK(AnyClass.self)
                        }
                    }
                }
                //   self.BookTicketTbl.reloadData()
                if UserData.current?.token != nil {
                    self.GetLastTicket()
                }
                
                //  self.ReadData()
            }
        }
        
        //MARK: - Back Office Data Offline
        func BackOfficeOfflineData() {
            if Public_BackOfficeDataDict.count == 0 {
                return
            }
            var dict = NSDictionary()
            dict = Public_BackOfficeDataDict
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
                    
                    if let mobileProductInfo = dict["mobileProductInfo"] as? NSArray {
                        if let qrTicketType = mobileProductInfo.value(forKey: "qrTicketType") as? NSArray {
                            Public_Product_qrTicketTypeArr = qrTicketType
                        }
                        
                        if let code = mobileProductInfo.value(forKey: "code") as? NSArray {
                            Public_Product_CodeArr = code
                        }
                    }
                    
                    if let mobileLineStationInfo = dict["mobileLineStationInfo"] as? NSArray {
                        //print("mobileLineStationInfo \(mobileLineStationInfo)")
                        if let logicalStationId = mobileLineStationInfo.value(forKey: "logicalStationId") as? NSArray {
                            self.Station_LogicalStationIDArr = logicalStationId
                        }
                    }
                    
                    if let mobileLineStationInfo = dict["mobileLineStationInfo"] as? NSArray {
                        //   print("mobileLineStationInfo \(mobileLineStationInfo)")
                        PublicMobileStationInforArray = mobileLineStationInfo
                    }
                    
                    if let mobileStationInfo = dict["mobileStationInfo"] as? NSArray {
                        // print("mobileStationInfo \(mobileStationInfo)")
                        if let logicalStationId = mobileStationInfo.value(forKey: "logicalStationId") as? NSArray {
                            self.Mobile_LogicalStationIDArr = logicalStationId
                        }
                        
                        if let stationName = mobileStationInfo.value(forKey: "stationName") as? NSArray {
                            self.Mobile_StationNameArr = stationName
                        }
                        self.StationInfoMutableArr_2 = NSMutableArray(array: mobileStationInfo)
                        for i in 0 ..< self.Mobile_LogicalStationIDArr.count {
                            PublicLogicalStationIDDict.setValue("\(self.Mobile_StationNameArr[i])", forKey: "\(self.Mobile_LogicalStationIDArr[i])")
                        }
                    }
                    // var IndexArr = [Int]()
                    for k in self.Station_LogicalStationIDArr {
                        let val = k as! Int
                        let index = self.Mobile_LogicalStationIDArr.index(of: val)
                        //  IndexArr.append(index) // 3, 0, 1, 2
                        self.StationInfoMutableArr.add(self.StationInfoMutableArr_2[index])
                        Public_StationInfoMutableArr = self.StationInfoMutableArr
                        print("Index : \(index)")
                    }
                    //////////
                    print(print("StationInfoMutableArr 00 : \(self.StationInfoMutableArr_2)"))
                    print(print("StationInfoMutableArr 3 : \(self.StationInfoMutableArr)"))
                    Public_StationNameListingArr = NSArray()
                    if let StationNameArr = self.StationInfoMutableArr.value(forKey: "stationName") as? NSArray {
                        print("StationNameArr : \(StationNameArr)")
                        Public_StationNameListingArr = StationNameArr
                    }
                    Public_StationLogicalIDListingArr = NSArray()
                    if let logicalStationId = self.StationInfoMutableArr.value(forKey: "logicalStationId") as? NSArray {
                        print("logicalStationId : \(logicalStationId)")
                        Public_StationLogicalIDListingArr = logicalStationId
                    }
                }else if result == 16 {
                    self.LogOK(AnyClass.self)
                }
            }
            
        }
        
        //MARK: - Set and Get DIct
        public func setDict(dict: NSDictionary) {
            let data = NSKeyedArchiver.archivedData(withRootObject: dict)
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey:"Public_BackOfficeDataDict")
        }
        
        public func getDict() -> NSDictionary {
            
            if UserDefaults.standard.object(forKey: "Public_BackOfficeDataDict") != nil {
                let data = UserDefaults.standard.object(forKey: "Public_BackOfficeDataDict") as! NSData
                let object = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! NSDictionary
                return object;
            }
            let dict = NSDictionary()
            return dict
        }
        
        //MARK: - Set and Get DIct
        public func SetArrayBanner(dict: NSArray) {
            let data = NSKeyedArchiver.archivedData(withRootObject: dict)
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey:"Public_BannerData")
        }
        
        
        public func GetArrayBanner() -> NSArray {
            if UserDefaults.standard.object(forKey: "Public_BannerData") != nil {
                let data = UserDefaults.standard.object(forKey: "Public_BannerData") as! NSData
                let object = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! NSArray
                return object;
            }
            let dict = NSArray()
            return dict
        }
        
        @IBAction func BookTicketsClicked(_ sender: Any) {
            if Public_BackOfficeDataDict.count == 0 {
                BackOffice()
            }else {
                let BookTicketViewController = self.storyboard?.instantiateViewController(withIdentifier: "BookTicketViewController")
                self.navigationController?.pushViewController(BookTicketViewController!, animated: true)
            }
        }
        
        @IBAction func CardsClicked(_ sender: Any) {
            if Public_BackOfficeDataDict.count > 0 {
                let CardsViewController = self.storyboard?.instantiateViewController(withIdentifier: "CardsViewController")
                self.navigationController?.pushViewController(CardsViewController!, animated: true)
            }else {
                BackOffice()
            }
        }
        
        @IBAction func RoutesClicked(_ sender: Any) {
            if Public_StationNameListingArr.count > 0 {
                let RouteInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "RouteInfoViewController") as! RouteInfoViewController
                self.navigationController?.pushViewController(RouteInfoViewController, animated: true)
            }else {
                BackOffice()
            }
        }
        
        @IBAction func StationInfoClicked(_ sender: Any) {
            if Public_StationNameListingArr.count > 0 {
                let StationInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "StationInfoViewController") as! StationInfoViewController
                self.navigationController?.pushViewController(StationInfoViewController, animated: true)
            }else {
                BackOffice()
            }
        }
        
        @IBAction func NearestStationClcked(_ sender: Any) {
            if Public_StationNameListingArr.count > 0 {
                let NearestStationViewController = self.storyboard?.instantiateViewController(withIdentifier: "NearestStationViewController") as! NearestStationViewController
                self.navigationController?.pushViewController(NearestStationViewController, animated: true)
            }else {
                BackOffice()
            }
        }
        
        @IBAction func TourGuideClcked(_ sender: Any) {
            let TouristSpotViewController = self.storyboard?.instantiateViewController(withIdentifier: "TouristSpotViewController") as! TouristSpotViewController
            self.navigationController?.pushViewController(TouristSpotViewController, animated: true)
        }
        
        @IBAction func SupportClicked(_ sender: Any) {
            if Public_StationNameListingArr.count > 0 {
                //let supportVC = self.storyboard?.instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
                let supportVC = self.storyboard?.instantiateViewController(withIdentifier: "SupportTVC") as! SupportTVC
                self.navigationController?.pushViewController(supportVC, animated: true)
            }else {
                BackOffice()
            }
        }
        
        @IBAction func ContactClicked(_ sender: Any) {
            if UserData.current != nil {
                if Public_BackOfficeDataDict.count > 0 {
                    let contactPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContactPageViewController") as! ContactPageViewController
                    self.navigationController?.pushViewController(contactPageViewController, animated: true)
                }else {
                    BackOffice()
                }
            }else {
                kAppDelegate.shared.showAlert(self, title: Alert.kTitle, message: Alert.kSigninMessage) { (success) in
                    if success  {
                        let landingVC = kStoryBoard.instantiateViewController(withIdentifier: StoryBoardIds.kLandingVC) as! LandingViewController
                        self.navigationController?.pushViewController(landingVC, animated: true)
                    }
                }
            }
        }
        
        @IBAction func NotificationClicked(_ sender: Any) {
            let NotificationPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "NotificationPageViewController") as! NotificationPageViewController
            self.navigationController?.pushViewController(NotificationPageViewController, animated: true)
        }
        
        //MARK: - Ticket History
        func GetLastTicket() {
            if UserData.current?.token != nil {
                let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
                let base64Credentials = credentialData.base64EncodedString(options: [])
                let headers1 = ["authorization": "Basic \(base64Credentials)"]
                
                let url = "\(APILink)ticket/get-last-ticket" //ticketHistory
                
                let parameters: [String: Any] = ["token" : UserData.current!.token!]
                
                sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                    //print(dataResponse.result.value!)
                    if let dict = dataResponse.result.value as? NSDictionary {
                        print("Last ticket : \(dict)")
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
                                if let Last = dict["lastTicketSerial"] as? Int {
                                    print("Last ticket no: \(Last)")
                                    if self.AlreadySavedData.count > 0 {
                                        if let arr1 = self.AlreadySavedData.value(forKey: "ticketSerial") as? NSArray {
                                            if let arr2 = arr1.object(at: 0) as? NSArray {
                                                if arr2.count > 0 {
                                                    if let Saved = ((self.AlreadySavedData.value(forKey: "ticketSerial") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as? Int {
                                                        print("Last Saved ticket no: \(Saved)")
                                                        if Saved != Last {
                                                            print("Not Match")
                                                            self.TicketHistory()
                                                        }else {
                                                            print("Match")
                                                        }
                                                    }
                                                }else {
                                                    self.TicketHistory()
                                                }
                                            }else {
                                                self.TicketHistory()
                                            }
                                        }else {
                                            self.TicketHistory()
                                        }
                                    }else {
                                        self.TicketHistory()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        func TocketCurrentDay() {
            if UserData.current?.token != nil {
                let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
                let base64Credentials = credentialData.base64EncodedString(options: [])
                let headers1 = ["authorization": "Basic \(base64Credentials)"]
                
                print("headers1 : \(headers1)")
                
                let url = "\(APILink)ticketHistoryForCurrentDay"
                
                let parameters: [String: Any] = [ "token" : UserData.current!.token! ]
                
                sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                    if let dict = dataResponse.result.value as? NSDictionary {
                        print("Ticket Current Day : \(dict)")
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
                        self.save(arr: self.TicketsArr)
                    }
                }
            }
        }
        
        func TicketHistory() {
            
            if UserData.current?.token != nil {
                let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
                let base64Credentials = credentialData.base64EncodedString(options: [])
                let headers1 = ["authorization": "Basic \(base64Credentials)"]
                
                print("headers1 : \(headers1)")
                
                let url = "\(APILink)ticketHistory"
                
                let parameters: [String: Any] = [ "token" : UserData.current!.token! ]
                
                sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
                    if let dict = dataResponse.result.value as? NSDictionary {
                        print("Ticket history : \(dict)")
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
                        self.save(arr: self.TicketsArr)
                    }
                }
            }
        }
        
        @IBAction func Back(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }
        
        //MARK: - Logout View
        @IBAction func LogOutClicked(_ sender: Any) {
            LogoutBlaceView.isHidden = false
        }
        
        @IBAction func LogOK(_ sender: Any) {
            kAppDelegate.shared.logoutCurrentUser { (success) in
                self.LogoutBlaceView.isHidden = true
            }
        }
        
        @IBAction func LogCancel(_ sender: Any) {
            LogoutBlaceView.isHidden = true
        }
        
        @IBAction func InternetOK(_ sender: Any) {
             //InternetBlackView.isHidden = true
        }
        
        //MARK: - Core Data
        func save(arr : NSArray) {
            deleteAllRecords()
            let StatusDict = NSMutableDictionary()
            for dic in arr {
                if let dd = dic as? NSDictionary {
                    if let ticketSerial = dd["ticketSerial"] as? Int {
                        if let qrTicketStatus = dd["qrTicketStatus"] as? String {
                            let dict2 = NSMutableDictionary()
                            dict2.setValue(qrTicketStatus, forKey: "Status")
                            dict2.setValue("0", forKey: "EntryCount")
                            dict2.setValue("0", forKey: "ExitCount")
                            StatusDict.setValue(dict2, forKey: "\(ticketSerial)")
                        }
                    }
                }
            }
            
            ////////// Saving Data
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                    return
            }
            let managedContext =
                appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "TicketData",in: managedContext)!
            let person = NSManagedObject(entity: entity,insertInto: managedContext)
            person.setValue(arr, forKeyPath: "tickets")
            print("StatusDict : \(StatusDict)")
            person.setValue(StatusDict, forKeyPath: "ticketstatus2")
            do {
                try managedContext.save()
                people.append(person)
            }catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            ReadData()
        }
        
        func ReadData() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                    return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TicketData")
            do {
                people = try managedContext.fetch(fetchRequest)
            }catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
            let db = people.map { $0.value(forKey: "tickets") as! NSArray}
            AlreadySavedData = db as NSArray
            PublicAlreadySavedData = AlreadySavedData
            
            print("PublicAlreadySavedData : \(PublicAlreadySavedData)")
            
            let dd = people.map({$0.value(forKey: "ticketstatus2") as? NSDictionary})
             print("DD : \(dd)")
            let statusData = people.map { $0.value(forKey: "ticketstatus2") as! NSDictionary}
            
            if statusData.count > 0 {
                Public_AlreadySavedTicketStatusData = NSDictionary()
                Public_AlreadySavedTicketStatusData = statusData[0]
            }
            
            print("AlreadySavedTicketStatusData : \(Public_AlreadySavedTicketStatusData)")
        }
        
        func deleteAllRecords() {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TicketData")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do {
                try context.execute(deleteRequest)
                try context.save()
            }catch {
                print ("There was an error")
            }
        }
    }
