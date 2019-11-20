//
//  ViewController.swift
//  Instagrid
//
//  Created by mac on 2019/11/20.
//  Copyright © 2019 Giovanni Gaffé. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var paternButtons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func paternButtonTapped(_ sender: UIButton) {
        print(sender.tag)
    }
    
}

