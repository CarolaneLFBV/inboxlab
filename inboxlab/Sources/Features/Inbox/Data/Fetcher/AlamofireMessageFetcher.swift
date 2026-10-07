//
//  AlamofireMEssageFetcher.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 07/10/2026.
//

import Foundation
import Alamofire

private extension App.Inbox.Data.AlamofireMessageFetcher {
    enum Constants {
        static let url: String = "https://jsonplaceholder.typicode.com/posts/1/comments"
    }
}

extension App.Inbox.Data {
    final class AlamofireMessageFetcher: App.Inbox.Domain.Fetching {
        func fetchMessages() async throws -> [App.Inbox.Domain.Message] {
            let request = AF.request(Constants.url, method: .get).validate() // validate => vérification statut HTTP (200..299) + content accepté
            let responses = try await request.serializingDecodable([App.Inbox.Data.MessageResponse].self).value
            let mappedResponse = responses.map { response in
                response.toDomain()
            }
            return mappedResponse
        }
    }
}
