//
//  DatabaseError.swift
//  Test
//
//  Created by Uyg'un Tursunov on 08/10/23.
//

import Foundation

enum DatabaseError: Error {
    case failedToSaveData
    case failedToFetchData
    case failedToDeleteData
}
