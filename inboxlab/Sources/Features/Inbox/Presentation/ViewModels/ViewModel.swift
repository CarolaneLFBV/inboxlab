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
        
        public var searchText: String = ""
        public private(set) var searchResults: [Inbox.Domain.Message] = []
        private var activeSearchID: UUID? = nil
        private(set) var searchTask: Task<Void, Never>? = nil
        
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
        
        public func searchMessages() {
            searchTask?.cancel()
            activeSearchID = nil
            let query = searchText
            
            if query.isEmpty {
                searchResults = []
                return
            }
            
            let searchID = UUID()
            activeSearchID = searchID
            searchTask = Task {
                do {
                    try await Task.sleep(for: .milliseconds(300))
                    let results = try await repository.searchMessages(query: query)
                    guard activeSearchID == searchID else { return }
                    try Task.checkCancellation()
                    searchResults = results
                } catch is CancellationError {
                    return
                } catch {
                    guard activeSearchID == searchID,
                        !Task.isCancelled else { return }
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
