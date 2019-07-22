//
//  DraggableViewDelegate.swift
//
//  Created by Korel Hayrullah on 22.07.2019.
//  Copyright © 2019 Korel Hayrullah. All rights reserved.
//

import UIKit

public protocol DraggableViewDelegate: class {
  func draggableViewDidStartDragging(_ draggableview: DraggableView)
  func draggableviewDidEndDragging(_ draggableview: DraggableView)
  func draggableviewDidCancel(_ draggableview: DraggableView)
  func draggableviewDidFail(_ draggableview: DraggableView)
  func draggableview(_ draggableview: DraggableView, gestureRecognizer: UIPanGestureRecognizer)
}

public extension DraggableViewDelegate {
  func draggableViewDidStartDragging(_ draggableview: DraggableView) {}
  func draggableviewDidEndDragging(_ draggableview: DraggableView) {}
  func draggableviewDidCancel(_ draggableview: DraggableView) {}
  func draggableviewDidFail(_ draggableview: DraggableView) {}
  func draggableview(_ draggableview: DraggableView, gestureRecognizer: UIPanGestureRecognizer) {}
}
