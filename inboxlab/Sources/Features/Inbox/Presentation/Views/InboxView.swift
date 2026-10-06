//
//  InboxView.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 05/10/2026.
//

import SwiftUI



extension App.Inbox.Presentation {
    struct View: SwiftUI.View {
        @State private var viewModel: App.Inbox.Presentation.ViewModel
        
        init(viewModel: App.Inbox.Presentation.ViewModel) {
            _viewModel = State(initialValue: viewModel)
        }
        
        var body: some SwiftUI.View {
            NavigationStack {
                content
                    .task {
                        await viewModel.observeMessages()
                    }
            }
        }
    }
}

private extension App.Inbox.Presentation.View {
    var content: some SwiftUI.View {
        List(viewModel.messages) { message in
            NavigationLink(destination: App.Inbox.Presentation.MessageDetailView(
                message: message,
                onOpen: {
                    try await viewModel.markMessageAsRead(id: message.id)
                }
            )) {
                App.Inbox.Presentation.MailRowComponent(message: message)
            }
        }
    }
}
