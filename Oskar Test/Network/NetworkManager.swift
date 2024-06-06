//
//  NetworkManager.swift
//  Oskar Test
//
//  Created by Senthil on 07/06/2024.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    private let baseURL = URL(string: "https://reverent-mayer-pemu3n2ls0.projects.oryapis.com")!

    private init() {}

    public func initiateSignup() async throws -> Flow {
        let url = baseURL.appendingPathComponent("/self-service/registration/api")
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        let signupFlow = try JSONDecoder().decode(Flow.self, from: data)
        return signupFlow
    }

    public func initiateSignin() async throws -> Flow {
        let url = baseURL.appendingPathComponent("/self-service/login/api")
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let signinFlow = try JSONDecoder().decode(Flow.self, from: data)
        return signinFlow
    }
}

enum NetworkError: Error {
    case invalidResponse
}
