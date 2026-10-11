//
//  ControlledSearchStub.swift
//  inboxlabTests
//
//  Created by Carolane Lefebvre on 11/10/2026.
//

import Foundation
import InboxDomain

@MainActor
final class ControlledSearchStub: Inbox.Domain.Providing {
    // suspend fonction, puis fournir result plus tard
    private var pendingSearches: [String: CheckedContinuation<[Inbox.Domain.Message], Error>] = [:]
    
    let startedSearches: AsyncStream<String>
    private let startedSearchesContinuation: AsyncStream<String>.Continuation
    
    init() {
        let pair = AsyncStream<String>.makeStream()
        self.startedSearches = pair.stream
        self.startedSearchesContinuation = pair.continuation
    }
    
    func observe() -> AsyncStream<[InboxDomain.Inbox.Domain.Message]> {
        return AsyncStream { continuation in
            continuation.finish()
        }
    }
    
    func markAsRead(id: Int) async throws {}
    
    func refresh() async throws {}
    
    func searchMessages(query: String) async throws -> [InboxDomain.Inbox.Domain.Message] {
        return try await withCheckedThrowingContinuation { continuation in
            pendingSearches[query] = continuation
            startedSearchesContinuation.yield(query)
        }
    }
    
    func completeSearch(query: String, messages: [Inbox.Domain.Message]) {
        guard let continuation = pendingSearches.removeValue(forKey: query) else { return }
        continuation.resume(returning: messages)
    }
}
