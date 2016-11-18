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

import MaterialMotionRuntime

/** Pauses a spring simulation while a gesture recognizer is active. */
@objc(MDMPauseSpring)
public final class PauseSpring: NSObject, Plan {

  /** The property whose springs should be paused while the gesture recognizer is active. */
  public var property: String

  /** The gesture recognizer to observe. */
  public var gestureRecognizer: UIGestureRecognizer

  /** Initialize a PauseSpring plan with a property and gesture recognizer. */
  @objc(initWithProperty:gestureRecognizer:)
  public init(_ property: String, whileActive gestureRecognizer: UIGestureRecognizer) {
    self.property = property
    self.gestureRecognizer = gestureRecognizer
    super.init()
  }

  /** The performer that will fulfill this plan. */
  public func performerClass() -> AnyClass {
    return POPPerformer.self
  }

  /** Returns a copy of this plan. */
  public func copy(with zone: NSZone? = nil) -> Any {
    return PauseSpring(property, whileActive: gestureRecognizer)
  }
}
