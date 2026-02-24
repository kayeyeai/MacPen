import AppKit

class OverlayWindow: NSWindow {

    override init(
        contentRect: NSRect,
        styleMask style: NSWindow.StyleMask,
        backing backingStoreType: NSWindow.BackingStoreType,
        defer flag: Bool
    ) {
        super.init(
            contentRect: contentRect,
            styleMask: .borderless,
            backing: backingStoreType,
            defer: flag
        )

        backgroundColor = .clear
        isOpaque = false
        level = .screenSaver
        hasShadow = false
        ignoresMouseEvents = true
        collectionBehavior = [
            .canJoinAllSpaces,
            .fullScreenAuxiliary,
            .stationary,
            .ignoresCycle
        ]
    }
}
