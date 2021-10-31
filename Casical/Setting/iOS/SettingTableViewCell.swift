//
//  SettingTableViewCell.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/31.
//

import UIKit

final class SettingTableViewCell: UITableViewCell {
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }

    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
}
