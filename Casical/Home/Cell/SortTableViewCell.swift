//
//  SortTableViewCell.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/30.
//

import UIKit

final class SortTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = .black
        
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    @IBAction private func chevronButtonDidTapped(_ sender: Any) {
        
    }
    
}
