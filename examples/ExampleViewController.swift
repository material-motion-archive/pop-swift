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
import pop
import MaterialMotionPopMotionFamily

let minSize: CGFloat  = 25.0
let maxSize: CGFloat  = 280.0

let springSpeed: CGFloat = 15.0
let springBounciness: CGFloat = 18.0

class ExampleViewController: UIViewController {

  var circle: CALayer!

  let scheduler = Scheduler()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = .white

    circle = CALayer()
    circle.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
    circle.position = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
    circle.cornerRadius = 15
    circle.backgroundColor = UIColor.red.cgColor
    self.view.layer.addSublayer(circle)

    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:))))
  }

  func handleTap(gestureRecognizer: UIGestureRecognizer) {
    let posPercent = 1.0 - (gestureRecognizer.location(in: self.view).y / self.view.frame.height)
    let newSize = posPercent * (maxSize - minSize) + minSize

    let bounds = POPSpringAnimation(propertyNamed: kPOPLayerBounds)
    bounds!.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: newSize, height: newSize))
    bounds!.springSpeed = springSpeed
    bounds!.springBounciness = springBounciness

    let borderRadius = POPSpringAnimation(propertyNamed: kPOPLayerCornerRadius)
    borderRadius!.toValue = NSNumber(value: Float(newSize / 2))
    borderRadius!.springSpeed = springSpeed
    borderRadius!.springBounciness = springBounciness

    let transaction = Transaction()
    transaction.add(plan: bounds!, to: circle)
    transaction.add(plan: borderRadius!, to: circle)

    scheduler.commit(transaction: transaction)
  }

}
