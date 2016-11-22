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

#import <XCTest/XCTest.h>

@import MaterialMotionRuntime;
@import MaterialMotionPop;

@interface ObjectiveCAPITests : XCTestCase
@end

// Verify that plans can be created in Objective-C.
@implementation ObjectiveCAPITests

- (void)testSpringToAPI {
  NSString *property = @"bounds.size";
  id destination = [NSValue valueWithCGSize:CGSizeMake(10, 10)];
  MDMSpringTo *plan = [[MDMSpringTo alloc] initWithProperty:property
                                                destination:destination];
  XCTAssertEqual(plan.property, property);
  XCTAssertEqual(plan.destination, destination);
}

- (void)testSpringConfigurationAPI {
  CGFloat tension = 300;
  CGFloat friction = 30;
  MDMSpringConfiguration *configuration = [[MDMSpringConfiguration alloc] initWithTension:tension
                                                                                 friction:friction];
  XCTAssertEqual(configuration.tension, tension);
  XCTAssertEqual(configuration.friction, friction);
}

- (void)testPausesSpringAPI {
  NSString *property = @"bounds.size";
  UIGestureRecognizer *gestureRecognizer = [UIGestureRecognizer new];
  MDMPausesSpring *plan = [[MDMPausesSpring alloc] initWithProperty:property
                                                  gestureRecognizer:gestureRecognizer];
  XCTAssertEqual(plan.property, property);
  XCTAssertEqual(plan.gestureRecognizer, gestureRecognizer);
}

- (void)testAppliesVelocityAPI {
  NSString *property = @"bounds.size";
  UIGestureRecognizer *gestureRecognizer = [UIGestureRecognizer new];
  MDMAppliesVelocity *plan = [[MDMAppliesVelocity alloc] initWithProperty:property
                                                        gestureRecognizer:gestureRecognizer];
  XCTAssertEqual(plan.property, property);
  XCTAssertEqual(plan.gestureRecognizer, gestureRecognizer);
}

@end
