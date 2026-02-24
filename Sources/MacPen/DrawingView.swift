import AppKit

class DrawingView: NSView {

    private var completedPaths: [NSBezierPath] = []
    private var currentPath: NSBezierPath?

    private let strokeColor: NSColor = .red
    private let strokeWidth: CGFloat = 3.0

    override func draw(_ dirtyRect: NSRect) {
        NSColor.clear.set()
        dirtyRect.fill()

        strokeColor.setStroke()

        for path in completedPaths {
            path.lineWidth = strokeWidth
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            path.stroke()
        }

        if let current = currentPath {
            current.lineWidth = strokeWidth
            current.lineCapStyle = .round
            current.lineJoinStyle = .round
            current.stroke()
        }
    }

    func beginNewPath(at point: NSPoint) {
        let path = NSBezierPath()
        path.move(to: point)
        currentPath = path
        needsDisplay = true
    }

    func addPoint(_ point: NSPoint) {
        guard let path = currentPath else { return }
        path.line(to: point)
        needsDisplay = true
    }

    func finishCurrentPath() {
        if let path = currentPath {
            completedPaths.append(path)
            currentPath = nil
        }
    }

    func clearAllPaths() {
        completedPaths.removeAll()
        currentPath = nil
        needsDisplay = true
    }
}
