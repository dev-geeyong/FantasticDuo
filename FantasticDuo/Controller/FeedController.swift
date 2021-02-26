//
//  FeedController.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/17.
//

import  UIKit
import Firebase
import SwipeCellKit
import MessageUI
private let reuseIdentifier = "Cell"


class FeedController: UIViewController {
    //MARK: - Propertie
    var TF:[Bool] = []
    
    let currentUid = Auth.auth().currentUser?.uid
    private var posts = [Post](){
        didSet {  tableView.reloadData()}
    }
    private var filteredPosts = [Post]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    let tableView = UITableView(frame: .zero, style: .plain)
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureSearchController()
        fetchFeed()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showLoader(true)
        handeleRefresh()
    }
    //MARK: - API
    func fetchFeed(){
        PostService.fetchFeedPosts { post in
        self.posts = post
    }
        showLoader(false)
}
    //MARK: - Actions
    @objc func handeleRefresh(){
        posts.removeAll()
        fetchFeed()
    }
    //MARK: - Helpers
    func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "제목 / 소환사 이름 검색"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    func configureUI(){
       
        view.backgroundColor = .systemGray6
        
        let stackView = UIStackView(arrangedSubviews: [tableView])
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.anchor(top:view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,bottom:view.bottomAnchor,
                         right: view.rightAnchor)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(FeedCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 90
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGray6
        
            
        navigationItem.title = "환상의 듀오"
        
    }
}
extension FeedController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = isSearchMode ? filteredPosts[indexPath.row] : posts[indexPath.row]
        let controller = PostDetailViewController(post: post)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension FeedController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filteredPosts.count : posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        for _ in 0...posts.count {
            self.TF.append(true)
        }
      
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        cell.selectionStyle = .none
        let user = isSearchMode ? filteredPosts[indexPath.row] : posts[indexPath.row]
        if currentUid == user.ownerUid {
            self.TF[indexPath.row] = true
        }else{
            self.TF[indexPath.row] = false
        }
        cell.viewModel = PostViewModel(post: user)
        return cell
    }
    
    
}
extension FeedController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        filteredPosts = posts.filter({
            $0.title.contains(searchText) ||
                $0.nickname.lowercased().contains(searchText)
        })
        self.tableView.reloadData()
        
    }
    
    
}
extension FeedController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
 
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
    }
}

extension FeedController: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        switch orientation {
        case .right:
            
            let deleteAction = SwipeAction(style: .destructive, title: nil, handler: {action, indexPath in
                if Auth.auth().currentUser?.uid == self.posts[indexPath.row].ownerUid{
                
                    PostService.deleteMyPost(postid: self.posts[indexPath.row].postId) { message in
                        self.showMessage(withTitle: message, message: "작성한 글 삭제완료")
                        self.posts.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    }
                
                }else{
                
                    self.mailCompose()
                    self.tableView.reloadData()
                }
                
            })
            
            deleteAction.title = self.TF[indexPath.row] ? "삭제하기" : "신고하기"
            deleteAction.image = UIImage(systemName: self.TF[indexPath.row] ? "trash.fill" : "exclamationmark.bubble")
            deleteAction.backgroundColor = self.TF[indexPath.row] ? #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) : #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
 
            return [deleteAction]

            
        case .left:
            
            let deleteAction = SwipeAction(style: .destructive, title: nil, handler: {action, indexPath in
                if Auth.auth().currentUser?.uid == self.posts[indexPath.row].ownerUid{
                
                    PostService.deleteMyPost(postid: self.posts[indexPath.row].postId) { message in
                        self.showMessage(withTitle: message, message: "작성한 글 삭제완료")
                        self.posts.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    }
                
                }else{
                
                    self.mailCompose()
                    self.tableView.reloadData()
                }
                
            })
            
            deleteAction.title = self.TF[indexPath.row] ? "삭제하기" : "신고하기"
            deleteAction.image = UIImage(systemName: self.TF[indexPath.row] ? "trash.fill" : "exclamationmark.bubble")
            deleteAction.backgroundColor = self.TF[indexPath.row] ? #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) : #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
 
            return [deleteAction]

       
        }
        
    }
       
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.transitionStyle = .drag
        
        return options
    }
    
    
}
