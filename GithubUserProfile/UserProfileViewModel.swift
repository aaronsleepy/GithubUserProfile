//
//  UserProfileViewModel.swift
//  GithubUserProfile
//
//  Created by Aaron on 2022/12/05.
//

import Foundation
import Combine

final class UserProfileViewModel {
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    // Data => Output
    @Published private(set) var user: UserProfile?
    
    // User Action => Input
    func search(keyword: String) {
        let resource = Resource<UserProfile>(
            base: "https://api.github.com/",
            path: "users/\(keyword)",
            params: [:],
            header: [:])
        
        networkService.load(resource)
            .receive(on: RunLoop.main)
            .print("[Debug]")
            .sink { completion in
                print("Completion: \(completion)")
                
                switch completion {
                case .failure(let error):
                    self.user = nil
                case .finished: break
                }
            } receiveValue: { user in
                self.user = user
            }.store(in: &subscriptions)
    }
}
