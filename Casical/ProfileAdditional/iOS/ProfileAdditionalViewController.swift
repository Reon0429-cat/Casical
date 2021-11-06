//
//  ProfileAdditionalViewController.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/30.
//

import UIKit
import PKHUD
import Firebase
import FirebaseFirestore
import Alamofire
import Kanna

final class ProfileAdditionalViewController: UIViewController {
    
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var houseTextField: UITextField!
    @IBOutlet private weak var experienceTextField: UITextField!
    @IBOutlet private weak var employmentStatusTextField: UITextField!
    @IBOutlet private weak var gitHubTextField: UITextField!
    @IBOutlet private weak var qiitaTextField: UITextField!
    @IBOutlet private weak var backButton: UIButton!
    
    private var housePickerView = UIPickerView()
    private var experiencePickerView = UIPickerView()
    private var employmentStatusPickerView = UIPickerView()
    private let houses = Prefecture.name
    private let experiences = [[Int](0...100), [Int](0...12)]
    private let employmentStatusArray = ["新卒", "中途"]
    private var oldSelectedExperiencesYearIndex = 0
    private var oldSelectedExperiencesMonthIndex = 0
    private var name: String { nameTextField.text ?? "" }
    private var workLocation: String { houseTextField.text ?? "" }
    private var employmentStatus: String { employmentStatusTextField.text ?? "" }
    private var qiitaName: String { qiitaTextField.text ?? "" }
    private var gitHubName: String { gitHubTextField.text ?? "" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        
    }
    
