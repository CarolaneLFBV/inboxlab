//
//  Repository.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 04/10/2026.
//

import Foundation

extension App.Inbox.Data {
    final class Repository: App.Inbox.Domain.Providing {
        private var messages: [App.Inbox.Domain.Message]
        // Conserve une continuation par abonnement pour diffuser les changements de messages à chaque observateur
        private var continuations: [UUID: AsyncStream<[App.Inbox.Domain.Message]>.Continuation] = [:]
        
        init(messages: [App.Inbox.Domain.Message]) {
            self.messages = messages
        }
        
        /// Crée flux observation des messages
        ///
        /// Chaque appel crée un abonnement indépendant
        /// reçoit la liste actuelle des messages
        ///
        /// - returns: flux dont chaque valeur = liste de messages
        func observe() -> AsyncStream<[App.Inbox.Domain.Message]> {
            return AsyncStream { continuation in
                let id = UUID()
                continuations[id] = continuation // conserve continuation -> send futur updates
                continuation.yield(messages) // envoie valeur dans le flux
            }
        }
        
        /// Marque message identifié comme lu et diffuse la liste updated
        ///
        /// - params(id): id message à marquer comme lu
        func markAsRead(id: UUID) async throws {
            guard let index = messages.firstIndex(where: { $0.id == id}) else { return }
            guard messages[index].hasBeenRead == false else { return }
            messages[index].hasBeenRead = true
            for continuation in continuations.values {
                continuation.yield(messages)
            }
        }
    }
}
