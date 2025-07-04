import Darwin
import Foundation

enum Terminal {
    static func size() -> Size {
        var size = winsize()
        guard ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size) == 0,
              size.ws_col > 0, size.ws_row > 0 else {
            fatalError("Could not get window size")
        }

        return Size(width: Int(size.ws_col), height: Int(size.ws_row))
    }

    static func clearChars(_ length: Int) {
        guard length > 0 else { return }

        // Move cursor left by the number of characters we previously drew
        print("\u{001B}[\(length)D", terminator: "")
    }

    static func showCursor(_ show: Bool) {
        if show {
            print("\u{001B}[?25h", terminator: "")
        } else {
            print("\u{001B}[?25l", terminator: "")
        }
    }

    static func quit(clearing drawnLength: Int, message: String? = nil) {
        clearChars(drawnLength)

        if let message {
            print(message)
        }

        showCursor(true)
        exit(0)
    }
}
