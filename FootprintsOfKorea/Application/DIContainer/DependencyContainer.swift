//
//  DependencyContainer.swift
//  FootprintsOfKorea
//
//  Created by Swain Yun on 5/18/24.
//

import Foundation

protocol DependencyResolvable {
    func resolve<T>(for type: T.Type) -> T
}

protocol DependencyRegistable {
    func register<T>(key: T.Type, value: T)
    func register<T>(for type: T.Type, _ handler: @escaping (DependencyResolvable) -> T)
}

typealias DependencyContainer = DependencyResolvable & DependencyRegistable

final class DefaultDependencyContainer: DependencyContainer {
    private var dependencies: [String: Any] = [:]
    
    // 실객체 인스턴스가 이미 존재할 때
    func register<T>(key: T.Type, value: T) {
        let key = String(describing: key)
        dependencies[key] = value
    }
    
    // 등록하려면 다른 객체가 필요할 때
    func register<T>(for type: T.Type, _ handler: @escaping (DependencyResolvable) -> T) {
        let key = String(describing: type)
        dependencies[key] = handler
    }
    
    func resolve<T>(for type: T.Type) -> T {
        let key = String(describing: type)
        
        if let value = dependencies[key] as? T {
            return value
        } else if let closure = dependencies[key] as? (DependencyResolvable) -> T {
            return closure(self)
        } else {
            fatalError("저장된 객체가 없음")
        }
    }
}
