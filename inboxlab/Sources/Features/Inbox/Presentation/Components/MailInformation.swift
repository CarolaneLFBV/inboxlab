//
//  PersonComponent.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 06/10/2026.
//

import SwiftUI

extension App.Inbox.Presentation {
    struct MailInformation: SwiftUI.View {
        let label: String
        let icon: String
        let value: String
        
        var body: some SwiftUI.View {
            HStack {
                Label(label, systemImage: icon)
                    .foregroundStyle(.gray)
                Text(value)
                    .foregroundStyle(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

}
