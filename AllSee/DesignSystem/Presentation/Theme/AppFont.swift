//
//  AppFont.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 22/07/2025.
//

import UIKit

enum AppFont {
    static func headline() -> UIFont { UIFont.systemFont(ofSize: 24, weight: .bold) }
    
    static func body() -> UIFont { UIFont.systemFont(ofSize: 16, weight: .regular) }
    
    static func caption() -> UIFont { UIFont.systemFont(ofSize: 12, weight: .light) }
}
