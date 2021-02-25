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
    private var user: User
    private var comments = [Comment]()
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let tableView = UITableView(frame: .zero, style: .plain)
    private var headerView: UIView = {
        let view = UIView()
        view.setHeight(100)
        return view
    }()
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    private let commentMark: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "- 소환사 한 줄 평 -"
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2063752115, green: 0.5944960713, blue: 0.8571043611, alpha: 1)
        return label
    }()
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapComments), for: .touchUpInside)
        button.setTitle("소환사 한줄평", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    private lazy var myPostListButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapmyPostList), for: .touchUpInside)
        button.setTitle("내가 작성한 글", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        return button
    }()
    private lazy var changeButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapChange), for: .touchUpInside)
        button.setTitle("소환사이름 변경", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        configureUI()
        fetchComments()
    }
    //MARK: - API
    func fetchComments(){
        CommnetService.fetchComments(uid: user.uid) { comments in
            self.comments = comments
            self.tableView.reloadData()
        }
    }
    //MARK: - Actions
    @objc func didTapmyPostList(){
        PostService.findMyPostsList(currentUserUid: user.uid) { post in
            let controller = MyPostListViewController(posts: post)
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
            
            
        }
    }
    @objc func didTapChange(){
        
    }
    @objc func didTapComments(){
        guard let uid = Auth.auth().currentUser?.uid else{ return } //작성하는 지금 나
        UserService.fetchUser(withUid: uid) { currentUser in
            if uid != self.user.uid{ //프로필 계정주인이랑..
                self.showAlert { conmment in
                    
                    CommnetService.uploadComment(comment: conmment, user: currentUser, profileUid: self.user.uid) { error in
                        if let error = error {print(error.localizedDescription)}
                        
                        self.fetchComments()
                    }
                    
                    
                }
            }
        }
        
        
       
        
    }
    @objc func didTapLogout(){
        do{
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }catch{
            print("debug: failed to sgin out")
        }
    }
    //MARK: - Helpers
    func configureUI(){
        navigationItem.title = "프로필"
        let rightButton = UIBarButtonItem(title: "로그아웃", style: .plain,
                                                            target: self, action: #selector(didTapLogout))
        
        let stack = UIStackView(arrangedSubviews: [headerView,commentMark,tableView])
        stack.axis = .vertical
        stack.spacing = 10
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemGray6
        tableView.register(ProfileCommentCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        
        view.addSubview(stack)
        
        stack.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,bottom:view.bottomAnchor, right: view.rightAnchor,paddingTop: 12,paddingLeft: 12,paddingBottom: 12,paddingRight: 12)

        headerView.backgroundColor = #colorLiteral(red: 0.2063752115, green: 0.5944960713, blue: 0.8571043611, alpha: 1)
        headerView.layer.cornerRadius = 8
        headerView.clipsToBounds = true
        
        headerView.addSubview(nicknameLabel)
        nicknameLabel.anchor(left: headerView.leftAnchor,paddingLeft: 32)
        nicknameLabel.centerY(inView: headerView)
        
        let stackview = UIStackView(arrangedSubviews: [commentButton,myPostListButton,changeButton,changeButton])
        headerView.addSubview(stackview)
        stackview.axis = .vertical
        stackview.distribution = .fillEqually
        stackview.anchor(top: headerView.topAnchor, bottom: headerView.bottomAnchor, right: headerView.rightAnchor,paddingRight: 16)
        
        nicknameLabel.text = user.nickname
        guard let currentUid = Auth.auth().currentUser?.uid else{return}
        if user.uid != currentUid{
            self.navigationItem.rightBarButtonItem = nil
            commentButton.isHidden = false
            myPostListButton.isHidden = true
            changeButton.isHidden = true
        }else{
            self.navigationItem.rightBarButtonItem = rightButton
            commentButton.isHidden = true
            
            myPostListButton.isHidden = false
            changeButton.isHidden = false
        }
//        headerView.addSubview(nicknameLabel)
//        nicknameLabel.anchor(top: headerView.topAnchor, left: headerView.leftAnchor, bottom: headerView.bottomAnchor, right: headerView.rightAnchor,paddingLeft: 32)
//        headerView.addSubview(commentButton)
//        commentButton.anchor(top: headerView.topAnchor, bottom: headerView.bottomAnchor, right: headerView.rightAnchor, paddingRight: 16)
        
        
    }
    func showAlert(completions: @escaping(String)->Void){
        
        let alert = UIAlertController(title: "소환사 한 줄 평", message: "소환사의 한 줄 평을 입력해주세요", preferredStyle: .alert)
        alert.addTextField()
        alert.textFields![0].placeholder = "한 줄 평"
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "입력", style: .default, handler: { (action) in
            if let userNickname = alert.textFields![0].text {
           
                completions(userNickname)
                
            }
        }))
        
        self.present(alert, animated: true )
        
        
        
    }
    
    
}
extension ProfileController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: false)
//        let post = comments[indexPath.row]
//        let controller = PostDetailViewController(post: post)
//        self.navigationController?.pushViewController(controller, animated: true)
    }
}
extension ProfileController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCommentCell
        cell.selectionStyle = .none
        cell.backgroundColor = .systemGray6
        cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        return cell
    }
    
    
}
extension ProfileController: MyPostListViewControllerDelegate{
    func updatePost() {
        
        PostService.findMyPostsList(currentUserUid: user.uid) { post in
            print("findMyPostsList",post)
            let controller = MyPostListViewController(posts: post)
            controller.posts.removeAll()
            controller.tableView.reloadData()
        }
        print("MyPostListViewControllerDelegate")
    }
    
    
}
