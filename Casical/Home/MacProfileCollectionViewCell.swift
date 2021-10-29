//
//  MacProfileCollectionViewCell.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/29.
//

import UIKit

final class MacProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var houseLabel: UILabel!
    @IBOutlet private weak var experienceLabel: UILabel!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        baseView.layer.cornerRadius = 20
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOffset = CGSize(width: 2, height: 2)
        baseView.layer.shadowRadius = 2
        baseView.layer.shadowOpacity = 0.8
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = nil
        
    }
    
    func configure(model: SampleModel) {
        profileImageView.image = model.image
        nameLabel.text = model.name
        languageLabel.text = "● " + model.language
        houseLabel.text = "● " + model.house
        experienceLabel.text = "● " + model.experience
    }

}
