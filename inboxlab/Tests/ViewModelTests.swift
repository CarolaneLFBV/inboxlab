//
//  ViewModelTests.swift
//  inboxlabTests
//
//  Created by Carolane Lefebvre on 11/10/2026.
//

import Testing
@testable import inboxlab
@testable import InboxDomain
@testable import InboxPresentation

@Suite("ViewModel Tests")
struct ViewModelTests {
    
    @Test @MainActor
    func olderSearchDoesNotReplaceNewerResults() async throws {
        let stub = ControlledSearchStub()
        let sut = Inbox.Presentation.ViewModel(repository: stub)
        var iterator = stub.startedSearches.makeAsyncIterator()

        sut.searchText = "ca"
        sut.searchMessages()
        let firstTask = try #require(sut.searchTask)

        let firstSearch = await iterator.next()
        #expect(firstSearch == "ca")

        sut.searchText = "café"
        sut.searchMessages()
        let secondTask = try #require(sut.searchTask)

        let secondSearch = await iterator.next()
        #expect(secondSearch == "café")

        stub.completeSearch(
            query: "café",
            messages: [Inbox.Domain.Message.mockRead]
        )
        await secondTask.value

        #expect(sut.searchResults.map(\.id) == [Inbox.Domain.Message.mockRead.id])

        stub.completeSearch(
            query: "ca",
            messages: [Inbox.Domain.Message.mockUnread]
        )
        await firstTask.value

        #expect(sut.searchResults.map(\.id) == [Inbox.Domain.Message.mockRead.id])
    }
}
