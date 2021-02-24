//
//  PostViewModel.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/24.
//

import UIKit

struct PostViewModel {
    var post: Post
    
    var title:String {return post.title}
    var content:String {return post.content}
    var nickname:String {return post.nickname}
    var ownerUid:String{return post.ownerUid}
    var rank:Int {return post.rank}
    var timestampString: String?{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        return formatter.string(from: post.timestamp.dateValue(), to: Date())
    }
    var setImamge: UIImage?{
        if rank == 0 {
            return #imageLiteral(resourceName: "Emblem_Iron")
        }else if rank == 1{
            return #imageLiteral(resourceName: "Emblem_Bronze")
        }else if rank == 2{
            return #imageLiteral(resourceName: "Emblem_Silver")
        }else if rank == 3{
            return #imageLiteral(resourceName: "Emblem_Gold")
        }else if rank == 4{
            return #imageLiteral(resourceName: "Emblem_Platinum")
        }else if rank == 5{
            return #imageLiteral(resourceName: "Emblem_Diamond")
        }
        return #imageLiteral(resourceName: "Emblem_Bronze")
    }
    init(post: Post){
        self.post = post
    }
    
}
