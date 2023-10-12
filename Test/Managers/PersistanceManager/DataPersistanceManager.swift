//
//  DataPersistanceManager.swift
//  Test
//
//  Created by Uyg'un Tursunov on 08/10/23.
//

import UIKit
import CoreData

class DataPersistanceManager {
    static let shared = DataPersistanceManager()
    
    func savePost(with model: Post, completion: @escaping(Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let item = PostsItem(context: context)
        item.userId = Int64(model.userId)
        item.id = Int64(model.id)
        item.title = model.title
        item.body = model.body
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func saveUser(with model: User, comletion: @escaping(Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let item = UsersItem(context: context)
        item.id = Int64(model.id)
        item.name = model.name
        item.email = model.email
        do {
            try context.save()
            comletion(.success(()))
        } catch {
            comletion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func fetchPostsFromDatabase(completion: @escaping(Result<[PostsItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<PostsItem> = PostsItem.fetchRequest()
        do {
            let posts = try context.fetch(request)
            completion(.success(posts))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func fetchUserFromDatabase(completion: @escaping(Result<[UsersItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<UsersItem> = UsersItem.fetchRequest()
        do {
            let users = try context.fetch(request)
            completion(.success(users))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deletePost(with model: PostsItem, completion: @escaping(Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
    func deleteUser(with model: UsersItem, comletion: @escaping(Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        do {
            try context.save()
            comletion(.success(()))
        } catch {
            comletion(.failure(DatabaseError.failedToDeleteData))
        }
    }
}
