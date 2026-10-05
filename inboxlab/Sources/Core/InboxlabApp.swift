import SwiftUI

@main
struct App: SwiftUI.App {
    @State private var viewModel = App.Inbox.Presentation.ViewModel(
        repository: App.Inbox.Data.Repository(
            messages: App.Inbox.Domain.Message.mocks
        )
    )
    
    var body: some Scene {
        WindowGroup {
            App.Inbox.Presentation.View(viewModel: viewModel)
        }
    }
}
