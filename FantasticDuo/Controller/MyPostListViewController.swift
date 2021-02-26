//
//  MyPostListViewController.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/24.
//

import UIKit
import Firebase
import SwipeCellKit
protocol MyPostListViewControllerDelegate: class{
    func updatePost()
}
private let reuseIdentifier = "MyPostListCell"
class MyPostListViewController: UITableViewController{
    //MARK: - Propertie
    var posts: [Post]
    weak var delegate: MyPostListViewControllerDelegate?
    //MARK: - Lifecycle
    init(posts: [Post]){
        self.posts = posts
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    //MARK: - API
    //MARK: - Actions
    //MARK: - Helpers
    func configureTableView(){
        navigationItem.title = "스와이프로 글 삭제"
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemGray6
        tableView.register(ProfileCommentCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        
    }
}

extension MyPostListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
}
extension MyPostListViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCommentCell
        cell.contentLabel.text = posts[indexPath.row].title
        cell.delegate = self
        return cell
    }
    
    
}
extension MyPostListViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        switch orientation {
        case .right:
            
            let deleteAction = SwipeAction(style: .destructive, title: nil, handler: {action, indexPath in
                
                PostService.deleteMyPost(postid: self.posts[indexPath.row].postId) { message in
                    self.showMessage(withTitle: message, message: "작성한 글 삭제완료")
                    self.posts.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
                
                
            })
            deleteAction.title = "삭제하기"
            deleteAction.image = UIImage(systemName: "trash.fill")
            deleteAction.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
 
            return [deleteAction]
            
        case .left:
            
            let deleteAction = SwipeAction(style: .destructive, title: nil, handler: {action, indexPath in
                
                PostService.deleteMyPost(postid: self.posts[indexPath.row].postId) { message in
                    self.showMessage(withTitle: message, message: "작성한 글 삭제완료")
                    self.posts.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
                          
                
            })
            deleteAction.title = "삭제하기"
            deleteAction.image = UIImage(systemName: "trash.fill")
            deleteAction.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
 
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
