//
//  Message.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 04/10/2026.
//

import Foundation

public extension Inbox.Domain {
    struct Message: Identifiable {
        public let id: Int
        public let sender: String
        public let recipient: String
        public let ccRecipients: [String]
        public let subject: String
        public let content: String
        public let receivedAt: Date
        public var hasBeenRead: Bool
        
        public init(
            id: Int,
            sender: String,
            recipient: String,
            ccRecipients: [String],
            subject: String,
            content: String,
            receivedAt: Date,
            hasBeenRead: Bool
        ) {
            self.id = id
            self.sender = sender
            self.recipient = recipient
            self.ccRecipients = ccRecipients
            self.subject = subject
            self.content = content
            self.receivedAt = receivedAt
            self.hasBeenRead = hasBeenRead
        }
    }
}


