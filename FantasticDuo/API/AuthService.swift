//
//  AuthService.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/18.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let nickname: String
}

struct AuthService {
    static func logUserIn(withEmail email: String, password:String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    static func registerUser(withCredential credentials: AuthCredentials, complietion: @escaping(Error?)->Void){
        
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password){
            (result, error) in
            if let error = error {
                print("debug failed to register user \(error.localizedDescription)")
            }
            
            guard let uid = result?.user.uid else{return}
            
            let data: [String: Any] = ["email": credentials.email,
                                       "nickname" : credentials.nickname,
                                       "uid": uid
            ]
            COLLECTION_USERS.document(uid).setData(data, completion: complietion)
            
        }
    }
    static func registerAppleLogin(uid: String, nickname: String, complietion: @escaping(Error?)->Void){
        
        let data: [String: Any] = ["nickname" : nickname,
                                   "uid" : uid]
        COLLECTION_USERS.document(uid).setData(data, completion: complietion)
        
    }
    
}

