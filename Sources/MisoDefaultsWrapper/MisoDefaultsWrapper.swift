//
//  MisoDefaultsWrapper.swift
//  MisoDefaultsWrapper
//
//  Created by Michel Donais on 2019-12-01.
//  Copyright © 2019-2020 Misoservices Inc. All rights reserved.
//  [BSL-1.0] This package is Licensed under the Boost Software License - Version 1.0
//

import Foundation
import Combine

public struct MisoDefaultsWrapper {
    public static var lockedUserDefaults = Set<UserDefaults>()
    
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public class Cancellables {
        public var dict = [String:AnyCancellable]()

        public static var userDefaults = [UserDefaults:Cancellables]()
    }
}
