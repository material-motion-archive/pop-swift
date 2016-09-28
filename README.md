# POP Material Motion Family written in Swift

[![Build Status](https://travis-ci.org/material-motion/material-motion-family-pop-swift.svg?branch=develop)](https://travis-ci.org/material-motion/material-motion-family-pop-swift)
[![codecov](https://codecov.io/gh/material-motion/material-motion-family-pop-swift/branch/develop/graph/badge.svg)](https://codecov.io/gh/material-motion/material-motion-family-pop-swift)

The POP Material Motion family provides a bridge between
[Facebook's POP library](https://github.com/facebook/pop) and the
[Material Motion runtime](https://github.com/material-motion/material-motion-runtime-objc).

## Plans

`SpringTo` uses POP springs to animate properties with a simulated spring curve driven on the main
thread of the application. `ConfigureSpring` allows you to configure the bounciness and speed of
the spring for a given property.

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

***In Swift:***

```swift
let transaction = Transaction()
transaction.add(plan: SpringTo(.<#property name#>, destination: <#Destination value#>),
                to: <#Layer instance#>)
```

### How to configure spring behavior

Code snippets:

***In Swift:***

```swift
let transaction = Transaction()
transaction.add(plan: ConfigureSpring(.<#Property name#>,
                                      bounciness: .<#Bounciness#>,
                                      speed: .<#Speed#>),
                to: <#Layer instance#>)
```

## Contributing

We welcome contributions!

Check out our [upcoming milestones](https://github.com/material-motion/material-motion-family-pop-swift/milestones).

Learn more about [our team](https://material-motion.gitbooks.io/material-motion-team/content/),
[our community](https://material-motion.gitbooks.io/material-motion-team/content/community/), and
our [contributor essentials](https://material-motion.gitbooks.io/material-motion-team/content/essentials/).

## License

Licensed under the Apache 2.0 license. See LICENSE for details.
