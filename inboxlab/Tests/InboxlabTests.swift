import Testing
@testable import inboxlab
@testable import InboxDomain
@testable import InboxData

@Suite("Inbox Lab Tests")
struct InboxlabTests {
    
    @Test @MainActor
    func bothObserversReceiveReadStatusUpdate() async throws {
        let message = Inbox.Domain.Message.mockUnread
        let sut = Inbox.Data.InMemoryRepository(messages: [message])
        
        let stream1 = sut.observe()
        let stream2 = sut.observe()
        
        // iterator = lecteur de flux
        var iterator1 = stream1.makeAsyncIterator()
        var iterator2 = stream2.makeAsyncIterator()
        
        // attd & retrieve prochaine liste de messages émise par le flux
        let initialMessage1 = await iterator1.next()
        let initialMessage2 = await iterator2.next()
        
        let message1 = try #require(initialMessage1)
        let message2 = try #require(initialMessage2)
        
        #expect(message1.count == 1)
        #expect(message2.count == 1)
        
        let receivedMessage1 = try #require(message1.first)
        let receivedMessage2 = try #require(message2.first)
        
        #expect(receivedMessage1.id == message.id)
        #expect(receivedMessage2.id == message.id)
        #expect(!receivedMessage1.hasBeenRead)
        #expect(!receivedMessage2.hasBeenRead)
        
        try await sut.markAsRead(id: message.id)
        
        let updatedMessage1 = await iterator1.next()
        let updatedMessage2 = await iterator2.next()
        
        let messageUpdated1 = try #require(updatedMessage1)
        let messageUpdated2 = try #require(updatedMessage2)
        
        #expect(messageUpdated1.count == 1)
        #expect(messageUpdated2.count == 1)
        
        let receivedUpdatedMessage1 = try #require(messageUpdated1.first)
        let receivedUpdatedMessage2 = try #require(messageUpdated2.first)
        
        #expect(receivedUpdatedMessage1.id == message.id)
        #expect(receivedUpdatedMessage2.id == message.id)
        #expect(receivedUpdatedMessage1.hasBeenRead)
        #expect(receivedUpdatedMessage2.hasBeenRead)
    }
    
    @Test @MainActor
    func remainingObserverReceivesUpdatesAfterCancellation() async throws {
        let unread = Inbox.Domain.Message.mockUnread
        let sut = Inbox.Data.InMemoryRepository(messages: [unread])
        
        let detailStream = sut.observe()
        let listStream = sut.observe()
        
        let detailTask = Task { @MainActor in
            for await _ in detailStream {}
        }
        
        var iterator = listStream.makeAsyncIterator()
        let initialMessage = await iterator.next()
        
        let messages = try #require(initialMessage)
        #expect(messages.count == 1)
        
        let receivedMessage = try #require(messages.first)
        #expect(!receivedMessage.hasBeenRead)
        
        detailTask.cancel()
        await detailTask.value
        try await sut.markAsRead(id: unread.id)
        
        let updatedMessages = await iterator.next()
        let unwrappedUpdatedMessages = try #require(updatedMessages)
        #expect(unwrappedUpdatedMessages.count == 1)
        
        let updatedMessage = try #require(unwrappedUpdatedMessages.first)
        #expect(updatedMessage.id == unread.id)
        #expect(updatedMessage.hasBeenRead)
    }
}
