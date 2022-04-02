//
//  TokenStore.swift
//  MusicThread
//
//  Created by Edward Wellbrook on 30/01/2021.
//

import Foundation
import JWTDecode

public protocol TokenStorage {
    func get(_ key: String) throws -> String?
    func set(_ value: String, key: String) throws
    func remove(_ key: String) throws
}

public actor TokenStore {

    typealias FetchAccessTokenCompletion = (Result<String, Error>) -> Void

    private let baseURL: URL
    private let storage: TokenStorage

    private var accessToken: String? {
        return try? self.storage.get("access_token")
    }

    private var refreshToken: String? {
        return try? self.storage.get("refresh_token")
    }

    private var isAccessTokenExpired: Bool {
        guard let tok = self.accessToken, let jwt = try? decode(jwt: tok) else {
            return true
        }
        return jwt.expired
    }

    var isAuthenticated: Bool {
        return self.refreshToken != nil
    }

    private var fetchAccessTokenRequests: Task<String, Error>?


    public init(authBaseURL: URL, storage: TokenStorage) {
        self.baseURL = authBaseURL
        self.storage = storage
    }

    public func setAuth(_ authResposne: TokenResponse) throws {
        try self.storage.set(authResposne.accessToken, key: "access_token")
        try self.storage.set(authResposne.refreshToken, key: "refresh_token")
    }


    func fetchAccessToken(client: ClientCredentials) async throws -> String {
        if let token = self.accessToken, self.isAccessTokenExpired == false {
            return token
        }

        guard let refreshToken = self.refreshToken else {
            let error = NSError(domain: "co.brushedtype.musicthread", code: -2222, userInfo: [NSLocalizedDescriptionKey: "No refreshToken set"])
            throw error
        }

        if let activeRequest = self.fetchAccessTokenRequests {
            return try await activeRequest.value
        }

        let task = Task<String, Error> {
            self.fetchAccessTokenRequests = nil

            do {
                let response = try await client.refreshToken(refreshToken: refreshToken)
                try? self.setAuth(response)
                return response.accessToken
            } catch {
                try? self.storage.remove("refresh_token")
                throw error
            }
        }

        self.fetchAccessTokenRequests = task

        return try await task.value
    }

}
