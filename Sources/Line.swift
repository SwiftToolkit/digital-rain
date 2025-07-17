import Foundation

struct Line {
    let letters: [Character]
    let duration: TimeInterval
    let appearedAt: Date
    var maxY: Int
}

extension Line {
    var minY: Int {
        maxY - letters.count
    }

    var timeSinceAppearance: TimeInterval {
        Date().timeIntervalSince(appearedAt)
    }

    var shouldBeRemoved: Bool {
        timeSinceAppearance >= duration
    }

    var shouldDimHalfEnd: Bool {
        timeSinceAppearance >= duration * 0.25
    }

    var shouldDim: Bool {
        timeSinceAppearance >= duration * 0.65
    }
}

extension [Line] {
    var minLine: Line? {
        self.min(by: { $0.minY < $1.minY })
    }

    func line(at row: Int) -> Line? {
        first { $0.maxY > row && $0.minY <= row }
    }
}
