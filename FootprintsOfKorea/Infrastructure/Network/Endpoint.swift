//
//  Endpoint.swift
//  FootprintsOfKorea
//
//  Created by Swain Yun on 5/14/24.
//

import Foundation

protocol Requestable {
    func urlRequest() -> URLRequest?
}

enum HttpMethodType {
    case get
    case post
    
    var value: String {
        switch self {
        case .get: "GET"
        case .post: "POST"
        }
    }
}

enum OSType {
    case ios, android
    
    var value: String {
        switch self {
        case .ios: "IOS"
        case .android: "AND"
        }
    }
}

/// 정렬 기준을 나타냅니다.
enum ContentArrangeType {
    case byTitle, byModifiedTime, byCreateTime
    
    var value: String {
        switch self {
        case .byTitle: "O"
        case .byModifiedTime: "Q"
        case .byCreateTime: "R"
        }
    }
}

enum Endpoint {
    case searchKeyword(osType: OSType, arrangeType: ContentArrangeType, keyword: String)
    
    // MARK: Properties
    static let propertyListFileName: String = "APIKey"
    static let keyName: String = "KorService"
    static let appName: String = "FootprintsOfKorea"
    
    var httpMethod: String {
        switch self {
        case .searchKeyword: HttpMethodType.get.value
        }
    }
    
    var scheme: String { "https" }
    
    var host: String { "apis.data.go.kr" }
    
    var path: String { "/B551011/KorService1/searchKeyword1" }
    
    var apiKey: String? {
        guard let apiKey = Bundle.main.korServiceAPIKey else { return nil }
        return apiKey
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .searchKeyword(let osType, let arrangeType, let keyword):
            return makeQueryItems(queries:
                                    ("MobileOS", osType.value),
                                  ("MobileApp", Endpoint.appName),
                                  ("_type", "json"),
                                  ("arrange", arrangeType.value),
                                  ("keyword", keyword),
                                  ("ServiceKey", apiKey))
        }
    }
    
    private func makeQueryItems(queries: (key: String, value: String?)...) -> [URLQueryItem] {
        return queries.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

// MARK: Requestable Confirmation
extension Endpoint: Requestable {
    func urlRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        guard let fullURL = components.url else { return nil }
        var request = URLRequest(url: fullURL)
        request.httpMethod = httpMethod
        return request
    }
}
