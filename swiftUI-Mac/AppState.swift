import Foundation
import SwiftUI
import Combine

class AppState: ObservableObject {
    public static let shared = AppState()
    
    private init() {
        
    }
    
    @Published var navTitle: String = "MacExamples" {
        didSet {
            print(navTitle)
        }
    }
    @Published var searchText: String = ""
    
}
