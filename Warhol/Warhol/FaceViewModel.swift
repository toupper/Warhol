//
//  WarholFaceViewModel.swift
//  Warhol
//
//  Created by Cesar Vargas on 23.03.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import Foundation
import UIKit

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
  
  mutating func clear() {
    leftEye = []
    rightEye = []
    leftEyebrow = []
    rightEyebrow = []
    nose = []
    outerLips = []
    innerLips = []
    faceContour = []
    
    boundingBox = .zero
  }
}
