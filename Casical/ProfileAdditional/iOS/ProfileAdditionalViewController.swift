//
//  ProfileAdditionalViewController.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/30.
//

import UIKit

private struct Prefecture {
    
    static let name = ["北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県", "茨城県",
                       "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県", "新潟県",
                       "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県", "静岡県", "愛知県",
                       "三重県", "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県", "鳥取県",
                       "島根県", "岡山県", "広島県", "山口県", "徳島県", "香川県", "愛媛県", "高知県",
                       "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"]
    
}

struct User {
    let name: String
    let workLocation: String
    let experience: Int
    let employmentStatus: String
    let registrationDate: Date
    let gitHub: GitHub
    let qiita: Qiita
    let skillScore: Int
}

struct GitHub {
    let name: String
    let mostUsedLanguage: String?
    let secondMostUsedLanguage: String?
    let thirdMostUsedLanguage: String?
    let followers: Int
    let contributions: Int
    let description: String
}

struct Qiita {
    let name: String
    let followers: Int
    let contributions: Int
    let tags: [(name: String, value: Int)]
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        
    }
    
    @IBAction private func registerButtonDidTapped(_ sender: Any) {
        // MARK: - ToDo 保存処理
        dismiss(animated: true)
    }
    
    @IBAction func dismissButtonDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func changeRegisterButtonState() {
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
