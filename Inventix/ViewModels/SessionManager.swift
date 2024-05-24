//
//  SessionManager.swift
//  Inventix
//
//  Created by Tri Tat on 5/7/24.
//


import SwiftUI
import Combine

class SessionManager: ObservableObject {
    static let shared = SessionManager()

    @Published var currentUserSession: User?

    private init() {} // Private initialization to ensure singleton instance

    func updateUserSession(with session: User) {
        self.currentUserSession = session
    }
    
    func clearUserSession() {
        self.currentUserSession = nil
    }
    
    func getAuthToken() -> String? {
        return currentUserSession?.token
    }
}
