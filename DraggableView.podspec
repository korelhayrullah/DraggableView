#
#  Be sure to run `pod spec lint DraggableView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "DraggableView"
  spec.version      = "0.0.2"
  spec.summary      = "A lightweight draggable view."
  spec.homepage     = "https://github.com/korelhayrullah/DraggableView"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "korelhayrullah" => "korel.hayrullah@gmail.com" }
  spec.platform     = :ios
  spec.source       = { :git => "https://github.com/korelhayrullah/DraggableView.git", :tag => "#{spec.version}" }
  spec.framework = "UIKit"
  spec.source_files  = "DraggableView/**/*.{swift}"
  spec.swift_version = "5"
  spec.ios.deployment_target  = '11.0'
end
