//
//  InMemoryRepository.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 04/10/2026.
//

import Foundation
import InboxDomain

public extension Inbox.Data {
    final class InMemoryRepository: Inbox.Domain.Providing {
        private var messages: [Inbox.Domain.Message]
        // Conserve une continuation par abonnement pour diffuser les changements de messages à chaque observateur
        private var continuations: [UUID: AsyncStream<[Inbox.Domain.Message]>.Continuation] = [:]
        
        public init(messages: [Inbox.Domain.Message]) {
            self.messages = messages
        }
        
        /// Crée flux observation des messages
        ///
        /// Chaque appel crée un abonnement indépendant
        /// reçoit la liste actuelle des messages
        ///
        /// - returns: flux dont chaque valeur = liste de messages
        public func observe() -> AsyncStream<[Inbox.Domain.Message]> {
            return AsyncStream { continuation in
                let id = UUID()
                continuations[id] = continuation // conserve continuation -> send futur updates
                continuation.yield(messages) // envoie valeur dans le flux
                
                // Retire abonnement à la terminaison du flux
                continuation.onTermination = { [weak self] _ in
                    Task { @MainActor [weak self] in
                        self?.continuations.removeValue(forKey: id)
                    }
                }
            }
        }
        
        /// Marque message identifié comme lu et diffuse la liste updated
        ///
        /// - params(id): id message à marquer comme lu
        public func markAsRead(id: Int) async throws {
            guard let index = messages.firstIndex(where: { $0.id == id}) else { return }
            guard messages[index].hasBeenRead == false else { return }
            messages[index].hasBeenRead = true
            for continuation in continuations.values {
                continuation.yield(messages)
            }
        }
        
        /// Réalise aucune opération car les messages sont fournis en mémoire sans source distante à rafraîchir.
        public func refresh() async throws {}
    }
}
