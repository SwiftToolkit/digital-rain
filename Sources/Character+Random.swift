import Foundation

extension Character {
    static func randomArray(length: Int) -> [Character] {
        (0..<length).map { _ in
            availableCharacters.randomElement()!
        }
    }
}

private let availableCharacters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
