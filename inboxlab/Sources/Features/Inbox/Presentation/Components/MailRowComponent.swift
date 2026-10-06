//
//  MailRowComponent.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 06/10/2026.
//

import SwiftUI

private extension App.Inbox.Presentation.MailRowComponent {
    enum Layout {
        static let dotSize: CGFloat = 10.0
    }
}

extension App.Inbox.Presentation {
    struct MailRowComponent: SwiftUI.View {
        let message: App.Inbox.Domain.Message
        
        var body: some SwiftUI.View {
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
