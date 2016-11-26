# POP for Material Motion (Swift)

[![Build Status](https://travis-ci.org/material-motion/pop-swift.svg?branch=develop)](https://travis-ci.org/material-motion/pop-swift)
[![codecov](https://codecov.io/gh/material-motion/pop-swift/branch/develop/graph/badge.svg)](https://codecov.io/gh/material-motion/pop-swift)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/MaterialMotionPop.svg)](https://cocoapods.org/pods/MaterialMotionPop)
[![Platform](https://img.shields.io/cocoapods/p/MaterialMotionPop.svg)](http://cocoadocs.org/docsets/MaterialMotionPop)
[![Docs](https://img.shields.io/cocoapods/metrics/doc-percent/MaterialMotionPop.svg)](http://cocoadocs.org/docsets/MaterialMotionPop)

The POP Material Motion family provides a bridge between
[Facebook's POP library](https://github.com/facebook/pop) and the
[Material Motion runtime](https://github.com/material-motion/runtime-objc).

## Supported languages

- Swift 3
- Objective-C

## Features

`SpringTo` uses POP springs to animate properties using spring physics driven on the main thread of
the application.

For example, you might use a SpringTo plan to move a view's position to a specific position on
screen:

```swift
let springTo = SpringTo("position", destination: CGPoint(x: 10, y: 10))
scheduler.addPlan(springTo, to: view.layer)
```

SpringTo supports a subset of key paths on certain types:

**CALayer**

- `backgroundColor`
- `bounds`
- `cornerRadius`
- `borderWidth`
- `borderColor`
- `opacity`
- `position`
- `position.x`
- `position.y`
- `transform.rotation.z`
- `transform.rotation.x`
- `transform.rotation.y`
- `transform.scale.x`
- `transform.scale`
- `transform.scale.y`
- `bounds.size`
- `sublayerTransform.scale`
- `sublayerTransform.translation.x`
- `sublayerTransform.translation`
- `sublayerTransform.translation.y`
- `sublayerTransform.translation.z`
- `transform.translation.x`
- `transform.translation`
- `transform.translation.y`
- `transform.translation.z`
- `zPosition`
- `shadowColor`
- `shadowOffset`
- `shadowOpacity`
- `shadowRadius`

**CAShapeLayer**

- `strokeStart`
- `strokeEnd`
- `strokeColor`
- `fillColor`
- `lineWidth`
- `lineDashPhase`

**NSLayoutConstraint**

- `constant`

**UIView**

- `alpha`
- `backgroundColor`
- `bounds`
- `center`
- `frame`
- `transform.scale.x`
- `transform.scale`
- `transform.scale.y`
- `bounds.size`
- `tintColor`

**UIScrollView**

- `contentOffset`
- `contentSize`
- `zoomScale`
- `contentInset`
- `scrollIndicatorInsets`

**UINavigationBar**

- `barTintColor`

**UILabel**

- `textColor`

[Read the feature request](https://github.com/material-motion/pop-swift/issues/19)
for supporting more key paths.

## Installation

### Installation with CocoaPods

> CocoaPods is a dependency manager for Objective-C and Swift libraries. CocoaPods automates the
> process of using third-party libraries in your projects. See
> [the Getting Started guide](https://guides.cocoapods.org/using/getting-started.html) for more
> information. You can install it with the following command:
>
>     gem install cocoapods

Add `MaterialMotionPop` to your `Podfile`:

    pod 'MaterialMotionPop'

Then run the following command:

    pod install

### Usage

Import the framework:

    @import MaterialMotionPop;

You will now have access to all of the APIs.

## Example apps/unit tests

Check out a local copy of the repo to access the Catalog application by running the following
commands:

    git clone https://github.com/material-motion/pop-swift.git
    cd pop-swift
    pod install
    open MaterialMotionPop.xcworkspace

## Guides

1. [How to animate a property with a SpringTo plan](#how-to-animate-a-property-with-a-springto-plan)
2. [How to configure spring behavior](#how-to-configure-spring-behavior)
3. [How to pause a spring while a gesture recognizer is active](#how-to-pause-a-spring-while-a-gesture-recognizer-is-active)

### How to animate a property with a SpringTo plan

Code snippets:

***In Objective-C:***

```objc
MDMSpringTo *springTo = [[MDMSpringTo alloc] initWithProperty:"<#property key path#>"
                                                  destination:<#Destination value#>];
[scheduler addPlan:springTo to:<#Object#>];
```

***In Swift:***

```swift
let springTo = SpringTo("<#property key path#>", destination: <#Destination value#>)
scheduler.addPlan(springTo, to: <#Object#>)
```

### How to configure spring behavior

A spring's behavior can be configured by setting a `SpringConfiguration` object on the SpringTo
instance.

Code snippets:

***In Objective-C:***

```objc
springTo.configuration = [[MDMSpringConfiguration alloc] initWithTension:<#tension#>
                                                                friction:<#friction#>];
```

***In Swift:***

```swift
springTo.configuration = SpringConfiguration(tension: <#tension#>, friction: <#friction#>)
```

### How to pause a spring while a gesture recognizer is active

Code snippets:

***In Objective-C:***

```objc
MDMPauseSpring *pauseSpring = [[MDMPauseSpring alloc] initWithProperty:"<#property key path#>"
                                                     gestureRecognizer:<#gesture recognizer#>];
[scheduler addPlan:springTo to:<#Object#>];
```

***In Swift:***

```swift
let springTo = MDMPauseSpring("<#property key path#>", whileActive: <#gesture recognizer#>)
scheduler.addPlan(springTo, to: <#Object#>)
```

## Contributing

We welcome contributions!

Check out our [upcoming milestones](https://github.com/material-motion/pop-swift/milestones).

Learn more about [our team](https://material-motion.github.io/material-motion/team/),
[our community](https://material-motion.github.io/material-motion/team/community/), and
our [contributor essentials](https://material-motion.github.io/material-motion/team/essentials/).

## License

Licensed under the Apache 2.0 license. See LICENSE for details.
