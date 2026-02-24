import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {

    var overlayWindow: OverlayWindow!
    var drawingView: DrawingView!
    var isDrawing = false

    var globalMouseMonitor: Any?
    var localMouseMonitor: Any?
    var globalFlagsMonitor: Any?
    var localFlagsMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        checkAccessibility()
        setupOverlayWindow()
        setupEventMonitors()
    }

    func applicationWillTerminate(_ notification: Notification) {
        removeEventMonitors()
    }

    // MARK: - Accessibility

    private func checkAccessibility() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
            as CFDictionary
        let trusted = AXIsProcessTrustedWithOptions(options)
        if !trusted {
            print("MacPen requires Accessibility permissions.")
            print("Please grant access in System Settings > Privacy & Security > Accessibility.")
        }
    }

    // MARK: - Window Setup

    private func setupOverlayWindow() {
        guard let screen = NSScreen.main else { return }

        overlayWindow = OverlayWindow(
            contentRect: screen.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )

        drawingView = DrawingView(frame: screen.frame)
        overlayWindow.contentView = drawingView
        overlayWindow.orderFrontRegardless()
    }

    // MARK: - Event Monitors

    private func setupEventMonitors() {
        globalFlagsMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: .flagsChanged
        ) { [weak self] event in
            self?.handleFlagsChanged(event)
        }

        localFlagsMonitor = NSEvent.addLocalMonitorForEvents(
            matching: .flagsChanged
        ) { [weak self] event in
            self?.handleFlagsChanged(event)
            return event
        }

        globalMouseMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: .mouseMoved
        ) { [weak self] event in
            self?.handleMouseMoved(event)
        }

        localMouseMonitor = NSEvent.addLocalMonitorForEvents(
            matching: .mouseMoved
        ) { [weak self] event in
            self?.handleMouseMoved(event)
            return event
        }
    }

    private func removeEventMonitors() {
        if let m = globalMouseMonitor { NSEvent.removeMonitor(m) }
        if let m = localMouseMonitor { NSEvent.removeMonitor(m) }
        if let m = globalFlagsMonitor { NSEvent.removeMonitor(m) }
        if let m = localFlagsMonitor { NSEvent.removeMonitor(m) }
    }

    // MARK: - Event Handling

    private func handleFlagsChanged(_ event: NSEvent) {
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)

        // CMD+CTRL → clear all drawings
        if flags.contains([.command, .control]) {
            if isDrawing {
                isDrawing = false
                drawingView.finishCurrentPath()
            }
            drawingView.clearAllPaths()
            return
        }

        // CMD+OPTION → toggle drawing
        let cmdOptPressed = flags.contains([.command, .option])

        if cmdOptPressed && !isDrawing {
            isDrawing = true
            let mouseLocation = NSEvent.mouseLocation
            let viewPoint = convertScreenToView(mouseLocation)
            drawingView.beginNewPath(at: viewPoint)
        } else if !cmdOptPressed && isDrawing {
            isDrawing = false
            drawingView.finishCurrentPath()
        }
    }

    private func handleMouseMoved(_ event: NSEvent) {
        guard isDrawing else { return }
        let mouseLocation = NSEvent.mouseLocation
        let viewPoint = convertScreenToView(mouseLocation)
        drawingView.addPoint(viewPoint)
    }

    // MARK: - Coordinate Conversion

    private func convertScreenToView(_ screenPoint: NSPoint) -> NSPoint {
        guard let screen = NSScreen.main else { return screenPoint }
        return NSPoint(
            x: screenPoint.x - screen.frame.origin.x,
            y: screenPoint.y - screen.frame.origin.y
        )
    }
}
