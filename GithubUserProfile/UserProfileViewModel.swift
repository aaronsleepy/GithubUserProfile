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
    
    init(networkService: NetworkService, selectedUser: UserProfile?) {
        self.networkService = networkService
        self.selectedUser = CurrentValueSubject(selectedUser)
    }
    
    var name: String {
        return selectedUser.value?.name ?? "n/a"
    }
    var login: String {
        return selectedUser.value?.login ?? "n/a"
    }
    var follower: String {
        guard let value = selectedUser.value?.followers else { return "" }
        return "followers: \(value)"
    }
    var following: String {
        guard let value = selectedUser.value?.following else { return "" }
        return "followings: \(value)"
    }
    var imageUrl: URL? {
        guard let value = selectedUser.value?.avatarUrl else { return nil }
        
        return URL(string: value)
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    // Data => Output
    var selectedUser: CurrentValueSubject<UserProfile?, Never>
    
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
                    self.selectedUser.send(nil)
                case .finished: break
                }
            } receiveValue: { user in
                self.selectedUser.send(user)
            }.store(in: &subscriptions)
    }
}
