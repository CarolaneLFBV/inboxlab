//
//  Fetching.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 07/10/2026.
//

import Foundation

extension App.Inbox.Domain {
    protocol Fetching {
        func fetchMessages() async throws -> [App.Inbox.Domain.Message]
    }
}
