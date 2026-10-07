//
//  Message+Mock.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 05/10/2026.
//

import Foundation

public extension Inbox.Domain.Message {
    static var mockUnread: Self {
        Self(
            id: 123,
            sender: "alice@example.com",
            recipient: "carolane@example.com",
            ccRecipients: [],
            subject: "Bienvenue dans InboxLab",
            content: "Ton premier message est arrivé.",
            receivedAt: Date(timeIntervalSince1970: 1_759_651_200),
            hasBeenRead: false
        )
    }

    static var mockRead: Self {
        Self(
            id: 456,
            sender: "bob@example.com",
            recipient: "carolane@example.com",
            ccRecipients: ["alice@example.com"],
            subject: "Notre prochain rendez-vous",
            content: "On se retrouve demain pour continuer le projet.",
            receivedAt: Date(timeIntervalSince1970: 1_759_564_800),
            hasBeenRead: true
        )
    }

    static var mocks: [Self] {
        [mockUnread, mockRead]
    }
}
