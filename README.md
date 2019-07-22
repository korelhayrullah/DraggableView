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

The usage is simple as creating an instance of a basic UIView :smile:.

```swi
var draggableView = DraggableView()

// The padding value that it will stay far from the edges
draggableView.padding = 16

// The threshold value defines the velocity on both x and y axis.
// After draging the view, the view will position itself according to
// the x and y velocity if the threshold condition is met.
// Othwerwise, it will position itself to the nearest corner. 
// See the source code on how it positions itself. 
draggableView.threshold = 1500
```

##### UIViewController Example

```swift
import UIKit
import DraggableView

class CustomView: DraggableView {
  // Your custom codes...
}

class ViewController: UIViewController {
  
  let draggableView = CustomView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setDraggableView()
  }
  
  func setDraggableView() {
    draggableView.translatesAutoresizingMaskIntoConstraints = false
    draggableView.backgroundColor = .darkGray
    
    view.addSubview(draggableView)
    
    draggableView.padding = 10
    draggableView.threshold = 1500
    
    let screenSize = UIScreen.main.bounds
    
    NSLayoutConstraint.activate([
      draggableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: draggableView.padding),
      draggableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -draggableView.padding),
      draggableView.heightAnchor.constraint(equalToConstant: screenSize.height * 0.4),
      draggableView.widthAnchor.constraint(equalToConstant: screenSize.width * 0.5)
      ])
  }
}


```



## Author

korelhayrullah, korel.hayrullah@gmail.com

## License

DraggableView is available under the MIT license. See the LICENSE file for more info.
