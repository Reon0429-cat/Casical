//
//  ProfileAdditionalViewController.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/30.
//

import UIKit

final class ProfileAdditionalViewController: UIViewController {
    
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var houseTextField: UITextField!
    @IBOutlet private weak var experienceTextField: UITextField!
    @IBOutlet private weak var employmentStatusTextField: UITextField!
    @IBOutlet private weak var gitHubTextField: UITextField!
    @IBOutlet private weak var qiitaTextField: UITextField!
    
    private var housePickerView = UIPickerView()
    private var experiencePickerView = UIPickerView()
    private var employmentStatusPickerView = UIPickerView()
    private let houses = Prefecture.name
    private let experiences = [[Int](0...100), [Int](0...12)]
    private let employmentStatus = ["新卒", "中途"]
    private var oldSelectedExperiencesYearIndex = 0
    private var oldSelectedExperiencesMonthIndex = 0
    private var gitHub: GitHub?
//    private var totalContributions = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // MARK: - ToDo 消す
        nameTextField.text = "REON"
        houseTextField.text = "東京都"
        experienceTextField.text = "1年"
        employmentStatusTextField.text = "新卒"
        gitHubTextField.text = "Reon0429-cat"
        qiitaTextField.text = "REON"
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        
    }
    
    @IBAction private func registerButtonDidTapped(_ sender: Any) {
        guard let name = nameTextField.text,
              let workLocation = houseTextField.text,
              let employmentStatus = employmentStatusTextField.text,
              let gitHubName = gitHubTextField.text,
              let qiitaName = qiitaTextField.text else { return }
        let experienceYear = experiences[0][oldSelectedExperiencesYearIndex]
        let experienceMonth = experiences[1][oldSelectedExperiencesMonthIndex]
        let experience = experienceYear * 12 + experienceMonth
        
        searchUser(userName: gitHubName)
        
        // MARK: - ToDo 保存処理
        //        dismiss(animated: true)
    }
    
    private func searchUser(userName: String) {
        GitHubAPIClient().searchUser(userName: userName) { result in
            switch result {
                case .failure(let title):
                    print("DEBUG_PRINT: ", title, #function)
                case .success(let gitHubUser):
                    self.searchRepos(userName: userName,
                                     gitHubUser: gitHubUser)
            }
        }
    }
    
    private func searchRepos(userName: String,
                             gitHubUser: GitHubUser) {
        GitHubAPIClient().searchRepos(userName: userName) { result in
            switch result {
                case .failure(let title):
                    print("DEBUG_PRINT: ", title, #function)
                case .success(let repos):
                    
                    let repoLanguages = repos.map { $0.language }
                    let excludeSameRepoLanguages = NSOrderedSet(array: repoLanguages).array as! [String]
                    var counts = [Int]()
                    excludeSameRepoLanguages.forEach { excludeSameRepoLanguage in
                        var count = 0
                        repoLanguages.forEach { repoLanguage in
                            if excludeSameRepoLanguage == repoLanguage {
                                count += 1
                            }
                        }
                        counts.append(count)
                    }
                    let percentCounts = counts.map { Double($0) / Double(repoLanguages.count) * 100 }.map { Int($0) }
                    var languageTaples = [(language: String, percentNumber: Int)]()
                    excludeSameRepoLanguages.enumerated().forEach { index, language in
                        languageTaples.append((language: language, percentNumber: percentCounts[index]))
                    }
                    let sortedLanguageTaples = languageTaples.sorted(by: { $0.percentNumber > $1.percentNumber })
                    
                    var mostUsedLanguage: (name: String, value: Int)?
                    var secondMostUsedLanguage: (name: String, value: Int)?
                    var thirdMostUsedLanguage: (name: String, value: Int)?
                    
                    switch sortedLanguageTaples.count {
                        case 0:
                            mostUsedLanguage = nil
                            secondMostUsedLanguage = nil
                            thirdMostUsedLanguage = nil
                        case 1:
                            mostUsedLanguage = (name: sortedLanguageTaples[0].language, value: sortedLanguageTaples[0].percentNumber)
                            secondMostUsedLanguage = nil
                            thirdMostUsedLanguage = nil
                        case 2:
                            mostUsedLanguage = (name: sortedLanguageTaples[0].language, value: sortedLanguageTaples[0].percentNumber)
                            secondMostUsedLanguage = (name: sortedLanguageTaples[1].language, value: sortedLanguageTaples[1].percentNumber)
                            thirdMostUsedLanguage = nil
                        default:
                            mostUsedLanguage = (name: sortedLanguageTaples[0].language, value: sortedLanguageTaples[0].percentNumber)
                            secondMostUsedLanguage = (name: sortedLanguageTaples[1].language, value: sortedLanguageTaples[1].percentNumber)
                            thirdMostUsedLanguage = (name: sortedLanguageTaples[2].language, value: sortedLanguageTaples[2].percentNumber)
                    }
                    
//                    repos.forEach { repo in
//                        self.searchContributors(userName: userName,
//                                                contributorsUrlString: repo.contributorsUrl,
//                                                gitHubUser: gitHubUser,
//                                                repos: repos)
//                    }
                    
                    
                    let avatarUrl = URL(string: gitHubUser.avatarUrl)!
                    let image = try! Data(contentsOf: avatarUrl)
                    let gitHub = GitHub(name: userName,
                                        mostUsedLanguage: mostUsedLanguage,
                                        secondMostUsedLanguage: secondMostUsedLanguage,
                                        thirdMostUsedLanguage: thirdMostUsedLanguage,
                                        followers: gitHubUser.followers,
                                        description: gitHubUser.bio,
                                        image: image)
                    
                    print("DEBUG_PRINT: ", gitHub)
                    
                    
            }
        }
    }
    
//    private func searchContributors(userName: String,
//                                    contributorsUrlString: String,
//                                    gitHubUser: GitHubUser,
//                                    repos: [GitHubRepoItem]) {
//        GitHubAPIClient().searchContributors(
//            contributorsUrlString: contributorsUrlString
//        ) { result in
//            switch result {
//                case .failure(let title):
//                    print("DEBUG_PRINT: ", title, #function)
//                case .success(let contributors):
//                    self.totalContributions += contributors.map { $0.contributions }.reduce(0, +)
//            }
//        }
//    }
    
    @IBAction func dismissButtonDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func changeRegisterButtonState() {
        let isEnabled = [
            nameTextField,
            houseTextField,
            experienceTextField,
            employmentStatusTextField,
            gitHubTextField,
            qiitaTextField
        ].allSatisfy { !$0!.text!.isEmpty }
        registerButton.isEnabled = isEnabled
        registerButton.layer.opacity = isEnabled ? 1 : 0.6
    }
    
}

extension ProfileAdditionalViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        changeRegisterButtonState()
    }
    
}

