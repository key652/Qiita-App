//
//  QiitaItem.swift
//  QiitaApp
//
//  Created by 矢田悠馬 on 2022/06/26.
//

struct Tag: Codable, Hashable {
    var name: String
    var versions: Array<String>
}

struct User: Codable, Hashable {
    var id: String
    var name: String
    var profile_image_url: String
}

struct QiitaItem: Codable, Hashable {
    var id: String
    var tags: [Tag]
    var title: String
    var likes_count: Int
    var user: User
    var created_at: String
}
