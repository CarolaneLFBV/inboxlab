//
//  Providing.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 04/10/2026.
//

import Foundation

public extension Inbox.Domain {
    protocol Providing {
        func observe() -> AsyncStream<[Inbox.Domain.Message]>
        func markAsRead(id: Int) async throws
        func refresh() async throws
    }
}
