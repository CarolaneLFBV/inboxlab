//
//  MessageResponse.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 07/10/2026.
//

import Foundation
import InboxDomain

public extension Inbox.Data {
    nonisolated struct MessageResponse: Decodable {
        public let id: Int
        public let sender: String
        public let subject: String
        public let content: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case sender = "email"
            case subject = "name"
            case content = "body"
        }
        
        public func toDomain() -> Inbox.Domain.Message {
            Inbox.Domain.Message(
                id: self.id,
                sender: self.sender,
                recipient: "test@test.com",
                ccRecipients: [],
                subject: self.subject,
                content: self.content,
                receivedAt: Date(timeIntervalSince1970: 1_791_331_200),
                hasBeenRead: false
            )
        }
    }
}
