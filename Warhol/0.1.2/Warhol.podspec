#
# Be sure to run `pod lib lint Warhol.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Warhol"
  s.version          = "0.1.2"
  s.summary          = "Face detection made easy."
  s.description      = <<-DESC
			Warhol acts as a wrapper on top of the Apple Vision Framework, detecting the features of a face from camera or image and providing these elements position in your own coordinates, so you can easily draw on top.
                       DESC
  s.homepage         = "https://github.com/toupper/Warhol"
  s.license          = 'MIT'
  s.author           = { "César Vargas Casaseca" => "c.vargas.casaseca@gmail.com" }
  s.source           = { :git => "https://github.com/toupper/Warhol.git", :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.requires_arc = true

  s.ios.source_files = 'Warhol/Warhol/**/*.{h,m,swift}'

  s.swift_version = "5.2"
end
