//
//  Fetching.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 07/10/2026.
//

import Foundation

public extension Inbox.Domain {
    protocol Fetching {
        func fetchMessages() async throws -> [Inbox.Domain.Message]
    }
}
