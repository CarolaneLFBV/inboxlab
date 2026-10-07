//
//  MessageDetailView.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 06/10/2026.
//

import SwiftUI
import InboxDomain

public extension Inbox.Presentation {
    struct MessageDetailView: SwiftUI.View {
        @State private var errorMessage: String?
        let message: Inbox.Domain.Message
        let onOpen: () async throws -> Void
        
        private var formattedDate: String {
            message.receivedAt.formatted(date: .abbreviated, time: .shortened)
        }
        
        public var body: some SwiftUI.View {
            ScrollView {
                mailInformations
                mailSubject
                mailContent
            }
            .navigationTitle(message.subject)
            .task {
                do {
                    try await onOpen()
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

private extension Inbox.Presentation.MessageDetailView {
    var mailInformations: some SwiftUI.View {
        VStack(spacing: 8) {
            Inbox.Presentation.MailInformation(
                label: "from:",
                icon: "person.circle",
                value: message.sender
            )
            
            Inbox.Presentation.MailInformation(
                label: "to:",
                icon: "person.circle",
                value: message.recipient
            )
            
            Inbox.Presentation.MailInformation(
                label: "received at:",
                icon: "calendar",
                value: formattedDate
            )
        }
        .padding()
    }
    
    var mailSubject: some SwiftUI.View {
        HStack {
            Text("Subject:")
            Text(message.subject)
                .bold()
        }
        .padding(.leading, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var mailContent: some SwiftUI.View {
        VStack {
            Text(message.content)
        }
        .padding(.leading, 16)
        .padding(.top, 4)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}
