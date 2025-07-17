import Foundation
import ColorizeSwift
import TerminalUtilities

@main
@MainActor
class DigitalRain {
    let size = Terminal.size()

    var lines: [Int: [Line]] = [:]
    var drawnLength = 0

    static func main() async {
        await DigitalRain().start()
    }

    private func start() async {
        Terminal.showCursor(false)

        let timerTask = Task.repeatingTimer(interval: 0.08) {
            self.updateLines()
            self.render()
        }

        Terminal.onInterruptionExit {
            timerTask.cancel()
            Terminal.eraseChars(self.drawnLength)
            Terminal.showCursor(true)
        }

        await timerTask.value
    }

    private func updateLines() {
        for column in 0..<size.width {
            var thisColumnLines = lines[column, default: []]
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
                let line = createLine(height: Int.random(in: 5..<10))
                thisColumnLines.append(line)
            }

            lines[column] = thisColumnLines
        }
    }

    private func createLine(height: Int) -> Line {
        Line(
            letters: Character.randomArray(length: height),
            duration: TimeInterval.random(in: 1...5),
            appearedAt: Date(),
            maxY: 0
        )
    }

    private func render() {
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

