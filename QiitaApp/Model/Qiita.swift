//
//  Qiita.swift
//  QiitaApp
//
//  Created by 矢田悠馬 on 2022/06/26.
//

import Foundation

protocol QiitaDelegate: AnyObject {
    func updateQiitaItems()
}

final class Qiita {
    static let baseURL = "https://qiita.com/api/v2/"
    static let accessToken = "3d849ed6e036b80639050dc4e4ed4e4cada2618a"
    
    weak var delegate: QiitaDelegate?
    var qiitaItems: [QiitaItem] = []
    
    func getItems() {
        guard let url = URL(string: Qiita.baseURL + "items?page=1&per_page=20") else { return }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer " + Qiita.accessToken, forHTTPHeaderField: "Authorization")
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
            self.qiitaItems = items
            
            self.delegate?.updateQiitaItems()
        }
        task.resume()
    }
}
