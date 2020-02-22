# MisoDefaultsWrapper

## A lightweight UserDefaults Swift wrapper

The goal of this yet-another defaults wrapper is to provide a very simple wrapper for any given data. The use-case being the preferences, as set by an application.

It is not meant as a full synchronization system between multiple applications. As such, it reads individual objects on first request, and keeps them in memory. It then saves the data back to `UserDefaults` on write.

Compared to other UserDefaults wrapper, the MisoDefaultsWrapper doesn't try to be fancy or all-encompassing. As such, there are two ways to create a key: through the `key:` parameter or the `jsonKey:` parameter. For simple values that are known to the `UserDefaults` system, the `key:` parameter is perfect. For more complex objects, including optionals, the `jsonKey:` parameter works its magic, as long as you implement your class or struct as `Codable`.

Since the data is kept in-memory, there is no registration involved either.


### Published object

An interesting part of the `Published` interface is knowing whenever an object has changed internally. If you want, you can make your object both `ObservableObject` and `Codable` to reap the rewards.


## Usage

### Storing a simple key

```swift
import MisoDefaultsWrapper

@Defaults(key: "AFunKey")
public var mySimpleObject = "A Simple Text"
```


### Storing a key in json

As bonus, you can use optionals in json

```swift
import MisoDefaultsWrapper

@Defaults(jsonKey: "ABiggerObject")
public var mySimpleObject: MyCodableObject? = nil
```


### Using Combine to publish a simple key

```swift
import MisoDefaultsWrapper

@Published(key: "activationRequest")
public var activationRequest: Bool = false
```


### Using Combine to publish an observable key

```swift
import MisoDefaultsWrapper

@Published(jsonKey: "somethingBig")
public var somethingBig = MyObservableObject()
```


### Disallow saving into a particular User Default

```
import MisoDefaultsWrapper

// Disllow saving until we know we can
MisoDefaultsWrapper.lockedUserDefaults.insert(.standard)

// Allow saving
MisoDefaultsWrapper.lockedUserDefaults.remove(.standard)
```


## Colophon

[The official address for this package][0]

[The git / package url][1]

This package is created and maintained by [Misoservices Inc.][2] and is [licensed under the BSL-1.0: Boost Software License - Version 1.0][3].


[0]: https://github.com/Misoservices/MisoDefaultsWrapper
[1]: https://github.com/Misoservices/MisoDefaultsWrapper.git
[2]: https://misoservices.com
[3]: https://choosealicense.com/licenses/bsl-1.0/
