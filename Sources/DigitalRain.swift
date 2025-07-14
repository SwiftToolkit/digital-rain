import Foundation
import ColorizeSwift
import TerminalUtilities

@main
class DigitalRain {
    static let refreshInterval: TimeInterval = 0.08

    var timer: Timer?
    var lines: [Int: [Line]] = [:]
    var drawnLength = 0

    static func main() {
        DigitalRain().start()
    }

    let size = Terminal.size()

    private func start() {
        Terminal.showCursor(false)

        timer = Timer.scheduledTimer(withTimeInterval: Self.refreshInterval, repeats: true) { _ in
            self.updateLines()
            self.draw()
        }

        Terminal.onInterruptionExit {
            Terminal.eraseChars(self.drawnLength)
            Terminal.showCursor(true)
        }

        RunLoop.main.run()
    }

    private func updateLines() {
        for column in 0..<size.width {
            var thisColumnLines = lines[column] ?? []
            let shouldAddNewLine = if let minLine = thisColumnLines.minLine, minLine.minY < 0 {
                false
            } else {
                Int.random(in: 1...40) % 40 == 0
            }

            thisColumnLines.enumerated().forEach { index, line in
                var copy = line
                copy.maxY += 1
                thisColumnLines[index] = copy
            }

            thisColumnLines.removeAll(where: \.shouldBeRemoved)

            if shouldAddNewLine {
                let line = createLine(height: Int.random(in: 5..<min(10, size.height)))
                thisColumnLines.append(line)
            }

            lines[column] = thisColumnLines
        }
    }

    private func createLine(height: Int) -> Line {
        Line(
            letters: Character.randomArray(length: height),
            duration: TimeInterval.random(in: 1...(Double(size.height + height) * Self.refreshInterval)),
            appearedAt: Date(),
            maxY: 0
        )
    }

    private func draw() {
        Terminal.eraseChars(drawnLength)

        var result = ""
        for row in 0..<size.height {
            for column in 0..<size.width {
                let thisColumnLines = lines[column] ?? []

                if let line = thisColumnLines.line(at: row) {
                    let indexInArray = row - line.minY
                    let char = line.letters[indexInArray]
                    var asString = String(char)
                    let isFirst = indexInArray == line.letters.count - 1

                    let color: TerminalColor = if isFirst {
                        .white
                    } else {
                        .green
                    }

                    asString = asString.foregroundColor(color)

                    let isEndHalf = indexInArray < (line.letters.count / 2)

                    let shouldDim = isEndHalf && line.shouldDimHalfEnd || line.shouldDim

                    if shouldDim {
                        asString = asString.dim()
                    }

                    result.append(asString)
                } else {
                    result.append(" ")
                }
            }
        }

        print(result, terminator: "")
        drawnLength = result.count
    }
}

