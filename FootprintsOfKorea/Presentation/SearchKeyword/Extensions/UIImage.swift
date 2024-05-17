//
//  UIImage.swift
//  FootprintsOfKorea
//
//  Created by 김경록 on 5/17/24.
//

import UIKit
import RxSwift
import RxCocoa

extension UIImageView {
    func setImage(from url: URL) -> Disposable {
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { UIImage(data: $0) }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] image in
                self?.image = image
            }, onError: { error in
                print("Failed to load the image: \(error)")
            })
    }
}
