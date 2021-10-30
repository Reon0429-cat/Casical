//
//  MacHomeViewController.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/30.
//

import UIKit

private enum SortType: CaseIterable {
    case language
    case prefecture
    case experience
    case github
    case qiita
    
    var title: String {
        switch self {
            case .language: return "使用言語"
            case .prefecture: return "都道府県"
            case .experience: return "実務経験"
            case .github: return "GitHub"
            case .qiita: return "Qiita"
        }
    }
}

final class MacHomeViewController: UIViewController {
    
    @IBOutlet private weak var sortButton: UIButton!
    @IBOutlet private weak var filterTableView: UITableView!
    @IBOutlet private weak var profileCollectionView: UICollectionView!
    @IBOutlet private weak var settingButton: UIButton!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet private weak var filterLabel: UILabel!
    
    private let sampleData = [[SampleModel]](repeating: SampleModel.data, count: 10).flatMap { $0 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    @IBAction private func sortButtonDidTapped(_ sender: Any) {
        
    }
    
    @IBAction private func settingButtonDidTapped(_ sender: Any) {
        // 実装しない
    }
    
}

extension MacHomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if isMac {
            let sampleModel = sampleData[indexPath.row]
            let macPersonalPageVC    = UIStoryboard(name: "MacPersonalPage", bundle: nil)
                .instantiateInitialViewController() as! MacPersonalPageViewController
            macPersonalPageVC.modalPresentationStyle = .fullScreen
            macPersonalPageVC.sampleModel = sampleModel
            present(macPersonalPageVC, animated: true)
        } else {
            // 実装しない
        }
    }
    
}

extension MacHomeViewController: UICollectionViewDataSource {
    
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

extension MacHomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.view.frame.width / 2 - 250
        let cellHeight: CGFloat = 160
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

extension MacHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension MacHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return SortType.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SortTableViewCell.identifier
        ) as! SortTableViewCell
        let title = SortType.allCases[indexPath.row].title
        cell.configure(title: title)
        return cell
    }
    
}

// MARK: - setup
private extension MacHomeViewController {
    
    func setupUI() {
        self.view.backgroundColor = .white
        headerTitleLabel.textColor = .darkColor
        headerTitleLabel.font = .systemFont(ofSize: 60, weight: .bold)
        settingButton.tintColor = .gray
        sortButton.setTitleColor(.darkColor, for: .normal)
        sortButton.tintColor = .darkColor
        filterLabel.textColor = .gray
        setupProfileCollectionView()
        setupFilterTableView()
    }
    
    func setupProfileCollectionView() {
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.showsVerticalScrollIndicator = false
        profileCollectionView.register(ProfileCollectionViewCell.nib,
                                forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        profileCollectionView.collectionViewLayout = layout
    }
    
    func setupFilterTableView() {
        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.register(SortTableViewCell.nib,
                                 forCellReuseIdentifier: SortTableViewCell.identifier)
    }
    
}
