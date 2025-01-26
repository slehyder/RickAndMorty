//
//  Toast.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

import Foundation
import UIKit

enum ToastDirection {
    case top
    case bottom
}

class Toast {
    
    @discardableResult
    init(duration: Double = 0,text: String, container: UINavigationController? = nil, viewController: UIViewController? = nil, backgroundColor: UIColor = UIColor.red, direction: ToastDirection = .top, labelCompletion: ((_ label: UILabel) -> Void)? = nil , completion: (() -> Void)? = nil, shouldAddExtraBottomMargin: Bool = false)  {
        let screenSize = UIScreen.main.bounds
        let labelHeight: CGFloat = 50
        var rect = CGRect(
            x: 15,
            y: direction == .top ? -(labelHeight - 20) : UIScreen.main.bounds.height + labelHeight,
            width: screenSize.width - 30,
            height: labelHeight
        )
        
        if shouldAddExtraBottomMargin, direction == .bottom {
            rect.origin.y -= 60
        }
        
        let label = UILabel(frame: rect)
        
        label.text = "  \(text)  "
        label.alpha = 0
        label.textColor = .white
        label.backgroundColor = backgroundColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.roundCorners([.allCorners], radius: 5)
        
        var timeToShow: Double = Double(text.count) / 20
        timeToShow = timeToShow < 1.5 ? 1.5 : timeToShow
        timeToShow = duration == 0 ? timeToShow : duration
        let tabBarHeight: CGFloat = ((container?.navigationBar.frame.height ?? 0.0) + 20 + 12)
        
        container?.view.addSubview(label)
        viewController?.view.addSubview(label)
        
        if let labelCompletion = labelCompletion {
            labelCompletion(label)
        }
        
        UIView.animate(withDuration: 0.35, animations: {
            label.alpha = 1
            if direction == .top {
                label.frame.origin.y += labelHeight + tabBarHeight + 8
            } else {
                label.frame.origin.y -= (labelHeight + tabBarHeight + 65)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timeToShow + 0.5, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    if direction == .top {
                        label.frame.origin.y -= (labelHeight + tabBarHeight)
                    } else {
                        label.frame.origin.y += (labelHeight + tabBarHeight)
                    }
                    
                    label.alpha = 0
                }, completion: { _ in
                    label.removeFromSuperview()
                    guard let completion = completion else { return }
                    completion()
                })
            })
        })
    }
    
}
