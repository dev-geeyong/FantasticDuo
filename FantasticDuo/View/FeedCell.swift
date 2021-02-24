//
//  FeedCell.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/17.
//

import UIKit

class FeedCell: UITableViewCell{
    //MARK: - Propertie
    var viewModel: PostViewModel?{
        didSet{configure()}
    }
    var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "Emblem_Diamond")
        return iv
    }()
    private let backView: UIView = {
        let view = UIView()
        return view
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "버스 기사 듀오 구합니다. 진짜 잘하시는분만구합니다다다다다다잘하시는분만구합니다다다다다다"
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.text = "지죵이"
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    var postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = "1 day"
        label.numberOfLines = 0
        label.textColor = .systemGray6
        return label
    }()
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
       
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemGray6
        addSubview(backView)
        backView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        backView.backgroundColor = #colorLiteral(red: 0.2291348279, green: 0.2652670145, blue: 0.4071175456, alpha: 1).withAlphaComponent(0.95)
        backView.layer.cornerRadius = 8
        backView.clipsToBounds = true
        
        backView.addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        backView.addSubview(nicknameLabel)
        nicknameLabel.anchor(bottom: backView.bottomAnchor, right:backView.rightAnchor,paddingTop: 8, paddingBottom: 8, paddingRight: 8)
        
        backView.addSubview(titleLabel)
        titleLabel.anchor(top:backView.topAnchor,
                            left:profileImageView.rightAnchor,
                            bottom:backView.bottomAnchor,
                            right: backView.rightAnchor, paddingLeft: 16, paddingRight: 5)
        titleLabel.adjustsFontSizeToFitWidth = true
        
        backView.addSubview(postTimeLabel)
        postTimeLabel.anchor(top: backView.topAnchor,left: backView.leftAnchor,paddingTop: 1,paddingLeft: 5)
        
 
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
        titleLabel.text = viewModel.title
        nicknameLabel.text = viewModel.nickname
        postTimeLabel.text = viewModel.timestampString
        profileImageView.image = viewModel.setImamge
    }
}
