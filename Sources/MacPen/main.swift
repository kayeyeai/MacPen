import AppKit

let app = NSApplication.shared
app.setActivationPolicy(.regular)

// Load the app icon from bundled SVG resource
if let iconURL = Bundle.module.url(forResource: "AppIcon", withExtension: "svg"),
   let iconData = try? Data(contentsOf: iconURL),
   let icon = NSImage(data: iconData) {
    app.applicationIconImage = icon
}

let delegate = AppDelegate()
app.delegate = delegate
app.run()
