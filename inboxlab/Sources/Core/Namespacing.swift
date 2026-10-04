//
//  Namespacing.swift
//  inboxlab
//
//  Created by Carolane Lefebvre on 04/10/2026.
//

import Foundation

extension App {
    enum Core {}
    enum DesignSystem {}
    
    // MARK: - Feature
    enum Inbox {}
}

extension App.Inbox {
    enum Domain {}
    enum Data {}
    enum Presentation {}
}
