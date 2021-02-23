//
//  User.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/18.
//

import Foundation
import Firebase

struct User {
    let nickname: String
    let uid: String
    
    init(dictionary :[String:Any]){
        self.nickname = dictionary["nickname"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
