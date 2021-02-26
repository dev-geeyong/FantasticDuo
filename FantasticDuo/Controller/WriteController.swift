

import UIKit
import Firebase
protocol WriteControllerDelegate: class {
    func test()
}
class WriteController: UIViewController{
    //MARK: - Propertie
    weak var delegate: WriteControllerDelegate?
    var currentuser: User?
    
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["아이언","브론즈","실버","골드","플레","다이아"])
        sc.addTarget(self, action: #selector(handleSegment), for: .valueChanged)
        return sc
    }()
    private let titleTextField: CustomTextField = {
        
        let tf = CustomTextField(placeholder: "제목")
        tf.keyboardType = .default
        tf.setHeight(50)
        tf.layer.cornerRadius = 10
        return tf
    }()

    private let contentTextField: CustomTextField = {
        
        let tf = CustomTextField(placeholder: "내용")
        tf.keyboardType = .default
        tf.layer.cornerRadius = 10
        tf.setHeight(100)
        
        return tf
    }()
    private lazy var submmitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("글 올리기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = #colorLiteral(red: 0.2063752115, green: 0.5944960713, blue: 0.8571043611, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSubmmitButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor  = .white
        titleTextField.delegate = self
        contentTextField.delegate = self
        configureUI()
    }
    //MARK: - API

    //MARK: - Actions
    @objc func handleSegment(){
        print(segmentedControl.selectedSegmentIndex)
        
    }
    @objc func handleSubmmitButton(){
        print("handleSubmmitButton")
        guard let title = titleTextField.text else{ return }
        guard let content = contentTextField.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let rank = segmentedControl.selectedSegmentIndex
        
        if rank == -1 {
            showMessage(withTitle: "티어를 선택해주세요!", message: "글을 올리기위해 티어를 선택해주세요")
            return
        }
        UserService.fetchUser(withUid: uid) { (user) in
            self.showLoader(true)
            PostService.uploadPost(title: title, content: content, rank: rank, user: user) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.titleTextField.text = ""
                self.contentTextField.text = ""
                self.submmitButton.isEnabled = false
                self.showLoader(false)
                self.tabBarController?.selectedIndex = 0
            }
        }
        
        
    }
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        segmentedControl.backgroundColor = #colorLiteral(red: 0.2063752115, green: 0.5944960713, blue: 0.8571043611, alpha: 1)
        navigationItem.title = "글쓰기"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let titleTextAttributes2 = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes2, for: .selected)

        let stackView = UIStackView(arrangedSubviews: [segmentedControl,titleTextField,contentTextField,submmitButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 32, paddingLeft: 16,paddingRight: 16)
      
        
    }
  
}
extension WriteController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if titleTextField.text != "" && contentTextField.text != "" && titleTextField.text!.count < 90{
            submmitButton.isEnabled = true
            submmitButton.backgroundColor = #colorLiteral(red: 0.2063752115, green: 0.5944960713, blue: 0.8571043611, alpha: 1)
        }
        else if titleTextField.text!.count > 90 || contentTextField.text!.count > 90 {
            showMessage(withTitle: "글자수 초과", message: "90글자 이상은 글을 쓸 수 없습니다.")
            submmitButton.isEnabled = false
            submmitButton.backgroundColor = #colorLiteral(red: 0.2063752115, green: 0.5944960713, blue: 0.8571043611, alpha: 1).withAlphaComponent(0.5)
        }
        else{
            submmitButton.isEnabled = false
            submmitButton.backgroundColor = #colorLiteral(red: 0.2063752115, green: 0.5944960713, blue: 0.8571043611, alpha: 1).withAlphaComponent(0.5)
        }
    }
}
