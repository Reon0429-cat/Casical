//
//  HomeViewController.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/29.
//

import UIKit
import FirebaseAuth
import SideMenu
import FirebaseFirestore

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
    @IBOutlet private weak var addButton: UIButton!
    
    private lazy var sortButtonFollowViewPosition: SortButtonFollowViewPosition = .register(sortRegisterButton)
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
    private var sortType: SortType = .register {
        didSet {
            rearranges(sortType: sortType)
        }
    }
    private var rightSideMenuNavC: SideMenuNavigationController?
    private var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        try! Auth.auth().signOut()
        let isNotLoggedIn = (Auth.auth().currentUser == nil)
        if isNotLoggedIn {
            presentLoginVC()
        }
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
    
    @IBAction private func sortScoreButton(_ sender: Any) {
        changeFollowViewPosition(to: sortScoreButton)
        sortType = .score
    }
    
    @IBAction private func sortRegisterButton(_ sender: Any) {
        changeFollowViewPosition(to: sortRegisterButton)
        sortType = .register
    }
    
    @IBAction private func sortExperienceButton(_ sender: Any) {
        changeFollowViewPosition(to: sortExperienceButton)
        sortType = .experience
    }
    
    @IBAction private func filterButton(_ sender: Any) {
        // 実装しない
    }
    
    @IBAction private func settingButton(_ sender: Any) {
        if isMac {
            // 実装しない
        } else {
            guard let sideMenuNavC = rightSideMenuNavC else { return }
            present(sideMenuNavC, animated: true)
        }
    }
    
    @IBAction private func presentProfileAdditionalScreenButtonDidTapped(_ sender: Any) {
        let profileAdditionalVC = UIStoryboard(name: "ProfileAdditional", bundle: nil)
            .instantiateInitialViewController() as! ProfileAdditionalViewController
        profileAdditionalVC.modalPresentationStyle = .fullScreen
        present(profileAdditionalVC, animated: true)
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
                    self.rearranges(sortType: self.sortType)
                }
            }
    }
    
    private func rearranges(sortType: SortType) {
        users = users.sorted(by: sortType.condition)
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
    
    private func makeSettings() -> SideMenuSettings {
        let presentationStyle: SideMenuPresentationStyle = .menuSlideIn
        presentationStyle.onTopShadowOpacity = 1.0
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.statusBarEndAlpha = 0
        return settings
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDataSource {
    
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
        cell.configure(model: model,
                       onCheckButtonEvent: { index in
            let user = self.users[index]
            Firestore.firestore().collection("users")
                .whereField("name", isEqualTo: user.name).getDocuments { snapshot, error in
                    if let error = error {
                        print("DEBUG_PRINT: チェックの更新失敗", error.localizedDescription, #line)
                        return
                    }
                    let id = snapshot?.documents.first?.documentID ?? ""
                    let document = Firestore.firestore().collection("prefectures").document(id)
                    Firestore.firestore().collection("users").document(document.documentID).updateData(["isChecked": !user.isChecked]) { error in
                        if let error = error {
                            print("DEBUG_PRINT: チェックの更新失敗", error.localizedDescription, #line)
                            return
                        }
                        self.collectionView.reloadData()
                    }
                }
        }, onTapMemoButtonEvent: { index in
        })
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
        setupSideMenu()
        sortScoreButton.setTitleColor(.black, for: .normal)
        sortRegisterButton.setTitleColor(.black, for: .normal)
        sortExperienceButton.setTitleColor(.black, for: .normal)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.tintColor = .black
        collectionView.indicatorStyle = .black
        settingButton.tintColor = .black
        sortButtonFollowView.backgroundColor = .darkColor
        addButton.backgroundColor = .mostLightColor
        addButton.setTitleColor(.darkColor, for: .normal)
        let image = UIImage(systemName: "plus")!
        let coloredImage = image.withTintColor(.darkColor, renderingMode: .alwaysOriginal)
        addButton.setImage(coloredImage, for: .normal)
        addButton.layer.cornerRadius = addButton.frame.height / 2
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
    
    func setupSideMenu() {
        let rightSideMenuVC = UIStoryboard(name: "Setting", bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: SettingViewController.self)
            ) as! SettingViewController
        rightSideMenuVC.onColorSelected = {
            self.sortButtonFollowView.backgroundColor = .darkColor
            self.addButton.backgroundColor = .mostLightColor
            let image = UIImage(systemName: "plus")!
            let coloredImage = image.withTintColor(.darkColor, renderingMode: .alwaysOriginal)
            self.addButton.setImage(coloredImage, for: .normal)
            self.collectionView.reloadData()
        }
        let rightSideMenuNavC = SideMenuNavigationController(rootViewController: rightSideMenuVC)
        rightSideMenuNavC.settings = makeSettings()
        rightSideMenuNavC.menuWidth = 200
        SideMenuManager.default.rightMenuNavigationController = rightSideMenuNavC
        self.rightSideMenuNavC = rightSideMenuNavC
        
        if let navigationController = self.navigationController {
            SideMenuManager.default.addPanGestureToPresent(toView: navigationController.navigationBar)
            SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: navigationController.view, forMenu: .left)
        }
    }
    
}

