//
//  RoundedAndOutlinedButton.swift
//  GOT
//
//  Created by C4Q on 11/7/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
 @IBDesignable
class RoundedAndOutlinedButton: UIButton {

        @IBInspectable var cornerRadius: CGFloat = 0{
            didSet{
                self.layer.cornerRadius = cornerRadius
            }
        }
        
        @IBInspectable var borderWidth: CGFloat = 0{
            didSet{
                self.layer.borderWidth = borderWidth
            }
        }
        
        @IBInspectable var borderColor: UIColor = UIColor.clear{
            didSet{
                self.layer.borderColor = borderColor.cgColor
            }
        }
}
