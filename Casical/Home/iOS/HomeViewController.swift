//
//  HomeViewController.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/29.
//

import UIKit
import FirebaseAuth

struct SampleModel {
    let image: UIImage
    let name: String
    let language: String
    let house: String
    let experience: String
}

extension SampleModel {
    static let data = [SampleModel(image: UIImage(named: "reon")!, name: "OONISHI REON", language: "Swift", house: "東京", experience: "1年"),
                       SampleModel(image: UIImage(named: "adu")!, name: "Azuki Yamada", language: "CSS", house: "大阪", experience: "6ヶ月"),
                       SampleModel(image: UIImage(named: "sakura")!, name: "宮脇 咲良", language: "JavaScript", house: "鹿児島", experience: "5年6ヶ月"),
                       SampleModel(image: UIImage(named: "mai")!, name: "Mai Shiraishi", language: "Java", house: "群馬", experience: "中途未経験"),
                       SampleModel(image: UIImage(named: "asuka")!, name: "齋藤 飛鳥", language: "PHP", house: "東京", experience: "新卒未経験"),]
}

private enum SortButtonFollowViewPosition {
    case score(UIButton)
    case register(UIButton)
    case experience(UIButton)
    
    var center: CGFloat {
        switch self {
            case .score(let button): return button.center.x
            case .register(let button): return button.center.x
            case .experience(let button): return button.center.x
        }
    }
    
}

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var sortScoreButton: UIButton!
    @IBOutlet private weak var sortRegisterButton: UIButton!
    @IBOutlet private weak var sortExperienceButton: UIButton!
    @IBOutlet private weak var sortButtonFollowView: UIView!
    @IBOutlet private weak var sortButtonFollowViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var filterButtonTopCenterConstraint: NSLayoutConstraint!
    @IBOutlet private weak var settingButton: UIButton!
    @IBOutlet private weak var separatorView: UIView!
    
    private let sampleData = [[SampleModel]](repeating: SampleModel.data, count: 10).flatMap { $0 }
    private lazy var sortButtonFollowViewPosition: SortButtonFollowViewPosition = .register(sortRegisterButton)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isNotLoggedIn = (Auth.auth().currentUser == nil)
        if isNotLoggedIn {
            presentLoginVC()
        }
        
        setupUI()
        
    }
    
    @IBAction private func sortScoreButton(_ sender: Any) {
        changeFollowViewPosition(to: sortScoreButton)
    }
    
    @IBAction private func sortRegisterButton(_ sender: Any) {
        changeFollowViewPosition(to: sortRegisterButton)
    }
    
    @IBAction private func sortExperienceButton(_ sender: Any) {
        changeFollowViewPosition(to: sortExperienceButton)
    }
    
    @IBAction private func filterButton(_ sender: Any) {
        
    }
    
    @IBAction private func settingButton(_ sender: Any) {
        
    }
    
    private func presentLoginVC() {
        let loginVC = UIStoryboard(name: "Login", bundle: nil)
            .instantiateInitialViewController() as! LoginViewController
        loginVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(loginVC, animated: true)
        }
    }
    
    private func changeFollowViewPosition(to destinationButton: UIButton) {
        let distance = sortButtonFollowViewPosition.center - destinationButton.center.x
        sortButtonFollowViewCenterConstraint.constant -= distance
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
        }
        sortButtonFollowViewPosition = .register(destinationButton)
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        sampleData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileCollectionViewCell.identifier,
            for: indexPath
        ) as! ProfileCollectionViewCell
        let model = sampleData[indexPath.row]
        cell.configure(model: model)
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.view.frame.width
        let cellHeight: CGFloat = 120
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

// MARK: - setup
private extension HomeViewController {
    
    func setupUI() {
        setupCollectionView()
        sortScoreButton.setTitleColor(.black, for: .normal)
        sortRegisterButton.setTitleColor(.black, for: .normal)
        sortExperienceButton.setTitleColor(.black, for: .normal)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.tintColor = .black
        collectionView.indicatorStyle = .black
        settingButton.tintColor = .black
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileCollectionViewCell.nib,
                                forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
    }
    
}

