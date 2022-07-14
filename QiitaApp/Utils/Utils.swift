//
//  Utils.swift
//  QiitaApp
//
//  Created by 矢田悠馬 on 2022/07/11.
//

import Foundation
import UIKit

struct Utils {
    static func loadImageFromUrl(url: String, complition: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            complition(UIImage(data: data))
        }
        
        task.resume()
    }
}
