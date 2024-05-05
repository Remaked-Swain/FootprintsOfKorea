//
//  JSONDecoder.swift
//  FootprintsOfKorea
//
//  Created by Swain Yun on 5/5/24.
//

import Foundation

protocol JSONDecodable {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: JSONDecodable { }
