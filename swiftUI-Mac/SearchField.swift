
import SwiftUI
import Introspect

// Убирает фокус
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}


struct SearchField: View {
    
    @State var searchState = false
    @State var searchText: String = ""
    @State private var textField: NSTextField = NSTextField()

    
    var body: some View {
        
        // MARK: Это поле поиска как Музыке, Апп сторе и других приложениях Эпл. Они не используют NSSearchField
        Text("Статус \(String(searchState))") + Text(" Текст \(searchText)")
        Button(action: {textField.window?.endEditing(for: textField); searchState = false}, label: {
            Text("Закончить")
        })
        ZStack(alignment: .trailing) {
            HStack {
                HStack {
                    // Изображение лупы
                    Image(systemName: "magnifyingglass")
                    // Само поле. Есть инспектор для получение его как NSTextField
                    TextField("Поиск...", text: $searchText)
                        .padding(.vertical, 8)
                        .frame(height: 25)
                        .background(Color("SearchField"))
                        .textFieldStyle(PlainTextFieldStyle())
                        .introspectTextField { textField in
                            self.textField = textField
                        }
                }
                .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 24))
                
                // Его фон и круговая строка
                .background(RoundedRectangle(cornerRadius: 8)
                                .stroke(searchState ? Color.accentColor : Color.black.opacity(0.1), lineWidth: searchState ? 3 : 0.5)
                                .background(Color("SearchField").cornerRadius(8)))
            }
            .zIndex(0)
            .padding(.horizontal, 12)
            
            // Невидимая кнопка, позволяет использовать шорткат
            Button(action: { self.textField.window?.makeFirstResponder(textField); searchState = true }) {
                Text("first responder")
            }
            .keyboardShortcut("f", modifiers: .command)
            .opacity(0.01)
            
            // КНопка для очистки + изображения шортката
            Button(action: {
                self.searchText = ""
            }) {
                HStack(spacing: 0) {
                    Image(systemName: "command")
                    Text("F")
                }
                .isHidden(searchState, remove: true)
                Image(systemName: "xmark.circle.fill")
                    .isHidden(searchText.isEmpty, remove: true)
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color("SearchField"))
            .padding(.trailing, 18)
            .zIndex(2)
            // Прозрачное вью для возможности клика на любое место
            // !!!: Обязательно, так как gestures не работает на textField
            Color.white
                .opacity(0.01)
                .isHidden(searchState)
                .frame(height: 25)
                .zIndex(1)
                .onTapGesture {
                    textField.window?.makeFirstResponder(textField)
                    searchState = true
                }
        }
        .frame(minWidth: 200, idealWidth: 300, maxWidth: .infinity, minHeight: 150, idealHeight: 300, maxHeight: .infinity, alignment: .center)
    }
}

struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField()
    }
}
