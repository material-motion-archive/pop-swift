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

import UIKit
import MaterialMotionRuntime
import MaterialMotionPop

// Demonstrates how to create an interaction that uses SpringTo, AppliesVelocity, and PauseSpring
// together to make a view tossable. We'll create an interaction class that is responsible for
// registering all of the relevant plans to a runtime.

class TossableInteraction {
  let runtime = MotionRuntime()

  let anchoredPosition: CGPoint
  let layer: CALayer
  let gestureContainerView: UIView
  init(layer: CALayer, anchoredPosition: CGPoint, gestureContainerView: UIView) {
    self.layer = layer
    self.anchoredPosition = anchoredPosition
    self.gestureContainerView = gestureContainerView

    setUp()
  }

  private func setUp() {
    let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
    gestureContainerView.addGestureRecognizer(pan)

    let position = "position"
    let plans: [Plan] = [
      // Always be anchored to the provided position.
      SpringTo(position, destination: anchoredPosition),

      // Pauses the spring simulation while the gesture recognizer is active.
      PauseSpring(position, whileActive: pan),

      // Feeds the pan gesture recognizer's velocity into the spring on gesture completion.
      AppliesVelocity(position, onCompletionOf: pan)
    ]
    for plan in plans {
      runtime.addPlan(plan, to: layer)
    }
  }

  // MARK: Reacting to user interactions

  var initialPosition: CGPoint?
  @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
    let translation = gestureRecognizer.translation(in: gestureRecognizer.view)

    if initialPosition == nil {
      initialPosition = layer.position
    }
    if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
      initialPosition = nil
    }

    if let initialPosition = initialPosition {
      let actionsWereDisabled = CATransaction.disableActions()
      CATransaction.setDisableActions(true)
      layer.position = CGPoint(x: initialPosition.x + translation.x,
                               y: initialPosition.y + translation.y)
      CATransaction.setDisableActions(actionsWereDisabled)
    }
  }
}

public class TossableExampleViewController: UIViewController, MotionRuntimeDelegate {

  // MARK: Configuring views and interactions

  // Views
  var circle: CALayer!
  var interaction: TossableInteraction!

  override public func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    circle = CALayer()
    circle.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    circle.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
    circle.cornerRadius = circle.bounds.width / 2
    circle.backgroundColor = UIColor(red: CGFloat(0x21) / 255.0,
                                     green: CGFloat(0x96) / 255.0,
                                     blue: CGFloat(0xF3) / 255.0,
                                     alpha: 1).cgColor
    view.layer.addSublayer(circle)

    interaction = TossableInteraction(layer: circle,
                                      anchoredPosition: CGPoint(x: view.bounds.midX,
                                                                y: view.bounds.midY),
                                      gestureContainerView: view)

    interaction.runtime.delegate = self
  }

  public func motionRuntimeActivityStateDidChange(_ runtime: MotionRuntime) {
    view.backgroundColor = runtime.isActive
      ? UIColor(red: CGFloat(0xE3) / 255.0,
                green: CGFloat(0xF2) / 255.0,
                blue: CGFloat(0xFD) / 255.0,
                alpha: 1)
      : .white
  }

  // MARK: Routing initializers

  func commonInit() {
    title = "Tossable"
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    self.commonInit()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    self.commonInit()
  }
}
