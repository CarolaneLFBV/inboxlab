//
//  Providing.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 04/10/2026.
//

import Foundation

extension App.Inbox.Domain {
    protocol Providing {
        func observe() -> AsyncStream<[App.Inbox.Domain.Message]>
        func markAsRead(id: UUID) async throws
    }
}
