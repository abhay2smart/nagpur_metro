//
//  Constants.swift
//  MyPort
//
//  Created by Vishnu M P on 24/05/19.
//  Copyright © 2019 MyPort. All rights reserved.
//

import Foundation
import  Alamofire

let kAppDelegate        = UIApplication.shared.delegate as! AppDelegate
let kScreenWidth        = UIScreen.main.bounds.width
let kScreenHeight       = UIScreen.main.bounds.height
let kStoryBoard         = UIStoryboard.init(name: Text.kMainStoryBoardName, bundle: nil)



struct Text {
    static let kMainStoryBoardName      = "Main"
}

struct StoryBoardIds {
    static let kSidemenuTVC      = "MPSidemenuTableViewController"
    static let kHomeVC           = "ViewController"
    static let kLoginTVC         = "LoginViewController"

    
}

struct Alert {
    static let kTitle                   = "My Port"
    static let kLogoutMessage           = "Do you want to logout?"
    
    
    
    
    static let kOk          = "OK"
    static let kCancel      = "Cancel"
}


class CommonFunctions : NSObject {
    
    //MARK:- Get build version
    static func getBuildVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "Ver:\(version) Build:\(build)"
    }
 
    //MARK:- Validation
    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func isValidMobile(testStr:String) -> Bool {
        let mobileRegEx = "^[1{1}]\\s\\d{3}-\\d{3}-\\d{4}$"
        let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
        return mobileTest.evaluate(with: testStr)
    }
    
    //MARK:- Store Current User Data
    func saveLoggedUserdetails(_ dictionary : NSDictionary){
        let data : NSData = NSKeyedArchiver.archivedData(withRootObject: dictionary) as NSData
        UserDefaults.standard.set(data, forKey: "User")
        UserDefaults.standard.synchronize()
    }
    
    //MARK:- Delete Current User
    class func logOutCurrentUser(){
        User.current = nil
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
    }
    
    func getViewContoller(_ controllerId : String) -> UIViewController {
        return kStoryBoard.instantiateViewController(withIdentifier: controllerId)
    }
    
    func getSerializedData(response:DataResponse<Any>)->Data {
        var dataNew : Data?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response.result.value!, options: .prettyPrinted)
            let reqJSONStr = String(data: jsonData, encoding: .utf8)
            dataNew = reqJSONStr!.data(using: String.Encoding.utf8, allowLossyConversion: true)
        }catch let error {
            print(error)
        }
        return dataNew!
    }
}
