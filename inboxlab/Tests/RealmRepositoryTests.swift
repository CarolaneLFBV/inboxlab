//
//  RealmRepositoryTests.swift
//  inboxlabTests
//
//  Created by Carolane Lefebvre on 06/10/2026.
//

import Testing
import RealmSwift
import Foundation
@testable import inboxlab

@Suite("Realm Repository Tests")
struct RealmRepositoryTests {

    @Test @MainActor
    func savingMessagePreservesItsData() throws {
        let configuration = Realm.Configuration(inMemoryIdentifier: UUID().uuidString)
        let realm = try Realm(configuration: configuration)
        let sut = App.Inbox.Data.RealmRepository(realm: realm)
        let unread = App.Inbox.Domain.Message.mockUnread
        
        try sut.save(messages: [unread])
        
        let object = realm.object(ofType: App.Inbox.Data.MessageObject.self, forPrimaryKey: unread.id)
        let result = try #require(object)
        let objectToDomain = result.toDomain()
        
        #expect(objectToDomain.id == unread.id)
        #expect(objectToDomain.sender == unread.sender)
        #expect(objectToDomain.recipient == unread.recipient)
        #expect(objectToDomain.subject == unread.subject)
        #expect(objectToDomain.ccRecipients == unread.ccRecipients)
        #expect(objectToDomain.content == unread.content)
        #expect(objectToDomain.receivedAt == unread.receivedAt)
        #expect(objectToDomain.hasBeenRead == unread.hasBeenRead)
    }
    
    @Test @MainActor
    func savingSameMessageTwiceUpdateWithoutDuplicating() throws {
        let configuration = Realm.Configuration(inMemoryIdentifier: UUID().uuidString)
        let realm = try Realm(configuration: configuration)
        let sut = App.Inbox.Data.RealmRepository(realm: realm)
        let unread = App.Inbox.Domain.Message.mockUnread
        
        try sut.save(messages: [unread])
        
        var editedMessage = unread
        editedMessage.hasBeenRead = true
        try sut.save(messages: [editedMessage])
        
        let objects = realm.objects(App.Inbox.Data.MessageObject.self)
        #expect(objects.count == 1)
        
        let object = try #require(objects.first)
        #expect(object.id == unread.id)
        #expect(object.hasBeenRead == true)
    }
    
    @Test @MainActor
    func markAsReadUpdatesStoredMessage() async throws {
        let configuration = Realm.Configuration(inMemoryIdentifier: UUID().uuidString)
        let realm = try await Realm(configuration: configuration)
        let sut = App.Inbox.Data.RealmRepository(realm: realm)
        let unread = App.Inbox.Domain.Message.mockUnread
        
        try sut.save(messages: [unread])
        try await sut.markAsRead(id: unread.id)
        
        let object = realm.object(ofType: App.Inbox.Data.MessageObject.self, forPrimaryKey: unread.id)
        let result = try #require(object)
        
        #expect(result.hasBeenRead)
    }
    
    @Test @MainActor
    func observeEmitsUpdatedReadStatus() async throws {
        let configuration = Realm.Configuration(inMemoryIdentifier: UUID().uuidString)
        let realm = try await Realm(configuration: configuration)
        let sut = App.Inbox.Data.RealmRepository(realm: realm)
        let unread = App.Inbox.Domain.Message.mockUnread
        
        try sut.save(messages: [unread])
        let stream = sut.observe()
        var iterator = stream.makeAsyncIterator()
        
        let initialSnapshot = await iterator.next()
        let initialMessages = try #require(initialSnapshot)
        let firstMessage = try #require(initialMessages.first)
        #expect(!firstMessage.hasBeenRead)
        
        try await sut.markAsRead(id: unread.id)
        
        let updatedSnapshot = await iterator.next()
        let updatedMessages = try #require(updatedSnapshot)
        let updatedMessage = try #require(updatedMessages.first)
        #expect(updatedMessage.id == unread.id)
        #expect(updatedMessage.hasBeenRead)
    }
}
