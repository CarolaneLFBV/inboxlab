//
//  FailingMessageFetcherStub.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 07/10/2026.
//

import Foundation
@testable import inboxlab

final class FailingMessageFetcherStub: App.Inbox.Domain.Fetching {
    enum Error: Swift.Error {
       case networkUnavailable
    }
    
    
    func fetchMessages() async throws -> [App.Inbox.Domain.Message] {
        throw Error.networkUnavailable
    }
}
