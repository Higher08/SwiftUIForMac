
import SwiftUI

@main
struct swiftUI_MacApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        //MARK: .handlesExternalEvents
        // Позволяет создать URL-scheme, нужно активировать в настройках target - info - urlTypes
        WindowGroup("Пример") {
            Text("Первый пример для открытия нового окна")
                .frame(minWidth: 30, idealWidth: 100, maxWidth: .infinity, minHeight: 20, idealHeight: 100, maxHeight: .infinity, alignment: .center)
        }
        // Пример - всегда открывает новое окно при вводе URL 'swiftUI-Mac/firstEx'
        .handlesExternalEvents(matching: Set(arrayLiteral: "firstEx"))
        
        
        WindowGroup("Пример") {
            Text("Другой пример для открытия и активации окна").handlesExternalEvents(preferring: Set(arrayLiteral: "secondEx"), allowing: Set(arrayLiteral: "secondEx")) // В случае если такое окно существует - оно активируется
                .frame(minWidth: 30, idealWidth: 100, maxWidth: .infinity, minHeight: 20, idealHeight: 100, maxHeight: .infinity, alignment: .center)
        }
        // Пример - открытия нового окна
        .handlesExternalEvents(matching: Set(arrayLiteral: "secondEx"))
        WindowGroup("Пример") {
            Sidebar().environmentObject(AppState.shared)
        }
        // Пример - открытия нового окна
        .handlesExternalEvents(matching: Set(arrayLiteral: "sidebarEx"))
        WindowGroup("Пример") {
            SearchField()
        }
        // Пример - открытия нового окна
        .handlesExternalEvents(matching: Set(arrayLiteral: "searchEx"))
        WindowGroup("Пример") {
            SidebarSearch().environmentObject(AppState.shared)
        }
        // Пример - открытия нового окна
        .handlesExternalEvents(matching: Set(arrayLiteral: "searchSideEx"))
        WindowGroup("Пример") {
            WindowMagic()
        }
        // Пример - открытия нового окна
        .handlesExternalEvents(matching: Set(arrayLiteral: "windowEx"))
    }
}
