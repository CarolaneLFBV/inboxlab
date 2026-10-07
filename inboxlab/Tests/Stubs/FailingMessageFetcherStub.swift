//
//  FailingMessageFetcherStub.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 07/10/2026.
//

import Foundation
import InboxDomain
@testable import inboxlab

final class FailingMessageFetcherStub: Inbox.Domain.Fetching {
    enum Error: Swift.Error {
       case networkUnavailable
    }
    
    
    func fetchMessages() async throws -> [Inbox.Domain.Message] {
        throw Error.networkUnavailable
    }
}
