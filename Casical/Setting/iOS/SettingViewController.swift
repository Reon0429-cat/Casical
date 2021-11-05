//
//  SettingViewController.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/31.
//

import UIKit

private enum SettingType: Int, CaseIterable {
    case themeColor
    case language
    case shareApp
    case report
    case howToUse
    case privacypolicy
    case license
    case version
    case logout
    
    var title: String {
        switch self {
            case .themeColor: return "テーマカラー"
            case .language: return "言語"
            case .shareApp: return "共有"
            case .report: return "レポート"
            case .howToUse: return "使い方"
            case .privacypolicy: return "プライバシーポリシー"
            case .license: return "ライセンス"
            case .version: return "バージョン"
            case .logout: return "ログアウト"
        }
    }
}

final class SettingViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var onColorSelected: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.nib,
                           forCellReuseIdentifier: SettingTableViewCell.identifier)
        
    }
    
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let settingType = SettingType(rawValue: indexPath.row) ?? .themeColor
        if settingType == .themeColor {
            let colorPickerVC = UIColorPickerViewController()
            colorPickerVC.selectedColor = .darkColor
            colorPickerVC.delegate = self
            present(colorPickerVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        SettingType.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingTableViewCell.identifier
        ) as! SettingTableViewCell
        let title = SettingType.allCases[indexPath.row].title
        cell.configure(title: title)
        return cell
    }
    
}

extension SettingViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController,
                                   didSelect color: UIColor,
                                   continuously: Bool) {
        UserDefaults.standard.save(color: color.withAlphaComponent(0.6), themeColorType: .lightColor)
        UserDefaults.standard.save(color: color.withAlphaComponent(0.4), themeColorType: .moreLightColor)
        UserDefaults.standard.save(color: color.withAlphaComponent(0.2), themeColorType: .mostLightColor)
        UserDefaults.standard.save(color: color.withAlphaComponent(0.8), themeColorType: .darkColor)
        UserDefaults.standard.save(color: color.withAlphaComponent(1), themeColorType: .moreDarkColor)
        onColorSelected?()
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        dismiss(animated: true)
    }
    
}
