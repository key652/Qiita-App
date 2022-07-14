//
//  String.swift
//  QiitaApp
//
//  Created by 矢田悠馬 on 2022/07/14.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let iso8601DateFormatter = ISO8601DateFormatter()
        
        return iso8601DateFormatter.date(from: self)
    }
}
