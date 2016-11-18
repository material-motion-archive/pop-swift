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
import MaterialMotionPop

import XCTest

class SpringPropertyTests: XCTestCase {

  func testLayerProperties() {
    let layer = CALayer()

    let runtime = Runtime()
    let delegate = TestableRuntimeDelegate()
    delegate.didIdleExpectation = expectation(description: "Did idle")
    runtime.delegate = delegate

    let map: [(POPProperty, Any, String)] = [
      (.layerBackgroundColor, UIColor.red.cgColor, "backgroundColor"),
      (.layerBounds, CGRect(origin: .zero, size: CGSize(width: 1, height: 1)), "bounds"),
      (.layerCornerRadius, 1, "cornerRadius"),
      (.layerBorderWidth, 1, "borderWidth"),
      (.layerBorderColor, UIColor.red.cgColor, "borderColor"),
      (.layerOpacity, 0.9, "opacity"),
      (.layerPosition, CGPoint(x: 1, y: 1), "position"),
      (.layerRotation, 0.1, "transform.rotation"),
      (.layerZPosition, 1, "zPosition"),
      (.layerShadowColor, UIColor.red.cgColor, "shadowColor"),
      (.layerShadowOffset, CGPoint(x: 0.1, y: 0.1), "shadowOffset"),
      (.layerShadowOpacity, 0.9, "shadowOpacity"),
      (.layerShadowRadius, 1, "shadowRadius")
    ]

    for (property, destination, _) in map {
      let animation = SpringTo(property, destination: destination)
      runtime.addPlan(animation, to: layer)
    }

    waitForExpectations(timeout: 10)
    XCTAssertEqual(runtime.activityState, .idle)

    for (_, destination, keyPath) in map {
      let finalValue = layer.value(forKeyPath: keyPath)!
      switch destination {
      case let value as Float:
        XCTAssertEqual(value, (finalValue as! NSNumber).floatValue, keyPath)
      case let value as Double:
        XCTAssertEqualWithAccuracy(value, (finalValue as! NSNumber).doubleValue, accuracy: 0.001, keyPath)
      case let value as Int:
        XCTAssertEqualWithAccuracy(Double(value), (finalValue as! NSNumber).doubleValue, accuracy: 0.01, keyPath)
      case let value as CGPoint:
        let finalPoint = (finalValue as! NSValue).cgPointValue
        XCTAssertEqualWithAccuracy(value.x, finalPoint.x, accuracy: 0.001, keyPath)
        XCTAssertEqualWithAccuracy(value.y, finalPoint.y, accuracy: 0.001, keyPath)
      case let value as CGRect:
        let finalRect = (finalValue as! NSValue).cgRectValue
        XCTAssertEqualWithAccuracy(value.origin.x, finalRect.origin.x, accuracy: 0.001, keyPath)
        XCTAssertEqualWithAccuracy(value.origin.y, finalRect.origin.y, accuracy: 0.001, keyPath)
        XCTAssertEqualWithAccuracy(value.size.width, finalRect.size.width, accuracy: 0.001, keyPath)
        XCTAssertEqualWithAccuracy(value.size.height, finalRect.size.height, accuracy: 0.001, keyPath)
      case let value as CGColor:
        let finalColor = finalValue as! CGColor
        XCTAssertEqual(finalColor.numberOfComponents, value.numberOfComponents)
        for index in 0..<finalColor.numberOfComponents {
          XCTAssertEqual(finalColor.components![index], value.components![index])
        }
      case let value as NSObject:
        XCTAssertEqual(value, (finalValue as! NSObject), keyPath)
      default:
        XCTAssertTrue(false, keyPath)
      }
    }
  }
}
