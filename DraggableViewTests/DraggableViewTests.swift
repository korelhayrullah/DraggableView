//
//  DraggableViewTests.swift
//  DraggableViewTests
//
//  Created by Korel Hayrullah on 22.07.2019.
//  Copyright © 2019 Korel Hayrullah. All rights reserved.
//

import XCTest
@testable import DraggableView

class DraggableViewTests: XCTestCase {
  
  var draggableView: DraggableView!
  
  override func setUp() {
    draggableView = DraggableView()
  }
  
  override func tearDown() {
    draggableView = nil
  }
  
  
  func testRestingPosition() {
    let restingPositions: [DraggableView.RestingPosition] = [
      .lowerLeft,
      .lowerRight,
      .upperLeft,
      .upperRight
    ]
    
    restingPositions.forEach { restingPosition in
      draggableView.changeCenter(animated: false, to: restingPosition)
      
      assert(draggableView.currentRestingPosition == restingPosition, "Resting positions does not match after changing center!")
    }
  }
  
  func testInferRestingPositionFromCenter() {
    
    let screenSize = CGSize(width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height)
    
    let minValue = -CGFloat.greatestFiniteMagnitude
    let maxValue = CGFloat.greatestFiniteMagnitude
    
    let midWidth = screenSize.width / 2
    let midHeight = screenSize.height / 2
    
    let testCount = 10
    
    for _ in 0...testCount {
      // should be equal to .upperLeft
      let randPoint1 = CGPoint(x: CGFloat.random(in: minValue...midWidth),
                               y: CGFloat.random(in: minValue...midHeight))
      
      // should be equal to .upperRight
      let randPoint2 = CGPoint(x: CGFloat.random(in: midWidth...maxValue),
                               y: CGFloat.random(in: minValue...midHeight))
      
      // should be equal to .lowerLeft
      let randPoint3 = CGPoint(x: CGFloat.random(in: minValue...midWidth),
                               y: CGFloat.random(in: midHeight...maxValue))
      
      // should be equal to .lowerRight
      let randPoint4 = CGPoint(x: CGFloat.random(in: midWidth...maxValue),
                               y: CGFloat.random(in: midHeight...maxValue))
      
      
      let points = [randPoint1, randPoint2, randPoint3, randPoint4]
      
      let expectedOutcomes: [DraggableView.RestingPosition] = [
        .upperLeft,
        .upperRight,
        .lowerLeft,
        .lowerRight
      ]
      
      zip(points, expectedOutcomes).forEach { (point, expectedOutcome) in
        let inferredOutcome = draggableView.inferRestingPosition(currentCenter: point)
        assert(inferredOutcome == expectedOutcome, "The inferred outcomes does not match with the result of the point: \(point)")
      }
    }
  }
  
  
  func testInferRestingPositionFromForcingDirection() {    
    // Test the values below threshold
    let force = CGPoint(x: 500, y: 1001)
    let threshold: CGFloat = 1000
    let expectedOutcome: DraggableView.ForcingDirection = .noForce
    let outcome = draggableView.inferForcingDirection(velocity: force, threshold: threshold)
    assert(expectedOutcome != outcome, "Outcome should not be equal to .noForce!")
    
    // Test several cases
    let force1 = CGPoint(x: 1001, y: 1001)
    let threshold1: CGFloat = 1000
    let expectedOutcome1: DraggableView.ForcingDirection = .downRight
    let outcome1 = draggableView.inferForcingDirection(velocity: force1, threshold: threshold1)
    assert(expectedOutcome1 == outcome1, "Outcome should be equal to .downRight!")
    
    
    let force2 = CGPoint(x: 850, y: -1001)
    let threshold2: CGFloat = 1000
    let expectedOutcome2: DraggableView.ForcingDirection = .up
    let outcome2 = draggableView.inferForcingDirection(velocity: force2, threshold: threshold2)
    assert(expectedOutcome2 == outcome2, "Outcome should be equal to .up!")
  }
  
  func testInferForcingDirection() {
    // Test several cases
    let previousRestingDirection: DraggableView.RestingPosition = .lowerLeft
    let forcingDirection: DraggableView.ForcingDirection = .upRight
    let expectedOutcome: DraggableView.RestingPosition = .upperRight
    
    let outcome = draggableView.inferRestingPosition(from: forcingDirection,
                                                     previousRestingPosition: previousRestingDirection)
    
    assert(outcome == expectedOutcome, "Outcomes does not match!")
    
    
    
    let previousRestingDirection1: DraggableView.RestingPosition = .lowerRight
    let forcingDirection1: DraggableView.ForcingDirection = .downRight
    let expectedOutcome1: DraggableView.RestingPosition = .lowerRight
    
    let outcome1 = draggableView.inferRestingPosition(from: forcingDirection1,
                                                     previousRestingPosition: previousRestingDirection1)
    
    assert(outcome1 == expectedOutcome1, "Outcomes does not match!")
    
    
    
    let previousRestingDirection2: DraggableView.RestingPosition = .lowerRight
    let forcingDirection2: DraggableView.ForcingDirection = .up
    let expectedOutcome2: DraggableView.RestingPosition = .upperRight
    
    let outcome2 = draggableView.inferRestingPosition(from: forcingDirection2,
                                                      previousRestingPosition: previousRestingDirection2)
    
    assert(outcome2 == expectedOutcome2, "Outcomes does not match!")
    
    
    let previousRestingDirection3: DraggableView.RestingPosition = .lowerRight
    let forcingDirection3: DraggableView.ForcingDirection = .noForce
    
    let outcome3 = draggableView.inferRestingPosition(from: forcingDirection3,
                                                      previousRestingPosition: previousRestingDirection3)
    
    assert(outcome3 == previousRestingDirection3, "Outcomes does not match!")
    
  }
}
