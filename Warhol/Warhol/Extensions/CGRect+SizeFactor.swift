//
//  CGRect+SizeFactor.swift
//  Warhol
//
//  Created by Cesar Vargas on 02.05.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGRect {
  func increaseRect(byPercentageWidth percentageWidth: CGFloat,
                    byPercentageHeight percentageHeight: CGFloat) -> CGRect {
    let startWidth = width
    let startHeight = height
    let adjustmentWidth = (startWidth * percentageWidth) / 2.0
    let adjustmentHeight = (startHeight * percentageHeight) / 2.0
    return insetBy(dx: -adjustmentWidth, dy: -adjustmentHeight)
  }
}
