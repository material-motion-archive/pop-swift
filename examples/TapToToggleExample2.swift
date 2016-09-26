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

// A demonstration of how to define composite plans.
//
// In this example we create a composite plan of the POP animations seen in the first tap-to-toggle
// example. We've called this composite plan: SpringDiameter.
//
// SpringDiameter exposes some configurable properties, notably the desired diameter.
//
// Rather than directly creating POP animation objects and adding them to the scheduler, we can now
// register a SpringDiameter plan to the scheduler. We can now also reuse this plan throughout
// our code-base.

private class SpringDiameter: NSObject, Plan {
  var diameter: CGFloat
  init(to diameter: CGFloat) {
    self.diameter = diameter
  }

  var springSpeed: CGFloat = 15.0
  var springBounciness: CGFloat = 18.0

  // Map this plan to our desired performer. This is a required method of the Plan protocol.
  func performerClass() -> AnyClass {
    return SpringDiameterPerformer.self
  }

  public func copy(with zone: NSZone? = nil) -> Any {
    return SpringDiameter(to: diameter)
  }
}

class TapToToggleExample2ViewController: UIViewController {

  let minSize: CGFloat = 100.0
  let maxSize: CGFloat = 280.0

  func commonInit() {
    scheduler.delegate = self
  }

  // MARK: Reacting to user interactions

  var toggleState = false

  func handleTap(gestureRecognizer: UIGestureRecognizer) {
    toggleState = !toggleState

    let posPercent = CGFloat(toggleState ? 1 : 0)
    let newDiameter = posPercent * (maxSize - minSize) + minSize

    // Note that, unlike the first tap-to-toggle example, we only have to configure the relevant
    // properties of our desired plans.

    let transaction = Transaction()
    transaction.add(plan: SpringDiameter(to: newDiameter), to: circle)
    scheduler.commit(transaction: transaction)
  }

  // Material Motion state
  let scheduler = Scheduler()

  // Visible entities
  var circle: CALayer!

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

// In Material Motion, a performer is an entity responsible for fulfilling plans that have been
// committed to targets.
//
// In this example we've defined a plan called SpringDiameter that requires this performer
// type. When a SpringDiameter plan is committed to a scheduler, the scheduler will create an
// instance of this performer (one instance per target) and provide the plan entities to it.
//
// Note that our add(plan:) method contains a decent amount of configuration logic that we now no
// longer need to implement in our view controller.

private class SpringDiameterPerformer: NSObject, PlanPerforming, ComposablePerforming {
  let target: CALayer
  var emitter: TransactionEmitting!

  required init(target: Any) {
    self.target = target as! CALayer
  }

  func add(plan: Plan) {
    let diameterChange = plan as! SpringDiameter

    let transaction = Transaction()
    func add(plans: [Plan], to target: Any) {
      for plan in plans {
        transaction.add(plan: plan, to: target)
      }
    }
    add(plans: [SpringTo(.layerBounds, destination: CGRect(x: 0, y: 0,
                                                           width: diameterChange.diameter,
                                                           height: diameterChange.diameter)),
                SpringTo(.layerCornerRadius, destination: diameterChange.diameter / 2)],
        to: target)
    emitter.emit(transaction: transaction)
  }

  func set(transactionEmitter: TransactionEmitting) {
    self.emitter = transactionEmitter
  }
}

// MARK: Example configuration

extension TapToToggleExample2ViewController: SchedulerDelegate {
  func schedulerActivityStateDidChange(_ scheduler: Scheduler) {
    switch scheduler.activityState {
    case .active:
      view.backgroundColor = .orange
    case .idle:
      view.backgroundColor = .white
    }
  }
}

extension TapToToggleExample2ViewController {
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
}

extension TapToToggleExample2ViewController {
  class func catalogBreadcrumbs() -> [String] {
    return ["Tap to Toggle 2"]
  }
}
