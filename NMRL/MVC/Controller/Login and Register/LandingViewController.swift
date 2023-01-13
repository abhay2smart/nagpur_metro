//
//  LandingViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 01/08/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit
import Crashlytics

class LandingViewController: UIViewController, CPSliderDelegate {
    
    @IBOutlet var TermsButt             : UIButton!
    @IBOutlet var PrivacyButt           : UIButton!
    @IBOutlet var SigningLbl            : UILabel!
    @IBOutlet var AndLbl                : UILabel!
    @IBOutlet var ServiceBlackVw        : UIView!
    @IBOutlet var ServiceWhiteVw        : UIView!
    @IBOutlet var Slider                : CPImageSlider!
    @IBOutlet var PageControl           : UIPageControl!
    
    let imageArr = ["Screen1", "Screen2", "Screen3", "Screen4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        Slider.images = imageArr
        Slider.delegate = self
        Slider.enablePageIndicator = false
        PageControl.currentPage = 0
        TermsButt.Underline()
        PrivacyButt.Underline()
        ServiceBlackVw.isHidden = true
        ServiceWhiteVw.isHidden = true

        if !DeviceType.IS_IPHONE_5 {
            TermsButt.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 12)
            PrivacyButt.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 12)
            
            SigningLbl.font = UIFont(name: "Montserrat-Regular", size: 10)
            AndLbl.font = UIFont(name: "Montserrat-Regular", size: 10)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.isJailBroken() {
            print("Jail Brocken")
            JailBroken()
            return
        }else {
            print("Not Jailbrocken")
        }
        Slider.autoSrcollEnabled = false
        
        if UserData.current != nil {
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardIds.kHomeVC) as! ViewController2
            self.navigationController?.pushViewController(homeVC, animated: false)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeIndex(not:)), name: Notification.Name("GetIndexValue1"), object: nil)
    }
    
    //MARK: - Jail Broken
    func JailBroken() {
        let alertController = UIAlertController(title: "Alert !!!", message: "Your device is Jail broken. You can't use this application", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            exit(0)
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sliderImageTapped(slider: CPImageSlider, index: Int) {
        //print("\(index)")
    }
    
    @objc func ChangeIndex(not : NSNotification) {
        PageControl.currentPage = not.object as! Int
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func CloseBlackVw(_ sender: Any) {
        ServiceBlackVw.isHidden = true
        ServiceWhiteVw.isHidden = true
    }
    
    @IBAction func TermsPrivacyClicked(_ sender: Any) {
        ServiceBlackVw.isHidden = false
        ServiceWhiteVw.isHidden = false
    }

    @IBAction func buttonBackTouched(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Crash Button
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }
}


