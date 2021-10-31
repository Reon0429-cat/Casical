//
//  HomeViewController.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/29.
//

import UIKit
import FirebaseAuth

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
    
    private var sampleData = SampleModel.data
    private lazy var sortButtonFollowViewPosition: SortButtonFollowViewPosition = .register(sortRegisterButton)
    private enum SortType {
        case score
        case register
        case experience
        
        var condition: (SampleModel, SampleModel) -> Bool {
            switch self {
                case .score: return { $0.skillScore > $1.skillScore }
                case .register: return { $0.registrationDate < $1.registrationDate }
                case .experience: return { $0.experience > $1.experience }
            }
        }
    }
    private var sortType: SortType = .register
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isNotLoggedIn = (Auth.auth().currentUser == nil)
        if isNotLoggedIn {
            presentLoginVC()
        }
        rearranges(sortType: .register)
        setupUI()
        
    }
    
    @IBAction private func sortScoreButton(_ sender: Any) {
        changeFollowViewPosition(to: sortScoreButton)
        rearranges(sortType: .score)
    }
    
    @IBAction private func sortRegisterButton(_ sender: Any) {
        changeFollowViewPosition(to: sortRegisterButton)
        rearranges(sortType: .register)
    }
    
    @IBAction private func sortExperienceButton(_ sender: Any) {
        changeFollowViewPosition(to: sortExperienceButton)
        rearranges(sortType: .experience)
    }
    
    @IBAction private func filterButton(_ sender: Any) {
        // 実装しない
    }
    
    @IBAction private func settingButton(_ sender: Any) {
        
    }
    
    private func rearranges(sortType: SortType) {
        sampleData = sampleData.sorted(by: sortType.condition)
        collectionView.reloadData()
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

