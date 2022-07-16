//
//  Qiita.swift
//  QiitaApp
//
//  Created by 矢田悠馬 on 2022/06/26.
//

import Foundation

final class Qiita {
    func getItems(completion: @escaping ([QiitaItem]) -> Void) {
        guard let url = URL(string: ApiUrl.qiitaBaseURL + "items?page=1&per_page=20") else { return }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer " + AccessTokens.qiitaAccessToken, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                print("client Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("server Error: \(response.debugDescription)")
                return
            }
            
            guard let data = data else {
                print("not data")
                return
            }
            
            let decoder = JSONDecoder()
            let items = try? decoder.decode([QiitaItem].self, from: data)
            
            guard let items = items else { return }
            completion(items)
        }
        task.resume()
    }
}
