//
//  MacPersonalPageViewController.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/30.
//

import UIKit
import Charts

final class MacPersonalPageViewController: UIViewController {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var houseLabel: UILabel!
    @IBOutlet private weak var experienceLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var githubAccountLabel: UILabel!
    @IBOutlet private weak var qiitaAccountLabel: UILabel!
    @IBOutlet private weak var bioLabel: UILabel!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet private weak var settingButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var personalDataBaseView: UIView!
    @IBOutlet private weak var personalDataGraphBaseView: UIView!
    @IBOutlet private weak var githubDataBaseView: UIView!
    @IBOutlet private weak var qiitaDataBaseView: UIView!
    @IBOutlet private weak var sendMessageBaseView: UIView!
    // Language
    @IBOutlet private weak var pieChartView: PieChartView!
    @IBOutlet private weak var pieChartCenterTitleLabel: UILabel!
    @IBOutlet private weak var pieChartCenterValueLabel: UILabel!
    @IBOutlet private weak var pieChartMostLanguageLabel: UILabel!
    @IBOutlet private weak var pieChartSecondMostLanguageLabel: UILabel!
    @IBOutlet private weak var pieChartThirdMostLanguageLabel: UILabel!
    @IBOutlet private weak var pieChartMostLanguageAccessoryView: UIView!
    @IBOutlet private weak var pieChartSecondMostLanguageAccessoryView: UIView!
    @IBOutlet private weak var pieChartThirdMostLanguageAccessoryView: UIView!
    // Qiita
    @IBOutlet private weak var horizontalBarChartView: HorizontalBarChartView!
    @IBOutlet private weak var qiitaFolloersLabel: UILabel!
    @IBOutlet private weak var qiitaContributionsLabel: UILabel!
    @IBOutlet private weak var qiitaTagNameStackView: UIStackView!
    @IBOutlet private weak var qiitaTagValueStackView: UIStackView!
    @IBOutlet private weak var postCountLabel: UILabel!
    
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
            self.pieChartMostLanguageAccessoryView.layer.cornerRadius = self.pieChartMostLanguageAccessoryView.frame.height / 2
            self.pieChartSecondMostLanguageAccessoryView.layer.cornerRadius = self.pieChartSecondMostLanguageAccessoryView.frame.height / 2
            self.pieChartThirdMostLanguageAccessoryView.layer.cornerRadius = self.pieChartThirdMostLanguageAccessoryView.frame.height / 2
        }
        
    }
    
    @IBAction private func backButtonDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction private func settingButtonDidTapped(_ sender: Any) {
        // 実装しない
    }
    
}

// MARK: - setup
private extension MacPersonalPageViewController {
    
    func setupUI() {
        self.view.backgroundColor = .white
        headerTitleLabel.textColor = .darkColor
        headerTitleLabel.font = .systemFont(ofSize: 60, weight: .bold)
        settingButton.tintColor = .gray
        backButton.tintColor = .gray
        setupPersonalData()
        setupGitHubData()
        setupQiitaData()
        setupSendMessage()
        setupPieChartView()
        setupHorizontalBarChartView()
    }
    
    func setupPersonalData() {
        nameLabel.text = user.name
        houseLabel.text = "● " + user.workLocation
        experienceLabel.text = "● " + user.convertExperienceToString()
        profileImageView.image = UIImage(data: user.gitHub.image)
        bioLabel.text = user.gitHub.description
        personalDataBaseView.layer.cornerRadius = 50
        personalDataGraphBaseView.layer.cornerRadius = 50
    }
    
    func setupGitHubData() {
        githubAccountLabel.text = user.gitHub.name
        githubDataBaseView.layer.cornerRadius = 50
    }
    
    func setupQiitaData() {
        qiitaAccountLabel.text = user.qiita.name
        qiitaDataBaseView.layer.cornerRadius = 50
    }
    
    func setupSendMessage() {
        sendMessageBaseView.layer.cornerRadius = 50
    }
    
