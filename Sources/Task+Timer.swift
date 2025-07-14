//
//  Task+Timer.swift
//  digital-rain
//
//  Created by Natan Rolnik on 14/07/2025.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func repeatingTimer(
        interval: TimeInterval,
        operation: @escaping @MainActor () -> Void
    ) -> Task<Void, Never> {
        .init {
            do {
                repeat {
                    try await Task.sleep(for: .seconds(interval))
                    await operation()
                    try Task.checkCancellation()
                } while true
            } catch {}
        }
    }
}
