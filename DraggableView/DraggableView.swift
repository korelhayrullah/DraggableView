//
//  DraggableView.swift
//
//  Created by Korel Hayrullah on 22.07.2019.
//  Copyright © 2019 Korel Hayrullah. All rights reserved.
//

import UIKit

open class DraggableView: UIView {
  // MARK: -Properties
  private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
    let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                   action: #selector(handlePan(_:)))
    gestureRecognizer.delegate = self
    return gestureRecognizer
  }()
  
  public var paddingInsets: UIEdgeInsets {
    let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    return UIEdgeInsets(top: safeAreaInsets.top + padding,
                        left: safeAreaInsets.left + padding,
                        bottom: safeAreaInsets.bottom + padding,
                        right: safeAreaInsets.right + padding)
  }
  
  /// The default resting position of the view.
  public var defaultRestingPosition: RestingPosition = .upperRight {
    didSet {
      changeCenter(animated: true, to: defaultRestingPosition)
      previousRestingPosition = defaultRestingPosition
    }
  }
  
  private var previousRestingPosition: RestingPosition = .upperRight
  
  /// Returns the current resting position of the view.
  var currentRestingPosition: RestingPosition {
    return previousRestingPosition
  }
  
  /// The threshold value to be applied on force calculations.
  open var threshold: CGFloat = 1400
  
  /// The padding amount when the view rests in one of the corners.
  open var padding: CGFloat = 16
  
  
  /// Enable or disable the draggin feature.
  public var isDraggingEnabled: Bool = true {
    willSet {
      panGestureRecognizer.isEnabled = newValue
    }
  }
  
  weak var delegate: DraggableViewDelegate?
  
  // MARK: -Methods
  override public init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  private func initialize() {
    addGestureRecognizer(panGestureRecognizer)
  }
  
  // MARK: -Actions
  @objc
  private func handlePan(_ sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: self)
    let currentCenter = CGPoint(x: center.x + translation.x,
                                y: center.y + translation.y)
    
    delegate?.draggableview(self, gestureRecognizer: sender)
    switch sender.state {
    case .began:
      delegate?.draggableViewDidStartDragging(self)
    case .changed:
      center = currentCenter
    case .ended:
      delegate?.draggableviewDidEndDragging(self)
      
      let restingPosition: RestingPosition
      let velocity = sender.velocity(in: self)
      let forcingDirection = inferForcingDirection(velocity: velocity, threshold: threshold)
      
      if forcingDirection == .noForce {
        restingPosition = inferRestingPosition(currentCenter: currentCenter)
      } else {
        restingPosition = inferRestingPosition(from: forcingDirection)
      }
      
      changeCenter(animated: true, to: restingPosition)
    case .cancelled:
      delegate?.draggableviewDidCancel(self)
    case .failed:
      delegate?.draggableviewDidFail(self)
    default:
      break
    }
    
    sender.setTranslation(.zero, in: self)
  }
  
  public func changeCenter(animated: Bool, to restingPosition: RestingPosition) {
    let newCenter = calculateNewCenter(restingPosition: restingPosition)
    
    if animated {
      UIView.animate(withDuration: 0.5,
                     delay: 0,
                     usingSpringWithDamping: 0.7,
                     initialSpringVelocity: 0.8,
                     options: [.curveEaseIn, .allowUserInteraction],
                     animations: { [weak self] in
                      self?.center = newCenter
      })
    } else {
      center = newCenter
    }
    
    previousRestingPosition = restingPosition
  }
  
  /**
   - Parameter currentCenter: The current center of the view in order to infer the resting position of the view.
   - Returns: The corresponding resting position of the given `currentCenter`.
   */
  public func inferRestingPosition(currentCenter: CGPoint) -> RestingPosition {
    let screenSize = CGSize(width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height)
    
    let minValue = -CGFloat.greatestFiniteMagnitude
    let maxValue = CGFloat.greatestFiniteMagnitude
    
    let midWidth = screenSize.width / 2
    let midHeight = screenSize.height / 2
    
    switch (currentCenter.x, currentCenter.y) {
    case (minValue...midWidth, minValue...midHeight):
      return .upperLeft
    case (midWidth...maxValue, minValue...midHeight):
      return .upperRight
    case (minValue...midWidth, midHeight...maxValue):
      return .lowerLeft
    case (midWidth...maxValue, midHeight...maxValue):
      return .lowerRight
    default:
      return .upperRight
    }
  }
  
  /**
   - Parameter velocity: The velocity of the force in order to infer the forcing direction.
   - Parameter threshold: The threshold that the velocity has to have in order to infer the forcing direction. If the velocity of x and y are below the threshold value, then it will return `ForcingDirection.noForce` and will just infer the resting position using the `inferRestingPosition(currentCenter:)` method.
   - Returns: The inferred `ForcingDirection`.
   */
  public func inferForcingDirection(velocity: CGPoint, threshold: CGFloat) -> ForcingDirection {
    let x = velocity.x
    let y = velocity.y
    
    if x > threshold && y > threshold {
      return .downRight
    } else if x < -threshold && y > threshold {
      return .downLeft
    } else if x > threshold && y < -threshold {
      return .upRight
    } else if x < -threshold && y < -threshold {
      return .upLeft
    } else if x > threshold {
      return .right
    } else if x < -threshold {
      return .left
    } else if y > threshold {
      return .down
    } else if y < -threshold {
      return .up
    } else {
      return .noForce
    }
  }
  
  /**
   - Parameter forcingDirection: The specified forcing direction to infer the resting position of the view.
   - Parameter previousRestingPosition: If this value is provided it will infer the resting position of the view based on this previous resting view. If not provided, it will use its property `previousRestingPosition`.
   - Returns: The corresponding resting position.
   */
  public func inferRestingPosition(from forcingDirection: ForcingDirection, previousRestingPosition: RestingPosition? = nil) -> RestingPosition {
    let _previousRestingPosition = previousRestingPosition ?? self.previousRestingPosition
    
    switch forcingDirection {
    case .down:
      switch _previousRestingPosition {
      case .upperLeft:
        return .lowerLeft
      case .upperRight:
        return .lowerRight
      case .lowerLeft, .lowerRight:
        return _previousRestingPosition
      }
    case .up:
      switch _previousRestingPosition {
      case .upperLeft, .upperRight:
        return _previousRestingPosition
      case .lowerLeft:
        return .upperLeft
      case .lowerRight:
        return .upperRight
      }
    case .left:
      switch _previousRestingPosition {
      case .upperLeft, .lowerLeft:
        return _previousRestingPosition
      case .upperRight:
        return .upperLeft
      case .lowerRight:
        return .lowerLeft
      }
    case .right:
      switch _previousRestingPosition {
      case .upperRight, .lowerRight:
        return _previousRestingPosition
      case .upperLeft:
        return .upperRight
      case .lowerLeft:
        return .lowerRight
      }
    case .downLeft:
      switch _previousRestingPosition {
      case .upperLeft, .upperRight:
        return .lowerLeft
      case .lowerLeft:
        return _previousRestingPosition
      case .lowerRight:
        return .lowerLeft
      }
    case .downRight:
      switch _previousRestingPosition {
      case .upperLeft, .upperRight:
        return .lowerRight
      case .lowerLeft:
        return .lowerRight
      case .lowerRight:
        return _previousRestingPosition
      }
    case .upLeft:
      switch _previousRestingPosition {
      case .upperLeft:
        return _previousRestingPosition
      case .upperRight:
        return .upperLeft
      case .lowerLeft, .lowerRight:
        return .upperLeft
      }
    case .upRight:
      switch _previousRestingPosition {
      case .upperLeft:
        return .upperRight
      case .upperRight:
        return _previousRestingPosition
      case .lowerLeft, .lowerRight:
        return .upperRight
      }
    case .noForce:
      return _previousRestingPosition
    }
  }
  
  private func calculateNewCenter(restingPosition: RestingPosition) -> CGPoint {
    let screenSize = CGSize(width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height)
    let x: CGFloat
    let y: CGFloat
    
    switch restingPosition {
    case .upperLeft:
      x = (frame.width / 2) + paddingInsets.right
      y = (frame.height / 2) + paddingInsets.top
    case .upperRight:
      x = (screenSize.width - frame.width / 2) - paddingInsets.left
      y = (frame.height / 2) + paddingInsets.top
    case .lowerLeft:
      x = (frame.width / 2) + paddingInsets.left
      y = (screenSize.height - frame.height / 2) - paddingInsets.bottom
    case .lowerRight:
      x = (screenSize.width - frame.width / 2) - paddingInsets.right
      y = (screenSize.height - frame.height / 2) - paddingInsets.bottom
    }
    
    return CGPoint(x: x, y: y)
  }
}

// MARK: -UIGestureRecognizerDelegate
extension DraggableView: UIGestureRecognizerDelegate {}
