//
//  PrimaryButton.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 22/07/2025.
//

import UIKit

extension UIButton.Configuration {
    static func primary(title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = AppColor.primary
        config.baseForegroundColor = AppColor.textPrimary
        config.cornerStyle = .medium
        config.title = title
        config.contentInsets = NSDirectionalEdgeInsets(
            top: AppSpacing.small,
            leading: AppSpacing.medium,
            bottom: AppSpacing.small,
            trailing: AppSpacing.medium,
        )
        
        return config
    }
}
