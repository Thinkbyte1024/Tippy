import SwiftUI

@main
struct MyApp: App {
    let controller = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TipListView()
                .environment(\.managedObjectContext, controller.container.viewContext)
        }
    }
}
