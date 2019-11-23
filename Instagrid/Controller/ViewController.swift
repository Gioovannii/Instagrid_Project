//
//  ViewController.swift
//  Instagrid
//
//  Created by mac on 2019/11/20.
//  Copyright © 2019 Giovanni Gaffé. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var paternViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func paternButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            resetPattern()
            paternViews[1].isHidden = true
        case 2:
            resetPattern()
            paternViews[2].isHidden = true
        case 3:
            resetPattern()
            
        default:
            break
        }
    }
    
    /// Set all View to normal view
    func resetPattern() {
        for i in 0..<paternViews.count {
            paternViews[i].isHidden = false
        }
    }
    
}

