//
//  MessageFetcherStub.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 07/10/2026.
//

import Foundation
@testable import inboxlab
import InboxDomain

final class MessageFetcherStub: Inbox.Domain.Fetching {
    private let messages: [Inbox.Domain.Message]
    
    init(messages: [Inbox.Domain.Message]) {
        self.messages = messages
    }
    
    func fetchMessages() async throws -> [Inbox.Domain.Message] {
        messages
    }
}
