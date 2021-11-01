//
//  GitHubAPIClient.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/31.
//

import Foundation

enum Result<Success, Failure> {
    case success(Success)
    case failure(Failure)
}

typealias ResultHandler<T> = (Result<T, String>) -> Void

final class GitHubAPIClient {
    
    func searchUser(userName: String,
                    completion: @escaping ResultHandler<GitHubUser>) {
        let urlString = "https://api.github.com/users/\(userName)"
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
            guard let user = try? jsonDecoder.decode(GitHubUser.self, from: data) else {
                completion(.failure("userが不適"))
                return
            }
            completion(.success(user))
        }
        task.resume()
    }
    
    func searchRepos(userName: String,
                     completion: @escaping ResultHandler<[GitHubRepoItem]>) {
        let urlString = "https://api.github.com/users/\(userName)/repos?per_page=100"
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
            guard let items = try? jsonDecoder.decode([GitHubRepoItem].self, from: data) else {
                completion(.failure("itemが不適"))
                return
            }
            completion(.success(items))
        }
        task.resume()
    }
    
}
