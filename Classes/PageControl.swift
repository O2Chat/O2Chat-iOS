//
//  PageControl.swift
//  Befiler
//
//  Created by Sanjay on 15/11/2022.
//  Copyright © 2022 Haseeb. All rights reserved.
//

import Foundation
import UIKit
class DefaultPageControl: UIPageControl {

    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }

    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        super.sendAction(action, to: target, for: event)
        updateDots()
    }

    private func updateDots() {
        let currentDot = subviews[currentPage]
        let largeScaling = CGAffineTransform(scaleX: 3.0, y: 3.0)
        let smallScaling = CGAffineTransform(scaleX: 1.0, y: 1.0)

        subviews.forEach {
            // Apply the large scale of newly selected dot.
            // Restore the small scale of previously selected dot.
            $0.transform = $0 == currentDot ? largeScaling : smallScaling
        }
    }

    override func updateConstraints() {
        super.updateConstraints()
        // We rewrite all the constraints
        rewriteConstraints()
    }

    private func rewriteConstraints() {
        let systemDotSize: CGFloat = 7.0
        let systemDotDistance: CGFloat = 16.0

        let halfCount = CGFloat(subviews.count) / 2
        subviews.enumerated().forEach {
            let dot = $0.element
            dot.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.deactivate(dot.constraints)
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: systemDotSize),
                dot.heightAnchor.constraint(equalToConstant: systemDotSize),
                dot.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
                dot.centerXAnchor.constraint(equalTo: centerXAnchor, constant: systemDotDistance * (CGFloat($0.offset) - halfCount))
            ])
        }
    }
}


class DefaultPageControl1: UIPageControl {

   override var currentPage: Int {
       didSet {
           updateDots()
       }
   }

   func updateDots() {
       let currentDot = subviews[currentPage]

       let spacing = 5.0

       subviews.forEach {
           $0.frame = ($0 == currentDot) ? CGRect(x: 0, y: 0, width: 16, height: 4) : CGRect(x: spacing, y: 0, width: 8, height: 4)
           //$0.frame.size = ($0 == currentDot) ? CGSize(width: 16, height: 4) : CGSize(width: 8, height: 4)
           $0.layer.cornerRadius = 2
       }
   }
}
