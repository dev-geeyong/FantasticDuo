//
//  FeedCell.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/17.
//

import UIKit
import SwipeCellKit
class ProfileCommentCell: SwipeTableViewCell{
    //MARK: - Propertie
    var viewModel:CommentViewModel?{
        didSet{
            configure()
        }
    }
    private let backView: UIView = {
        let view = UIView()
        return view
    }()
    var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    var postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.numberOfLines = 0
        label.textColor = .systemGray6
        return label
    }()
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemGray6
        addSubview(backView)
        backView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: 10)
        backView.backgroundColor = #colorLiteral(red: 0.2291348279, green: 0.2652670145, blue: 0.4071175456, alpha: 1)
        backView.layer.cornerRadius = 8
        backView.clipsToBounds = true
        
        backView.addSubview(nicknameLabel)
        nicknameLabel.anchor(bottom: backView.bottomAnchor, right:backView.rightAnchor, paddingBottom: 8, paddingRight: 8)
        
        backView.addSubview(contentLabel)
        contentLabel.anchor(top:backView.topAnchor,
                            left:backView.leftAnchor,
                            bottom:backView.bottomAnchor,
                            right: backView.rightAnchor, paddingLeft: 16, paddingRight: 5)
        backView.addSubview(postTimeLabel)
        postTimeLabel.anchor(top:backView.topAnchor,
                             right: backView.rightAnchor,
                             paddingTop: 8,
                             paddingRight: 8)
        contentLabel.adjustsFontSizeToFitWidth = true
        
 
//        contentLabel.centerY(inView: backView)
//        contentLabel.centerX(inView: backView)
    }
    override func layoutSubviews() {
         super.layoutSubviews()
         let bottomSpace = 10.0 // Let's assume the space you want is 10
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(bottomSpace), right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - API
    //MARK: - Actions
    //MARK: - Helpers
    func configure(){
        guard let viewModel = viewModel else{return}
        nicknameLabel.text = viewModel.nickname
        contentLabel.text = viewModel.commentText
        postTimeLabel.text = viewModel.timestampString
        
    }
}
