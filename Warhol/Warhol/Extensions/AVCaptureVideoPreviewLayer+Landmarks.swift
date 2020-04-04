//
//  AVCaptureVideoPreviewLayer+Landmarks.swift
//  Warhol
//
//  Created by Cesar Vargas on 23.03.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import Foundation
import AVFoundation

extension AVCaptureVideoPreviewLayer {
  func convert(rect: CGRect) -> CGRect {
    let origin = layerPointConverted(fromCaptureDevicePoint: rect.origin)
    let size = layerPointConverted(fromCaptureDevicePoint: rect.size.cgPoint)

    return CGRect(origin: origin, size: size.cgSize)
  }

  func landmark(point: CGPoint, to rect: CGRect) -> CGPoint {
    let absolute = point.absolutePoint(in: rect)
    let converted = layerPointConverted(fromCaptureDevicePoint: absolute)

    return converted
  }
}
