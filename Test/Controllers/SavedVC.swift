//
//  SavedVC.swift
//  Test
//
//  Created by Uyg'un Tursunov on 07/10/23.
//

import UIKit

class SavedVC: UIViewController {
    
    var mainViewModel = MainViewModel()
    
    var usersIdAndName = [Int: String]()
    var usersIdAndMail = [Int: String]()
    let emptyStateView = EmptyView(message: "No Saved Posts")
    
    lazy var savedPostsTable: UITableView = {
        let table = UITableView()
        table.register(PostsTableViewCell.self, forCellReuseIdentifier: PostsTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        addSubviews()
        setupBinding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        savedPostsTable.frame = view.bounds
        emptyStateView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBinding()
    }
    
    func setupBinding() {
        mainViewModel.fetchPostsFromDatabase()
        mainViewModel.fetchUsersFromDataBase()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Saved"), object: nil, queue: nil) { _ in
            self.mainViewModel.fetchPostsFromDatabase()
            self.mainViewModel.fetchUsersFromDataBase()
            DispatchQueue.main.async {
                self.savedPostsTable.reloadData()
            }
        }
        if(mainViewModel.isEmpty) {
            emptyStateView.isHidden = false
        } else {
            emptyStateView.isHidden = true
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        title = "Saved Posts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        emptyStateView.isHidden = true
    }
    
    private func addSubviews() {
        view.addSubview(savedPostsTable)
        view.addSubview(emptyStateView)
    }
}

extension SavedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewModel.postItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.identifier, for: indexPath) as? PostsTableViewCell else { return UITableViewCell() }
        
        let postItem = mainViewModel.postItems[indexPath.row]
        let userId = Int(postItem.userId)
        let filteredUser = mainViewModel.userItems.filter( {$0.id == userId} )
        if(filteredUser.count > 0) {
            let authorName = filteredUser[0].name ?? ""
            cell.configure(with: Post(userId: Int(postItem.userId), id: Int(postItem.id), title: postItem.title ?? "", body: postItem.body ?? ""), authorName: authorName, imageString: "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let post = mainViewModel.postItems[indexPath.row]
            let userId = Int(post.userId)
            mainViewModel.deleteUSer(with: userId)
            mainViewModel.deletePostAt(indexPathRow: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let postItem = mainViewModel.postItems[indexPath.row]
        let userId = postItem.userId
        let filteredUser = mainViewModel.userItems.filter( {$0.id == userId} )
        if(filteredUser.count > 0) {
            if let name = filteredUser[0].name, let mail = filteredUser[0].email {
                let author = "\(name))\n\(mail))"
                let postDetails = PostDetailsViewModel(title: postItem.title ?? "", body: postItem.body ?? "", authorName: author)
                
                let vc = DetailedVC()
                vc.configure(with: postDetails)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
