//
//  MacPersonalPageViewController.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/30.
//

import UIKit

final class MacPersonalPageViewController: UIViewController {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var houseLabel: UILabel!
    @IBOutlet private weak var experienceLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var githubAccountLabel: UILabel!
    @IBOutlet private weak var qiitaAccountLabel: UILabel!
    @IBOutlet private weak var bioLabel: UILabel!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet private weak var settingButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var personalDataBaseView: UIView!
    @IBOutlet private weak var personalDataGraphBaseView: UIView!
    @IBOutlet private weak var githubDataBaseView: UIView!
    @IBOutlet private weak var qiitaDataBaseView: UIView!
    @IBOutlet private weak var sendMessageBaseView: UIView!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    @IBAction private func backButtonDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction private func settingButtonDidTapped(_ sender: Any) {
        // 実装しない
    }
    
}

// MARK: - setup
private extension MacPersonalPageViewController {
    
    func setupUI() {
        self.view.backgroundColor = .white
        headerTitleLabel.textColor = .darkColor
        headerTitleLabel.font = .systemFont(ofSize: 60, weight: .bold)
        settingButton.tintColor = .gray
        backButton.tintColor = .gray
        setupPersonalData()
        setupGitHubData()
        setupQiitaData()
        setupSendMessage()
    }
    
    func setupPersonalData() {
        nameLabel.text = user.name
        houseLabel.text = "● " + user.workLocation
        experienceLabel.text = "● " + user.convertExperienceToString()
        profileImageView.image = UIImage(data: user.gitHub.image)
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        bioLabel.text = user.gitHub.description
        personalDataBaseView.layer.cornerRadius = 50
        personalDataGraphBaseView.layer.cornerRadius = 50
    }
    
    func setupGitHubData() {
        githubAccountLabel.text = user.gitHub.name
        githubDataBaseView.layer.cornerRadius = 50
    }
    
    func setupQiitaData() {
        qiitaAccountLabel.text = user.qiita.name
        qiitaDataBaseView.layer.cornerRadius = 50
    }
    
    func setupSendMessage() {
        sendMessageBaseView.layer.cornerRadius = 50
    }
    
}
