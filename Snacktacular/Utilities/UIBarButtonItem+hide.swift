//
//  UIBarButtonItem+hide.swift
//  Snacktacular
//
//  Created by Morgan Prime on 11/15/20.
//

import UIKit

extension UIBarButtonItem {
    func hide(){
        self.isEnabled = false
        self.tintColor = .clear
    }
}
