//
//  UIView.swift
//  Instagrid
//
//  Created by mac on 2019/12/16.
//  Copyright © 2019 Giovanni Gaffé. All rights reserved.
//

import UIKit

// 
extension UIView {
    var asImage : UIImage {
        // Convert view (squareImagesView) in UIImage
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        return image
    }
}
