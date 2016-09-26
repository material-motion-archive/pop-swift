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
public class SpringTo: NSObject, Plan, POPPlan {
  public var property: POPProperty
  public var destination: Any

  public init(_ property: POPProperty, destination: Any) {
    self.property = property
    self.destination = coerce(value: destination)
  }

  public func performerClass() -> AnyClass {
    return POPPerformer.self
  }
  public func copy(with zone: NSZone? = nil) -> Any {
    return SpringTo(property, destination: destination)
  }
}

/** The animatable properties for use with the SpringTo plan. */
public enum POPProperty {
  case layerBackgroundColor
  case layerBounds
  case layerCornerRadius
  case layerBorderWidth
  case layerBorderColor
  case layerOpacity
  case layerPosition
  case layerPositionX
  case layerPositionY
  case layerRotation
  case layerRotationX
  case layerRotationY
  case layerScaleX
  case layerScaleXY
  case layerScaleY
  case layerSize
  case layerSubscaleXY
  case layerSubtranslationX
  case layerSubtranslationXY
  case layerSubtranslationY
  case layerSubtranslationZ
  case layerTranslationX
  case layerTranslationXY
  case layerTranslationY
  case layerTranslationZ
  case layerZPosition
  case layerShadowColor
  case layerShadowOffset
  case layerShadowOpacity
  case layerShadowRadius

  case shapeLayerStrokeStart
  case shapeLayerStrokeEnd
  case shapeLayerStrokeColor
  case shapeLayerFillColor
  case shapeLayerLineWidth
  case shapeLayerLineDashPhase

  case layoutConstraintConstant

  case viewAlpha
  case viewBackgroundColor
  case viewBounds
  case viewCenter
  case viewFrame
  case viewScaleX
  case viewScaleXY
  case viewScaleY
  case viewSize
  case viewTintColor

  case scrollViewContentOffset
  case scrollViewContentSize
  case scrollViewZoomScale
  case scrollViewContentInset
  case scrollViewScrollIndicatorInsets

  case navigationBarBarTintColor

  case labelTextColor
}
