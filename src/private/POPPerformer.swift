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
import pop

class POPPerformer: NSObject, ContinuousPerforming {
  deinit {
    for key in springs.values.map({ $0.key }) {
      target.pop_removeAnimation(forKey: key)
    }
  }

  let target: NSObject
  required init(target: Any) {
    self.target = target as! NSObject
  }

  func addPlan(_ plan: Plan) {
    switch plan {
    case let springTo as SpringTo:
      self.addSpringTo(springTo)
    case let pausesSpring as PausesSpring:
      self.addPausesSpring(pausesSpring)
    default:
      assertionFailure("Unknown plan: \(plan)")
    }
  }

  // MARK: SpringTo

  private func addSpringTo(_ springTo: SpringTo) {
    let spring = springForProperty(springTo.property)
    spring.animation.dynamicsFriction = springTo.configuration.friction
    spring.animation.dynamicsTension = springTo.configuration.tension
    spring.animation.toValue = springTo.destination
    spring.animation.isPaused = false

    if tokens[spring.animation] == nil {
      tokens[spring.animation] = tokenGenerator.generate()!
    }
  }

  // MARK: PausesSpring

  var gestureRecognizerToProperties: [UIGestureRecognizer: [String]] = [:]
  private func addPausesSpring(_ pausesSpring: PausesSpring) {
    pausesSpring.gestureRecognizer.addTarget(self, action: #selector(gestureDidUpdate))

    gestureRecognizerToProperties[pausesSpring.gestureRecognizer,
                                  withDefault: []].append(pausesSpring.property)

    gestureDidUpdate(pausesSpring.gestureRecognizer)
  }

  // MARK: Gesture events

  func gestureDidUpdate(_ gestureRecognizer: UIGestureRecognizer) {
    let gestureIsActive = gestureRecognizer.state == .began || gestureRecognizer.state == .changed
    if gestureIsActive {
      for property in gestureRecognizerToProperties[gestureRecognizer]! {
        guard let spring = springs[property] else {
          continue
        }
        spring.activeGestureRecognizers.insert(gestureRecognizer)
        target.pop_removeAnimation(forKey: spring.key)
      }
      return
    }

    for property in gestureRecognizerToProperties[gestureRecognizer]! {
      guard let spring = springs[property] else {
        continue
      }
      spring.activeGestureRecognizers.remove(gestureRecognizer)

      if spring.activeGestureRecognizers.count == 0 {
        spring.animation.fromValue = nil

        // We create a copy of the animation in order to blow away internal POP state from the old
        // animation.
        let copy = spring.animation.copy() as! POPSpringAnimation
        spring.animation = copy

        // Eventually terminated by pop_animationDidStop.
        tokens[copy] = tokenGenerator.generate()!

        target.pop_add(spring.animation, forKey: spring.key)
      }
    }
  }

  // MARK: POP delegation

  func pop_animationDidStart(_ anim: POPSpringAnimation!) {
    if tokens[anim] == nil {
      tokens[anim] = tokenGenerator.generate()!
    }
  }

  func pop_animationDidStop(_ anim: POPSpringAnimation!, finished: Bool) {
    if let token = tokens[anim] {
      token.terminate()
      tokens.removeValue(forKey: anim)
    }
  }

  // MARK: Internal state

  var springs: [String: Spring] = [:]
  private func springForProperty(_ property: String) -> Spring {
    if let spring = springs[property] {
      return spring
    }

    let propertyName = popPropertyNameForProperty(property)
    assert(propertyName != nil, "\(property) is an unsupported property with POP springs")
    let springAnimation = POPSpringAnimation(propertyNamed: propertyName)!
    let spring = Spring(animation: springAnimation)
    springAnimation.dynamicsTension = SpringTo.defaultConfiguration.tension
    springAnimation.dynamicsFriction = SpringTo.defaultConfiguration.friction
    springAnimation.delegate = self
    springAnimation.removedOnCompletion = false

    springs[property] = spring

    target.pop_add(springAnimation, forKey: spring.key)

    return spring
  }

  // Type-safe conversion of key path to POP animation property. POP has different readers/writers
  // for similar-looking key paths depending on the target type, so we handle that mapping here.
  private func popPropertyNameForProperty(_ property: String) -> String? {
    if target is CAShapeLayer, let name = CAShapeLayerProperties[property] {
      return name
    }
    if target is CALayer, let name = CALayerProperties[property] {
      return name
    }
    if target is NSLayoutConstraint, let name = NSLayoutConstraintProperties[property] {
      return name
    }
    if target is UIView, let name = UIViewProperties[property] {
      return name
    }
    if target is UIScrollView, let name = UIScrollViewProperties[property] {
      return name
    }
    if target is UINavigationBar, let name = UINavigationBarProperties[property] {
      return name
    }
    if target is UILabel, let name = UILabelProperties[property] {
      return name
    }
    return nil
  }

  // MARK: Performer specialization

  var tokens: [POPSpringAnimation: IsActiveTokenable] = [:]
  var tokenGenerator: IsActiveTokenGenerating!
  func set(isActiveTokenGenerator: IsActiveTokenGenerating) {
    tokenGenerator = isActiveTokenGenerator
  }
}

class Spring {
  var animation: POPSpringAnimation
  let key = NSUUID().uuidString
  var activeGestureRecognizers = Set<UIGestureRecognizer>()
  init(animation: POPSpringAnimation) {
    self.animation = animation
  }
}

extension Dictionary {
  fileprivate subscript(key: Key, withDefault value: @autoclosure () -> Value) -> Value {
    mutating get {
      if self[key] == nil {
        self[key] = value()
      }
      return self[key]!
    }
    set {
      self[key] = newValue
    }
  }
}

func coerce(value: Any) -> Any {
  switch value {
  case let rect as CGRect:
    return NSValue(cgRect: rect)
  case let point as CGPoint:
    return NSValue(cgPoint: point)
  default:
    return value
  }
}

let CALayerProperties = [
  NSStringFromSelector(#selector(getter: CALayer.backgroundColor)): kPOPLayerBackgroundColor,
  NSStringFromSelector(#selector(getter: CALayer.bounds)): kPOPLayerBounds,
  NSStringFromSelector(#selector(getter: CALayer.cornerRadius)): kPOPLayerCornerRadius,
  NSStringFromSelector(#selector(getter: CALayer.borderWidth)): kPOPLayerBorderWidth,
  NSStringFromSelector(#selector(getter: CALayer.borderColor)): kPOPLayerBorderColor,
  NSStringFromSelector(#selector(getter: CALayer.opacity)): kPOPLayerOpacity,
  NSStringFromSelector(#selector(getter: CALayer.position)): kPOPLayerPosition,
  NSStringFromSelector(#selector(getter: CALayer.position)) + ".x": kPOPLayerPositionX,
  NSStringFromSelector(#selector(getter: CALayer.position)) + ".y": kPOPLayerPositionY,
  NSStringFromSelector(#selector(getter: CALayer.transform)) + ".rotation.z": kPOPLayerRotation,
  NSStringFromSelector(#selector(getter: CALayer.transform)) + ".rotation.x": kPOPLayerRotationX,
  NSStringFromSelector(#selector(getter: CALayer.transform)) + ".rotation.y": kPOPLayerRotationY,
  NSStringFromSelector(#selector(getter: CALayer.transform)) + ".scale.x": kPOPLayerScaleX,
  NSStringFromSelector(#selector(getter: CALayer.transform)) + ".scale": kPOPLayerScaleXY,
  NSStringFromSelector(#selector(getter: CALayer.transform)) + ".scale.y": kPOPLayerScaleY,
  NSStringFromSelector(#selector(getter: CALayer.bounds)) + ".size": kPOPLayerSize,
  NSStringFromSelector(#selector(getter: CALayer.sublayerTransform)) + ".scale": kPOPLayerSubscaleXY,
  NSStringFromSelector(#selector(getter: CALayer.sublayerTransform)) + ".translation.x": kPOPLayerSubtranslationX,
  NSStringFromSelector(#selector(getter: CALayer.sublayerTransform)) + ".translation": kPOPLayerSubtranslationXY,
  NSStringFromSelector(#selector(getter: CALayer.sublayerTransform)) + ".translation.y": kPOPLayerSubtranslationY,
  NSStringFromSelector(#selector(getter: CALayer.sublayerTransform)) + ".translation.z": kPOPLayerSubtranslationZ,
  NSStringFromSelector(#selector(getter: CALayer.transform)) + ".translation.x": kPOPLayerTranslationX,
  NSStringFromSelector(#selector(getter: CALayer.transform)) + ".translation": kPOPLayerTranslationXY,
  NSStringFromSelector(#selector(getter: CALayer.transform)) + ".translation.y": kPOPLayerTranslationY,
  NSStringFromSelector(#selector(getter: CALayer.transform)) + ".translation.z": kPOPLayerTranslationZ,
  NSStringFromSelector(#selector(getter: CALayer.zPosition)): kPOPLayerZPosition,
  NSStringFromSelector(#selector(getter: CALayer.shadowColor)): kPOPLayerShadowColor,
  NSStringFromSelector(#selector(getter: CALayer.shadowOffset)): kPOPLayerShadowOffset,
  NSStringFromSelector(#selector(getter: CALayer.shadowOpacity)): kPOPLayerShadowOpacity,
  NSStringFromSelector(#selector(getter: CALayer.shadowRadius)): kPOPLayerShadowRadius
]

let CAShapeLayerProperties = [
  NSStringFromSelector(#selector(getter: CAShapeLayer.strokeStart)): kPOPShapeLayerStrokeStart,
  NSStringFromSelector(#selector(getter: CAShapeLayer.strokeEnd)): kPOPShapeLayerStrokeEnd,
  NSStringFromSelector(#selector(getter: CAShapeLayer.strokeColor)): kPOPShapeLayerStrokeColor,
  NSStringFromSelector(#selector(getter: CAShapeLayer.fillColor)): kPOPShapeLayerFillColor,
  NSStringFromSelector(#selector(getter: CAShapeLayer.lineWidth)): kPOPShapeLayerLineWidth,
  NSStringFromSelector(#selector(getter: CAShapeLayer.lineDashPhase)): kPOPShapeLayerLineDashPhase,
]

let NSLayoutConstraintProperties = [
  NSStringFromSelector(#selector(getter: NSLayoutConstraint.constant)): kPOPLayoutConstraintConstant
]

let UIViewProperties = [
  NSStringFromSelector(#selector(getter: UIView.alpha)): kPOPViewAlpha,
  NSStringFromSelector(#selector(getter: UIView.backgroundColor)): kPOPViewBackgroundColor,
  NSStringFromSelector(#selector(getter: UIView.bounds)): kPOPViewBounds,
  NSStringFromSelector(#selector(getter: UIView.center)): kPOPViewCenter,
  NSStringFromSelector(#selector(getter: UIView.frame)): kPOPViewFrame,
  NSStringFromSelector(#selector(getter: UIView.transform)) + ".scale.x": kPOPViewScaleX,
  NSStringFromSelector(#selector(getter: UIView.transform)) + ".scale": kPOPViewScaleXY,
  NSStringFromSelector(#selector(getter: UIView.transform)) + ".scale.y": kPOPViewScaleY,
  NSStringFromSelector(#selector(getter: UIView.bounds)) + ".size": kPOPViewSize,
  NSStringFromSelector(#selector(getter: UIView.tintColor)): kPOPViewTintColor,
]

let UIScrollViewProperties = [
  NSStringFromSelector(#selector(getter: UIScrollView.contentOffset)): kPOPScrollViewContentOffset,
  NSStringFromSelector(#selector(getter: UIScrollView.contentSize)): kPOPScrollViewContentSize,
  NSStringFromSelector(#selector(getter: UIScrollView.zoomScale)): kPOPScrollViewZoomScale,
  NSStringFromSelector(#selector(getter: UIScrollView.contentInset)): kPOPScrollViewContentInset,
  NSStringFromSelector(#selector(getter: UIScrollView.scrollIndicatorInsets)): kPOPScrollViewScrollIndicatorInsets,
]

let UINavigationBarProperties = [
  NSStringFromSelector(#selector(getter: UINavigationBar.barTintColor)): kPOPNavigationBarBarTintColor,
]

let UILabelProperties = [
  NSStringFromSelector(#selector(getter: UILabel.textColor)): kPOPLabelTextColor
]
