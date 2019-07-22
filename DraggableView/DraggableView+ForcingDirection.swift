//
//  DraggableView+ForcingDirection.swift
//
//  Created by Korel Hayrullah on 22.07.2019.
//  Copyright © 2019 Korel Hayrullah. All rights reserved.
//

import Foundation

public extension DraggableView {
  // The forcing direction of the view. If there is no force applied to the view, then no force would be the value.
  enum ForcingDirection: Int {
    case down = 0
    case up
    case left
    case right
    case downLeft
    case downRight
    case upLeft
    case upRight
    case noForce
  }
}
