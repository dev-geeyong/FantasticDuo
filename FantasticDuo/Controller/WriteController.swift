

import UIKit
protocol WriteControllerDelegate: class {
    func test()
}
class WriteController: UIViewController{
    //MARK: - Propertie
    weak var delegate: WriteControllerDelegate?
    private var currentuser: User?
    init(user: User){
        self.currentuser = user
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["아/브","실","골","플","다"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegment), for: .valueChanged)
        return sc
    }()
    private let titleTextField: CustomTextField = {
        
        let tf = CustomTextField(placeholder: "제목")
        tf.keyboardType = .default
        tf.setHeight(50)
        
        return tf
    }()
    private let nicknameTextField: CustomTextField = {
        
        let tf = CustomTextField(placeholder: "롤닉네임")
        tf.setHeight(50)
        
        return tf
    }()
    private let contentTextField: CustomTextField = {
        
        let tf = CustomTextField(placeholder: "내용")
        tf.keyboardType = .default
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
        titleTextField.delegate = self
        nicknameTextField.delegate = self
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
        guard let user = currentuser else {return}
        let rank = segmentedControl.selectedSegmentIndex
        
        PostService.uploadPost(title: title, content: content, rank: rank, user: user) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.tabBarController?.selectedIndex = 0
            self.delegate?.test()
        }
        
    }
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        let paddedStackView = UIStackView(arrangedSubviews: [segmentedControl])
        paddedStackView.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 12)
        paddedStackView.isLayoutMarginsRelativeArrangement = true
        let stackView = UIStackView(arrangedSubviews: [paddedStackView,titleTextField,nicknameTextField,contentTextField,submmitButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 32, paddingLeft: 32,paddingRight: 32)
        guard let user = currentuser else {
            return
        }
        nicknameTextField.text = user.nickname
    }
  
   
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//    }
}
extension WriteController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if titleTextField.text != "" && nicknameTextField.text != "" && contentTextField.text != "" {
            submmitButton.isEnabled = true
            submmitButton.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        }
        else{
            submmitButton.isEnabled = false
            submmitButton.backgroundColor = #colorLiteral(red: 0.2063752115, green: 0.5944960713, blue: 0.8571043611, alpha: 1).withAlphaComponent(0.5)
        }
    }
}
