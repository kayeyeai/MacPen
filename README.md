# MacPen

MacPen is a tiny macOS overlay app that lets you draw directly on your screen.

## How it works

- Hold **⌘ Cmd + ⌥ Option** and move your mouse → MacPen draws a **red line/path** that follows the cursor.
- Release **⌘ Cmd + ⌥ Option** → it stops drawing.
- Hold **⌘ Cmd + ⌃ Control** → clears the drawing.

## Build (no Xcode GUI)

### Prerequisites

- macOS with **Xcode Command Line Tools** installed

Install CLT:

```bash
xcode-select --install
```

### Compile + run

From the repo root:

```bash
swift build -c release
.build/release/MacPen
```

For a debug build:

```bash
swift build
.build/debug/MacPen
```

## Permissions (required)

MacPen listens for global mouse movement and modifier keys using a `CGEventTap`.
macOS will block this until you grant privacy permissions.

1) Open **System Settings → Privacy & Security**
2) Enable **Input Monitoring** for `MacPen`
3) If it still doesn’t receive events, also enable **Accessibility** for `MacPen`

After changing permissions, quit and relaunch MacPen.

## Notes / Troubleshooting

- If nothing draws, it’s almost always missing **Input Monitoring** permission.
- Some systems require **Accessibility** in addition to Input Monitoring.
- This is an overlay window: it’s transparent and ignores mouse clicks.
