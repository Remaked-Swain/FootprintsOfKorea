//
//  NetworkSessionManager.swift
//  FootprintsOfKorea
//
//  Created by Swain Yun on 5/5/24.
//

import Foundation

protocol NetworkSessionManager {
    func request(_ request: URLRequest) async throws -> (Data, URLResponse)
    func data(from url: URL) async throws -> (Data, URLResponse)
}

final class DefaultNetworkSessionManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

// MARK: NetworkSessionManager Confirmation
extension DefaultNetworkSessionManager: NetworkSessionManager {
    func request(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: request)
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        return try await session.data(from: url)
    }
}


