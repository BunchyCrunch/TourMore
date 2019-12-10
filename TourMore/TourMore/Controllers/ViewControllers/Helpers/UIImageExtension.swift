//
//  UIImageExtension.swift
//  TourMore
//
//  Created by Michael Di Cesare on 12/10/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit


extension UIImage {
    func scaleImage(into size: CGSize, centered: Bool = false) -> UIImage {
        var (targetWidth, targetHeight) = (self.size.width, self.size.height)
        var (scaleWidth, scaleHeight) = (1 as CGFloat, 1 as CGFloat)
        
        if targetWidth > size.width {
            scaleWidth = size.width/targetWidth
        }
        
        if targetHeight > size.height {
            scaleHeight = size.height/targetHeight
        }
        
        let scale = min(scaleWidth, scaleHeight)
        targetWidth *= scale
        targetHeight *= scale
        let newSize = CGSize(width: targetWidth, height: targetHeight)
        
        if !centered {
            return UIGraphicsImageRenderer(size: newSize).image { _ in
                self.draw(in: CGRect(origin: .zero, size: newSize))
            }
        }
        
        let x = (size.width - targetWidth)/2
        let y = (size.height - targetHeight)/2
        let origin = CGPoint(x: x, y: y)
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            self.draw(in: CGRect(origin: origin, size: newSize))
        }
    }
}
