//
//  Bundle.swift
//  FootprintsOfKorea
//
//  Created by Swain Yun on 5/5/24.
//

import Foundation

extension Bundle {
    /**
     번들 내 탐색 에러를 정의합니다.
     */
    private enum TraversalError: Error, CustomDebugStringConvertible {
        case fileNotFound, keyNotFound
        
        var debugDescription: String {
            switch self {
            case .fileNotFound: "번들에서 파일을 찾을 수 없음."
            case .keyNotFound: "번들에서 키를 찾을 수 없음."
            }
        }
    }
    
    typealias APIKey = String
    
    var korServiceAPIKey: APIKey? {
        switch traverse() {
        case .success(let key):
            return key
        case .failure(let error):
            print(error.debugDescription)
            return nil
        }
    }
    
    private func traverse() -> Result<APIKey, TraversalError> {
        guard let fileURL = Self.main.url(forResource: Endpoint.propertyListFileName, withExtension: "plist") else {
            return .failure(.fileNotFound)
        }
        
        guard let file = NSDictionary(contentsOf: fileURL),
              let value = file.object(forKey: Endpoint.keyName) as? String
        else {
            return .failure(.keyNotFound)
        }
        
        return .success(value)
    }
}
