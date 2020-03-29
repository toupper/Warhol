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
  func detectFace(from imageBuffer: CVImageBuffer, previewLayer: AVCaptureVideoPreviewLayer, completion: @escaping (FaceViewModel) -> ()) {
    let detectFaceRequest = VNDetectFaceLandmarksRequest(completionHandler: { request, error in
      guard let results = request.results as? [VNFaceObservation],
        let result = results.first else {
          return
      }
            
      let landmarkMaker: (VNFaceLandmarkRegion2D?) -> FaceLandmark? = { faceLandmarkRegion in
        guard let points = faceLandmarkRegion?.normalizedPoints else {
          return nil
        }

        return points.compactMap { previewLayer.landmark(point: $0, to: result.boundingBox) }
      }
      
      if let faceViewModel = FaceViewModel.faceViewModel(from: result, landmarkMaker: landmarkMaker, boundingBoxMaker: previewLayer.convert) {
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
  
  private func detectFace(from image: UIImage, completion: @escaping (FaceViewModel) -> ()) {
    let detectFaceRequest = VNDetectFaceLandmarksRequest { (request, error) in
        if error == nil {
            if let results = request.results as? [VNFaceObservation],
              let result = results.first {
              
              let rectWidth = image.size.width * result.boundingBox.size.width
              let rectHeight = image.size.height * result.boundingBox.size.height
              
              let boundingBoxMaker: (CGRect) -> CGRect = { boundingBox in
                return CGRect(x: boundingBox.origin.x * image.size.width, y:boundingBox.origin.y * image.size.height, width: rectWidth, height: rectHeight)
              }
              
              let landmarkMaker: (VNFaceLandmarkRegion2D?) -> FaceLandmark? = { faceLandmarkRegion in
                 faceLandmarkRegion?.pointsInImage(imageSize: image.size)
              }
              
              if let viewModel = FaceViewModel.faceViewModel(from: result, landmarkMaker: landmarkMaker, boundingBoxMaker: boundingBoxMaker) {
                completion(viewModel)
              }
            }
        } else {
            print(error!.localizedDescription)
        }
    }
    
    let vnImage = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
    try? vnImage.perform([detectFaceRequest])
  }
  
  func detectFace(from source: UIImageView, completion: @escaping (FaceViewModel, CGContext) -> Void, error: (Error) -> Void ) {
    guard let image = source.image else {
      error(WarholError.noImage)
      return
    }
    
    detectFace(from: image, completion: { viewModel in
      UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
      let context = UIGraphicsGetCurrentContext()!
      self.prepareContextForDrawing(context, image: image)
      
      let rect = CGRect(x: 0, y:0, width: image.size.width, height: image.size.height)
      context.draw(image.cgImage!, in: rect)
      
      completion(viewModel, context)
      
      let processedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      
      source.image = processedImage
    })
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
