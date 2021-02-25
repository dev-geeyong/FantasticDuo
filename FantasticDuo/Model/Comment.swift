//
//  Comment.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/24.
//

import Firebase

struct Comment {
    let profileUid: String
    let uid: String
    let nickname: String
    let timestapm: Timestamp
    let commentText: String
    let commentId: String
    
    init(commentId: String, dictionary: [String:Any]){
        self.commentId = commentId
        self.profileUid = dictionary["profileUid"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.nickname = dictionary["nickname"] as? String ?? ""
        self.timestapm = dictionary["timestapm"] as? Timestamp ?? Timestamp(date: Date())
        self.commentText = dictionary["commnetText"] as? String ?? ""
    }
}
