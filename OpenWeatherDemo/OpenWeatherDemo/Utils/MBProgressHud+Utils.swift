//
//  MBProgressHud+Utils.swift
//  OpenWeatherDemo
//
//  Created by AoiSakura on 2022/7/15.
//

import UIKit
import MBProgressHUD

extension MBProgressHUD {
    class func showHud(to view: UIView, message: String?, timeDelay: TimeInterval = 0, animated: Bool, completionBlock: MBProgressHUDCompletionBlock? = nil) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: animated)
        hud.mode = .customView
        hud.isSquare = true
        hud.removeFromSuperViewOnHide = false
        hud.label.textColor = .white
        hud.bezelView.layer.cornerRadius = 20
        hud.bezelView.color = UIColor(white: 0, alpha: 0.7)
        hud.label.numberOfLines = 0
        hud.label.widthAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
        if let handler = completionBlock {
            hud.completionBlock = handler
        }
        
        if let message = message {
            hud.label.text = message
        }
        
        if timeDelay > 0 {
            hud.hide(animated: animated, afterDelay: timeDelay)
        }
        
        return hud
    }
}
