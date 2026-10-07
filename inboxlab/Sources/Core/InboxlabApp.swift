import SwiftUI
import RealmSwift

@main
struct App: SwiftUI.App {
    @State private var viewModel: App.Inbox.Presentation.ViewModel?
    private var errorMessage: String?
    
    init() {
        do {
            let realm = try Realm()
            let fetching = App.Inbox.Data.AlamofireMessageFetcher()
            let repository = App.Inbox.Data.RealmRepository(
                realm: realm,
                fetching: fetching
            )
            let viewModel = App.Inbox.Presentation.ViewModel(repository: repository)
            self.errorMessage = nil

            if realm.objects(App.Inbox.Data.MessageObject.self).isEmpty {
                try repository.save(messages: App.Inbox.Domain.Message.mocks)
            }
            
            _viewModel = State(initialValue: viewModel)
        } catch {
            _viewModel = State(initialValue: nil)
            self.errorMessage = error.localizedDescription
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if let viewModel {
                App.Inbox.Presentation.View(viewModel: viewModel)
            } else {
                Text(errorMessage ?? "Unknown error")
            }
        }
    }
}
