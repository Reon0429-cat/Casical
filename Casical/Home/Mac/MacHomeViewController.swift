//
//  MacHomeViewController.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/30.
//

import UIKit
import UIKit
import FirebaseAuth
import SideMenu
import FirebaseFirestore

enum FilterType: Int, CaseIterable {
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
    
    private var listener: ListenerRegistration?
    private var users = [User]()
    private enum SortType {
        case score
        case register
        case experience
        
        var condition: (User, User) -> Bool {
            switch self {
                case .score: return { $0.skillScore > $1.skillScore }
                case .register: return { $0.registrationDate > $1.registrationDate }
                case .experience: return { $0.experience > $1.experience }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        attachFirestore()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        listener?.remove()
        
    }
    
    private func attachFirestore() {
        listener = Firestore.firestore().collection("users")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("DEBUG_PRINT: ", error.localizedDescription)
                    return
                }
                var users = [User]()
                snapshot?.documents.forEach { snapshot in
                    let dic = snapshot.data()
                    let user = User(dic: dic)
                    users.append(user)
                }
                self.users = users
                DispatchQueue.main.async {
                    self.rearranges(sortType: .register)
                }
            }
    }
    
    private func rearranges(sortType: SortType) {
        users = users.sorted(by: sortType.condition)
        profileCollectionView.reloadData()
        filterTableView.reloadData()
    }
    
    @IBAction private func sortButtonDidTapped(_ sender: Any) {
        // 実装しない
    }
    
    @IBAction private func settingButtonDidTapped(_ sender: Any) {
        // 実装しない
    }
    
}

extension MacHomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if isMac {
            let user = users[indexPath.row]
            let macPersonalPageVC    = UIStoryboard(name: "MacPersonalPage", bundle: nil)
                .instantiateInitialViewController() as! MacPersonalPageViewController
            macPersonalPageVC.modalPresentationStyle = .fullScreen
            macPersonalPageVC.user = user
            present(macPersonalPageVC, animated: true)
        } else {
            // 実装しない
        }
    }
    
}

extension MacHomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        users.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileCollectionViewCell.identifier,
            for: indexPath
        ) as! ProfileCollectionViewCell
        let model = users[indexPath.row]
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
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension MacHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return FilterType.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SortTableViewCell.identifier
        ) as! SortTableViewCell
        let title = FilterType.allCases[indexPath.row].title
        cell.tag = indexPath.row
        cell.configure(title: title, users: users) { [weak self] cellTag in
            let filterType = FilterType(rawValue: cellTag) ?? .language
            switch filterType {
                case .language:
                    print("DEBUG_PRINT: language")
                case .prefecture:
                    print("DEBUG_PRINT: prefecture")
                case .experience:
                    print("DEBUG_PRINT: experience")
                case .github:
                    print("DEBUG_PRINT: github")
                case .qiita:
                    print("DEBUG_PRINT: qiita")
            }
            self?.filterTableView.reloadData()
        }
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
