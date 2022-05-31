import Combine
import Foundation


    // MARK: App configurations

class AppSettings: ObservableObject {
    @Published var displayIntro: Bool {
        didSet {
            UserDefaults.standard.set(displayIntro, forKey: "displayIntro")
        }
    }

    init() {
        displayIntro = UserDefaults.standard.object(forKey: "displayIntro") as? Bool ?? true
    }
}
