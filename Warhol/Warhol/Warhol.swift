//
//  Warhol.swift
//  Warhol
//
//  Created by Cesar Vargas on 22.03.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import UIKit
import Vision

public enum WarholError: Error {
  case noImage
}

public func detectLandmarks(in imageView: UIImageView, completion: @escaping (FaceViewModel, CGContext) -> Void, error: (Error) -> Void ) {
  let faceDetector = FaceDetector()
  faceDetector.detectFace(from: imageView, completion: completion, error: error)
}


