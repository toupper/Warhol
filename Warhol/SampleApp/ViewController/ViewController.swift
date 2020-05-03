//
//  ViewController.swift
//  SampleApp
//
//  Created by Vargas Casaseca, Cesar on 18.06.18.
//  Copyright © 2018 Vargas Casaseca, Cesar. All rights reserved.
//

import UIKit
import Warhol

class ViewController: UIViewController {
  @IBAction func openCameraWithClientDrawingButtonWasPressed(_ sender: Any) {
    let cameraViewController = CameraFaceDetectionViewController()

    let faceView = FaceView()
    faceView.backgroundColor = .clear
    cameraViewController.cameraFrontView = faceView

    present(cameraViewController, animated: true, completion: nil)
  }

  @IBAction func openCameraWithImageFeatures(_ sender: Any) {
    let cameraViewController = CameraFaceDetectionViewController()

    let leftEye = ImageLayout(image: UIImage(named: "leftEye")!, sizeRatio: SizeRatio(width: 1, height: 4))
    let rightEye = ImageLayout(image: UIImage(named: "rightEye")!, sizeRatio: SizeRatio(width: 1, height: 4))
    let nose = ImageLayout(image: UIImage(named: "nose")!)

    let faceLayout = FaceLayout(landmarkLayouts: [.leftEye: leftEye,
                                                  .rightEye: rightEye,
                                                  .nose: nose])
    cameraViewController.faceLayout = faceLayout

    present(cameraViewController, animated: true, completion: nil)

  }

  @IBAction func openImageButtonWasPressed(_ sender: Any) {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let imageViewController = mainStoryboard.instantiateViewController(withIdentifier: "ImageViewController")
     present(imageViewController, animated: true, completion: nil)
  }
}
