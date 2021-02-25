//
//  UserService.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/23.
//

import Firebase

typealias FirestoreCompletion = (Error?) -> Void

struct UserService {
    static func fetchUser(withUid uid: String, completion: @escaping(User)->Void){
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else{return}
            
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    static func updateUserNickname(uid :String, nickname: String, completion: @escaping(String)->Void){
        COLLECTION_USERS.document(uid).updateData(["nickname" : nickname])
        completion("완료")
    }
}
