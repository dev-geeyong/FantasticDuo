//
//  MainTabController.swift
//  FantasticDuo
//
//  Created by dev.geeyong on 2021/02/17.
//

import UIKit
import Firebase
class MainTabController: UITabBarController{
    
    //MARK: - Propertie
    var user: User? {
        didSet{
            guard let user = user else{return}
            configureViewController(withUser: user)
        }
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        checkIfUserIsLoggedIn()
        fetchUser()
    }
    //MARK: - API
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.fetchUser(withUid: uid) { user in
            self.user = user
            print(user.nickname)
        }
    }
    //MARK: - Actions
    //MARK: - Helpers
    func configureViewController(withUser user: User){
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController())
        let write = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: WriteController())
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: ProfileController(user: user))
        
        
        viewControllers = [feed,write,profile]
        tabBar.tintColor = .black
    }
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController{
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser == nil{ //로그인 상태가 아니면 로그인 화면으로
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
}
//MARK: - AuthenticationDelegate

extension MainTabController: AuthenticationDelegate{
    func authenticationDidComplete() {
        print("authenticationDidComplete")
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
