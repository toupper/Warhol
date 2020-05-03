//
//  FaceView.swift
//  SampleApp
//
//  Created by Cesar Vargas on 24.03.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import Foundation
import Warhol
import UIKit

final class FaceView: UIView, CameraFrontView {
  var viewModel: FaceViewModel?

  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext(),
          let viewModel = viewModel else {
      return
    }

    context.saveGState()

    defer {
      context.restoreGState()
    }

    context.addRect(viewModel.boundingBox)

    UIColor.red.setStroke()
    context.strokePath()
    UIColor.white.setStroke()

    Array(viewModel.landmarks.values).forEach {self.draw(landmark: $0, closePath: true, in: context) }
  }

  private func draw(landmark: FaceLandmarkPerimeter, closePath: Bool, in context: CGContext) {
    guard !landmark.isEmpty else {
      return
    }

    context.addLines(between: landmark)

    if closePath {
      context.closePath()
    }

    context.strokePath()
  }
}
