//
//  Apiservice.swift
//  SustantrailIOS
//
//  Created by Rahul Ramjeawon on 9/1/26.
//
//  Swift port of `ApiService` (Retrofit interface). Uses async/await + URLSession,
//  the iOS-native analog to Kotlin coroutines/suspend functions.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(statusCode: Int)
}

final class APIService {
    
    // NOTE: Kotlin used "http://10.0.2.2:8000" — that's the Android emulator's
    // alias for the host machine's localhost. The iOS Simulator can reach the
    // host directly, so use "http://127.0.0.1:8000" (or your machine's LAN IP
    // if testing on a physical device).
    private static let baseURL = "http://127.0.0.1:8000"
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    // MARK: - Endpoints (mirrors ApiService)
    
    func getHomeExpositions(userId: String) async throws -> [Exposition] {
        try await get([Exposition].self, path: "/api/home/\(userId)")
    }
    
    func getEventExpositions() async throws -> [Exposition] {
        try await get([Exposition].self, path: "/api/events")
    }
    
    func deleteUser(userId: String) async throws {
        _ = try await send(path: "/api/user/\(userId)", method: "DELETE")
    }
    
    func postSustainScore(userId: String, eventCategory: String) async throws {
        _ = try await send(path: "/api/sustainscore/\(userId)/\(eventCategory)", method: "PUT")
    }
    
    func registerUser(userId: String) async throws {
        _ = try await send(path: "/api/auth/register/\(userId)", method: "POST")
    }
    
    // MARK: - Helpers
    
    private func get<T: Decodable>(_ type: T.Type, path: String) async throws -> T {
        let data = try await send(path: path, method: "GET")
        return try decoder.decode(T.self, from: data)
    }
    
    @discardableResult
    private func send(path: String, method: String) async throws -> Data {
        guard let url = URL(string: Self.baseURL + path) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let (data, response) = try await session.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            throw APIError.requestFailed(statusCode: http.statusCode)
        }
        return data
    }
}
