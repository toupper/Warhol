//
//  WarholCameraViewController.swift
//  Warhol
//
//  Created by Cesar Vargas on 22.03.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import AVFoundation
#if !os(macOS)
  import UIKit
#endif
import Vision

/// Views to be updated when a face is detected should comply with this protocol
public protocol CameraFrontView: UIView {
  var viewModel: FaceViewModel? { get set }
}

public protocol CameraFaceDetectionDelegate: class {
  func faceViewModelDidUpdate(_ viewModel: FaceViewModel)
  func errorDidHappenWhenUpdating(_ error: WarholError)
}

/// This view controller shows the camera and updates the front view when a face is detected
public class CameraFaceDetectionViewController: UIViewController {
  public weak var delegate: CameraFaceDetectionDelegate?
  var sequenceHandler = VNSequenceRequestHandler()

  private var faceViewModel = FaceViewModel()
  private let faceDetector = FaceDetector()

  /// This view will be called to draw through the draw(_ rect: CGRect) function
  /// when the face is detected and the view model updated
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
    view.adjustSubviewToEdges(subView: frontView)
  }

  let session = AVCaptureSession()
  var previewLayer: AVCaptureVideoPreviewLayer!

  let dataOutputQueue = DispatchQueue(
    label: "video data queue",
    qos: .userInitiated,
    attributes: [],
    autoreleaseFrequency: .workItem)

  var faceViewHidden = false

  override public func viewDidLoad() {
    super.viewDidLoad()
    configureCaptureSession()

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
  public func captureOutput(_ output: AVCaptureOutput,
                            didOutput sampleBuffer: CMSampleBuffer,
                            from connection: AVCaptureConnection) {
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }

    faceDetector.detectFace(from: imageBuffer, previewLayer: previewLayer, completion: {viewModel in
      self.delegate?.faceViewModelDidUpdate(self.faceViewModel)
      self.cameraFrontView?.viewModel = viewModel

      DispatchQueue.main.async {
        self.cameraFrontView?.setNeedsDisplay()
      }
    }, error: { error in
      self.delegate?.errorDidHappenWhenUpdating(error)
    })
  }
}
