//
//  DraggableView+RestingPosition.swift
//
//  Created by Korel Hayrullah on 22.07.2019.
//  Copyright © 2019 Korel Hayrullah. All rights reserved.
//

import Foundation

public extension DraggableView {
  /// The final position of the view when the user doesn't interact with the view.
  enum RestingPosition: Int {
    case upperLeft  = 0
    case upperRight
    case lowerLeft
    case lowerRight
  }
}
