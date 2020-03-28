//
//  Warhol.swift
//  Warhol
//
//  Created by Cesar Vargas on 22.03.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import UIKit
import Vision

public func detectLandmarks(in imageView: UIImageView, completion: @escaping (FaceViewModel, CGContext) -> Void) {
  let faceDetector = FaceDetector()
  faceDetector.highlightFaces(for: imageView, complete: completion)
}

class FaceDetector {
    
  open func highlightFaces(for source: UIImageView, complete: @escaping (FaceViewModel, CGContext) -> Void) {
    let image = source.image!
        let detectFaceRequest = VNDetectFaceLandmarksRequest { (request, error) in
            if error == nil {
                if let results = request.results as? [VNFaceObservation],
                  let result = results.first,
                  let landmarks = result.landmarks {
                  var viewModel = FaceViewModel()
                  
                  let rectWidth = image.size.width * result.boundingBox.size.width
                  let rectHeight = image.size.height * result.boundingBox.size.height
                  
                  let test = VNImageRectForNormalizedRect(result.boundingBox, Int(image.size.width), Int(image.size.height))
                  
                  let imageBoundingBox = CGRect(x: result.boundingBox.origin.x * image.size.width, y:result.boundingBox.origin.y * image.size.height, width: rectWidth, height: rectHeight)
                  var correctedImageBoundingBox = test
                  correctedImageBoundingBox.origin.y = image.size.height - test.origin.y - test.size.height
                  
                  viewModel.boundingBox = imageBoundingBox
                  debugPrint("test \(test) image  size \(image.size)")
                        if let faceContour = landmarks.faceContour {
                          viewModel.faceContour = faceContour.pointsInImage(imageSize: image.size)
                        }
                        if let leftEye = landmarks.leftEye {
                          viewModel.leftEye = leftEye.pointsInImage(imageSize: image.size)
                        }
                        if let rightEye = landmarks.rightEye {
                          viewModel.rightEye = rightEye.pointsInImage(imageSize: image.size)
                        }
                        if let nose = landmarks.nose {
                          viewModel.nose = nose.pointsInImage(imageSize: image.size)
                        }
                        if let noseCrest = landmarks.noseCrest {
                          //viewModel.noseCrest = source.faceLandmark(from: noseCrest) ?? []
                        }
                        if let medianLine = landmarks.medianLine {
                          //viewModel.medianLine = source.faceLandmark(from: medianLine) ?? []
                        }
                        if let outerLips = landmarks.outerLips {
                          viewModel.outerLips = outerLips.pointsInImage(imageSize: image.size)
                          
                        }
                  
                  UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
                  let context = UIGraphicsGetCurrentContext()!
                  context.translateBy(x: 0, y: image.size.height)
                  context.scaleBy(x: 1.0, y: -1.0)
                  context.setBlendMode(CGBlendMode.colorBurn)
                  context.setLineJoin(.round)
                  context.setLineCap(.round)
                  context.setShouldAntialias(true)
                  context.setAllowsAntialiasing(true)
                  
                  let rect = CGRect(x: 0, y:0, width: image.size.width, height: image.size.height)
                  context.draw(image.cgImage!, in: rect)
                  
                  complete(viewModel, context)
                  
                  let coloredImg : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                  UIGraphicsEndImageContext()
                  
                  source.image = coloredImg
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        let vnImage = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        try? vnImage.perform([detectFaceRequest])
    }
  }
