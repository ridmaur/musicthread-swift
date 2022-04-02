//
//  KeychainTokenStorage.swift
//  MusicThread
//
//  Created by Edward Wellbrook on 02/04/2022.
//

import Foundation
import KeychainAccess
import MusicThreadAPI

public class KeychainTokenStorage: TokenStorage {

    let keychain: Keychain

    public init(keychain: Keychain) {
        self.keychain = keychain
    }

    public convenience init(service: String, accessGroup: String?) {
        if let accessGroup = accessGroup {
            self.init(keychain: Keychain(service: service, accessGroup: accessGroup))
        } else {
            self.init(keychain: Keychain(service: service))
        }
    }

    public func get(_ key: String) throws -> String? {
        return try self.keychain.getString(key)
    }

    public func set(_ value: String, key: String) throws {
        try self.keychain.set(value, key: key)
    }

    public func remove(_ key: String) throws {
        try self.keychain.remove(key)
    }

}
