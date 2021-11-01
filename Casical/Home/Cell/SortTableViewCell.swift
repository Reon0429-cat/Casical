//
//  SortTableViewCell.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/30.
//

import UIKit

final class SortTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var chevronButton: UIButton!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    var onTapEvent: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = .black
        
    }
    
    func configure(title: String,
                   users: [User],
                   onTapEvent: ((Int) -> Void)?) {
        self.onTapEvent = onTapEvent
        titleLabel.text = title
        chevronButton.showsMenuAsPrimaryAction = true
        chevronButton.menu = createUIMenu(users: users)
    }
    
    @IBAction private func chevronButtonDidTapped(_ sender: Any) {
    }
    
    private func createUIMenu(users: [User]) -> UIMenu {
        let filterType = FilterType(rawValue: self.tag) ?? .language
        switch filterType {
            case .language:
                let languageNames = users.map { $0.gitHub.mostUsedLanguage?.name }.compactMap { $0 }
                let filteredLanguageNames = NSOrderedSet(array: languageNames).array as! [String]
                let actions =  filteredLanguageNames.map { UIAction(title: $0) { _ in self.onTapEvent?(self.tag) } }
                return UIMenu(title: "使用言語",
                              options: .displayInline,
                              children: actions)
            case .prefecture:
                break
            case .experience:
                break
            case .github:
                break
            case .qiita:
                break
        }
        return UIMenu()
    }
    
}
