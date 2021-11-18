//
//  UIFont+extension.swift
//  Instagrid
//
//  Created by Loic Mazuc on 18/11/2021.
//

import UIKit

extension UIFont {
    static func delm(size: CGFloat) -> UIFont {
        return UIFont(name: "Delm-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func thirstySoft(size: CGFloat) -> UIFont {
        return UIFont(name: "ThirstySoftRegular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
