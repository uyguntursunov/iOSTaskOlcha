//
//  DetailedVC.swift
//  Test
//
//  Created by Uyg'un Tursunov on 10/10/23.
//

import UIKit

class DetailedVC: UIViewController {
    
    let detailsView = DetailsView()
    var postFromMain: Post?
    var postFromSearch: Post?
    var postFromSaved: PostsItem?
    var author: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detailsView.frame = view.bounds
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    func addSubviews() {
        view.addSubview(detailsView)
    }
    
    func configure(with model: PostDetailsViewModel) {
        detailsView.configure(with: model)
    }
}
