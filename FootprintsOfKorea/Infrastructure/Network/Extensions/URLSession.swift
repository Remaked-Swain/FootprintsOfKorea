//
//  URLSession.swift
//  FootprintsOfKorea
//
//  Created by Swain Yun on 5/5/24.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }
