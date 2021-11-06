//
//  MacPersonalPageViewController.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/30.
//

import UIKit
import Charts
import Alamofire
import Kanna
import PKHUD

final class MacPersonalPageViewController: UIViewController {
    
    // Profile
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
    @IBOutlet private weak var qiitaDataBaseView: UIView!
    @IBOutlet private weak var horizontalBarChartView: HorizontalBarChartView!
    @IBOutlet private weak var qiitaFolloersLabel: UILabel!
    @IBOutlet private weak var qiitaContributionsLabel: UILabel!
    @IBOutlet private weak var qiitaTagNameStackView: UIStackView!
    @IBOutlet private weak var qiitaTagValueStackView: UIStackView!
    @IBOutlet private weak var postCountLabel: UILabel!
    
    // GitHub
    @IBOutlet private weak var githubDataBaseView: UIView!
    @IBOutlet private weak var githubFollowersCountLabel: UILabel!
    @IBOutlet private weak var githubContributionsCountLabel: UILabel!
    @IBOutlet private weak var githubRepositoriesCountLabel: UILabel!
    @IBOutlet private weak var barChartView: BarChartView!
    @IBOutlet private weak var githubMonthStackView: UIStackView!
    
    // Skill Score
    @IBOutlet private weak var radarChartView: RadarChartView!
    @IBOutlet private weak var skillScoreLabel: UILabel!
    
    // Send Message
    @IBOutlet private weak var sendMessageBaseView: UIView!
    
    var user: User!
    private var indicatorView = UIView()
    private let cornerPoint: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        indicator(isHidden: false)
        
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
    
    private func indicator(isHidden: Bool) {
        if isHidden {
            self.indicatorView.isHidden = true
            HUD.hide(nil)
        } else {
            indicatorView.backgroundColor = .white
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(indicatorView)
            [indicatorView.topAnchor.constraint(equalTo: self.view.topAnchor),
             indicatorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
             indicatorView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
             indicatorView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            ].forEach { $0.isActive = true }
            HUD.show(.progress, onView: indicatorView)
        }
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
        setupBarChartView()
    }
    
    func setupPersonalData() {
        nameLabel.text = user.name
        houseLabel.text = "● " + user.workLocation
        experienceLabel.text = "● " + user.convertExperienceToString()
        profileImageView.image = UIImage(data: user.gitHub.image)
        bioLabel.text = user.gitHub.description
        personalDataBaseView.layer.cornerRadius = cornerPoint
        personalDataGraphBaseView.layer.cornerRadius = cornerPoint
    }
    
    func setupGitHubData() {
        githubAccountLabel.text = user.gitHub.name
        githubDataBaseView.layer.cornerRadius = cornerPoint
    }
    
    func setupQiitaData() {
        qiitaAccountLabel.text = user.qiita.name
        qiitaDataBaseView.layer.cornerRadius = cornerPoint
    }
    
