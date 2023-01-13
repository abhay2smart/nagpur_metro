//
//  SplashVC.swift
//  NMRL
//
//  Created by Akhil Johny on 06/06/19.
//  Copyright © 2019 SC Soft Technologies. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    @IBOutlet var imageViewAnimate: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageViewAnimate.image = UIImage.gifImageWithName(name: "GIFMaker.org_oLch3z")
    }
    
}