    @IBAction private func registerButtonDidTapped(_ sender: Any) {
        HUD.show(.progress)
        DispatchQueue.global().async {
            if let gitHubUser = self.searchGitHubUser(),
               let gitHubRepos = self.searchGitHubRepos(gitHubUser: gitHubUser),
               let qiitaUser = self.searchQiitaUser(),
               let user = self.scrapingQiita(gitHubUser: gitHubUser,
                                             qiitaUser: qiitaUser,
                                             repos: gitHubRepos) {
                self.saveUser(user: user)
            } else {
                print("DEBUG_PRINT: 失敗", #function)
            }
            DispatchQueue.main.async {
                HUD.flash(.success,
                          onView: nil,
                          delay: 0) { _ in
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    private func searchGitHubUser() -> GitHubUser? {
        let semaphore = DispatchSemaphore(value: 0)
        var _gitHubUser: GitHubUser?
        GitHubAPIClient().searchUser(userName: gitHubName) { result in
            switch result {
                case .failure(let title):
                    DispatchQueue.main.async {
                        HUD.flash(.error, onView: self.view)
                    }
                    print("DEBUG_PRINT: ", title, #function)
                    semaphore.signal()
                case .success(let gitHubUser):
                    _gitHubUser = gitHubUser
                    semaphore.signal()
            }
        }
        semaphore.wait()
        return _gitHubUser
    }
    
    private func searchGitHubRepos(gitHubUser: GitHubUser) -> [GitHubRepoItem]? {
        let semaphore = DispatchSemaphore(value: 0)
        var items: [GitHubRepoItem]?
        GitHubAPIClient().searchRepos(userName: gitHubName) { result in
            switch result {
                case .failure(let title):
                    DispatchQueue.main.async {
                        HUD.flash(.error, onView: self.view)
                    }
                    print("DEBUG_PRINT: ", title, #function)
                    semaphore.signal()
                case .success(let repos):
                    items = repos
                    semaphore.signal()
            }
        }
        semaphore.wait()
        return items
    }
    
    private func searchQiitaUser() -> QiitaUser? {
        let semaphore = DispatchSemaphore(value: 0)
        var _qiitaUser: QiitaUser?
        QiitaAPIClient().searchUser(userName: qiitaName) { result in
            switch result {
                case .failure(let title):
                    DispatchQueue.main.async {
                        HUD.flash(.error, onView: self.view)
                    }
                    print("DEBUG_PRINT: ", title, #function)
                    semaphore.signal()
                case .success(let qiitaUser):
                    _qiitaUser = qiitaUser
                    semaphore.signal()
            }
        }
        semaphore.wait()
        return _qiitaUser
    }
    
    private func scrapingQiita(gitHubUser: GitHubUser, qiitaUser: QiitaUser, repos: [GitHubRepoItem]) -> User? {
        let semaphore = DispatchSemaphore(value: 0)
        var _user: User?
        let avatarUrl = URL(string: gitHubUser.avatarUrl)!
        let image = try! Data(contentsOf: avatarUrl)
        let mostUsedLanguage = self.calculateUsedLanguage(repos: repos)[0]
        let secondMostUsedLanguage = self.calculateUsedLanguage(repos: repos)[1]
        let thirdMostUsedLanguage = self.calculateUsedLanguage(repos: repos)[2]
        let gitHub = GitHub(name: gitHubName,
                            mostUsedLanguage: mostUsedLanguage,
                            secondMostUsedLanguage: secondMostUsedLanguage,
                            thirdMostUsedLanguage: thirdMostUsedLanguage,
                            followers: gitHubUser.followers,
                            description: gitHubUser.bio ?? "",
                            image: image)
        AF.request("https://qiita.com/\(qiitaName)").responseString { response in
            switch response.result {
                case .success(let value):
                    if let doc = try? HTML(html: value, encoding: .utf8) {
                        let contributions = Int(doc.xpath("//span[@class='css-mf9wc5']")
                                                    .compactMap { $0.text }
                                                    .first ?? "0") ?? 0
                        let postedArticleNames = doc.xpath("//span[@class='css-1s0lzlm e1ojqm5t4']")
                            .compactMap { $0.text }
                            .map { $0.dropLast() }
                            .enumerated()
                            .filter { $0.offset < 5 }
                            .map { String($0.element) }
                        let postedArticleValues = doc.xpath("//span[@class='css-9yocrl e1ojqm5t5']")
                            .compactMap { $0.text }
                            .map { $0.dropLast() }
                            .enumerated()
                            .filter { $0.offset < 5 }
                            .compactMap { Int($0.element) }
                        let experienceYear = self.experiences[0][self.oldSelectedExperiencesYearIndex]
                        let experienceMonth = self.experiences[1][self.oldSelectedExperiencesMonthIndex]
                        let experience = experienceYear * 12 + experienceMonth
                        DispatchQueue.main.async {
                            let qiita = Qiita(name: self.qiitaName,
                                              followers: qiitaUser.followersCount,
                                              itemsCount: qiitaUser.itemsCount,
                                              contributions: contributions,
                                              postedArticleNames: postedArticleNames,
                                              postedArticleValues: postedArticleValues)
                            let user = User(name: self.name,
                                            workLocation: self.workLocation,
                                            experience: experience,
                                            employmentStatus: self.employmentStatus,
                                            registrationDate: Date(),
                                            gitHub: gitHub,
                                            qiita: qiita,
                                            skillScore: [1, 2, 3, 4, 5, 6, 7, 8, 9].randomElement()!,
                                            isChecked: false)
                            _user = user
                            semaphore.signal()
                        }
                    }
                case .failure:
                    print("DEBUG_PRINT: Qiitaスクレイビング失敗")
                    semaphore.signal()
            }
        }
        semaphore.wait()
        return _user
    }
    
    private func saveUser(user: User) {
        print("DEBUG_PRINT: userを保存", user)
        Firestore.firestore().collection("users")
            .addDocument(data: user.toDic()) { error in
                if let error = error {
                    print("DEBUG_PRINT: ", error.localizedDescription)
                    return
                }
            }
    }
    
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
    
    private func calculateUsedLanguage(repos: [GitHubRepoItem]) -> [(name: String, value: Int)?] {
        let repoLanguages = repos.map { $0.language }.compactMap { $0 }
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
        return [mostUsedLanguage, secondMostUsedLanguage, thirdMostUsedLanguage]
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
                employmentStatusTextField.text = employmentStatusArray[row]
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
                return employmentStatusArray[row]
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
                return employmentStatusArray.count
            default:
                return 0
        }
    }
    
}

// MARK: - setup
private extension ProfileAdditionalViewController {
    
    func setupUI() {
        registerButton.backgroundColor = .darkColor
        backButton.tintColor = .darkColor
        
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
