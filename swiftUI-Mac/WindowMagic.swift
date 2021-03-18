

import SwiftUI

struct WindowMagic: View {
    
    @State var window: NSWindow = NSWindow()
    
    var body: some View {
        VStack {
            Button(action: {window.toggleFullScreen(nil)}, label: {
                Text("Полный экран")
            })
            Button(action: {window.appearance = NSAppearance(named: .aqua)}, label: {
                Text("Белая тема")
            })
            Button(action: {window.appearance = NSAppearance(named: .darkAqua)}, label: {
                Text("Темная тема")
            })
        }
        .viewOnner { (view) in
            // Получаем окно, и делаем всякие штуки
            DispatchQueue.main.async {
                guard let window = view.window else { return }
                window.isMovableByWindowBackground = true
                window.titlebarAppearsTransparent = true
                window.titlebarSeparatorStyle = .none
                window.styleMask.insert(.fullSizeContentView)

                window.toolbar = nil
                // !!!: Присваим окно в переменную
                self.window = window
            }
        }
        // Стейт переменные остаются в оперативке даже после полного закрытия, так что если в приложение есть музыка или видео - они будут продолжатс
        .onAppear() {
            // Отслеживает акрытия окна и удаляем его
            NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: nil, queue: .main) { window1 in
                if window == window1.object as? NSWindow {
                    print("close")
                    self.window = NSWindow()
                }
            }
        }
    }
}

struct WindowMagic_Previews: PreviewProvider {
    static var previews: some View {
        WindowMagic()
    }
}

import SwiftUI



// Получает nsView с swiftUI View
extension View {
    func viewOnner(added: @escaping (NSUIView) -> Void) -> some View {
        AccesoredForView(onViewAdded: added) { self }
    }
}

struct AccesoredForView<Content>: NSUIViewRepresentable where Content: View {
    var onView: (NSUIView) -> Void
    var viewBuilder: () -> Content
    typealias NSUIViewType = ViewAccessorHosting<Content>
    
    init(onViewAdded: @escaping (NSUIView) -> Void, @ViewBuilder viewBuilder: @escaping () -> Content) {
        self.onView = onViewAdded
        self.viewBuilder = viewBuilder
    }
    func makeNSView(context: Context) -> ViewAccessorHosting<Content> {
        return ViewAccessorHosting(onView: onView, rootView: self.viewBuilder())
    }
    
    func updateNSView(_ nsView: ViewAccessorHosting<Content>, context: Context) {
        nsView.rootView = self.viewBuilder()
    }
}

class ViewAccessorHosting<Content>: NSUIHostingView<Content> where Content: View {
    var onView: ((NSUIView) -> Void)
    
    init(onView: @escaping (NSUIView) -> Void, rootView: Content) {
        self.onView = onView
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(rootView: Content) {
        fatalError("init(rootView:) has not been implemented")
    }
    
    override func didAddSubview(_ subview: NSUIView) {
        super.didAddSubview(subview)
        onView(subview)
    }
}

import AppKit

public typealias NSUIView = NSView
public typealias NSUIHostingView = NSHostingView
public typealias NSUIScrollView = NSScrollView
public typealias NSUILabel = NSTextField
public typealias NSUIFont = NSFont
public typealias NSUIColor = NSColor
public typealias NSUIWindow = NSWindow

public protocol NSUIViewRepresentable: NSViewRepresentable {
    typealias NSUIViewType = NSViewType
    func makeView(context: Self.Context) -> Self.NSUIViewType
    func updateView(_ view: Self.NSUIViewType, context: Self.Context)
}

public extension NSUIViewRepresentable {
    func makeView(context: Self.Context) -> Self.NSUIViewType {
        return makeNSView(context: context)
    }
    
    func updateView(_ view: Self.NSUIViewType, context: Self.Context) {
        updateNSView(view, context: context)
    }
}
