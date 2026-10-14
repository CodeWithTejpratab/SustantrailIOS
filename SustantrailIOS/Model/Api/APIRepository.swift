//
//  Apirespository.swift
//  SustantrailIOS
//
//  Created by Rahul Ramjeawon on 9/1/26.
//
//  Swift port of `APIRepository`. Kotlin's suspend fun + Response<T> + try/catch
//  returning Boolean/null becomes async func + do/catch returning Bool/nil,
//  which keeps the same "never throw to the caller" contract the Android
//  code relies on.
//

import Foundation
import os.log

enum Screen {
    case home
    case events
}

final class APIRepository {
    
    static let shared = APIRepository()
    
    private let apiService: APIService
    private let logger = Logger(subsystem: "com.sustenanceios", category: "APIRepository")
    
    // TODO: swap in your actual Firebase auth manager equivalent.
    // Kotlin read this from `AppModule.firebaseAuthManager.currentUserId`.
    private var userID: String {
        FirebaseAuthManager.shared.currentUserId
    }
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    func registerUser() async -> Bool {
        do {
            try await apiService.registerUser(userId: userID)
            return true
        } catch {
            logger.debug("\(error.localizedDescription, privacy: .public)")
            return false
        }
    }
    
    func deleteUser() async -> Bool {
        do {
            try await apiService.deleteUser(userId: userID)
            return true
        } catch {
            logger.debug("\(error.localizedDescription, privacy: .public)")
            return false
        }
    }
    
    func sendActionEvent(eventCategory: String) async -> Bool {
        do {
            try await apiService.postSustainScore(userId: userID, eventCategory: eventCategory)
            return true
        } catch {
            logger.debug("\(error.localizedDescription, privacy: .public)")
            return false
        }
    }
    
    func fetchExpositions(screen: Screen) async -> [Exposition]? {
        do {
            switch screen {
            case .home:
                return try await apiService.getHomeExpositions(userId: userID)
            case .events:
                return try await apiService.getEventExpositions()
            }
        } catch {
            logger.debug("\(error.localizedDescription, privacy: .public)")
            return nil
        }
    }
}

// MARK: - Placeholder auth manager (replace with your real implementation)

final class FirebaseAuthManager {
    static let shared = FirebaseAuthManager()
    var currentUserId: String = ""
}
