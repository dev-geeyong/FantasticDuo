//
//  FeedController.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/17.
//

import  UIKit
import Firebase
private let reuseIdentifier = "Cell"


class FeedController: UIViewController {
    //MARK: - Propertie
    private var posts = [Post](){
        didSet {  tableView.reloadData()}
    }
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["전체","아/브","실","골","플","다"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegment), for: .valueChanged)
        
        return sc
    }()
    let tableView = UITableView(frame: .zero, style: .plain)
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFeed()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        handeleRefresh()
    }
    //MARK: - API
    func fetchFeed(){
        PostService.fetchFeedPosts { post in
        self.posts = post
        self.tableView.refreshControl?.endRefreshing()
    }
}
    //MARK: - Actions
    @objc func handleSegment(){
        print(segmentedControl.selectedSegmentIndex)
        
    }
    @objc func handeleRefresh(){
        posts.removeAll()
        fetchFeed()
    }
    //MARK: - Helpers
    func configureUI(){
       
        view.backgroundColor = .systemGray6
        
        let paddedStackView = UIStackView(arrangedSubviews: [segmentedControl])
        paddedStackView.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 12)
        paddedStackView.isLayoutMarginsRelativeArrangement = true
        
        let stackView = UIStackView(arrangedSubviews: [paddedStackView,tableView])
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.anchor(top:view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,bottom:view.bottomAnchor,
                         right: view.rightAnchor)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(FeedCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGray6
        
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handeleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
        
        
    }
}
extension FeedController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = posts[indexPath.row]
        let controller = PostDetailViewController(post: post)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
extension FeedController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.contentLabel.text = posts[indexPath.row].title
        cell.nicknameLabel.text = posts[indexPath.row].nickname
        cell.profileImageView.image = #imageLiteral(resourceName: "Emblem_Platinum")
        return cell
    }
    
    
}

//  extension FeedController  {
//
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
////        cell.backgroundColor = UIColor.white
////                cell.layer.borderColor = UIColor.black.cgColor
////                cell.layer.borderWidth = 1
////                cell.layer.cornerRadius = 8
////                cell.clipsToBounds = true
//        return cell
//    }
//}
//
////MARK: - UITableViewDelegate
//extension FeedController {
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//}
