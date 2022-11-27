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
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
//        guard let request = resource.urlRequest else {
//            return .fail(NetworkError.invalidRequest)
//        }
        
        let request = resource.urlRequest!
        
        return session.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                guard let httpReponse = result.response as? HTTPURLResponse, (200..<300).contains(httpReponse.statusCode) else {
                    let response = result.response as? HTTPURLResponse
                    let statusCode = response?.statusCode ?? -1
                    throw NetworkError.responseError(statusCode: statusCode)
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
