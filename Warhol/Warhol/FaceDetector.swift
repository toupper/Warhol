//
//  FaceDetector.swift
//  Warhol
//
//  Created by Cesar Vargas on 29.03.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import Foundation
import Vision
import UIKit
import AVFoundation
import CoreMedia

class FaceDetector {
  func detectFace(from imageBuffer: CVImageBuffer,
                  previewLayer: AVCaptureVideoPreviewLayer,
                  completion: @escaping (FaceViewModel) -> Void,
                  error: @escaping (WarholError) -> Void) {
    let detectFaceRequest = VNDetectFaceLandmarksRequest(completionHandler: { request, detectedError in
      if let detectedError = detectedError {
        error(WarholError.internalError(detectedError))
        return
      }

      guard let results = request.results as? [VNFaceObservation],
        let result = results.first else {
           error(WarholError.noFaceDetected)
          return
      }

      let landmarkMaker: (VNFaceLandmarkRegion2D?) -> FaceLandmark? = { faceLandmarkRegion in
        guard let points = faceLandmarkRegion?.normalizedPoints else {
          return nil
        }

        return points.compactMap { previewLayer.landmark(point: $0, to: result.boundingBox) }
      }

      if let faceViewModel = FaceViewModel.faceViewModel(from: result,
                                                         landmarkMaker: landmarkMaker,
                                                         boundingBoxMaker: previewLayer.convert) {
         completion(faceViewModel)
      }
    })

    let sequenceHandler = VNSequenceRequestHandler()

    do {
      try sequenceHandler.perform(
        [detectFaceRequest],
        on: imageBuffer,
        orientation: .leftMirrored)
    } catch {
      print(error.localizedDescription)
    }
  }

  private func detectFace(from image: UIImage,
                          completion: @escaping (FaceViewModel) -> Void,
                          error: @escaping (WarholError) -> Void) {
    let detectFaceRequest = VNDetectFaceLandmarksRequest { (request, detectedError) in
        if detectedError == nil {
            if let results = request.results as? [VNFaceObservation],
              let result = results.first {

              let rectWidth = image.size.width * result.boundingBox.size.width
              let rectHeight = image.size.height * result.boundingBox.size.height

              let boundingBoxMaker: (CGRect) -> CGRect = { boundingBox in
                return CGRect(x: boundingBox.origin.x * image.size.width,
                              y: boundingBox.origin.y * image.size.height,
                              width: rectWidth,
                              height: rectHeight)
              }

              let landmarkMaker: (VNFaceLandmarkRegion2D?) -> FaceLandmark? = { faceLandmarkRegion in
                 faceLandmarkRegion?.pointsInImage(imageSize: image.size)
              }

              if let viewModel = FaceViewModel.faceViewModel(from: result,
                                                             landmarkMaker: landmarkMaker,
                                                             boundingBoxMaker: boundingBoxMaker) {
                completion(viewModel)
              }
            } else {
              error(WarholError.noFaceDetected)
          }
        } else {
          print(detectedError!.localizedDescription)
          error(WarholError.internalError(detectedError!))
        }
    }

    let vnImage = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
    try? vnImage.perform([detectFaceRequest])
  }

  func drawLandmarks(in imageView: UIImageView,
                     draw: @escaping (FaceViewModel, CGContext) -> Void,
                     error: @escaping (Error) -> Void) {
    guard let image = imageView.image else {
      error(WarholError.noImagePassed)
      return
    }

    detectFace(from: image, completion: { viewModel in
      UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
      let context = UIGraphicsGetCurrentContext()!
      self.prepareContextForDrawing(context, image: image)

      let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
      context.draw(image.cgImage!, in: rect)

      draw(viewModel, context)

      let processedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()

      imageView.image = processedImage
    }, error: error)
  }

  func drawLandmarksInNewImage(from imageView: UIImageView,
                               draw: @escaping (FaceViewModel, CGContext) -> Void,
                               completion: @escaping (UIImage) -> Void,
                               error: @escaping (Error) -> Void) {
    guard let image = imageView.image else {
      error(WarholError.noImagePassed)
      return
    }

    detectFace(from: image, completion: { viewModel in
      UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
      let context = UIGraphicsGetCurrentContext()!
      self.prepareContextForDrawing(context, image: image)

      let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
      context.draw(image.cgImage!, in: rect)

      draw(viewModel, context)

      let processedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()

      completion(processedImage)
    }, error: error)
  }

  private func prepareContextForDrawing(_ context: CGContext, image: UIImage) {
    context.translateBy(x: 0, y: image.size.height)
    context.scaleBy(x: 1.0, y: -1.0)
    context.setBlendMode(CGBlendMode.colorBurn)
    context.setLineJoin(.round)
    context.setLineCap(.round)
    context.setShouldAntialias(true)
    context.setAllowsAntialiasing(true)
  }
}
