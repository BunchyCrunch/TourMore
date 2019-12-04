//
//  Utilities.swift
//  TourMore
//
//  Created by Christopher Alegre on 11/27/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import UIKit

class Utilities {
    static func textFieldSignUpStyle(_ textField: UITextField) {
        
        let styleLine = CALayer()
        
        styleLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 1)
        styleLine.backgroundColor = UIColor(named: "textFieldLineColor")?.cgColor
        
        textField.borderStyle = .none
        textField.layer.addSublayer(styleLine)
        textField.textColor = .darkText
    }
}
