//
//  SampleModel.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/31.
//

import UIKit

struct SampleModel {
    let image: UIImage
    let name: String
    let language: String
    let house: String
    let experience: String
    let github: String
    let qiita: String
    let bio: String
    let skillScore: Int
    let registrationDate: Date
    
    private static func date(value: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: value, to: Date())!
    }
}

extension SampleModel {
    static let data = [
        SampleModel(image: UIImage(named: "reon")!,
                    name: "OONISHI REON",
                    language: "Swift",
                    house: "東京",
                    experience: "1年",
                    github: "Reon0429-cat",
                    qiita: "REON",
                    bio: "iOSエンジニアを目指してます！Swift大好き！",
                    skillScore: 100,
                    registrationDate: date(value: 10)),
        SampleModel(image: UIImage(named: "adu")!,
                    name: "Azuki Yamada",
                    language: "CSS",
                    house: "大阪",
                    experience: "6ヶ月",
                    github: "aduGitHub",
                    qiita: "aduQiita",
                    bio: "aduBio",
                    skillScore: 120,
                    registrationDate: date(value: 40)),
        SampleModel(image: UIImage(named: "sakura")!,
                    name: "宮脇 咲良",
                    language: "JavaScript",
                    house: "鹿児島",
                    experience: "5年6ヶ月",
                    github: "sakuraGitHub",
                    qiita: "sakuraQiita",
                    bio: "sakuraBio",
                    skillScore: 40,
                    registrationDate: date(value: 10)),
        SampleModel(image: UIImage(named: "mai")!,
                    name: "Mai Shiraishi",
                    language: "Java",
                    house: "群馬",
                    experience: "中途未経験",
                    github: "maiGitHub",
                    qiita: "maiQiita",
                    bio: "maiBio",
                    skillScore: 200,
                    registrationDate: date(value: 60)),
        SampleModel(image: UIImage(named: "asuka")!,
                    name: "齋藤 飛鳥",
                    language: "PHP",
                    house: "東京",
                    experience: "新卒未経験",
                    github: "asukaGitHub",
                    qiita: "asukaQiita",
                    bio: "asukaBio",
                    skillScore: 250,
                    registrationDate: date(value: 100)),]
}
