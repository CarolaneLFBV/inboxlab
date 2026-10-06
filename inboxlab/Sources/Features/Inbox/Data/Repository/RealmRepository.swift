//
//  RealmRepository.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 06/10/2026.
//

import Foundation
import RealmSwift

extension App.Inbox.Data {
    final class RealmRepository: App.Inbox.Domain.Providing {
        private let realm: Realm
        
        init(realm: Realm) {
            self.realm = realm
        }
        
        // MARK: - Methods
        
        /// Observe messages saved dans Realm
        ///
        /// Émet liste initiale, puis new list à chaque notification d'update.
        /// Objets Realm -> Modèles Domain
        ///
        /// - returns: flux listes de message
        func observe() -> AsyncStream<[App.Inbox.Domain.Message]> {
            let results = realm.objects(App.Inbox.Data.MessageObject.self)
            return AsyncStream { continuation in
                let token = results.observe { change in
                    switch change {
                    case .initial(let collection):
                        let messages = Array(collection.map { $0.toDomain() })
                        continuation.yield(messages)
                    case .update(let collection, _, _, _):
                        let messages = Array(collection.map { $0.toDomain() })
                        continuation.yield(messages)
                    case .error:
                        continuation.finish()
                    }
                }
                
                continuation.onTermination = { _ in
                    token.invalidate()
                }
            }
        }
        
        /// Marque message comme lu dans transaction Realm
        ///
        /// - params(id): id message à edit
        /// - throws: erreur si transaction d'écriture échoue
        func markAsRead(id: UUID) async throws {
            guard let message = realm.object(ofType: App.Inbox.Data.MessageObject.self, forPrimaryKey: id),
                  !message.hasBeenRead else { return }
            
            try realm.write {
                message.hasBeenRead = true
            }
        }
        
        /// Save messages Domain dans une transaction Realm
        ///
        /// Convertit messages en objets persistés et update objets existants w/ même clé primaire
        ///
        /// - params(messages): messages à enregistrer
        /// - throws: erreur si transaction d'écriture échoue
        func save(messages: [App.Inbox.Domain.Message]) throws {
            // conversion
            let objects = messages.map {
                App.Inbox.Data.MessageObject(from: $0)
            }
            
            // save
            try realm.write {
                realm.add(objects, update: .modified)
            }
        }
    }
}
