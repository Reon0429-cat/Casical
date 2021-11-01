//
//  QiitaAPIModel.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/31.
//

import Foundation

// https://qiita.com/api/v2/users/REON

let json10 = """
{
"followers_count": 23,
"items_count": 98,
}
"""

struct QiitaUser: Codable {
    let followersCount: Int
    let itemsCount: Int
}
