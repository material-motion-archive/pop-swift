/*
 Copyright 2016-present The Material Motion Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import XCTest
import MaterialMotionRuntime
import MaterialMotionPopFamily

class SpringToTests: XCTestCase {

  func testDidPerformAndIdleOnLayer() {
    let animation = SpringTo(.layerOpacity, destination: 1)

    let layer = CALayer()

    let runtime = Runtime()
    let delegate = TestableRuntimeDelegate()

    delegate.didIdleExpectation = expectation(description: "Did idle")
    runtime.delegate = delegate

    runtime.addPlan(animation, to: layer)

    waitForExpectations(timeout: 0.3)
    XCTAssertEqual(runtime.activityState, .idle)
  }

  func testDidChangeToValue() {
    let animation = SpringTo(.layerOpacity, destination: 1)

    let layer = CALayer()

    let runtime = Runtime()
    let delegate = TestableRuntimeDelegate()
    runtime.delegate = delegate

    runtime.addPlan(animation, to: layer)
    animation.destination = Float(0.9)
    runtime.addPlan(animation, to: layer)

    delegate.didIdleExpectation = expectation(description: "Did idle")
    waitForExpectations(timeout: 1)

    XCTAssertEqual(runtime.activityState, .idle)
    XCTAssertEqual(layer.opacity, animation.destination as! Float)
  }

  class PositionTraceLayer: CALayer {
    var values: [CGPoint] = []

    override var position: CGPoint {
      set {
        values.append(newValue)
        super.position = newValue
      }
      get {
        return super.position
      }
    }
  }

  func testNotBouncySpringIsLessBouncy() {
    let layer = PositionTraceLayer()

    let runtime = Runtime()
    let delegate = TestableRuntimeDelegate()
    runtime.delegate = delegate

    let springTo = SpringTo(.layerPosition, destination: CGPoint(x: 10, y: 10))
    springTo.configuration = SpringConfiguration(tension: SpringTo.defaultTension,
                                                 friction: sqrt(4 * SpringTo.defaultTension) * 0.7)
    runtime.addPlan(springTo, to: layer)

    delegate.didIdleExpectation = expectation(description: "Did idle")
    waitForExpectations(timeout: 1)

    // Calculate the maximum overshoot; a bouncy spring should overshoot the destination value
    XCTAssertEqual(runtime.activityState, .idle)
    var maxXPosition: CGFloat = 0
    for point in layer.values {
      maxXPosition = max(point.x, maxXPosition)
    }
    XCTAssertGreaterThan(maxXPosition, 10)

    // Reset state
    layer.position = .zero
    layer.values.removeAll()

    springTo.configuration = SpringConfiguration(tension: SpringTo.defaultTension,
                                                 friction: sqrt(4 * SpringTo.defaultTension) * 1.0)
    runtime.addPlan(springTo, to: layer)

    delegate.activityStateDidChange = false
    delegate.didIdleExpectation = expectation(description: "Did idle")
    waitForExpectations(timeout: 1)

    XCTAssertEqual(runtime.activityState, .idle)
    for point in layer.values {
      XCTAssertLessThan(point.x, maxXPosition, "Expected not to overshoot springy max")
    }
  }
}
