//
//  ProfileController.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/17.
//

import UIKit
import Firebase
private let reuseIdentifier = "ProfileCell"
class ProfileController: UIViewController {
    
    //MARK: - Propertie
    let tableView = UITableView(frame: .zero, style: .plain)
    private var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.setHeight(100)
        return view
    }()
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "지죵이"
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapComments), for: .touchUpInside)
        button.setTitle(" 소환사 한줄평", for: .normal)
        return button
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - API
    //MARK: - Actions
    @objc func didTapComments(){
        do{
            try Auth.auth().signOut()
            let controller = LoginController()
//            controller.delegate = self.tabBarController as? MainTabController
//            let nav = UINavigationController(rootViewController: controller)
//            nav.modalPresentationStyle = .fullScreen
//            self.present(nav, animated: true, completion: nil)
        }catch{
            print("debug: failed to sgin out")
        }
    }
    //MARK: - Helpers
    func configureUI(){
        
        let stack = UIStackView(arrangedSubviews: [headerView,tableView])
        stack.axis = .vertical
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.register(ProfileCommentCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        view.addSubview(stack)
        stack.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,bottom:view.bottomAnchor, right: view.rightAnchor)
        headerView.anchor(top: stack.topAnchor, left: stack.leftAnchor, right: stack.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        headerView.backgroundColor = .systemGray6
        headerView.layer.cornerRadius = 8
        headerView.clipsToBounds = true
        
        headerView.addSubview(nicknameLabel)
        nicknameLabel.anchor(top: headerView.topAnchor, left: headerView.leftAnchor, bottom: headerView.bottomAnchor, right: headerView.rightAnchor,paddingLeft: 32)
        headerView.addSubview(commentButton)
        commentButton.anchor(top: headerView.topAnchor, bottom: headerView.bottomAnchor, right: headerView.rightAnchor, paddingRight: 16)
        
        
    }
    
}
extension ProfileController: UITableViewDelegate{
    
}
extension ProfileController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCommentCell
        return cell
    }
    
    
}
