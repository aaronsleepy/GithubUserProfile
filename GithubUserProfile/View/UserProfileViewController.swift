//
//  ViewController.swift
//  GithubUserProfile
//
//  Created by Aaron on 2022/11/26.
//

import UIKit
import Combine

class UserProfileViewController: UIViewController {
    
    // TODO:
    // setupUI
    // data: userprofile
    // bind
    // search control
    // network
    var subscriptions = Set<AnyCancellable>()
    
    var viewModel: UserProfileViewModel!

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserProfileViewModel(networkService: NetworkService(configuration: .default), selectedUser: nil)
        
        setupUI()
        embedSearchControl()
        bind()
    }
    
    private func setupUI() {
        thumbnail.layer.cornerRadius = 80
    }
    
    private func embedSearchControl() {
        self.navigationItem.title = "Search"
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "aaronsleepy"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = searchController
    }
    
    private func bind() {
        viewModel.selectedUser
            .receive(on: RunLoop.main)
            .sink { result in
                self.update()
            }.store(in: &subscriptions)
    }
    
    private func update() {
        self.nameLabel.text = viewModel.name
        self.loginLabel.text = viewModel.login
        self.followerLabel.text = viewModel.follower
        self.followingLabel.text = viewModel.following
        
        if (viewModel.imageUrl == nil) {
            self.thumbnail.image = nil
        } else {
            self.thumbnail.load(url: viewModel.imageUrl!)
        }
    }
}

extension UserProfileViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let keyword = searchController.searchBar.text
        
        print("search: \(keyword)")
    }
}

extension UserProfileViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("button Clicked: \(searchBar.text)")
        
        guard let keyword = searchBar.text,
              !keyword.isEmpty else { return }
        
        viewModel.search(keyword: keyword)
    }
}

// Kingfisher 패키지 설치 못함
// 아래 코드 복붙
// Ref: https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
