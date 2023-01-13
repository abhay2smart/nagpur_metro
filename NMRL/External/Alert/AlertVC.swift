//
//  AlertVC.swift
//  
//
//  Created by Vishnu M P on 26/05/19.
//  Copyright © 2019 Vishnu M P. All rights reserved.
//

import UIKit

enum AlertAnimationType {
    case scale
    case rotate
    case bounceUp
    case bounceDown
}

class AlertVC: UIViewController {

    @IBOutlet weak var alertView    : UIView!
    
    @IBOutlet var titleLabel        : UILabel!
    @IBOutlet var messageLabel      : UILabel!
    @IBOutlet var btnYes            : UIButton!
    @IBOutlet var btnNo             : UIButton!
    
    var backgroundColor: UIColor = .black
    var backgroundOpacity: CGFloat = 0.5
    var animateDuration: TimeInterval = 0.8
    
    var scaleX: CGFloat = 0.3
    var scaleY: CGFloat = 1.5
    var rotateRadian:CGFloat = 1.5 // 1 rad = 57 degrees
    
    var springWithDamping: CGFloat = 0.7
    var delay: TimeInterval = 0
    
    var titleMessage: String = ""
    var message: String = ""
    var animationType: AlertAnimationType = .scale
    
    var cornerRadius: CGFloat = 4
    var alpha: CGFloat = 0
    
    private var yesAction: AlertAction?
    private var noAction: AlertAction?
    
    convenience init(title: String, message: String, animationType: AlertAnimationType = .scale) {
        self.init()
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.titleMessage = title
        self.message = message
        self.animationType = animationType
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.alpha = alpha
        view.backgroundColor = backgroundColor.withAlphaComponent(backgroundOpacity)
        setupButton()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimating(type: self.animationType)
    }
    
    //MARK: - CONFIG
    func show(into viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        viewController.present(self, animated: false, completion: nil)
    }
    
    private func setupUI() {
        
        if titleLabel != nil {
            titleLabel.text = titleMessage
        }
        
        if messageLabel != nil {
            messageLabel.text = message
        }
        
    }
    
    private func setupButton() {
        
        if let yAction = self.yesAction {
            self.btnYes.setTitle(yAction.title, for: .normal)
        }
        
//        if btnNo != nil {
//            btnNo.isHidden = true
       // }
        
        if let nAction = self.noAction {
            self.btnNo.isHidden = false
            self.btnNo.setTitle(nAction.title, for: .normal)
        }
        
    }
    
    private func startAnimating(type: AlertAnimationType) {
        
        alertView.alpha = 1
        switch type {
        case .rotate:
            alertView.transform = CGAffineTransform(rotationAngle: rotateRadian)
        case .bounceUp:
            let screenHeight = UIScreen.main.bounds.height/2 + alertView.frame.height/2
            alertView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        case .bounceDown:
            let screenHeight = -(UIScreen.main.bounds.height/2 + alertView.frame.height/2)
            alertView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        default:
            alertView.transform = CGAffineTransform(scaleX: 0.1 , y: 0.1)
        }
        UIView.animate(withDuration: animateDuration, delay: delay, usingSpringWithDamping: springWithDamping, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.alertView.transform = .identity
        }, completion: nil)
        
    }
    
    func addAction(_ action: AlertAction) {
        switch action.type {
        case .yes:
            yesAction = action
        case .no:
            noAction = action
        }
    }

    @IBAction func buttonYesTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            if let posHandler = self.yesAction?.handler{
                posHandler()
            }
        })
    }
    
    @IBAction func btnNoTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            if let negHandler = self.noAction?.handler{
                negHandler()
            }
        })
    }
}
