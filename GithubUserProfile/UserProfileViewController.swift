//
//  ViewController.swift
//  GithubUserProfile
//
//  Created by Aaron on 2022/11/26.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    // TODO:
    // setupUI
    // data: userprofile
    // bind
    // search control
    // network

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        thumbnail.layer.cornerRadius = 80
    }
}

