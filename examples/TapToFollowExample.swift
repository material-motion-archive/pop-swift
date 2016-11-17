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

/** A demonstration of how to commit a SpringTo plan to a layer using a Material Motion runtime. */
class TapToFollowExampleViewController: UIViewController, RuntimeDelegate {

  // We create a single Runtime for the lifetime of this view controller. How many runtimes you
  // decide to create is a matter of preference, but generally speaking it's fair to create one
  // runtime per self-contained interaction or transition.
  let runtime = Runtime()

  func commonInit() {
    // In this demo we show the runtime's activity state by changing the background color of
    // self.view. In order to react to the activity state change events we set ourselves as the
    // runtime's delegate.
    runtime.delegate = self

    title = type(of: self).catalogBreadcrumbs().last
  }

  // MARK: Reacting to user interactions

  func handleTap(gestureRecognizer: UITapGestureRecognizer) {
    let location = gestureRecognizer.location(in: view)
    let springPosition = SpringTo(.layerPosition, destination: location)

    let configuration = SpringConfiguration(tension: SpringTo.defaultTension,
                                            friction: sqrt(4 * SpringTo.defaultTension) * 0.5)
    springPosition.configuration = configuration

    // The runtime will create an entity capable of adding POP animations to layers.
    runtime.addPlan(springPosition, to: circle)
  }

  func runtimeActivityStateDidChange(_ runtime: Runtime) {
    switch runtime.activityState {
    case .active:
      view.backgroundColor = UIColor(red: CGFloat(0xE3) / 255.0,
                                     green: CGFloat(0xF2) / 255.0,
                                     blue: CGFloat(0xFD) / 255.0,
                                     alpha: 1)
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
    circle.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    circle.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
    circle.cornerRadius = circle.bounds.width / 2
    circle.backgroundColor = UIColor(red: CGFloat(0x21) / 255.0,
                                     green: CGFloat(0x96) / 255.0,
                                     blue: CGFloat(0xF3) / 255.0,
                                     alpha: 1).cgColor
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
