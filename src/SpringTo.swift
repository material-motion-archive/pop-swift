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

/**
 Pull a property towards a specific value using a POP spring.

 When multiple plans are added to the same property, the last-registered plan's destination will be
 used.
 */
@objc(MDMSpringTo)
public final class SpringTo: NSObject, Plan {

  /** The property whose value should be pulled towards the destination. */
  public var property: String

  /** The value to which the property should be pulled. */
  public var destination: Any

  /**
   The spring's desired configuration.

   If nil then the spring's configuration will not be affected.
   */
  public var configuration = SpringTo.defaultConfiguration

  /**
   The default spring configuration.

   Default extracted from a POP spring with speed = 12 and bounciness = 4.
   */
  public static var defaultConfiguration: SpringConfiguration {
    get {
      // Always return a new instance so that the values can't be changed externally.
      return SpringConfiguration(tension: 342, friction: 30)
    }
  }

  /** Initialize a SpringTo plan with a property and destination. */
  @objc(initWithProperty:destination:)
  public init(_ property: String, destination: Any) {
    self.property = property
    self.destination = coerce(value: destination)
  }

  /** The performer that will fulfill this plan. */
  public func performerClass() -> AnyClass {
    return POPPerformer.self
  }
  /** Returns a copy of this plan. */
  public func copy(with zone: NSZone? = nil) -> Any {
    let springTo = SpringTo(property, destination: destination)
    springTo.configuration = (configuration.copy() as! SpringConfiguration)
    return springTo
  }
}

/**
 Configure the spring traits for a given property.

 Affects the spring behavior of the SpringTo plan.
 */
@objc(MDMSpringConfiguration)
public final class SpringConfiguration: NSObject, NSCopying {
  /**
   The tension coefficient for the property's spring.

   If nil, the spring's tension will not be changed.
   */
  public var tension: CGFloat

  /**
   The friction coefficient for the property's spring.

   If nil, the spring's friction will not be changed.
   */
  public var friction: CGFloat

  /** Initializes the configuration with a given tension and friction. */
  @objc(initWithTension:friction:)
  public init(tension: CGFloat, friction: CGFloat) {
    self.tension = tension
    self.friction = friction
  }

  /** Returns a copy of this configuration. */
  public func copy(with zone: NSZone? = nil) -> Any {
    return SpringConfiguration(tension: tension, friction: friction)
  }
}
