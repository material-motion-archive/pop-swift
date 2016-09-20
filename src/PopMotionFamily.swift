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

/**
 Make POPAnimations conform to Plan so they can be used in Material Motion.
 */
extension POPAnimation: Plan {

  public func performerClass() -> AnyClass {
    return POPAnimationPerformer.self
  }

}

/**
 Lightweight bridge between POP and Material Motion. Describes how to perform a POPAnimation.
 */
class POPAnimationPerformer: NSObject, PlanPerforming, DelegatedPerforming, POPAnimationDelegate {
  let target: NSObject
  required init(target: Any) {
    self.target = target as! NSObject
    super.init()
  }

  var tokens: [POPAnimation: DelegatedPerformingToken] = [:]
  func add(plan: Plan) {
    let animation = plan as! POPAnimation
    animation.delegate = self
    self.target.pop_add(animation, forKey: nil)
  }

  var willStart: DelegatedPerformanceTokenReturnBlock!
  var didEnd: DelegatedPerformanceTokenArgBlock!
  func setDelegatedPerformance(willStart: @escaping DelegatedPerformanceTokenReturnBlock,
                               didEnd: @escaping DelegatedPerformanceTokenArgBlock) {
    self.willStart = willStart
    self.didEnd = didEnd
  }
}

extension POPAnimationPerformer {
  func pop_animationDidStart(_ anim: POPAnimation!) {
    guard let token = self.willStart() else { return }
    tokens[anim] = token
  }

  func pop_animationDidStop(_ anim: POPAnimation!, finished: Bool) {
    let token = tokens[anim]!

    self.didEnd(token)
    tokens.removeValue(forKey: anim)
  }
}
