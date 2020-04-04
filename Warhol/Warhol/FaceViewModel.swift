//
//  Warholswift
//  Warhol
//
//  Created by Cesar Vargas on 23.03.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import Foundation
import UIKit
import Vision

public typealias FaceLandmark = [CGPoint]

public struct FaceViewModel {
  internal(set) public var leftEye: FaceLandmark
  internal(set) public var rightEye: FaceLandmark
  internal(set) public var leftEyebrow: FaceLandmark
  internal(set) public var rightEyebrow: FaceLandmark
  internal(set) public var nose: FaceLandmark
  internal(set) public var outerLips: FaceLandmark
  internal(set) public var innerLips: FaceLandmark
  internal(set) public var faceContour: FaceLandmark

  internal(set) public var boundingBox = CGRect.zero

  init() {
    leftEye = []
    rightEye = []
    leftEyebrow = []
    rightEyebrow = []
    nose = []
    outerLips = []
    innerLips = []
    faceContour = []
  }

  static func faceViewModel(from faceObservation: VNFaceObservation,
                            landmarkMaker: (VNFaceLandmarkRegion2D?) -> FaceLandmark?,
                            boundingBoxMaker: (CGRect) -> CGRect) -> FaceViewModel? {
    guard let landmarks = faceObservation.landmarks else {
      return nil
    }

    var viewModel = FaceViewModel()

    viewModel.boundingBox = boundingBoxMaker(faceObservation.boundingBox)

    if let leftEye = landmarkMaker(landmarks.leftEye) {
      viewModel.leftEye = leftEye
    }

    if let rightEye = landmarkMaker(landmarks.rightEye) {
      viewModel.rightEye = rightEye
    }

    if let leftEyebrow = landmarkMaker(landmarks.leftEyebrow) {
      viewModel.leftEyebrow = leftEyebrow
    }

    if let rightEyebrow = landmarkMaker(landmarks.rightEyebrow) {
      viewModel.rightEyebrow = rightEyebrow
    }

    if let nose = landmarkMaker(landmarks.nose) {
      viewModel.nose = nose
    }

    if let outerLips = landmarkMaker(landmarks.outerLips) {
      viewModel.outerLips = outerLips
    }

    if let innerLips = landmarkMaker(landmarks.innerLips) {
      viewModel.innerLips = innerLips
    }

    if let faceContour = landmarkMaker(landmarks.faceContour) {
      viewModel.faceContour = faceContour
    }

    return viewModel
  }
}
