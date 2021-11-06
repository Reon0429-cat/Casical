//
//  SortTableViewCell.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/30.
//

import UIKit

final class SortTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var chevronButton: UIButton!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    var onTapEvent: ((Int, String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = .black
        
    }
    
    func configure(title: String,
                   users: [User],
                   detailText: String,
                   onTapEvent: ((Int, String) -> Void)?) {
        self.onTapEvent = onTapEvent
        titleLabel.text = title
        chevronButton.showsMenuAsPrimaryAction = true
        chevronButton.menu = createUIMenu(users: users)
        detailLabel.text = detailText
    }
    
    @IBAction private func chevronButtonDidTapped(_ sender: Any) {
    }
    
    private func createUIMenu(users: [User]) -> UIMenu {
        let filterType = FilterType(rawValue: self.tag) ?? .language
        switch filterType {
            case .language:
                let languageNames = users.map { $0.gitHub.mostUsedLanguage?.name }.compactMap { $0 }
                let filteredLanguageNames = NSOrderedSet(array: languageNames).array as! [String]
                var actions = filteredLanguageNames.map {
                    UIAction(title: $0) { self.onTapEvent?(self.tag, $0.title) }
                }
                actions.insert(UIAction(title: "すべて", handler: { _ in self.onTapEvent?(-1, "すべて") }), at: 0)
                return UIMenu(title: "使用言語",
                              options: .displayInline,
                              children: actions)
            case .prefecture:
                var actions = Prefecture.name.map {
                    UIAction(title: $0) { self.onTapEvent?(self.tag, $0.title) }
                }
                actions.insert(UIAction(title: "すべて", handler: { _ in self.onTapEvent?(-2, "すべて") }), at: 0)
                return UIMenu(title: "都道府県",
                              options: .displayInline,
                              children: actions)
            default: break
        }
        return UIMenu()
    }
    
}
