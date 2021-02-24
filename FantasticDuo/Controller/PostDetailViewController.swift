//
//  PostDetailViewController.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/23.
//

import UIKit

class PostDetailViewController: UIViewController{
    //MARK: - Propertie
    private var currentPost: Post?
    init(post: Post) {
        self.currentPost = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let backView: UIView = {
        let view = UIView()
        return view
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "제목"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    var nicknameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("소환사이름: 지죵이", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = #colorLiteral(red: 0.2063752115, green: 0.5944960713, blue: 0.8571043611, alpha: 1)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.addTarget(self, action: #selector(handleNicknameButton), for: .touchUpInside)
        
        return button
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        configureUI()
    }
    //MARK: - API
    //MARK: - Actions
    @objc func handleNicknameButton(){
        print("handleNicknameButton", currentPost?.ownerUid)
        
        if let uid = currentPost?.ownerUid{
            UserService.fetchUser(withUid: uid) { user in
                let controller = ProfileController(user: user)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    //MARK: - Helpers
    func configureUI(){
        guard let title = currentPost?.title else{return}
        guard let content = currentPost?.content else{return}
        guard let nickname = currentPost?.nickname else{return}
        
        view.addSubview(backView)
        backView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 10
        backView.clipsToBounds = true
        
        backView.addSubview(titleLabel)
        titleLabel.anchor(top: backView.topAnchor, left: backView.leftAnchor, right: backView.rightAnchor,paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        backView.addSubview(contentLabel)
        contentLabel.anchor(top: titleLabel.bottomAnchor, left: backView.leftAnchor, right: backView.rightAnchor,paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        backView.addSubview(nicknameButton)
        
        nicknameButton.anchor(left:backView.leftAnchor ,bottom:backView.bottomAnchor, right: backView.rightAnchor, paddingLeft: 32, paddingBottom: 32, paddingRight: 32)
        nicknameButton.centerX(inView: backView)
        titleLabel.text = title
        contentLabel.text = content
        nicknameButton.setTitle("소환사 이름: \(nickname)", for: .normal)
        
        
        
    }
}
