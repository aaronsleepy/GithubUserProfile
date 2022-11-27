//
//  NetworkService.swift
//  GithubUserProfile
//
//  Created by Aaron on 2022/11/27.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidRequest
    case transportError(Error)
    case responseError(statusCode: Int)
    case noData
    case decodingError(Error)
}

final class NetworkService {
    func fetchProfile(_ url: URLRequest) -> AnyPublisher<UserProfile, Error> {
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let httpReponse = result.response as? HTTPURLResponse, (200..<300).contains(httpReponse.statusCode) else {
                    let response = result.response as? HTTPURLResponse
                    let statusCode = response?.statusCode ?? -1
                    throw NetworkError.responseError(statusCode: statusCode)
                }
                return result.data
            }
            .decode(type: UserProfile.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        return publisher
    }
}
