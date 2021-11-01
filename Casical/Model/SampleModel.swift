//
//  SampleModel.swift
//  Casical
//
//  Created by 大西玲音 on 2021/11/01.
//

import UIKit

struct SampleModel {
    let image: UIImage
    let name: String
    let language: String
    let house: String
    let experience: Int
    let github: String
    let qiita: String
    let bio: String
    let skillScore: Int
    let registrationDate: Date
    private static func date(value: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: value, to: Date())!
    }
}

// experience: 3年10ヶ月 => 3 * 12 + 10 = 46
// 未経験 => 0

extension SampleModel {
    static let data = [
        SampleModel(image: UIImage(named: "reon")!,
                    name: "OONISHI REON",
                    language: "Swift",
                    house: "東京",
                    experience: 12,
                    github: "Reon0429-cat",
                    qiita: "REON",
                    bio: "iOSエンジニアを目指してます！Swift大好き！",
                    skillScore: 100,
                    registrationDate: date(value: 10)),
        SampleModel(image: UIImage(named: "adu")!,
                    name: "Azuki Yamada",
                    language: "CSS",
                    house: "大阪",
                    experience: 6,
                    github: "aduGitHub",
                    qiita: "aduQiita",
                    bio: "aduBio",
                    skillScore: 120,
                    registrationDate: date(value: 20)),
        SampleModel(image: UIImage(named: "sakura")!,
                    name: "宮脇 咲良",
                    language: "JavaScript",
                    house: "鹿児島",
                    experience: 66,
                    github: "sakuraGitHub",
                    qiita: "sakuraQiita",
                    bio: "sakuraBio",
                    skillScore: 40,
                    registrationDate: date(value: 30)),
        SampleModel(image: UIImage(named: "mai")!,
                    name: "Mai Shiraishi",
                    language: "Java",
                    house: "群馬",
                    experience: 0,
                    github: "maiGitHub",
                    qiita: "maiQiita",
                    bio: "maiBio",
                    skillScore: 200,
                    registrationDate: date(value: 60)),
        SampleModel(image: UIImage(named: "asuka")!,
                    name: "齋藤 飛鳥",
                    language: "PHP",
                    house: "東京",
                    experience: 0,
                    github: "asukaGitHub",
                    qiita: "asukaQiita",
                    bio: "asukaBio",
                    skillScore: 250,
                    registrationDate: date(value: 100)),
    ]
}

extension SampleModel {
    
    func convertExperienceToString() -> String {
        let year = self.experience / 12
        let month = self.experience % 12
        if year == 0, month == 0 {
            return "未経験"
        } else if year == 0, month != 0 {
            return "\(month)ヶ月"
        } else if year != 0, month == 0 {
            return "\(year)年"
        } else if year != 0, month != 0 {
            return "\(year)年\(month)ヶ月"
        } else {
            return ""
        }
    }
    
}
