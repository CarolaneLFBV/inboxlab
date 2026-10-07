//
//  RealmRepository.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 06/10/2026.
//

import Foundation
import RealmSwift
import InboxDomain

extension Inbox.Data {
    final class RealmRepository: Inbox.Domain.Providing {
        private let realm: Realm
        private let fetching: Inbox.Domain.Fetching
        
        init(
            realm: Realm,
            fetching: Inbox.Domain.Fetching
        ) {
            self.realm = realm
            self.fetching = fetching
        }
        
        // MARK: - Methods
        
        /// Observe messages saved dans Realm
        ///
        /// Émet liste initiale, puis new list à chaque notification d'update.
        /// Objets Realm -> Modèles Domain
        ///
        /// - returns: flux listes de message
        func observe() -> AsyncStream<[Inbox.Domain.Message]> {
            let results = realm.objects(Inbox.Data.MessageObject.self)
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
        func markAsRead(id: Int) async throws {
            guard let message = realm.object(ofType: Inbox.Data.MessageObject.self, forPrimaryKey: id),
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
        func save(messages: [Inbox.Domain.Message]) throws {
            // conversion
            let objects = messages.map {
                Inbox.Data.MessageObject(from: $0)
            }
            
            // save
            try realm.write {
                realm.add(objects, update: .modified)
            }
        }
        
        /// Fetch messages distants et sauvegarde dans Realm
        /// Changements diffusés par observation de la base
        ///
        /// - throws: erreur récupération ou sauvegarde
        func refresh() async throws {
            let messages = try await fetching.fetchMessages()
            let messagesToSave = messages.map { message in
                var updatedMessage = message
                
                if let existing = realm.object(ofType: Inbox.Data.MessageObject.self, forPrimaryKey: message.id) {
                    updatedMessage.hasBeenRead = existing.hasBeenRead
                }
                return updatedMessage
                
            }
            try save(messages: messagesToSave)
        }
    }
}
