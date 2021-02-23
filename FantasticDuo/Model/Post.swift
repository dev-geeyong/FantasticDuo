//
//  Post.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/23.
//

import Firebase

struct Post {
    var title: String
    var content: String
    let nickname: String
    let ownerUid: String
    let postId: String
    var rank: Int
    let timestamp: Timestamp
    
    init(postId: String, dictionary: [String:Any]){
        self.postId = postId
        self.title = dictionary["title"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.nickname = dictionary["nickname"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.rank = dictionary["rank"] as? Int ?? 0
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
    }
}
