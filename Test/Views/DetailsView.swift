//
//  DetailsView.swift
//  Test
//
//  Created by Uyg'un Tursunov on 10/10/23.
//

import UIKit

class DetailsView: UIView {
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 30, weight: .regular)
        return titleLabel
    }()
    
    lazy var bodyLabel: UILabel = {
        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 20)
        bodyLabel.numberOfLines = 0
        return bodyLabel
    }()
    
    lazy var authorNameLabel: UILabel = {
        let authorNameLabel = UILabel()
        authorNameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        authorNameLabel.textAlignment = .right
        authorNameLabel.numberOfLines = 0
        return authorNameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with model: PostDetailsViewModel) {
        self.titleLabel.text = model.title
        self.bodyLabel.text = model.body
        self.authorNameLabel.text = model.authorName
    }
    
    func addSubviews() {
        for item in [titleLabel, bodyLabel, authorNameLabel] {
            addSubview(item)
        }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).inset(100)
            make.leading.equalTo(self).inset(20)
            make.trailing.equalTo(self).inset(10)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-25)
            make.leading.trailing.equalTo(self).inset(20)
        }
        
        authorNameLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel.snp.bottom).inset(-30)
            make.trailing.equalTo(self).inset(20)
        }
    }
}
