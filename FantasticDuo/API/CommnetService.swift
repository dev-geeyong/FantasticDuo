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
   
//        var comments = [Comment]()
//        let query = COLLECTION_USERS.document(uid).collection("comments").order(by: "timestapm", descending: true)
//        query.addSnapshotListener{(snapshot, error)in
//            snapshot?.documentChanges.forEach({change in
//                if change.type == .added {
//                    let data = change.document.data()
//                    let comment = Comment(dictionary: data)
//                    comments.append(comment)
//                }
//            })
//            completion(comments)
//        }
        COLLECTION_USERS.document(uid).collection("comments").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else{return}
            var posts = documents.map({Comment(commentId: $0.documentID, dictionary: $0.data())})
            posts.sort(by: { $0.timestapm.seconds > $1.timestapm.seconds})
            completion(posts)
        }
    }
    static func deleteMyComment(commentid: String, completion: @escaping(String)->Void){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        print("uid",uid)
//        COLLECTION_POSTS.document(postid).delete()
//        completion("삭제완료")
    
        COLLECTION_USERS.document(uid).collection("comments").document(commentid).delete { error in
            if let error = error {
                print("eer")
            }
            else{
                print("succ")
                completion("삭제완료")
            }
            
        }
     
        
    }
}
