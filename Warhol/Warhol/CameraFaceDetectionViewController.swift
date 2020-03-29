//
//  WarholCameraViewController.swift
//  Warhol
//
//  Created by Cesar Vargas on 22.03.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import AVFoundation
import UIKit
import Vision

public protocol CameraFrontView: UIView {
  var viewModel: FaceViewModel? { get set }
}

public protocol CameraFaceDetectionDelegate: class {
  func faceViewModelDidUpdate(_ viewModel: FaceViewModel)
}

public class CameraFaceDetectionViewController: UIViewController {
  public weak var delegate: CameraFaceDetectionDelegate?
  var sequenceHandler = VNSequenceRequestHandler()

  private var faceViewModel = FaceViewModel()
  private let faceDetector = FaceDetector()
  
  public var cameraFrontView: CameraFrontView? {
    willSet {
      guard let faceView = newValue else {
        return
      }
      
      addCameraFrontView(faceView)
    }
  }
  
  private func addCameraFrontView(_ frontView: UIView) {
    view.addSubview(frontView)
    
    frontView.translatesAutoresizingMaskIntoConstraints = false
    
    let horizontalConstraint = NSLayoutConstraint(item: frontView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
    let verticalConstraint = NSLayoutConstraint(item: frontView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
    let widthConstraint = NSLayoutConstraint(item: frontView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
    let heightConstraint = NSLayoutConstraint(item: frontView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0)
    
    view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
  }
  
  let session = AVCaptureSession()
  var previewLayer: AVCaptureVideoPreviewLayer!
  
  let dataOutputQueue = DispatchQueue(
    label: "video data queue",
    qos: .userInitiated,
    attributes: [],
    autoreleaseFrequency: .workItem)

  var faceViewHidden = false
  
  var maxX: CGFloat = 0.0
  var midY: CGFloat = 0.0
  var maxY: CGFloat = 0.0

  override public func viewDidLoad() {
    super.viewDidLoad()
    configureCaptureSession()
        
    maxX = view.bounds.maxX
    midY = view.bounds.midY
    maxY = view.bounds.maxY
    
    session.startRunning()
  }
}

// MARK: - Video Processing methods
extension CameraFaceDetectionViewController {
  func configureCaptureSession() {
    connectCameraToCaptureSessionInput()
    addVideoDataOutputToSession()
    configurePreviewLayer()
  }
  
  private func connectCameraToCaptureSessionInput() {
    guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                               for: .video,
                                               position: .front) else {
      fatalError("No front video camera available")
    }
    
    do {
      let cameraInput = try AVCaptureDeviceInput(device: camera)
      session.addInput(cameraInput)
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
  private func addVideoDataOutputToSession() {
    let videoOutput = AVCaptureVideoDataOutput()
    videoOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
    videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
    
    session.addOutput(videoOutput)
    
    let videoConnection = videoOutput.connection(with: .video)
    videoConnection?.videoOrientation = .portrait
  }
  
  private func configurePreviewLayer() {
    previewLayer = AVCaptureVideoPreviewLayer(session: session)
    previewLayer.videoGravity = .resizeAspectFill
    previewLayer.frame = view.bounds
    view.layer.insertSublayer(previewLayer, at: 0)
  }
}

extension CameraFaceDetectionViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
  public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }
    
    faceDetector.detectFace(from: imageBuffer, previewLayer: previewLayer, completion: {viewModel in
      self.delegate?.faceViewModelDidUpdate(self.faceViewModel)
      self.cameraFrontView?.viewModel = viewModel
      
      DispatchQueue.main.async {
        self.cameraFrontView?.setNeedsDisplay()
      }
    })
  }
}
