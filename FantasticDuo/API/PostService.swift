//
//  PostService.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/23.
//

import UIKit
import Firebase

struct PostService {
    static func uploadPost(title: String, content: String, rank: Int, user: User, completion: @escaping(FirestoreCompletion)){
        
        guard let uid = Auth.auth().currentUser?.uid else{ return }
        
        let data = ["title":title,
                    "content":content,
                    "nickname":user.nickname,
                    "ownerUid":user.uid,
                    "rank":rank,
                    "timestamp":Timestamp(date: Date())] as [String : Any]
        let docRef = COLLECTION_POSTS.addDocument(data: data, completion: completion)
        self.updateUserFeedAfterPost(postId: docRef.documentID)
        print(docRef.documentID)
        
    }
    static func fetchFeedPosts(completion: @escaping([Post])->Void){
        
        COLLECTION_POSTS.getDocuments{ (snapshot, error) in
            guard let documents = snapshot?.documents else{return}
            var posts = documents.map({Post(postId: $0.documentID, dictionary: $0.data())})
            posts.sort(by: { $0.timestamp.seconds > $1.timestamp.seconds})
            completion(posts)
//            if let snapshotDocuments = snapshot?.documents{
//                for doc in snapshotDocuments{
//                    let data = doc.data()
//                    posts.append(data)
//                }
//            }
            
        }
    }
    static func updateUserFeedAfterPost(postId: String){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot,_ in
            guard let documents = snapshot?.documents else {return} //해당 유저를 팔로우하고있는사람들
            
            documents.forEach { document in
                COLLECTION_USERS.document(document.documentID).collection("user-feed").document(postId).setData([:])
            }
            COLLECTION_USERS.document(uid).collection("user-feed").document(postId).setData([:])
        }
    }
}
