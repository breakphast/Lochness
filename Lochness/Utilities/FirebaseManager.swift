//
//  FirebaseManager.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/27/23.
//

import Foundation
import SwiftUI
import Combine
import Firebase

class FirebaseManager {
    static func fetch<T>(query: Query, convert: @escaping (QueryDocumentSnapshot) -> T, listener: @escaping ([T]) -> Void) -> ListenerRegistration {
        let listenerRegistration = query.addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            let items = documents.map(convert)
            listener(items)
        }
        
        return listenerRegistration
    }
}
