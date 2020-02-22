//
//  Defaults.swift
//  MisoDefaultsWrapper
//
//  Created by Michel Donais on 2019-12-01.
//  Copyright © 2019-2020 Misoservices Inc. All rights reserved.
//  [BSL-1.0] This package is Licensed under the Boost Software License - Version 1.0
//

import Foundation

@propertyWrapper
public struct Defaults<Value> {
    private let sink: (_ val: Value)->Void
    
    public var wrappedValue: Value {
        willSet {
            self.sink(newValue)
        }
    }
}

public extension Defaults {
    init(wrappedValue defaultValue: Value,
         key: String) {
        self.init(wrappedValue: defaultValue,
                  key: key,
                  userDefaults: .standard)
    }

    init(wrappedValue defaultValue: Value,
         key: String,
         userDefaults: UserDefaults?) {
        guard let userDefaults = userDefaults else {
            self.sink = { _ in }
            self.wrappedValue = defaultValue
            return
        }
        self.wrappedValue = userDefaults.object(forKey: key) as? Value ?? defaultValue
        
        self.sink = { (newValue: Value) in
            if !MisoDefaultsWrapper.lockedUserDefaults.contains(userDefaults) {
                userDefaults.set(newValue, forKey: key)
            }
        }
    }
}

public extension Defaults where Value: Codable {
    init(wrappedValue defaultValue: Value,
         jsonKey key: String) {
        self.init(wrappedValue: defaultValue,
                  jsonKey: key,
                  userDefaults: .standard)
    }

    init(wrappedValue defaultValue: Value,
         jsonKey key: String,
         userDefaults: UserDefaults?) {
        guard let userDefaults = userDefaults else {
            self.sink = { _ in }
            self.wrappedValue = defaultValue
            return
        }
        let json = userDefaults.object(forKey: key) as? Data
        let decoder: JSONDecoder? = json != nil ? JSONDecoder() : nil
        let decodedJson = try? decoder?.decode(Value.self, from: json!)
        
        self.wrappedValue = decodedJson ?? defaultValue
        
        self.sink = { (newValue: Value) in
            if !MisoDefaultsWrapper.lockedUserDefaults.contains(userDefaults),
                let json = try? JSONEncoder().encode(newValue) {
                userDefaults.set(json, forKey: key)
            }
        }
    }
}
