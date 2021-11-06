//
//  ProfileCollectionViewCell.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/29.
//

import UIKit

final class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var houseLabel: UILabel!
    @IBOutlet private weak var experienceLabel: UILabel!
    @IBOutlet private weak var imageStackViewSpacing: NSLayoutConstraint!
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var memoButton: UIButton!
    
    var onTapCheckButton: ((Int) -> Void)?
    var onTapMemoButton: ((Int) -> Void)?
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        baseView.layer.cornerRadius = 20
        if isMac {
            nameLabel.font = .systemFont(ofSize: 27)
            languageLabel.font = .systemFont(ofSize: 22)
            houseLabel.font = .systemFont(ofSize: 22)
            experienceLabel.font = .systemFont(ofSize: 22)
            imageStackViewSpacing.constant = 50
        } else {
//            baseView.layer.shadowColor = UIColor.black.cgColor
//            baseView.layer.shadowOffset = CGSize(width: 2, height: 2)
//            baseView.layer.shadowRadius = 2
//            baseView.layer.shadowOpacity = 0.8
        }
        
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
    
    @IBAction func checkButtonDidTapped(_ sender: Any) {
        onTapCheckButton?(self.tag)
    }
    
    @IBAction func memoButtonDidTapped(_ sender: Any) {
        onTapMemoButton?(self.tag)
    }
    
    func configure(model: User,
                   onCheckButtonEvent: ((Int) -> Void)?,
                   onTapMemoButtonEvent: ((Int) -> Void)?) {
        self.onTapCheckButton = onCheckButtonEvent
        self.onTapMemoButton = onTapMemoButtonEvent
        let starFillImage = UIImage(systemName: "star.fill")?.withTintColor(.orange,
                                                                            renderingMode: .alwaysOriginal)
        let starImage = UIImage(systemName: "star")?.withTintColor(.gray,
                                                                   renderingMode: .alwaysOriginal)
        let image = model.isChecked ? starFillImage : starImage
        checkButton.setImage(image!, for: .normal)
        baseView.backgroundColor = .lightColor
        nameLabel.textColor = .darkColor
        profileImageView.image = UIImage(data: model.gitHub.image)
        nameLabel.text = model.name
        if let languageName = model.gitHub.mostUsedLanguage?.name {
            languageLabel.text = "● " + languageName
        } else {
            languageLabel.text = "● " + "言語なし"
        }
        houseLabel.text = "● " + model.workLocation
        experienceLabel.text = "● " + model.convertExperienceToString()
    }

}
