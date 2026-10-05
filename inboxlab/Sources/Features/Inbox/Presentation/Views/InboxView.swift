//
//  InboxView.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 05/10/2026.
//

import SwiftUI

private extension App.Inbox.Presentation.View {
    enum Layout {
        static let dotSize: CGFloat = 10.0
    }
}

extension App.Inbox.Presentation {
    struct View: SwiftUI.View {
        @State private var viewModel: App.Inbox.Presentation.ViewModel
        
        init(viewModel: App.Inbox.Presentation.ViewModel) {
            _viewModel = State(initialValue: viewModel)
        }
        
        var body: some SwiftUI.View {
            content
                .task {
                    await viewModel.observeMessages()
                }
        }
    }
}

private extension App.Inbox.Presentation.View {
    var content: some SwiftUI.View {
        List(viewModel.messages) { message in
            HStack {
                VStack(alignment: .leading){
                    Text(message.sender)
                        .font(.headline)
                    Text(message.subject)
                        .font(.subheadline)
                }
                
                Spacer()
                
                if !message.hasBeenRead {
                    Circle()
                        .fill(.blue)
                        .frame(width: Layout.dotSize, height: Layout.dotSize)
                }
            }
        }
    }
}
