//
//  InboxView.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 05/10/2026.
//

import SwiftUI
import InboxDomain

extension Inbox.Presentation {
    struct View: SwiftUI.View {
        @State private var viewModel: Inbox.Presentation.ViewModel
        
        init(viewModel: Inbox.Presentation.ViewModel) {
            _viewModel = State(initialValue: viewModel)
        }
        
        var body: some SwiftUI.View {
            NavigationStack {
                content
                    .task {
                        await viewModel.observeMessages()
                    }
                    .refreshable {
                        await viewModel.refreshMessages()
                    }
                    .alert(
                        "Erreur de rafraîchissement",
                        isPresented: Binding(
                            get: { viewModel.errorMessage != nil },
                            set: { isPresented in
                                if !isPresented { viewModel.dismissError() }
                            }
                        )
                    ) {
                        Button("OK", role: .cancel) {
                            viewModel.dismissError()
                        }
                    } message: {
                        Text(viewModel.errorMessage ?? "Veuillez réessayer")
                    }
            }
        }
    }
}

private extension Inbox.Presentation.View {
    var content: some SwiftUI.View {
        List(viewModel.messages) { message in
            NavigationLink(destination: Inbox.Presentation.MessageDetailView(
                message: message,
                onOpen: {
                    try await viewModel.markMessageAsRead(id: message.id)
                }
            )) {
                Inbox.Presentation.MailRowComponent(message: message)
            }
        }
    }
}
