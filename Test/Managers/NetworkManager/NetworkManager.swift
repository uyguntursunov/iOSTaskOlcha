//
//  NetworkManager.swift
//  Test
//
//  Created by Uyg'un Tursunov on 07/10/23.
//

import UIKit

enum APIError: Error {
    case failedToGetData
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func getPosts(for urlString: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: "\(urlString)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = URL(string: "\(Endpoints.users)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode([User].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
}
