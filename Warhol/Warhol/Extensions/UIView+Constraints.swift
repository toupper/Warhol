//
//  UIView+Constraints.swift
//  Warhol
//
//  Created by Cesar Vargas on 31.03.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  func adjustSubviewToEdges(subView: UIView) {
    subView.translatesAutoresizingMaskIntoConstraints = false

    let horizontalConstraint = NSLayoutConstraint(item: subView,
                                                  attribute: NSLayoutConstraint.Attribute.centerX,
                                                  relatedBy: NSLayoutConstraint.Relation.equal, toItem: self,
                                                  attribute: NSLayoutConstraint.Attribute.centerX,
                                                  multiplier: 1,
                                                  constant: 0)

    let verticalConstraint = NSLayoutConstraint(item: subView,
                                                attribute: NSLayoutConstraint.Attribute.centerY,
                                                relatedBy: NSLayoutConstraint.Relation.equal,
                                                toItem: self,
                                                attribute: NSLayoutConstraint.Attribute.centerY,
                                                multiplier: 1,
                                                constant: 0)

    let widthConstraint = NSLayoutConstraint(item: subView,
                                             attribute: NSLayoutConstraint.Attribute.width,
                                             relatedBy: NSLayoutConstraint.Relation.equal,
                                             toItem: self,
                                             attribute: NSLayoutConstraint.Attribute.width,
                                             multiplier: 1,
                                             constant: 0)

    let heightConstraint = NSLayoutConstraint(item: subView,
                                              attribute: NSLayoutConstraint.Attribute.height,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.height,
                                              multiplier: 1,
                                              constant: 0)

    addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
  }
}
