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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.image = UIImage(named: "Face")
    Warhol.detectLandmarks(in: imageView, completion: { (viewModel, context)  in
            context.saveGState()

            defer {
              context.restoreGState()
            }

            context.addRect(viewModel.boundingBox)

            UIColor.red.setStroke()
            context.strokePath()
            UIColor.blue.setStroke()
            
            self.draw(landmark: viewModel.leftEye, closePath: true, in: context)
            self.draw(landmark: viewModel.rightEye, closePath: true, in: context)
            
            self.draw(landmark: viewModel.leftEyebrow, closePath: false, in: context)
            self.draw(landmark: viewModel.rightEyebrow, closePath: false, in: context)
            
            self.draw(landmark: viewModel.nose, closePath: false, in: context)
            
            self.draw(landmark: viewModel.outerLips, closePath: true, in: context)
            self.draw(landmark: viewModel.innerLips, closePath: true, in: context)
            
            self.draw(landmark: viewModel.faceContour, closePath: false, in: context)
    }, error: {_ in })
  }
  
  private func draw(landmark: FaceLandmark, closePath: Bool, in context: CGContext) {
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
