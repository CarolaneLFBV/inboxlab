//
//  MessageDetailView.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 06/10/2026.
//

import SwiftUI

extension App.Inbox.Presentation {
    struct MessageDetailView: SwiftUI.View {
        @State private var errorMessage: String?
        let message: App.Inbox.Domain.Message
        let onOpen: () async throws -> Void
        
        private var formattedDate: String {
            message.receivedAt.formatted(date: .abbreviated, time: .shortened)
        }
        
        var body: some SwiftUI.View {
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

private extension App.Inbox.Presentation.MessageDetailView {
    var mailInformations: some SwiftUI.View {
        VStack(spacing: 8) {
            App.Inbox.Presentation.MailInformation(
                label: "from:",
                icon: "person.circle",
                value: message.sender
            )
            
            App.Inbox.Presentation.MailInformation(
                label: "to:",
                icon: "person.circle",
                value: message.recipient
            )
            
            App.Inbox.Presentation.MailInformation(
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

#Preview {
    App.Inbox.Presentation.MessageDetailView(
        message: App.Inbox.Domain.Message.mockUnread,
        onOpen: {}
    )
}
