//
//  ViewController.swift
//  Instagrid
//
//  Created by mac on 2019/11/20.
//  Copyright © 2019 Giovanni Gaffé. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var patternButtons: [UIButton]!
    @IBOutlet weak var topRightView: UIView!
    @IBOutlet weak var bottomRightView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func paternButtonTapped(_ sender: UIButton) {
        patternButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        
        switch sender.tag {
        case 1:
            topRightView.isHidden = true
            bottomRightView.isHidden = false
        case 2:
            topRightView.isHidden = false
            bottomRightView.isHidden = true
            
        case 3:
            topRightView.isHidden = false
            bottomRightView.isHidden = false
            
        default:
            break
        }
    }
    @IBAction func pickUpImagesButton(_ sender: Any) {
        
        
    }
    
  
}

