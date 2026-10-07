import SwiftUI
import RealmSwift
import InboxDomain

@main
struct App: SwiftUI.App {
    @State private var viewModel: Inbox.Presentation.ViewModel?
    private var errorMessage: String?
    
    init() {
        do {
            let realm = try Realm()
            let fetching = Inbox.Data.AlamofireMessageFetcher()
            let repository = Inbox.Data.RealmRepository(
                realm: realm,
                fetching: fetching
            )
            let viewModel = Inbox.Presentation.ViewModel(repository: repository)
            self.errorMessage = nil

            if realm.objects(Inbox.Data.MessageObject.self).isEmpty {
                try repository.save(messages: Inbox.Domain.Message.mocks)
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
                Inbox.Presentation.View(viewModel: viewModel)
            } else {
                Text(errorMessage ?? "Unknown error")
            }
        }
    }
}
