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
    private var filteredPosts = [Post]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
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
        configureSearchController()
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
        
        
//        let refresher = UIRefreshControl()
//        refresher.addTarget(self, action: #selector(handeleRefresh), for: .valueChanged)
//        tableView.refreshControl = refresher
        
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.selectionStyle = .none
        let user = isSearchMode ? filteredPosts[indexPath.row] : posts[indexPath.row]
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
