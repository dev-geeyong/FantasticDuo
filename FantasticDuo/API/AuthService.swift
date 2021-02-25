//
//  AuthService.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/18.
//

import UIKit
import Firebase
import Toast
struct AuthCredentials {
    let email: String
    let password: String
    let nickname: String
}

struct AuthService {
    static func logUserIn(withEmail email: String, password:String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    static func registerUser(withCredential credentials: AuthCredentials, uid: String, complietion: @escaping(Error?)->Void){

      
            
            let data: [String: Any] = ["nickname" : credentials.nickname,
                                       "uid": uid
            ]
            COLLECTION_USERS.document(uid).setData(data, completion: complietion)
            
        }
    
    static func registerAppleLogin(uid: String, nickname: String, complietion: @escaping(Error?)->Void){
        
        let data: [String: Any] = ["nickname" : nickname,
                                   "uid" : uid]
        COLLECTION_USERS.document(uid).setData(data, completion: complietion)
        
    }

    
    
}

