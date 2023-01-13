//
//  AppDelegate.swift
//  NMRL
//
//  Created by Akhil Johny on 20/07/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import Firebase
import Fabric
import Crashlytics
import UserNotifications
//import FirebaseMessaging

let app = UIApplication.shared.delegate as! AppDelegate

//let APILink = "http://84.241.12.180:4547/afc/api/mobileApplicationService/"
//let APILink = "http://84.241.12.180:4646/afc/api/mobileApplicationService/"

//let APILink = "http://121.46.94.23:8080/afc/api/mobileApplicationService/" // Test server Nagpur

//let APILink = "https://117.203.240.74:8181/afc/api/mobileApplicationService/" //Test server NMRC

//let APILink = "https://mobile.ticketsnmrc.com/afc/api/mobileApplicationService/" //Original Noida Ticke®t server

//let APILink = "http://10.254.254.28:8080/afc/api/mobileApplicationService/" //Local Server

//let APILink = "http://10.254.254.82:8080/afc/api/mobileApplicationService/" //Local Server 2

let APILink = "https://nagpurmobileapp.mahametro.org/afc/api/mobileApplicationService/" // Nagpur Original Server


let AuthUser = "mobileuser"
let AuthPass = "Mobile201754321"

var TokenStr = String()

var OTPPageHeading = String()

var PublicBannerImages = NSArray()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let ViewCon = ViewController()
    
    var TabIndex = 0
    
    var sideArray = ["My Tickets", "My Profile", "History", "City Guide", "Change Password", "Log out"]
    
    var InactiveArr = [#imageLiteral(resourceName: "SIdeTicketsInactive"), #imageLiteral(resourceName: "SideProfileInactive"), #imageLiteral(resourceName: "SideHistoryInactive"), #imageLiteral(resourceName: "SideCityGuideInactive"), #imageLiteral(resourceName: "SideChangePassInactive"), #imageLiteral(resourceName: "SideLogoutInactive")]
    
    var ActiveArr = [#imageLiteral(resourceName: "SideTicketsActive"), #imageLiteral(resourceName: "SideProfileActive"), #imageLiteral(resourceName: "SideHistoryActive"), #imageLiteral(resourceName: "SIdeCityGuideActive"), #imageLiteral(resourceName: "SideChangePassActive"), #imageLiteral(resourceName: "SideLogoutActive")]
    
    var SideCheckArr = NSMutableArray()
    
    var viewslide = UIView()
    
    var viewslideBackground = UIView()
    
    var slidetableview: UITableView!

    let Share = SharedViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setWindow()
        setSplashScreen()
        Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(self.setHome), userInfo: nil, repeats: false)
        TokenStr = "0"
        OTPPageHeading = "Verify OTP"
        GMSServices.provideAPIKey("AIzaSyDxf_ZaIh4at_3UvU0fv0hL8TNBDWmUqJ8")
        //GMSPlacesClient.provideAPIKey("AIzaSyDxf_ZaIh4at_3UvU0fv0hL8TNBDWmUqJ8")
        if DeviceType.IS_IPHONE_X {
            kStoryBoard = UIStoryboard.init(name: Text.kiPhoneXStoryboardName, bundle: nil)// Storyboard_iPhoneX
        }else if DeviceType.IS_IPHONE_XP {
             kStoryBoard = UIStoryboard(name: Text.kiPhoneXStoryboardName, bundle: nil) //Storyboard_iPhoneX
        }else {
             kStoryBoard = UIStoryboard(name: Text.kMainStoryBoardName, bundle: nil)
        }
        
        for _ in InactiveArr {
            SideCheckArr.add(0)
        }
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        //Messaging.messaging().delegate = self
        let _ = RCValues.sharedInstance
        Fabric.with([Crashlytics.self])
        
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaults.standard.setValue(TokenStr, forKey: "tok")
        UserDefaults.standard.synchronize()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        UserDefaults.standard.setValue(TokenStr, forKey: "tok")
        UserDefaults.standard.synchronize()
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "NMRL")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK:- setWindow
    func setWindow() {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    }
    
    //MARK:- setWindow
    func setSplashScreen() {
        let splashVC = kStoryBoard.instantiateViewController(withIdentifier: StoryBoardIds.kSplashVC) as! SplashVC
        self.window?.rootViewController = splashVC
        self.window?.makeKeyAndVisible()
    }
    
    //MARK:- setLogin
    func setLogin() {
        let loginVC = kStoryBoard.instantiateViewController(withIdentifier: StoryBoardIds.kSigninTVC) as! SignInViewController
        self.window?.rootViewController = UINavigationController(rootViewController: loginVC)
        self.window?.makeKeyAndVisible()
    }
    
    //MARK:- setHome
    @objc func setHome() {
        let homeVC = kStoryBoard.instantiateViewController(withIdentifier: StoryBoardIds.kLandingVC) as! LandingViewController

        //let homeVC = kStoryBoard.instantiateViewController(withIdentifier: StoryBoardIds.kHomeVC) as! ViewController2
//        let sideMenu = kStoryBoard.instantiateViewController(withIdentifier: StoryBoardIds.kSidemenuTVC) as! MPSidemenuTableViewController
//        let mainNavVC:UINavigationController = UINavigationController(rootViewController: homeVC)
//        let container = MFSideMenuContainerViewController.container(withCenter: mainNavVC, leftMenuViewController: sideMenu, rightMenuViewController: nil)
        kAppDelegate.window?.rootViewController = UINavigationController(rootViewController: homeVC)
        kAppDelegate.window?.makeKeyAndVisible()
    }

}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
       /* if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }*/
        print(userInfo)
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
       /* if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }*/
        print(userInfo)
        completionHandler()
    }
}

/*extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        PublicUserFCMID = fcmToken
        }
}*/

