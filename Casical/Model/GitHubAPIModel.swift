//
//  GitHubAPIModel.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/31.
//

import Foundation

// https://api.github.com/users/Reon0429-cat

let json = """
{
"avatar_url": "https://avatars.githubusercontent.com/u/66917548?v=4",
"bio": " iOSエンジニア志望\r\n🎓都内の大学生です！\r\n\r\n",
"followers": 5,
}
"""

struct GitHubUser: Codable {
    let avatarUrl: String
    let bio: String?
    let followers: Int
}





// https://api.github.com/users/Reon0429-cat/repos
let json2 = """
[
{
"language": "Swift",
"contributors_url": "https://api.github.com/repos/Reon0429-cat/accordionTableView/contributors",
},
]
"""

// mostUsedLanguage
// secondMostUsedLanguage
// thirdMostUsedLanguage


struct GitHubRepoItem: Codable {
    let language: String?
    let contributorsUrl: String
}





// https://api.github.com/repos/Reon0429-cat/accordionTableView/contributors
let json3 = """
[
{
"contributions": 8
}
]
"""

// contributions

struct GitHubContributorItem: Codable {
    let contributions: Int
}
