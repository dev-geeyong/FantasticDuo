//
//  FeedCell.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/17.
//

import UIKit

class ProfileCommentCell: UITableViewCell{
    //MARK: - Propertie
    private let backView: UIView = {
        let view = UIView()
        return view
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "버스 기사 듀오 구합니다. 진짜 잘하시는분만구합니다다다다다다잘하시는분만구합니다다다다다다"
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = "지죵이"
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(backView)
        backView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        backView.backgroundColor = .systemGray6
        backView.layer.cornerRadius = 8
        backView.clipsToBounds = true
        
        backView.addSubview(nicknameLabel)
        nicknameLabel.anchor(bottom: backView.bottomAnchor, right:backView.rightAnchor, paddingBottom: 8, paddingRight: 8)
        
        backView.addSubview(contentLabel)
        contentLabel.anchor(top:backView.topAnchor,
                            left:backView.leftAnchor,
                            bottom:backView.bottomAnchor,
                            right: backView.rightAnchor, paddingLeft: 16, paddingRight: 5)
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
}
