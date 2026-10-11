//
//  Providing.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 04/10/2026.
//

import Foundation

public extension Inbox.Domain {
    @MainActor
    protocol Providing {
        func observe() -> AsyncStream<[Inbox.Domain.Message]>
        func markAsRead(id: Int) async throws
        func refresh() async throws
        func searchMessages(query: String) async throws -> [Inbox.Domain.Message]
    }
}
