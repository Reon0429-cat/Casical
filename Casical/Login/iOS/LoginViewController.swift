//
//  LoginViewController.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/29.
//

import UIKit
import FirebaseAuth
import PKHUD
import Reachability

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var mailAddressTextField: CustomTextField!
    @IBOutlet private weak var passwordTextField: CustomTextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var twitterLoginButton: UIButton!
    @IBOutlet private weak var googleLoginButton: UIButton!
    @IBOutlet private weak var appleLoginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconImageView.image = UIImage(named: "icon")
        mailAddressTextField.tintColor = .black
        passwordTextField.tintColor = .black
        passwordTextField.isSecureTextEntry = true
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
        guard let email = mailAddressTextField.text,
              let password = passwordTextField.text else { return }
        let reachability = try! Reachability()
        if reachability.connection == .unavailable {
            print("DEBUG_PRINT: ", "通信環境が良くない")
            return
        }
        HUD.show(.progress)
        Auth.auth().signIn(withEmail: email,
                           password: password) { _, error in
            if let error = error {
                HUD.flash(.error)
                print("DEBUG_PRINT: 失敗", error.localizedDescription)
                return
            }
            HUD.flash(.success,
                      onView: nil,
                      delay: 0) { _ in
                self.dismiss(animated: true)
            }
        }
    }
    
}
