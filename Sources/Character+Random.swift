import Foundation

extension Character {
    static func randomArray(length: Int) -> [Character] {
        var result = [Character]()

        while result.count < length {
            result.append(availableCharacters.randomElement()!)
        }

        return result
    }
}

private let availableCharacters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
