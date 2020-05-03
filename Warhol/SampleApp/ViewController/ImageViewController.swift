//
//  ImageViewController.swift
//  SampleApp
//
//  Created by Cesar Vargas on 26.03.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import Foundation
import UIKit
import Warhol

final class ImageViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var faceView: FaceView!
  @IBOutlet weak var newImageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    imageView.image = UIImage(named: "Face")
    Warhol.drawLandmarksInNewImage(from: imageView,
                                   draw: { (viewModel, context)  in
                                    self.draw(viewModel: viewModel, in: context)
    }, completion: { newImage in
      self.newImageView.image = newImage
    },
    error: {_ in })
  }

  private func draw(viewModel: FaceViewModel, in context: CGContext) {
    context.saveGState()

    defer {
      context.restoreGState()
    }

    context.addRect(viewModel.boundingBox)

    UIColor.red.setStroke()
    context.strokePath()
    UIColor.blue.setStroke()

    Array(viewModel.landmarks.values).forEach { self.draw(landmark: $0, closePath: true, in: context) }
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
