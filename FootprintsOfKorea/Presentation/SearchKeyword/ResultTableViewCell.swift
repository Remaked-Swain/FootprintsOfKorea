//
//  ReusltTableViewCell.swift
//  FootprintsOfKorea
//
//  Created by 김경록 on 5/16/24.
//

import UIKit

final class ResultTableViewCell: UITableViewCell {
    private let primaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let telePhoneNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            addressLabel,
            telePhoneNumberLabel
        ])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        setConstraints()
    }

    func bindModel(item: SearchKeywordViewController.CellItem?) {
        titleLabel.text = item?.title
        addressLabel.text = item?.address
        telePhoneNumberLabel.text = item?.telephoneNumber
        primaryImageView.image = item?.primaryImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        self.addSubview(primaryImageView)
        self.addSubview(stackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            primaryImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            primaryImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            primaryImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            primaryImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4),
            
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: primaryImageView.trailingAnchor, constant: 10)
        ])
    }
}
