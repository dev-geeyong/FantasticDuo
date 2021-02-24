//
//  CommentViewModel.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/24.
//

import UIKit

struct CommentViewModel {
    
    var comment: Comment
    var nickname: String {return comment.nickname}
    var commentText: String{return comment.commentText}
    
    init(comment: Comment){
        self.comment = comment

    }
    var timestampString: String?{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        return formatter.string(from: comment.timestapm.dateValue(), to: Date())
    }
}
