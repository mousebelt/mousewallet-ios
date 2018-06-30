# PromiseKit CoreBluetooth Extensions ![Build Status]

This project adds promises to Apple’s CoreBluetooth framework.

## CocoaPods

```ruby
pod "PromiseKit/CoreBluetooth" ~> 6.0
```

The extensions are built into `PromiseKit.framework` thus nothing else is needed.

## Carthage

```ruby
github "PromiseKit/CoreBluetooth" ~> 3.0
```

The extensions are built into their own framework:

```swift
// swift
import PromiseKit
import PMKCoreBluetooth
```

```objc
// objc
@import PromiseKit;
@import PMKCoreBluetooth;
```


[Build Status]: https://travis-ci.org/PromiseKit/CoreBluetooth.svg?branch=master
