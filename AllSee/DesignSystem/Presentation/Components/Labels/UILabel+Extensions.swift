//
//  UILabel+Extensions.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 22/07/2025.
//

import UIKit

extension UILabel {
    static func headline(text: String) -> UILabel {
        let label = UILabel()
        
        label.text = text
        label.textColor = AppColor.textPrimary
        label.font = AppFont.headline()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }
    
    static func body(text: String) -> UILabel {
        let label = UILabel()
        
        label.text = text
        label.textColor = AppColor.textSecondary
        label.font = AppFont.body()
        label.numberOfLines = 0
        
        return label
    }
    
    static func caption(text: String) -> UILabel {
        let label = UILabel()
        
        label.text = text
        label.textColor = AppColor.textSecondary
        label.font = AppFont.caption()
        label.numberOfLines = 0
        
        return label
    }
}
