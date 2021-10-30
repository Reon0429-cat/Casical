//
//  MacHomeViewController.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/30.
//

import UIKit

final class MacHomeViewController: UIViewController {
    
    @IBOutlet private weak var sortButton: UIButton!
    @IBOutlet private weak var filterTableView: UITableView!
    @IBOutlet private weak var profileCollectionView: UICollectionView!
    @IBOutlet private weak var settingButton: UIButton!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    
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
    
}

extension MacHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

// MARK: - setup
private extension MacHomeViewController {
    
    func setupUI() {
        self.view.backgroundColor = .white
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
    }
    
}
