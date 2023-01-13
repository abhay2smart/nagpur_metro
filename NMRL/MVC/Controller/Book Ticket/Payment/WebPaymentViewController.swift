//
//  WebPaymentViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 31/08/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import WebKit

import CoreData

import Alamofire

import SafariServices

class WebPaymentViewController: UIViewController, UIWebViewDelegate, WKScriptMessageHandler, NSURLConnectionDelegate {

    @IBOutlet var Web: UIWebView!
    
     
    
    @IBOutlet var Web2: WKWebView!
    
    @IBOutlet var containerView: UIView? = nil
    
    @IBOutlet var BlackView: UIView!
    
    var TemporaryMutableArr = NSMutableArray()
    
    var SecondTemporaryArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BlackView.isHidden = true
        
        let url = NSURL (string: PublicPaymentURL)//where URL = https://203.xxx.xxx.xxx
        let requestObj = NSURLRequest(url: url! as URL)
        let request: NSURLRequest = NSURLRequest(url: url! as URL)
        let connection: NSURLConnection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: false)!
        connection.start()
        Web.loadRequest(requestObj as URLRequest)
        
        
      //  Web.loadRequest(URLRequest(url: URL(string: PublicPaymentURL)!))
        
       // Web2.load(URLRequest(url: URL(string: PublicPaymentURL)!))
        
      //  Web.loadRequest(URLRequest(url: URL(string: "https://www.google.com/")!))
      
        Web.delegate = self
        
      
        
        print("Already Saved Data : \(PublicAlreadySavedData)")
        
        if PublicAlreadySavedData.count > 0
        {
            let arr = PublicAlreadySavedData[0] as! NSArray
            
            TemporaryMutableArr = NSMutableArray(array: arr)
            
            print("TemporaryMutableArr : \(TemporaryMutableArr)")
        }
        
        //Web.loadRequest(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "paymentpage", ofType: "html")!)))

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        
//        let contentController = WKUserContentController()
//        contentController.add(self, name: "payment")
//        let config = WKWebViewConfiguration()
//        config.userContentController = contentController
//        
//     //   self.Web2 = WKWebView( frame: self.containerView!.bounds, configuration: config)
//        self.view = self.Web2
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {// edit: changed fun to func
        
        if (message.name == "payment"){
            print("Message \(message.body)")
        }
        
        print(message.name)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Loading...")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        
       // print("Scheme : \(request.url?.scheme!)")
        
        print("Query : \(request.url?.absoluteString)")
        
        if (request.url?.absoluteString.contains("status=success"))!
        {
            //TocketHistory()
            TocketCurrentDay()
        }
        else if (request.url?.absoluteString.contains("status=sucess"))!
        {
            //TocketHistory()
            TocketCurrentDay()
        }
        else if (request.url?.absoluteString.contains("status=fail"))!
        {
            let FailedViewController = self.storyboard?.instantiateViewController(withIdentifier: "FailedViewController")
            
            self.navigationController?.pushViewController(FailedViewController!, animated: true)
        }
        
        return true
    }
    
    //MARK: - Web Connection Delegate
    
    func connection(_ connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: URLProtectionSpace) -> Bool
    {
        print("In canAuthenticateAgainstProtectionSpace");
        
        return true;
    }
    
    func connection(_ connection: NSURLConnection, willSendRequestFor challenge: URLAuthenticationChallenge)
    {
        print("In willSendRequestForAuthenticationChallenge..");
        challenge.sender!.use(URLCredential(trust: challenge.protectionSpace.serverTrust!), for: challenge)
        challenge.sender!.continueWithoutCredential(for: challenge)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func TocketCurrentDay()
    {
        if UserData.current?.token != nil {
        let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        print("headers1 : \(headers1)")
        
        let url = "\(APILink)ticketHistoryForCurrentDay"
        
        let parameters: [String: Any] = [
            "token" : UserData.current!.token!
        ]
        
        print("token : \(UserData.current!.token!)")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show(withStatus: "Loading...")
        sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            SVProgressHUD.dismiss()
            if let dict = dataResponse.result.value as? NSDictionary
            {
                print("Ticket Current Day : \(dict)")
                
                if let result = dict["resultType"] as? Int
                {
                    if result == 1
                    {
                        if let tok = dict["token"] as? String
                        {
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
                        
                        if let arr = dict["tickets"] as? NSArray
                        {
                            self.TicketsArr = arr
                        }
                    }
                }
                
            }
            
            if self.TicketsArr.count > 0
            {
                self.SecondTemporaryArray = NSMutableArray(array: self.TicketsArr)
                
                if self.TemporaryMutableArr.count > 0
                {
                    for i in self.TemporaryMutableArr
                    {
                        if let dic = i as? NSDictionary
                        {
                            if !self.SecondTemporaryArray.contains(dic)
                            {
                                self.SecondTemporaryArray.add(dic)
                            }
                        }
                    }
                }
                
            }
            
            print("Second temporary arr : \(self.SecondTemporaryArray)")
            
            if self.SecondTemporaryArray.count > 0
            {
                let arr = self.SecondTemporaryArray as NSArray
                
                self.save(arr: arr)
            }
            
//            if self.TicketsArr.count > 0
//            {
//                self.save(arr: self.TicketsArr)
//            }
            
            
            let ConfirmationViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmationViewController")
            
            self.navigationController?.pushViewController(ConfirmationViewController!, animated: true)
            
        }
    }
    }
    
    func TocketHistory()
    {
        if UserData.current?.token != nil {
        
        let credentialData = "\(AuthUser):\(AuthPass)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers1 = ["authorization": "Basic \(base64Credentials)"]
        
        let url = "\(APILink)ticketHistory"
        
        let parameters: [String: Any] = [
            "token" : UserData.current!.token!,
            ]
        
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.show(withStatus: "Loading...")
        sessionManager1.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default, headers : headers1).responseJSON { dataResponse in
            SVProgressHUD.dismiss()
          //  print(dataResponse.result.value!)
            
            if let dict = dataResponse.result.value as? NSDictionary
            {
                print("Tickets : \(dict)")
                
                if let result = dict["resultType"] as? Int
                {
                    
                    if result == 1
                    {
                        if let tok = dict["token"] as? String
                        {
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
                        
                        if let arr = dict["tickets"] as? NSArray
                        {
                            self.TicketsArr = arr
                            
                        }
                    }
                }
                
            }
            
            if self.TicketsArr.count > 0
            {
                self.save(arr: self.TicketsArr)
            }
            
 
            let ConfirmationViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmationViewController")
            
            self.navigationController?.pushViewController(ConfirmationViewController!, animated: true)
        }
    }
    }
    
    var TicketsArr = NSArray()
    var people: [NSManagedObject] = []
    var AlreadySavedData = NSArray()
    
    //MARK: - Core Data
    
    func save(arr : NSArray) {
        
        deleteAllRecords()
        
        let StatusDict = NSMutableDictionary()
        
        for dic in arr
        {
            if let dd = dic as? NSDictionary
            {
                if let ticketSerial = dd["ticketSerial"] as? Int
                {
                    if let qrTicketStatus = dd["qrTicketStatus"] as? String
                    {
                        let dict2 = NSMutableDictionary()
                        dict2.setValue(qrTicketStatus, forKey: "Status")
                        dict2.setValue("0", forKey: "EntryCount")
                        dict2.setValue("0", forKey: "ExitCount")
                        StatusDict.setValue(dict2, forKey: "\(ticketSerial)")
                    }
                    
                }
            }
        }
        
        //  print("StatusDict Saving : \(StatusDict)")
        
        ////////// Saving Data
        
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "TicketData",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        person.setValue(arr, forKeyPath: "tickets")
        
       // print("StatusDict : \(StatusDict)")
        
        person.setValue(StatusDict, forKeyPath: "ticketstatus2")
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        ReadData()
        
        //print("People 2 : \(people)")
        
        //   print("Saved data : \(String(describing: person.value(forKeyPath: "ticketstatus")!))")
        
    }
    
    func ReadData()
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "TicketData")
        
        //3
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let db = people.map { $0.value(forKey: "tickets") as! NSArray}
        AlreadySavedData = db as NSArray
        PublicAlreadySavedData = AlreadySavedData
        
        print("PublicAlreadySavedData : \(PublicAlreadySavedData)")
    
        
        let statusData = people.map { $0.value(forKey: "ticketstatus2") as! NSDictionary}
        
        if statusData.count > 0
        {
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
        } catch {
            print ("There was an error")
        }
    }

    
    
    
    @IBAction func Back(_ sender: Any) {
        
        BlackView.isHidden = false
        
    }
    
    @IBAction func OK(_ sender: Any) {
        
        var array : [UIViewController] = (self.navigationController?.viewControllers)!
        
        array.remove(at: array.count - 1)
        array.remove(at: array.count - 1)
        
        self.navigationController?.viewControllers = array
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Caencel(_ sender: Any) {
        
        BlackView.isHidden = true
    }
}


extension NSURLRequest {
    #if DEBUG
    static func allowsAnyHTTPSCertificate(forHost host: String) -> Bool {
        return true
    }
    #endif
}

extension URLRequest
{
    #if DEBUG
    static func allowsAnyHTTPSCertificate(forHost host: String) -> Bool {
        return true
    }
    #endif
}
