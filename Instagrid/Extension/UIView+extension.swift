//
//  UIView+extension.swift
//  FrenchGameFactory
//
//  Created by Loic Mazuc on 22/10/2021.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
