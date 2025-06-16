//
//  SessionManager.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import Foundation

final class SessionManager {
    static let shared = SessionManager()

    private init() {
        loadReviewsFromUserDefaults()
    }

    var userId: String?
    var userName: String?
    var email: String?

    var isLoggedIn: Bool {
        return userId != nil
    }

    /// Yorumlar (kalıcı)
    var reviews: [String: (comment: String, rating: Int)] = [:] {
        didSet {
            saveReviewsToUserDefaults()
        }
    }

    /// Oturumu temizle
    func clearSession() {
        userId = nil
        userName = nil
        email = nil
       // reviews.removeAll()
       // UserDefaults.standard.removeObject(forKey: "userReviews")
    }

    /// Yorumları kaydet
    private func saveReviewsToUserDefaults() {
        let mapped = reviews.mapValues { ["comment": $0.comment, "rating": $0.rating] }
        UserDefaults.standard.set(mapped, forKey: "userReviews")
    }

    /// Yorumları yükle
    func loadReviewsFromUserDefaults() {
        guard let saved = UserDefaults.standard.dictionary(forKey: "userReviews") as? [String: [String: Any]] else { return }

        var loaded: [String: (String, Int)] = [:]

        for (eventID, data) in saved {
            if let comment = data["comment"] as? String,
               let rating = data["rating"] as? Int {
                loaded[eventID] = (comment, rating)
            }
        }

        self.reviews = loaded
    }
}




/*
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

    var reviews: [String: (comment: String, rating: Int)] = [:] {
        didSet {
            saveReviewsToUserDefaults()
        }
    }

    func clearSession() {
        userId = nil
        userName = nil
        email = nil
        reviews.removeAll()
    }
}*/
