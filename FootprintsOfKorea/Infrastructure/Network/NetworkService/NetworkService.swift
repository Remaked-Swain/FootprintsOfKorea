//
//  NetworkService.swift
//  FootprintsOfKorea
//
//  Created by Swain Yun on 5/5/24.
//

import Foundation

protocol NetworkService {
    func request<T: Decodable>(query: Requestable, for type: T.Type) async throws -> T
    func data(url: URL) async throws -> Data
}

fileprivate enum NetworkServiceError: Error {
    case requestFailed
    case badResponse(code: Int)
    case notConnectedToInternet
    case invalidURL
    case decodingError(type: String)
}

final class DefaultNetworkService {
    private let networkSessionManager: NetworkSessionManager
    private let decoder: JSONDecodable
    
    init(networkSessionManager: NetworkSessionManager, decoder: JSONDecodable = JSONDecoder()) {
        self.networkSessionManager = networkSessionManager
        self.decoder = decoder
    }
    
    private func resolveError(error: Error) -> NetworkServiceError {
        if let error = error as? NetworkServiceError {
            return error
        } else {
            let code = URLError.Code(rawValue: (error as NSError).code)
            
            switch code {
            case .notConnectedToInternet: return .notConnectedToInternet
            default: return .requestFailed
            }
        }
    }
    
    private func handleResponse(_ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkServiceError.requestFailed
        }
        
        guard (200..<300).contains(response.statusCode) else {
            throw NetworkServiceError.badResponse(code: response.statusCode)
        }
    }
    
    private func decode<T: Decodable>(for type: T.Type, with data: Data) throws -> T {
        guard let decodedData = try? decoder.decode(type, from: data) else {
            throw NetworkServiceError.decodingError(type: String(describing: type))
        }
        return decodedData
    }
}

// MARK: NetworkService Confirmation
extension DefaultNetworkService: NetworkService {
    func request<T: Decodable>(query: Requestable, for type: T.Type) async throws -> T {
        guard let request = query.urlRequest() else {
            throw NetworkServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await networkSessionManager.request(request)
            try handleResponse(response)
            let decodedData = try decode(for: type, with: data)
            return decodedData
        } catch let error {
            throw resolveError(error: error)
        }
    }
    
    func data(url: URL) async throws -> Data {
        do {
            let (data, response) = try await networkSessionManager.data(from: url)
            try handleResponse(response)
            return data
        } catch let error {
            throw resolveError(error: error)
        }
    }
}
