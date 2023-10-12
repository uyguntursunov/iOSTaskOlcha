//
//  EmptyView.swift
//  Test
//
//  Created by Uyg'un Tursunov on 11/10/23.
//

import UIKit

class EmptyView: UIView {
    
    lazy var emptyLabel: UILabel = {
        let emptyLabel = UILabel()
        emptyLabel.textAlignment = .center
        emptyLabel.font = .systemFont(ofSize: 40)
        emptyLabel.textColor = .secondaryLabel
        return emptyLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        emptyLabel.text = message
    }
    
    func configureUI() {
        backgroundColor = .systemBackground
    }
    
    func addSubviews() {
        addSubview(emptyLabel)
    }
    
    func setConstraints() {
        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
            make.leading.trailing.equalTo(self).inset(20)
        }
    }
}
