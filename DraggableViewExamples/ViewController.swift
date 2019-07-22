//
//  ViewController.swift
//  DraggableViewExamples
//
//  Created by Korel Hayrullah on 22.07.2019.
//  Copyright © 2019 Korel Hayrullah. All rights reserved.
//

import UIKit
import DraggableView

class ViewController: UIViewController {
  
  var draggableView = DraggableView()
  
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

