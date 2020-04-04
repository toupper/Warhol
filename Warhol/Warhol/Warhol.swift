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
  case noImagePassed
  case noFaceDetected
  case internalError(Error)
}

/**
 Detects a face given a UIImageView instance, and asks the caller to draw on it.

- Parameter imageView: The image view containing the face to be detected.
- Parameter draw: This closure is called when the face is detected.
The caller is asked to draw given the detected view model and a context
- Parameter error: Called when an error is found
*/
public func drawLandmarks(in imageView: UIImageView,
                          draw: @escaping (FaceViewModel, CGContext) -> Void,
                          error: @escaping (Error) -> Void) {
  let faceDetector = FaceDetector()
  faceDetector.drawLandmarks(in: imageView, draw: draw, error: error)
}

/**
 Detects a face given a UIImageView instance, and asks the caller to draw generating a new one.

- Parameter imageView: The image view containing the face to be detected.
- Parameter draw: This closure is called when the face is detected.
The caller is asked to draw given the detected view model and a context
- Parameter completion: Called when the new image has been generated.
It is composed of the original image in the background and the caller drawing on top.
- Parameter error: Called when an error is found
*/
public func drawLandmarksInNewImage(from imageView: UIImageView,
                                    draw: @escaping (FaceViewModel, CGContext) -> Void,
                                    completion: @escaping (UIImage) -> Void,
                                    error: @escaping (Error) -> Void) {
  let faceDetector = FaceDetector()
  faceDetector.drawLandmarksInNewImage(from: imageView, draw: draw, completion: completion, error: error)
}