extension ProfileAdditionalViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        switch pickerView {
            case housePickerView:
                houseTextField.text = houses[row]
            case experiencePickerView:
                if component == 0 {
                    oldSelectedExperiencesYearIndex = row
                } else {
                    oldSelectedExperiencesMonthIndex = row
                }
                let yearText = "\(experiences[0][oldSelectedExperiencesYearIndex])年"
                let monthText = "\(experiences[1][oldSelectedExperiencesMonthIndex])ヶ月"
                experienceTextField.text = yearText + monthText
            case employmentStatusPickerView:
                employmentStatusTextField.text = employmentStatus[row]
            default:
                break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        switch pickerView {
            case housePickerView:
                return houses[row]
            case experiencePickerView:
                return String(experiences[component][row])
            case employmentStatusPickerView:
                return employmentStatus[row]
            default:
                return ""
        }
    }
    
}

extension ProfileAdditionalViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
            case housePickerView: return 1
            case experiencePickerView: return 2
            case employmentStatusPickerView: return 1
            default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
            case housePickerView:
                return houses.count
            case experiencePickerView:
                return experiences[component].count
            case employmentStatusPickerView:
                return employmentStatus.count
            default:
                return 0
        }
    }
    
}

// MARK: - setup
private extension ProfileAdditionalViewController {
    
    func setupUI() {
        changeRegisterButtonState()
        housePickerView.dataSource = self
        housePickerView.delegate = self
        experiencePickerView.dataSource = self
        experiencePickerView.delegate = self
        employmentStatusPickerView.dataSource = self
        employmentStatusPickerView.delegate = self
        
        nameTextField.setUnderLine()
        nameTextField.delegate = self
        nameTextField.tintColor = .black
        
        houseTextField.setUnderLine()
        houseTextField.delegate = self
        houseTextField.tintColor = .black
        houseTextField.setImageToRightView()
        houseTextField.getButton().addTarget(
            self,
            action: #selector(houseTextFieldButtonDidTapped),
            for: .touchUpInside
        )
        houseTextField.inputView = housePickerView
        
        experienceTextField.setUnderLine()
        experienceTextField.delegate = self
        experienceTextField.tintColor = .black
        experienceTextField.setImageToRightView()
        experienceTextField.getButton().addTarget(
            self,
            action: #selector(experienceTextFieldButtonDidTapped),
            for: .touchUpInside
        )
        experienceTextField.inputView = experiencePickerView
        
        employmentStatusTextField.setUnderLine()
        employmentStatusTextField.delegate = self
        employmentStatusTextField.tintColor = .black
        employmentStatusTextField.setImageToRightView()
        employmentStatusTextField.getButton().addTarget(
            self,
            action: #selector(employmentStatusTextFieldButtonDidTapped),
            for: .touchUpInside
        )
        employmentStatusTextField.inputView = employmentStatusPickerView
        
        gitHubTextField.setUnderLine()
        gitHubTextField.delegate = self
        gitHubTextField.tintColor = .black
        
        qiitaTextField.setUnderLine()
        qiitaTextField.delegate = self
        qiitaTextField.tintColor = .black
    }
    
    @objc
    func houseTextFieldButtonDidTapped() {
        houseTextField.becomeFirstResponder()
    }
    
    @objc
    func experienceTextFieldButtonDidTapped() {
        experienceTextField.becomeFirstResponder()
    }
    
    @objc
    func employmentStatusTextFieldButtonDidTapped() {
        employmentStatusTextField.becomeFirstResponder()
    }
    
}

private extension UITextField {
    
    func setImageToRightView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let button = UIButton(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.tintColor = .darkColor
        view.addSubview(button)
        self.rightViewMode = .always
        self.rightView = view
    }
    
    func getButton() -> UIButton {
        self.rightView?.subviews.first(where: { $0 is UIButton }) as! UIButton
    }
    
}