    func setupSendMessage() {
        sendMessageBaseView.layer.cornerRadius = cornerPoint
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
    
    func setupBarChartView() {
        githubFollowersCountLabel.text = String(user.gitHub.followers)
        githubMonthStackView.subviews.forEach { $0.backgroundColor = .clear }
        
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelTextColor = .black
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.drawLabelsEnabled = false
        
        barChartView.rightAxis.enabled = false
        
        barChartView.leftAxis.enabled = false
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.drawZeroLineEnabled = true
        barChartView.leftAxis.zeroLineColor = .black
        barChartView.leftAxis.labelCount = 5
        barChartView.leftAxis.labelTextColor = .black
        barChartView.leftAxis.gridColor = .black
        barChartView.leftAxis.drawAxisLineEnabled = false
        
        barChartView.legend.enabled = false
        
        AF.request("https://github.com/\(user.gitHub.name)").responseString { response in
            switch response.result {
                case .success(let value):
                    guard let doc = try? HTML(html: value, encoding: .utf8) else { return }
                    let grass = doc.css("rect").compactMap { $0["data-count"] }
                    let date = doc.css("rect").compactMap { $0["data-date"] }
                    let taple = zip(date, grass).map { (date: $0.0, count: Int($0.1)!) }
                    let august = taple.filter { $0.date.contains("2021-08-") }
                    let september = taple.filter { $0.date.contains("2021-09-") }
                    let october = taple.filter { $0.date.contains("2021-10-") }
                    let november = taple.filter { $0.date.contains("2021-11-") }
                    
                    let august1Count = august.filter { "2021-08-01" <= $0.date && $0.date <= "2021-08-07" }.map { $0.count }.reduce(0, +)
                    let august2Count = august.filter { "2021-08-08" <= $0.date && $0.date <= "2021-08-15" }.map { $0.count }.reduce(0, +)
                    let august3Count = august.filter { "2021-08-16" <= $0.date && $0.date <= "2021-08-23" }.map { $0.count }.reduce(0, +)
                    let august4Count = august.filter { "2021-08-24" <= $0.date && $0.date <= "2021-08-31" }.map { $0.count }.reduce(0, +)
                    let september1Count = september.filter { "2021-09-01" <= $0.date && $0.date <= "2021-09-07" }.map { $0.count }.reduce(0, +)
                    let september2Count = september.filter { "2021-09-08" <= $0.date && $0.date <= "2021-09-15" }.map { $0.count }.reduce(0, +)
                    let september3Count = september.filter { "2021-09-16" <= $0.date && $0.date <= "2021-09-23" }.map { $0.count }.reduce(0, +)
                    let september4Count = september.filter { "2021-09-24" <= $0.date && $0.date <= "2021-09-31" }.map { $0.count }.reduce(0, +)
                    let october1Count = october.filter { "2021-10-01" <= $0.date && $0.date <= "2021-10-07" }.map { $0.count }.reduce(0, +)
                    let october2Count = october.filter { "2021-10-08" <= $0.date && $0.date <= "2021-10-15" }.map { $0.count }.reduce(0, +)
                    let october3Count = october.filter { "2021-10-16" <= $0.date && $0.date <= "2021-10-23" }.map { $0.count }.reduce(0, +)
                    let october4Count = october.filter { "2021-10-24" <= $0.date && $0.date <= "2021-10-31" }.map { $0.count }.reduce(0, +)
                    let november1Count = november.filter { "2021-11-01" <= $0.date && $0.date <= "2021-11-07" }.map { $0.count }.reduce(0, +)
                    let november2Count = november.filter { "2021-11-08" <= $0.date && $0.date <= "2021-11-15" }.map { $0.count }.reduce(0, +)
                    let november3Count = november.filter { "2021-11-16" <= $0.date && $0.date <= "2021-11-23" }.map { $0.count }.reduce(0, +)
                    let november4Count = november.filter { "2021-11-24" <= $0.date && $0.date <= "2021-11-31" }.map { $0.count }.reduce(0, +)
                    
                    let rawData = [
                        august1Count,
                        august2Count,
                        august3Count,
                        august4Count,
                        september1Count,
                        september2Count,
                        september3Count,
                        september4Count,
                        october1Count,
                        october2Count,
                        october3Count,
                        october4Count,
                        november1Count,
                        november2Count,
                        november3Count,
                        november4Count,
                    ]
                    let entries = rawData
                        .enumerated()
                        .map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
                    let dataSet = BarChartDataSet(entries: entries)
                    dataSet.valueFont = .systemFont(ofSize: 20)
                    dataSet.valueTextColor = .black
                    dataSet.colors = [.darkColor]
                    let data = BarChartData(dataSet: dataSet)
                    data.barWidth = 0.9
                    self.barChartView.data = data
                    
                    self.setupRadarChartView()

                case .failure(let error):
                    print("DEBUG_PRINT: ", error.localizedDescription)
            }
        }
        
    }
    
    func setupRadarChartView() {
        radarChartView.xAxis.labelPosition = .top
        radarChartView.xAxis.labelTextColor = .black
        radarChartView.xAxis.drawGridLinesEnabled = false
        radarChartView.xAxis.drawAxisLineEnabled = false
        radarChartView.xAxis.drawLabelsEnabled = false
        radarChartView.xAxis.enabled = false
        radarChartView.xAxis.xOffset = 0
        radarChartView.xAxis.yOffset = 0

        radarChartView.yAxis.drawLabelsEnabled = false
        radarChartView.yAxis.axisMinimum = 0
        radarChartView.yAxis.axisMaximum = 5
        radarChartView.yAxis.enabled = false
        radarChartView.yAxis.drawGridLinesEnabled = false
        radarChartView.yAxis.drawAxisLineEnabled = false
        radarChartView.yAxis.labelTextColor = .clear

        radarChartView.legend.enabled = false
        radarChartView.legend.drawInside = true
        radarChartView.legend.textColor = .black
        
        AF.request("https://github.com/\(user.gitHub.name)").responseString { response in
            switch response.result {
                case .success(let value):
                    guard let doc = try? HTML(html: value, encoding: .utf8) else { return }
                    let gitHubContributions = doc.xpath("//h2[@class='f4 text-normal mb-2']")
                        .compactMap { $0.text }
                        .first!
                        .components(separatedBy: NSCharacterSet.decimalDigits.inverted)
                        .joined()
                    let gitHubRepositories = doc.xpath("//span[@class='Counter']")
                        .compactMap { $0.text }
                        .first!
                    self.githubContributionsCountLabel.text = gitHubContributions
                    self.githubRepositoriesCountLabel.text = gitHubRepositories
                    
                    
                    let gitHubRepositoriesScore = Double(gitHubRepositories)! / 100
                    let gitHubContributionsScore = Double(gitHubContributions)! / 1000
                    let gitHubScores = [gitHubRepositoriesScore, gitHubContributionsScore].reduce(0, +)
                    
                    let qiitaContributionsScore = Double(self.user.qiita.contributions) / 500
                    let qiitaItemCountScore = Double(self.user.qiita.itemsCount) / 100
                    let qiitaScores = [qiitaContributionsScore, qiitaItemCountScore].reduce(0, +)
                    
                    let experienceScore: Double = {
                        switch self.user.experience / 12 {
                            case 0: return 0
                            case 1: return 1
                            case 2...3: return 2
                            case 4...5: return 3
                            case 5...10: return 4
                            default: return 5
                        }
                    }()
                    
                    let skillScores = [gitHubScores, qiitaScores, experienceScore]
                    let entries = skillScores.map { RadarChartDataEntry(value: $0) }
                    let dataSet = RadarChartDataSet(entries: entries, label: "")
                    dataSet.drawFilledEnabled = true
                    dataSet.fillColor = .darkColor
                    dataSet.lineWidth = 2
                    dataSet.valueTextColor = .clear
                    dataSet.colors = [.darkColor]
                    let data = RadarChartData(dataSet: dataSet)
                    self.radarChartView.data = data
                    
                    self.skillScoreLabel.text = String(floor(skillScores.reduce(0, +) * 10) / 10)
                    
                    self.indicator(isHidden: true)
                    
                case .failure(let error):
                    print("DEBUG_PRINT: ", error.localizedDescription)
            }
        }
        
    }
    
}
