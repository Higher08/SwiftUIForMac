
import SwiftUI

public enum NavigationItemSearch {
    case search
    case main
    case tv
    case films
    case favorites
    case history
}

struct SidebarSearch: View {
    
    @EnvironmentObject private var appState: AppState
    
    @State private var selection: NavigationItemSearch? = .films {
        didSet {
            print(selection as Any)
        }
    }
    @State var videoURL: URL = URL(string: "127.0.0.1")!
    @State var searchText: String = ""
    @State var selectedTextFiled: Bool = false
    @State private var showCancelButton: Bool = false
    @State private var textField: NSTextField = NSTextField()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .trailing) {
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            
                            TextField("Поиск...", text: $searchText)
                                .onChange(of: searchText, perform: { value in
                                    appState.searchText = value
                                })
                                .padding(.vertical, 8)
                                .frame(height: 25)
                                .background(Color("SearchField"))
                                .textFieldStyle(PlainTextFieldStyle())
                                .introspectTextField { textField in
                                    self.textField = textField
                                }
                        }
                        .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 24))
                        .background(RoundedRectangle(cornerRadius: 8)
                                        .stroke(selection == .search ? Color.accentColor : Color.black.opacity(0.1), lineWidth: selection == .search ? 3 : 0.5)
                                        .background(Color("SearchField").cornerRadius(8)))
                    }
                    .zIndex(0)
                    .background(NavigationLink(destination: Text("Поиск ") + Text(appState.searchText).bold(), tag: NavigationItemSearch.search, selection: $selection) {
                        Label("2", systemImage: "film")
                    }
                    .tag(NavigationItemSearch.search))
                    .padding(.horizontal, 12)
                    
                    Button(action: { self.textField.window?.makeFirstResponder(textField); selection = .search }) {
                        Text("first responder")
                    }
                    .keyboardShortcut("f", modifiers: .command)
                    .opacity(0.01)
                    
                    Button(action: {
                        self.searchText = ""
                    }) {
                        HStack(spacing: 0) {
                            Image(systemName: "command")
                            Text("F")
                        }
                        .isHidden(selection == .search, remove: true)
                        Image(systemName: "xmark.circle.fill")
                            .isHidden(searchText.isEmpty, remove: true)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .background(Color("SearchField"))
                    .padding(.trailing, 18)
                    .zIndex(2)
                    Color.white
                        .opacity(0.01)
                        .isHidden(selection == .search)
                        .frame(height: 25)
                        .zIndex(1)
                        .onTapGesture {
                            textField.window?.makeFirstResponder(textField)
                            selection = .search
                        }
                }
                List(selection: $selection) {
                    NavigationLink(destination: Text("Main"), tag: NavigationItemSearch.main, selection: $selection) {
                        Label("Главная", systemImage: "info.circle")
                    }
                    .tag(NavigationItemSearch.main)
                    NavigationLink(destination: Text("Films"), tag: NavigationItemSearch.films, selection: $selection) {
                        Label("Фильмы", systemImage: "film")
                    }
                    .tag(NavigationItemSearch.films)
                    NavigationLink(destination: Text("TV shows"), tag: NavigationItemSearch.tv, selection: $selection) {
                        Label("Сериалы", systemImage: "play.tv")
                    }
                    .tag(NavigationItemSearch.tv)
                }.animation(nil)
                .listStyle(SidebarListStyle())
            }
        }
    }
}

struct SidebarSearch_Previews: PreviewProvider {
    static var previews: some View {
        SidebarSearch()
    }
}
