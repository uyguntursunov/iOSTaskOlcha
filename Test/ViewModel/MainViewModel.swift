//
//  MainViewModel.swift
//  Test
//
//  Created by Uyg'un Tursunov on 07/10/23.
//

import UIKit

class MainViewModel {
    
    var postsDidChange: (()-> Void)?
    var usersDidChange: (()-> Void)?
    
    var inSearchMode: Bool = false
    var filteredPosts: [Post] = []
    
    var allPosts: [Post] = [] {
        didSet {
            postsDidChange?()
        }
    }
    
    var users: [User] = [] {
        didSet {
            usersDidChange?()
        }
    }
    
    var posts: [Post] {
        return inSearchMode ? filteredPosts : allPosts
    }
    
    var postItems: [PostsItem] = [PostsItem]()
    var userItems: [UsersItem] = [UsersItem]()
    var usersIdAndName = [Int: String]()
    var usersIdAndMail = [Int: String]()
    var isEmpty: Bool = true
    
    func getPosts(for urlType: String) {
        NetworkManager.shared.getPosts(for: urlType) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self.allPosts = posts
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getUsers() {
        NetworkManager.shared.getUsers() { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.users = users
                    
                    let usersIdAndName = users.reduce(into: [Int: String]()) { (result, user) in
                        result[user.id] = user.name
                    }
                    self.usersIdAndName = usersIdAndName
                    
                    let usersIdAndMail = users.reduce(into: [Int: String]()) { (result, user) in
                        result[user.id] = user.email
                    }
                    self.usersIdAndMail = usersIdAndMail
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func savePostAt(indexPathRow: Int) {
        DataPersistanceManager.shared.savePost(with: posts[indexPathRow]) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("Saved"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func saveUser(with id: Int) {
        let filteredUser = users.filter({$0.id == id})
        DataPersistanceManager.shared.saveUser(with: filteredUser[0]) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("Saved"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deletePostAt(indexPathRow: Int) {
        DataPersistanceManager.shared.deletePost(with: postItems[indexPathRow]) { [weak self] result in
            switch result {
            case .success(()):
                print("Post Deleted Successfully")
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.postItems.remove(at: indexPathRow)
        }
    }
    
    func deleteUSer(with id: Int) {
        let filteredUser = userItems.filter({$0.id == id})
        if(filteredUser.count > 0) {
            DataPersistanceManager.shared.deleteUser(with: filteredUser[0]) { [weak self] result in
                switch result {
                case .success(()):
                    print("User Deleted Successfully")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.userItems.remove(at: 0)
            }
        }
    }
    
    func fetchPostsFromDatabase() {
        DataPersistanceManager.shared.fetchPostsFromDatabase { [weak self] result in
            switch result {
            case .success(let postItems):
                if(!postItems.isEmpty) {
                    self?.isEmpty = false
                    self?.postItems = postItems
                } else {
                    self?.isEmpty = true
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchUsersFromDataBase() {
        DataPersistanceManager.shared.fetchUserFromDatabase { [weak self] result in
            switch result {
            case .success(let userItems):
                self?.userItems = userItems
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension MainViewModel {
    func setInSearchMode(_ searchController: UISearchController) {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        self.inSearchMode = isActive && !searchText.isEmpty
    }
    
    func updateSearchController(searchBarText: String?) {
        self.filteredPosts = allPosts
        guard let query = searchBarText,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 1 else {return }
        self.filteredPosts = self.allPosts.filter( {$0.title.contains(query.lowercased())} )
    }
}
