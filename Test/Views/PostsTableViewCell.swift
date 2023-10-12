//
//  PostsTableViewCell.swift
//  Test
//
//  Created by Uyg'un Tursunov on 07/10/23.
//

import UIKit
import SnapKit

class PostsTableViewCell: UITableViewCell {
    
    static let identifier = "PostsTableViewCell"
    weak var delegate: MainVCDelegate?
    
    var indexPathRow: Int?
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        nameLabel.textColor = UIColor.label
        return nameLabel
    }()
    
    lazy var saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.layer.cornerRadius = 15
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return saveButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        for item in [titleLabel, nameLabel, saveButton] {
            contentView.addSubview(item)
        }
    }
    
    func setConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self).inset(10)
            make.leading.equalTo(self).inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).inset(-5)
            make.leading.equalTo(self).inset(20)
            make.trailing.equalTo(self).inset(45)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(self).inset(40)
            make.trailing.equalTo(self).inset(10)
            make.height.width.equalTo(30)
        }
    }
    
    func configure(with model: Post, authorName: String, imageString: String) {
        self.titleLabel.text = model.title
        self.nameLabel.text = authorName
        if(imageString != "") {
            self.saveButton.setImage(UIImage(systemName: imageString), for: .normal)
            self.saveButton.backgroundColor = .secondarySystemBackground
        }
    }
    
    @objc func saveButtonPressed() {
        if let indexPathRow = indexPathRow {
            delegate?.didTapSaveButton(for: indexPathRow)
        }
    }
}
