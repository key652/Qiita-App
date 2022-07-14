//
//  Date.swift
//  QiitaApp
//
//  Created by 矢田悠馬 on 2022/07/14.
//

import Foundation

extension Date {
    func toString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: self)
    }
}
