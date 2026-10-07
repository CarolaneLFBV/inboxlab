//
//  Message.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 04/10/2026.
//

import Foundation

extension App.Inbox.Domain {
    struct Message: Identifiable {
        let id: Int
        let sender: String
        let recipient: String
        let ccRecipients: [String]
        let subject: String
        let content: String
        let receivedAt: Date
        var hasBeenRead: Bool
    }
}


