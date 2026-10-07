//
//  ViewModel.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 05/10/2026.
//

import Foundation
import InboxDomain

public extension Inbox.Presentation {
    @Observable
    final class ViewModel {
        private let repository: Inbox.Domain.Providing
        private(set) var messages: [Inbox.Domain.Message] = []
        private(set) var errorMessage: String? = nil
        
        public init(repository: Inbox.Domain.Providing) {
            self.repository = repository
        }
        
        // MARK: - Methods
        public func observeMessages() async {
            let stream = repository.observe()
            for await receivedMessages in stream {
                self.messages = receivedMessages
            }
        }
        
        public func markMessageAsRead(id: Int) async throws {
            try await repository.markAsRead(id: id)
        }
        
        public func refreshMessages() async {
            dismissError()
            do {
                try await repository.refresh()
            } catch(let error) {
                errorMessage = error.localizedDescription
            }
        }
        
        public func dismissError() {
            errorMessage = nil
        }
    }
}
