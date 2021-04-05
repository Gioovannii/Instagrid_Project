//
//  Fonction.swift
//  Instagrid
//
//  Created by Giovanni Gaffé on 2021/4/4.
//  Copyright © 2021 Giovanni Gaffé. All rights reserved.
//

import Foundation

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}

