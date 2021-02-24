//
//  CommnetService.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/24.
//

import Firebase

struct CommnetService {
    static func uploadComment(comment: String, user: User, profileUid: String, completion: @escaping(FirestoreCompletion)){
        
        let data: [String:Any] = ["profileUid":profileUid,
                                  "uid":user.uid,
                                  "nickname":user.nickname,
                                  "timestapm":Timestamp(date: Date()),
                                  "commnetText":comment]
        
        COLLECTION_USERS.document(profileUid).collection("comments").addDocument(data: data,completion: completion)
        
    }
    static func fetchComments(uid: String, completion: @escaping([Comment])->Void){
   
        var comments = [Comment]()
        let query = COLLECTION_USERS.document(uid).collection("comments").order(by: "timestapm", descending: true)
        query.addSnapshotListener{(snapshot, error)in
            snapshot?.documentChanges.forEach({change in
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comment(dictionary: data)
                    comments.append(comment)
                }
            })
            completion(comments)
        }
    }
}
