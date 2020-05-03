//
//  FaceLandmarkPerimeter+Rect.swift
//  Warhol
//
//  Created by Cesar Vargas on 03.05.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import Foundation
import CoreGraphics

extension FaceLandmarkPerimeter {
  func rect() -> CGRect {
    let leftMost: CGFloat = self.reduce(CGFloat.greatestFiniteMagnitude) { Swift.min($0, $1.x) }
    let upMost = reduce(CGFloat.greatestFiniteMagnitude) { Swift.min($0, $1.y) }
    let rightMost = reduce(0) { Swift.max($0, $1.x) }
    let downMost = reduce(0) { Swift.max($0, $1.y) }

    let originalWidth = rightMost - leftMost
    let originalHeight = downMost - upMost

    return CGRect(x: leftMost, y: upMost, width: originalWidth, height: originalHeight)
  }
}
