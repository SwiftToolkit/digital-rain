import Foundation

struct Size {
    let width: Int
    let height: Int
}

extension Size: CustomStringConvertible {
    static var zero: Size { Size(width: 0, height: 0) }

    var description: String { "\(width)x\(height)" }
}

struct Point: Hashable {
    let x: Int
    let y: Int
}
