

import SwiftUI

struct Sidebar: View {
    
    @EnvironmentObject private var appState: AppState
    
    // Если не нужны баги с заголовками окон и их перестановкой - нужен enum с вьюшками
    public enum NavigationItem {
        case main
        case also
        case superalso
    }
    
    // Автоматичсекое открытия сразу выбраной вью
    @State private var selection: NavigationItem? = .main {
        didSet {
            print(selection as Any)
        }
    }
    
    var body: some View {
        NavigationView {
            List(selection: $selection) {
                    NavigationLink(destination: Text("First").onAppear() { AppState.shared.navTitle = "Первое"}, tag: NavigationItem.main, selection: $selection) {
                        Label("Первая", systemImage: "info.circle")
                    }
                    .tag(NavigationItem.main)
                    NavigationLink(destination: Text("Second").onAppear() { AppState.shared.navTitle = "Второе"}, tag: NavigationItem.also, selection: $selection) {
                        Label("Другая", systemImage: "film")
                    }
                    .tag(NavigationItem.also)
                    NavigationLink(destination: Text("Third").onAppear() { AppState.shared.navTitle = "Третье"}, tag: NavigationItem.superalso, selection: $selection) {
                        Label("Еще другая", systemImage: "play.tv")
                    }
                    .tag(NavigationItem.superalso)
            }.animation(nil)
            .listStyle(SidebarListStyle())
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { toggleSidebar() }) {
                        Image(systemName: "sidebar.left")
                    }
                }
            }
            .frame(minWidth: 150)
        }
        // !!!: Не используйте модификатор .navigationTitle, когда нужно изменить заголовок. Гораздо лучше - свойство viewModel
        // View Model должна быть через EnvironmentObject, а не ViewModel()
        .navigationTitle(appState.navTitle)
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}


func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
}
