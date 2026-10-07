//
//  AlamofireMEssageFetcher.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 07/10/2026.
//

import Foundation
import Alamofire
import InboxDomain

private extension Inbox.Data.AlamofireMessageFetcher {
    enum Constants {
        static let url: String = "https://jsonplaceholder.typicode.com/posts/1/comments"
    }
}

extension Inbox.Data {
    final class AlamofireMessageFetcher: Inbox.Domain.Fetching {
        func fetchMessages() async throws -> [Inbox.Domain.Message] {
            let request = AF.request(Constants.url, method: .get).validate() // validate => vérification statut HTTP (200..299) + content accepté
            let responses = try await request.serializingDecodable([Inbox.Data.MessageResponse].self).value
            let mappedResponse = responses.map { response in
                response.toDomain()
            }
            return mappedResponse
        }
    }
}
