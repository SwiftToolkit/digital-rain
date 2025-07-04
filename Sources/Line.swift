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

    var shouldBeRemoved: Bool {
        Date().timeIntervalSince(appearedAt) >= duration
    }

    var shouldDimHalfEnd: Bool {
        ((duration / 4)..<(duration / 2)).contains(Date().timeIntervalSince(appearedAt))
    }

    var shouldDim: Bool {
        Date().timeIntervalSince(appearedAt) >= duration / 1.5
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
