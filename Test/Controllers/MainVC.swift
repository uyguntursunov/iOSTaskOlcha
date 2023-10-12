//
//  MainVC.swift
//  Test
//
//  Created by Uyg'un Tursunov on 07/10/23.
//

import UIKit

protocol MainVCDelegate: AnyObject {
    func didTapSaveButton(for indexPathRow: Int)
}

class MainVC: UIViewController {
    
    var mainViewModel = MainViewModel()
    let refreshControl = UIRefreshControl()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    lazy var postsTable: UITableView = {
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
        setupSearchController()
        setupBinding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        postsTable.frame = view.bounds
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        postsTable.addSubview(refreshControl)
    }
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func addSubviews() {
        view.addSubview(postsTable)
    }
    
    func setupBinding() {
        showLoadingView()
        mainViewModel.getPosts(for: Endpoints.posts)
        mainViewModel.getUsers()
        dismissLoadingView()
        mainViewModel.postsDidChange = {
            DispatchQueue.main.async {
                self.postsTable.reloadData()
            }
        }
        
        mainViewModel.usersDidChange = {
            DispatchQueue.main.async {
                self.postsTable.reloadData()
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        setupBinding()
        refreshControl.endRefreshing()
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainViewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.identifier, for: indexPath) as? PostsTableViewCell else {
            return UITableViewCell() }
        
        cell.delegate = self
        let post = mainViewModel.posts[indexPath.row]
        cell.configure(with: post, authorName: mainViewModel.usersIdAndName[post.userId] ?? "", imageString: "plus")
        cell.indexPathRow = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = mainViewModel.posts[indexPath.row]
        if let userName = mainViewModel.usersIdAndName[post.userId], let mail = mainViewModel.usersIdAndMail[post.userId] {
            let author = "\(String(describing: userName))\n\(String(describing: mail))"
            let postDetails = PostDetailsViewModel(title: post.title, body: post.body, authorName: author)
            let vc = DetailedVC()
            vc.configure(with: postDetails)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MainVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.mainViewModel.setInSearchMode(searchController)
        self.mainViewModel.updateSearchController(searchBarText: searchController.searchBar.text)
        DispatchQueue.main.async {
            self.postsTable.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mainViewModel.setInSearchMode(searchController)
    }
}

extension MainVC: MainVCDelegate {
    func didTapSaveButton(for indexPathRow: Int) {
        mainViewModel.fetchPostsFromDatabase()
        var userId = Int()
        
        let postId = mainViewModel.posts[indexPathRow].id
        let samePosts = mainViewModel.postItems.filter( {$0.id == postId} )
        if(samePosts.count == 0) {
            mainViewModel.savePostAt(indexPathRow: indexPathRow)
            userId = mainViewModel.posts[indexPathRow].userId
            mainViewModel.saveUser(with: userId)
            presentAlert(with: "Success", message: "You have successfully saved this post🎉")
        } else {
            self.presentAlert(with: "Something went wrong", message: "You have already saved this post!")
        }
    }
}
