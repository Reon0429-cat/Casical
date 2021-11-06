//
//  User.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/31.
//

import Foundation
import Firebase

struct User {
    let name: String
    let workLocation: String
    let experience: Int
    let employmentStatus: String
    let registrationDate: Date
    let gitHub: GitHub
    let qiita: Qiita
    let skillScore: Int
    let isChecked: Bool
}

extension User {
    
    init(dic: [String: Any]) {
        self.name = dic["name"] as! String
        self.workLocation = dic["workLocation"] as! String
        self.experience = dic["experience"] as! Int
        self.employmentStatus = dic["employmentStatus"] as! String
        let timestamp = dic["registrationDate"] as! Timestamp
        self.registrationDate = timestamp.dateValue()
        let gitHubDic = dic["gitHub"] as! [String: Any]
        self.gitHub = GitHub(dic: gitHubDic)
        let qiitaDic = dic["qiita"] as! [String: Any]
        self.qiita = Qiita(dic: qiitaDic)
        self.skillScore = dic["skillScore"] as! Int
        self.isChecked = dic["isChecked"] as! Bool
    }
    
}

extension User {
    
    func toDic() -> [String: Any] {
        return [
            "name": name,
            "workLocation": workLocation,
            "experience": experience,
            "employmentStatus": employmentStatus,
            "registrationDate": registrationDate,
            "gitHub": gitHub.toDic(),
            "qiita": qiita.toDic(),
            "skillScore": skillScore,
            "isChecked": isChecked,
        ] as [String: Any]
    }
    
}

extension User {
    
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
