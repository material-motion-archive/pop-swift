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
import MaterialMotionPopMotionFamily
import pop

/**
 A demonstration of how to commit a POP animation to a layer using a Material Motion scheduler.
 */
class TapToToggleExample1ViewController: UIViewController, SchedulerDelegate {

  let minSize: CGFloat = 100.0
  let maxSize: CGFloat = 280.0

  let springSpeed: CGFloat = 15.0
  let springBounciness: CGFloat = 18.0

  // We create a single Scheduler for the lifetime of this view controller. How many schedulers you
  // decide to create is a matter of preference, but generally speaking it's fair to create one
  // scheduler per self-contained interaction or transition.
  let scheduler = Scheduler()

  func commonInit() {
    // In this demo we show the scheduler's activity state by changing the background color of
    // self.view. In order to react to the activity state change events we set ourselves as the
    // scheduler's delegate.
    scheduler.delegate = self
  }

  // MARK: Reacting to user interactions

  // State
  var toggleState = false

  func handleTap(gestureRecognizer: UIGestureRecognizer) {
    toggleState = !toggleState

    let posPercent = CGFloat(toggleState ? 1 : 0)
    let newSize = posPercent * (maxSize - minSize) + minSize

    let bounds = POPSpringAnimation(propertyNamed: kPOPLayerBounds)
    bounds!.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: newSize, height: newSize))
    bounds!.springSpeed = springSpeed
    bounds!.springBounciness = springBounciness

    let borderRadius = POPSpringAnimation(propertyNamed: kPOPLayerCornerRadius)
    borderRadius!.toValue = NSNumber(value: Float(newSize / 2))
    borderRadius!.springSpeed = springSpeed
    borderRadius!.springBounciness = springBounciness

    // vv Material Motion-specific code vv

    // Here we create a new transaction with which we'll associate POP animations to targets.

    // In this case we're associating POP animations with a CALayer instance (circle). We can
    // also associate POP animations with UIView instances.

    let transaction = Transaction()
    transaction.add(plan: bounds!, to: circle)
    transaction.add(plan: borderRadius!, to: circle)

    // On commit, the runtime will create an entity capable of adding POP animations to layers.
    scheduler.commit(transaction: transaction)

    // ## Why commit POP animations to a runtime?
    //
    // This example demonstrates an important point: the Material Motion runtime is able to receive
    // objects defined by third party frameworks and to coordinate them alongside other animation
    // and interaction plans. In particular, the schedulerActivityStateDidChange event demonstrates
    // that we're able to track the overall activity state of many plans; this can be helpful for
    // building view controller transitions.

    // ^^ Material Motion-specific code ^^
  }

  func schedulerActivityStateDidChange(_ scheduler: Scheduler) {
    switch scheduler.activityState {
    case .active:
      view.backgroundColor = .orange
    case .idle:
      view.backgroundColor = .white
    }
  }

  // MARK: Configuring views and interactions

  // Views
  var circle: CALayer!

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    circle = CALayer()
    circle.bounds = CGRect(x: 0, y: 0, width: minSize, height: minSize)
    circle.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
    circle.cornerRadius = circle.bounds.width / 2
    circle.backgroundColor = UIColor.red.cgColor
    view.layer.addSublayer(circle)

    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
    view.addGestureRecognizer(tap)
  }

  // MARK: Routing initializers

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    self.commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    self.commonInit()
  }
}
