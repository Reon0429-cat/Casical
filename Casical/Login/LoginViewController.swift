//
//  LoginViewController.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/29.
//

import UIKit

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var mailAddressTextField: CustomTextField!
    @IBOutlet private weak var passwordTextField: CustomTextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var twitterLoginButton: UIButton!
    @IBOutlet private weak var googleLoginButton: UIButton!
    @IBOutlet private weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        twitterLoginButton.layer.borderColor = UIColor.lightColor.cgColor
        twitterLoginButton.layer.borderWidth = 1
        googleLoginButton.layer.borderColor = UIColor.lightColor.cgColor
        googleLoginButton.layer.borderWidth = 1
        appleLoginButton.layer.borderColor = UIColor.lightColor.cgColor
        appleLoginButton.layer.borderWidth = 1
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mailAddressTextField.roundCorners()
        passwordTextField.roundCorners()
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        twitterLoginButton.layer.cornerRadius = twitterLoginButton.frame.height / 2
        googleLoginButton.layer.cornerRadius = googleLoginButton.frame.height / 2
        appleLoginButton.layer.cornerRadius = appleLoginButton.frame.height / 2
        
    }
    
    @IBAction private func loginButtonDidTapped(_ sender: Any) {
        
    }
    
}
