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
    
    static func add<T: Encodable>(item: T, id: String, to collectionReference: CollectionReference) async throws {
        let documentRef = collectionReference.document(id)
        
        do {
            let data = try Helpers.encoder.encode(item)
            if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                try await documentRef.setData(dictionary)
                print("\(T.self) added successfully")
            }
        } catch {
            print("Error encoding \(T.self): \(error.localizedDescription)")
        }
    }
}
