//
//  MessageObject.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 06/10/2026.
//

import Foundation
import RealmSwift
import InboxDomain

public extension Inbox.Data {
    @objc(InboxMessageObject)
    class MessageObject: Object {
        @Persisted(primaryKey: true)
        var id: Int
        
        @Persisted
        var sender: String
        
        @Persisted
        var recipient: String
        
        @Persisted
        var ccRecipient: List<String>
        
        @Persisted
        var subject: String
        
        @Persisted
        var receivedAt: Date
        
        @Persisted
        var content: String
        
        @Persisted
        var hasBeenRead: Bool
        
        /// Initialise objet Realm à partir d'un message Domain
        /// Conserve id et data
        /// Objet pas encore enregistré en base
        convenience init(from domain: Inbox.Domain.Message) {
            self.init()
            self.id = domain.id
            self.sender = domain.sender
            self.recipient = domain.recipient
            self.ccRecipient.append(objectsIn: domain.ccRecipients)
            self.subject = domain.subject
            self.content = domain.content
            self.receivedAt = domain.receivedAt
            self.hasBeenRead = domain.hasBeenRead
        }
        
        /// Convertit objet Realm en Domain indépendante de Realm
        ///
        /// ccRecipients convertie en tableau Swift
        func toDomain() -> Inbox.Domain.Message {
            return Inbox.Domain.Message(
                id: self.id,
                sender: self.sender,
                recipient: self.recipient,
                ccRecipients: Array(self.ccRecipient),
                subject: self.subject,
                content: self.content,
                receivedAt: self.receivedAt,
                hasBeenRead: self.hasBeenRead
            )
        }
    }
}
