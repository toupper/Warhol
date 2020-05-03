//
//  FaceImagesLayout.swift
//  Warhol
//
//  Created by Cesar Vargas on 01.05.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import Foundation
import UIKit

public struct SizeRatio {
  let width: CGFloat
  let height: CGFloat

  public init(width: CGFloat, height: CGFloat) {
    self.width = width
    self.height = height
  }
}

public struct ImageLayout {
  let image: UIImage
  let offset: CGPoint
  let sizeRatio: SizeRatio

  public init(image: UIImage, offset: CGPoint? = nil, sizeRatio: SizeRatio? = nil) {
    self.image = image
    self.offset = offset ?? CGPoint.zero
    self.sizeRatio = sizeRatio ?? SizeRatio(width: 1, height: 1)
  }
}

public struct FaceLayout {
  let landmarkLayouts: [FaceLandmarkType: ImageLayout]

  public init (landmarkLayouts: [FaceLandmarkType: ImageLayout]) {
    self.landmarkLayouts = landmarkLayouts
  }
}
