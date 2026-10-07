//
//  PreviewFetcher.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 07/10/2026.
//

import Foundation

extension App.Inbox.Data {
    final class PreviewFetcher: App.Inbox.Domain.Fetching {
        private let messages: [App.Inbox.Domain.Message]
        
        init(messages: [App.Inbox.Domain.Message]) {
            self.messages = messages
        }
        
        func fetchMessages() async throws -> [App.Inbox.Domain.Message] {
            messages
        }
    }
}
