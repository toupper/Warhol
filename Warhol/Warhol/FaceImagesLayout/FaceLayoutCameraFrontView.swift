//
//  FaceLayoutCameraFrontView.swift
//  Warhol
//
//  Created by Cesar Vargas on 01.05.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import Foundation
import UIKit

final class FaceLayoutCameraFrontView: UIView, CameraFrontView {
  var viewModel: FaceViewModel?
  var layout: FaceLayout

  init(layout: FaceLayout) {
    self.layout = layout

    super.init(frame: CGRect.zero)

    backgroundColor = .clear
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext(),
    let viewModel = viewModel else {
      return
    }

    context.saveGState()

    defer {
      context.restoreGState()
    }

    Array(viewModel.landmarks.keys).forEach { key in
      guard let imageLayout = layout.landmarkLayouts[key],
        let perimeter = viewModel.landmarks[key] else {
        return
      }

      draw(layout: imageLayout, in: context, from: perimeter)
    }
  }

  private func draw(layout: ImageLayout, in context: CGContext, from perimeter: FaceLandmarkPerimeter) {
    let offsetAdjustedRect = perimeter.rect().offsetBy(dx: layout.offset.x, dy: layout.offset.y)

    layout.image.draw(in: offsetAdjustedRect.increaseRect(byPercentageWidth: layout.sizeRatio.width,
                                                          byPercentageHeight: layout.sizeRatio.height))
    //context.draw(layout.image.cgImage!, in: rect.increaseRect(byPercentageWidth: 1, byPercentageHeight: 4))
  }
}
