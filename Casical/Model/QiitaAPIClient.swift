//
//  QiitaAPIClient.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/31.
//

import Foundation

final class QiitaAPIClient {
    
    func searchUser(userName: String,
                    completion: @escaping ResultHandler<QiitaUser>) {
        let urlString = "https://qiita.com/api/v2/users/\(userName)"
        guard let url = URL(string: urlString) else {
            completion(.failure("url見つからない"))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure("dataがnil"))
                return
            }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let user = try! jsonDecoder.decode(QiitaUser.self, from: data)
            completion(.success(user))
        }
        task.resume()
    }
    
}
