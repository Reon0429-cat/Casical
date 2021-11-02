//
//  Qiita.swift
//  Casical
//
//  Created by 大西玲音 on 2021/11/01.
//

import Foundation

struct Qiita {
    let name: String
    let followers: Int
    let itemsCount: Int
    let contributions: Int
    let postedArticleNames: [String]
    let postedArticleValues: [Int]
}

extension Qiita {
    
    init(dic: [String: Any]) {
        self.name = dic["name"] as! String
        self.followers = dic["followers"] as! Int
        self.itemsCount = dic["itemsCount"] as! Int
        self.contributions = dic["contributions"] as! Int
        self.postedArticleNames = dic["postedArticleNames"] as! [String]
        self.postedArticleValues = dic["postedArticleValues"] as! [Int]
    }
    
}

extension Qiita {
    
    func toDic() -> [String: Any] {
        return [
            "name": name,
            "followers": followers,
            "itemsCount": itemsCount,
            "contributions": contributions,
            "postedArticleNames": postedArticleNames,
            "postedArticleValues": postedArticleValues
        ] as [String: Any]
    }
    
}
