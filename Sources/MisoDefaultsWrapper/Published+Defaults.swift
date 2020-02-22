//
//  Published+Defaults.swift
//  MisoDefaultsWrapper
//
//  Created by Michel Donais on 2019-12-01.
//  Copyright © 2019-2020 Misoservices Inc. All rights reserved.
//  [BSL-1.0] This package is Licensed under the Boost Software License - Version 1.0
//

import Foundation
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Published {
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
            self.init(initialValue: defaultValue)
            return
        }
        if MisoDefaultsWrapper.Cancellables.userDefaults[userDefaults] == nil {
            MisoDefaultsWrapper.Cancellables.userDefaults[userDefaults] = MisoDefaultsWrapper.Cancellables()
        }
        
        let value = userDefaults.object(forKey: key) as? Value ?? defaultValue
        
        self.init(initialValue: value)
        
        MisoDefaultsWrapper.Cancellables.userDefaults[userDefaults]?.dict[key] = projectedValue.sink { val in
            if !MisoDefaultsWrapper.lockedUserDefaults.contains(userDefaults) {
                userDefaults.set(val, forKey: key)
            }
        }
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Published where Value: Codable {
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
            self.init(initialValue: defaultValue)
            return
        }
        if MisoDefaultsWrapper.Cancellables.userDefaults[userDefaults] == nil {
            MisoDefaultsWrapper.Cancellables.userDefaults[userDefaults] = MisoDefaultsWrapper.Cancellables()
        }
        
        let json = userDefaults.object(forKey: key) as? Data
        let decoder: JSONDecoder? = json != nil ? JSONDecoder() : nil
        let decodedJson = try? decoder?.decode(Value.self, from: json!)
        let value = decodedJson ?? defaultValue
        
        self.init(initialValue: value)
        
        MisoDefaultsWrapper.Cancellables.userDefaults[userDefaults]?.dict[key] = projectedValue.sink { val in
            if !MisoDefaultsWrapper.lockedUserDefaults.contains(userDefaults),
                let json = try? JSONEncoder().encode(val) {
                userDefaults.set(json, forKey: key)
            }
        }
    }
}

