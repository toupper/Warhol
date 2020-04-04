# Warhol
> Warhol is a library written in Swift that makes easy the process of Face Detection and drawing on IOS.

[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)  
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

Warhol acts as a wrapper on top of the Apple Vision Framework, detecting the features of a face from camera or image and provising these elements position in your own coordinates, so you can easily draw on top. You can therefore absolutely forget about the Vision or AVFoundation frameworks, just handle the Warhol Face View Model class that encapsulates the features coordinates.

## Features

- [x] Face Detection from Camera
- [x] Face Detection from UIImageView
- [x] Face features conversion to the client coordinates.
- [x] Draw on top of the face.

## Requirements

- iOS 11.0+
- Xcode 11.0+

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `Warhol` by adding it to your `Podfile`:

```ruby
platform :ios, '11.0'
use_frameworks!
pod 'Warhol'
```

To get the full benefits import `Warhol` wherever you use it

``` swift
import Wahol
```
### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate Alamofire into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "toupper/Warhol" ~> 0.1.0
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but Alamofire does support its use on supported platforms.

Once you have your Swift package set up, adding Alamofire as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/toupper/Warhol.git", .upToNextMajor(from: "0.1.0"))
]
```
## Manually

You can also integrate Alamofire into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add Warhol as a git [submodule](https://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/toupper/Warhol.git
  ```

- Open the new `Warhol` folder, and drag the `Warhol.xcodeproj` into the Project Navigator of your application's Xcode project.

- And that's it!

## Usage example

### With Camera

Import Warhol in the file you are going to use it. Create an instance of ```CameraFaceDetectionViewController```, and asign the view where you are going to draw to the ```cameraFrontView``` property of the former. You can then present the view controller:

```swift
import Warhol
let cameraViewController = CameraFaceDetectionViewController()
    let faceView = FaceView()
    faceView.backgroundColor = .clear
    cameraViewController.cameraFrontView = faceView
    present(cameraViewController, animated: true, completion: nil)
```

In order to draw, we should create a subclass of UIView that complies with the Warhol protocol FaceView. We can then draw in their ```func draw(_ rect: CGRect)``` function:

```swift
import Warhol
inal class FaceView: UIView, CameraFrontView {
  var viewModel: FaceViewModel?

  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext(),
          let viewModel = viewModel else {
      return
    }

    context.saveGState()

    defer {
      context.restoreGState()
    }

    context.addRect(viewModel.boundingBox)

    ...
```

### With Image

In order to detect a face features and draw on top, we should pass the sdk the UIImageView depicting the face, and a closure where we draw on top of the image:
```swift
    import Warhol
    imageView.image = UIImage(named: "Face")
    Warhol.drawLandmarks(from: imageView,
                                   draw: { (viewModel, context)  in
                                    // draw with CGContext
                                    },
                                     error: {_ in })
```

If instead of modifying the passed image of the you want to generate a new UIImageView instance, use ```drawLandmarksInNewImage```:

```swift
imageView.image = UIImage(named: "Face")
    Warhol.drawLandmarksInNewImage(from: imageView,
                                   draw: { (viewModel, context)  in
                                    self.draw(viewModel: viewModel, in: context)
    }, completion: { newImage in
      self.newImageView.image = newImage
    },
    error: {_ in })
```
## Contribute

We would love you for the contribution to **Warhol**, check the ``LICENSE`` file for more info.

## Meta

Created and maintained by [César Vargas Casaseca](https://github.com/toupper). You can follow me om Medium [@toupper](https://medium.com/@toupper) for project updates, releases and more stories.

## License

Warhol is released under the MIT license. [See LICENSE](https://github.com/toupper/Warhol/blob/master/LICENSE) for details.

[swift-image]:https://img.shields.io/badge/swift-5.2-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: https://github.com/toupper/Warhol/blob/master/LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
