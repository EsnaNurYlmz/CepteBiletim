//
//  SessionManager.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import Foundation

final class SessionManager {
    static let shared = SessionManager()

    private init() {} // dışarıdan init edilmesini engeller

    var userId: String?
    var userName: String?
    var email: String?

    var isLoggedIn: Bool {
        return userId != nil
    }

    func clearSession() {
        userId = nil
        userName = nil
        email = nil
    }
}
