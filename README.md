# POP Material Motion Family written in Swift

[![Build Status](https://travis-ci.org/material-motion/material-motion-family-pop-swift.svg?branch=develop)](https://travis-ci.org/material-motion/material-motion-family-pop-swift)
[![codecov](https://codecov.io/gh/material-motion/material-motion-family-pop-swift/branch/develop/graph/badge.svg)](https://codecov.io/gh/material-motion/material-motion-family-pop-swift)

The POP Material Motion family provides a bridge between
[Facebook's POP library](https://github.com/facebook/pop) and the
[Material Motion runtime](https://github.com/material-motion/material-motion-runtime-objc).

## Supported languages

- Swift 3
- Objective-C

## Features

`SpringTo` uses POP springs to animate properties using spring physics driven on the main thread of
the application.

For example, you might use a SpringTo plan to move a view's position to a specific position on
screen:

```swift
let springTo = SpringTo(.layerPosition destination: CGPoint(x: 10, y: 10))
scheduler.addPlan(springTo, to: view.layer)
```

SpringTo supports the properties included in the POPProperty enum. Unlike POP, SpringTo does not
presently support custom key paths.
[Read the feature request](https://github.com/material-motion/material-motion-family-pop-swift/issues/19)
for supporting custom key paths.

## Installation

### Installation with CocoaPods

> CocoaPods is a dependency manager for Objective-C and Swift libraries. CocoaPods automates the
> process of using third-party libraries in your projects. See
> [the Getting Started guide](https://guides.cocoapods.org/using/getting-started.html) for more
> information. You can install it with the following command:
>
>     gem install cocoapods

Add `MaterialMotionPopFamily` to your `Podfile`:

    pod 'MaterialMotionPopFamily'

Then run the following command:

    pod install

### Usage

Import the framework:

    @import MaterialMotionPopFamily;

You will now have access to all of the APIs.

## Example apps/unit tests

Check out a local copy of the repo to access the Catalog application by running the following
commands:

    git clone https://github.com/material-motion/material-motion-family-pop-swift.git
    cd material-motion-family-pop-swift
    pod install
    open MaterialMotionPopFamily.xcworkspace

## Guides

1. [How to animate a property with a SpringTo plan](#how-to-animate-a-property-with-a-springto-plan)
2. [How to configure spring behavior](#how-to-configure-spring-behavior)

### How to animate a property with a SpringTo plan

Code snippets:

***In Objective-C:***

```objc
MDMSpringTo *springTo = [[MDMSpringTo alloc] initWithProperty:MDMPOPProperty<#property name#>
                                                  destination:<#Destination value#>];
[scheduler addPlan:springTo to:<#Object#>];
```

***In Swift:***

```swift
let springTo = SpringTo(.<#property name#>, destination: <#Destination value#>)
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

## Contributing

We welcome contributions!

Check out our [upcoming milestones](https://github.com/material-motion/material-motion-family-pop-swift/milestones).

Learn more about [our team](https://material-motion.gitbooks.io/material-motion-team/content/),
[our community](https://material-motion.gitbooks.io/material-motion-team/content/community/), and
our [contributor essentials](https://material-motion.gitbooks.io/material-motion-team/content/essentials/).

## License

Licensed under the Apache 2.0 license. See LICENSE for details.
