//
//  ViewModel.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 05/10/2026.
//

import Foundation

extension App.Inbox.Presentation {
    @Observable
    final class ViewModel {
        private let repository: App.Inbox.Domain.Providing
        private(set) var messages: [App.Inbox.Domain.Message] = []
        private(set) var errorMessage: String? = nil
        
        init(repository: App.Inbox.Domain.Providing) {
            self.repository = repository
        }
        
        // MARK: - Methods
        func observeMessages() async {
            let stream = repository.observe()
            for await receivedMessages in stream {
                self.messages = receivedMessages
            }
        }
        
        func markMessageAsRead(id: Int) async throws {
            try await repository.markAsRead(id: id)
        }
        
        func refreshMessages() async {
            dismissError()
            do {
                try await repository.refresh()
            } catch(let error) {
                errorMessage = error.localizedDescription
            }
        }
        
        func dismissError() {
            errorMessage = nil
        }
    }
}