    func setupPieChartView() {
        pieChartView.legend.enabled = false
        pieChartView.holeColor = .clear
        pieChartView.holeRadiusPercent = 0.7
        let mostUsedLanguageValue = Double(user.gitHub.mostUsedLanguage?.value ?? 0)
        let secondMostUsedLanguageValue = Double(user.gitHub.secondMostUsedLanguage?.value ?? 0)
        let thirdMostUsedLanguageValue = Double(user.gitHub.thirdMostUsedLanguage?.value ?? 0)
        let all = mostUsedLanguageValue + secondMostUsedLanguageValue + thirdMostUsedLanguageValue
        let mostUsedLanguageValuePercent = mostUsedLanguageValue / all * 100
        let secondMostUsedLanguageValuePercent = secondMostUsedLanguageValue / all * 100
        let otherLanguagePercent = 100 - mostUsedLanguageValuePercent - secondMostUsedLanguageValuePercent
        let dataEntries = [
            PieChartDataEntry(value: mostUsedLanguageValuePercent),
            PieChartDataEntry(value: secondMostUsedLanguageValuePercent),
            PieChartDataEntry(value: otherLanguagePercent),
        ]
        let dataSet = PieChartDataSet(entries: dataEntries)
        dataSet.colors = [.pieChartColor1, .pieChartColor2, .pieChartColor3]
        dataSet.valueTextColor = .black
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .clear
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        let mostUsedLanguageName = user.gitHub.mostUsedLanguage?.name ?? ""
        let secondMostUsedLanguageName = user.gitHub.secondMostUsedLanguage?.name ?? ""
        pieChartCenterTitleLabel.text = mostUsedLanguageName
        pieChartCenterValueLabel.text = String(Int(mostUsedLanguageValuePercent)) + "%"
        pieChartMostLanguageLabel.text = mostUsedLanguageName + " " + String(Int(mostUsedLanguageValuePercent)) + "%"
        pieChartSecondMostLanguageLabel.text = secondMostUsedLanguageName + " " + String(Int(secondMostUsedLanguageValuePercent)) + "%"
        pieChartThirdMostLanguageLabel.text = "others" + " " + String(Int(otherLanguagePercent)) + "%"
        pieChartMostLanguageAccessoryView.backgroundColor = .pieChartColor1
        pieChartSecondMostLanguageAccessoryView.backgroundColor = .pieChartColor2
        pieChartThirdMostLanguageAccessoryView.backgroundColor = .pieChartColor3
    }
    
    func setupHorizontalBarChartView() {
        qiitaFolloersLabel.text = String(user.qiita.followers)
        qiitaContributionsLabel.text = String(user.qiita.contributions)
        postCountLabel.text = String(user.qiita.itemsCount)
        
        horizontalBarChartView.legend.enabled = false
        horizontalBarChartView.borderColor = .clear
        horizontalBarChartView.gridBackgroundColor = .clear
        horizontalBarChartView.drawGridBackgroundEnabled = false
        horizontalBarChartView.chartDescription?.enabled = false
        horizontalBarChartView.drawValueAboveBarEnabled = false
        
        horizontalBarChartView.xAxis.drawAxisLineEnabled = false
        horizontalBarChartView.xAxis.enabled = false
        horizontalBarChartView.xAxis.labelPosition = .topInside
        
        horizontalBarChartView.leftAxis.drawAxisLineEnabled = false
        horizontalBarChartView.leftAxis.drawGridLinesEnabled = false
        horizontalBarChartView.leftAxis.enabled = false
        
        horizontalBarChartView.rightAxis.drawAxisLineEnabled = false
        horizontalBarChartView.rightAxis.drawGridLinesEnabled = false
        horizontalBarChartView.rightAxis.enabled = false
        
        let barColors: [UIColor] = [
            .horizontalChartColor1,
            .horizontalChartColor2,
            .horizontalChartColor3,
            .horizontalChartColor4,
            .horizontalChartColor5
        ].reversed()
        let itemCount = user.qiita.itemsCount
        let barChartDataEntries = user.qiita.postedArticleValues
            .reversed()
            .enumerated()
            .map { BarChartDataEntry(x: Double($0 + 1), y: Double($1)) }
        user.qiita.postedArticleNames.enumerated().forEach { index, name in
            let label = UILabel()
            label.text = name
            label.textColor = .black
            label.font = .systemFont(ofSize: 20)
            label.textAlignment = .right
            qiitaTagNameStackView.addArrangedSubview(label)
        }
        user.qiita.postedArticleValues.enumerated().forEach { index, value in
            let label = UILabel()
            label.text = String(Int(floor(Double(value * itemCount) / Double(100)))) + " posts"
            label.textColor = .black
            label.font = .systemFont(ofSize: 20)
            label.textAlignment = .left
            qiitaTagValueStackView.addArrangedSubview(label)
        }
        let barChartDataSet = BarChartDataSet(entries: barChartDataEntries, label: "")
        barChartDataSet.colors = barColors
        barChartDataSet.valueTextColor = .clear
        
        let barChartData = BarChartData(dataSet: barChartDataSet)
        barChartData.barWidth = 1
        horizontalBarChartView.data = barChartData
    }
    
}
