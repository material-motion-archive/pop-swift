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
import MaterialMotionPopMotionFamily

class SpringToTests: XCTestCase {

  func testDidPerformAndIdleOnLayer() {
    let animation = SpringTo(.layerOpacity, destination: 1)

    let layer = CALayer()

    let transaction = Transaction()
    transaction.add(plan: animation, to: layer)

    let scheduler = Scheduler()
    let delegate = TestableSchedulerDelegate()

    delegate.didIdleExpectation = expectation(description: "Did idle")
    scheduler.delegate = delegate

    scheduler.commit(transaction: transaction)

    waitForExpectations(timeout: 0.3)
    XCTAssertEqual(scheduler.activityState, .idle)
  }

  func testDidChangeToValue() {
    let animation = SpringTo(.layerOpacity, destination: 1)

    let layer = CALayer()

    let scheduler = Scheduler()
    let delegate = TestableSchedulerDelegate()
    scheduler.delegate = delegate

    let transaction = Transaction()
    transaction.add(plan: animation, to: layer)
    animation.destination = Float(0.9)
    transaction.add(plan: animation, to: layer)
    scheduler.commit(transaction: transaction)

    delegate.didIdleExpectation = expectation(description: "Did idle")
    waitForExpectations(timeout: 1)

    XCTAssertEqual(scheduler.activityState, .idle)
    XCTAssertEqual(layer.opacity, animation.destination as! Float)
  }
}
