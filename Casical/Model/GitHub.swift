//
//  GitHub.swift
//  Casical
//
//  Created by 大西玲音 on 2021/11/01.
//

import Foundation

struct GitHub {
    let name: String
    let mostUsedLanguage: (name: String, value: Int)?
    let secondMostUsedLanguage: (name: String, value: Int)?
    let thirdMostUsedLanguage: (name: String, value: Int)?
    let followers: Int
    let description: String
    let image: Data
}

extension GitHub {
    
    init(dic: [String: Any]) {
        let name = dic["name"] as! String
        let mostUsedLanguage = dic["mostUsedLanguage"] as! [String: Any]
        let mostUsedLanguageName = mostUsedLanguage["name"] as? String
        let mostUsedLanguageValue = mostUsedLanguage["value"] as? Int
        let mostUsedLanguageTaple: (name: String, value: Int)? = {
            if let mostUsedLanguageName = mostUsedLanguageName,
               let mostUsedLanguageValue = mostUsedLanguageValue {
                return (name: mostUsedLanguageName, value: mostUsedLanguageValue)
            }
            return nil
        }()
        let secondMostUsedLanguage = dic["secondMostUsedLanguage"] as! [String: Any]
        let secondMostUsedLanguageName = secondMostUsedLanguage["name"] as? String
        let secondMostUsedLanguageValue = secondMostUsedLanguage["value"] as? Int
        let secondMostUsedLanguageTaple: (name: String, value: Int)? = {
            if let secondMostUsedLanguageName = secondMostUsedLanguageName,
               let secondMostUsedLanguageValue = secondMostUsedLanguageValue {
                return (name: secondMostUsedLanguageName, value: secondMostUsedLanguageValue)
            }
            return nil
        }()
        let thirdMostUsedLanguage = dic["thirdMostUsedLanguage"] as! [String: Any]
        let thirdMostUsedLanguageName = thirdMostUsedLanguage["name"] as? String
        let thirdMostUsedLanguageValue = thirdMostUsedLanguage["value"] as? Int
        let thirdMostUsedLanguageTaple: (name: String, value: Int)? = {
            if let thirdMostUsedLanguageName = thirdMostUsedLanguageName,
               let thirdMostUsedLanguageValue = thirdMostUsedLanguageValue {
                return (name: thirdMostUsedLanguageName, value: thirdMostUsedLanguageValue)
            }
            return nil
        }()
        self.name = name
        self.mostUsedLanguage = mostUsedLanguageTaple
        self.secondMostUsedLanguage = secondMostUsedLanguageTaple
        self.thirdMostUsedLanguage = thirdMostUsedLanguageTaple
        self.followers = dic["followers"] as! Int
        self.description = dic["description"] as! String
        self.image = dic["image"] as! Data
    }
    
}

extension GitHub {
    
    func toDic() -> [String: Any] {
        let mostUsedLanguageDic = [
            "name": mostUsedLanguage?.name ?? "",
            "value": mostUsedLanguage?.value ?? ""
        ] as [String: Any]
        let secondMostUsedLanguageDic = [
            "name": secondMostUsedLanguage?.name ?? "",
            "value": secondMostUsedLanguage?.value ?? ""
        ] as [String: Any]
        let thirdMostUsedLanguageDic = [
            "name": thirdMostUsedLanguage?.name ?? "",
            "value": thirdMostUsedLanguage?.value ?? ""
        ] as [String: Any]
        return [
            "name": name,
            "mostUsedLanguage": mostUsedLanguageDic,
            "secondMostUsedLanguage": secondMostUsedLanguageDic,
            "thirdMostUsedLanguage": thirdMostUsedLanguageDic,
            "followers": followers,
            "description": description,
            "image": image,
        ] as [String: Any]
    }
    
}
