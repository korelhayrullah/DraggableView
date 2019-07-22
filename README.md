# DraggableView
A lightweight draggable view.
[![Version](https://img.shields.io/cocoapods/v/DraggableView.svg?style=flat)](https://cocoapods.org/pods/DraggableView)
[![License](https://img.shields.io/cocoapods/l/DraggableView.svg?style=flat)](https://cocoapods.org/pods/DraggableView)
[![Platform](https://img.shields.io/cocoapods/p/DraggableView.svg?style=flat)](https://cocoapods.org/pods/DraggableView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

DraggableView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DraggableView'
```

## Usage

```swi
var draggableView = DraggableView()

// The padding value that it will stay far from the edges
draggableView.padding = 16

// The threshold value defines the velocity on both x and y axis. After draging the view, the view will position itself according to the x and y velocity if the threshold condition is met. Othwerwise, it will position itself to the nearest corner. See the source code on how it positions itself. 
draggableView.threshold = 1500
```



## Author

korelhayrullah, korel.hayrullah@gmail.com

## License

DraggableView is available under the MIT license. See the LICENSE file for more info.
