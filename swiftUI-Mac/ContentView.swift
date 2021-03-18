
import SwiftUI

struct ContentView: View {
    
    @Environment(\.openURL) var openURL

    var body: some View {
        VStack {
        HStack {
            Button(action: { openURL(URL(string: "swiftUI://firstEx")!) }, label: {
                Text("Первый пример")
            })
            Button(action: { openURL(URL(string: "swiftUI://secondEx")!) }, label: {
                Text("Второй пример")
            })
            Button(action: { openURL(URL(string: "swiftUI://sidebarEx")!) }, label: {
                Text("Пример с бок. панелю")
            })
        }
            HStack {
                Button(action: { openURL(URL(string: "swiftUI://searchEx")!) }, label: {
                    Text("Поле поиска")
                })
                Button(action: { openURL(URL(string: "swiftUI://searchSideEx")!) }, label: {
                    Text("Боковая панель + Поле поиска")
                })
                Button(action: { openURL(URL(string: "swiftUI://windowEx")!) }, label: {
                    Text("Window Magic")
                })
            }
        }
        .frame(minWidth: 500, idealWidth: 520, maxWidth: .infinity, minHeight: 500, idealHeight: 520, maxHeight: .infinity, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
