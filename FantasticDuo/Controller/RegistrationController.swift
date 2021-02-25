//
//  RegistrationController.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/02.
//

import UIKit
import Firebase
import SafariServices
class RegistrationController: UIViewController {
    
    //MARK: - Properties
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    weak var delegate: AuthenticationDelegate?

    private let iconImage: UIImageView = {
       let iv = UIImageView(image: #imageLiteral(resourceName: "제목 추가 (3)"))
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    private let emailTextField: CustomTextField = {
        
        let tf = CustomTextField(placeholder: "이메일")
        tf.setHeight(50)
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
       let tf = CustomTextField(placeholder: "비밀번호")
        tf.isSecureTextEntry = true
        tf.setHeight(50)
        return tf
    }()
    private let nicknameTextField :CustomTextField = {
        let tf = CustomTextField(placeholder: "롤 소환사 이름")
         tf.setHeight(50)
         return tf
    }()
    
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(pushSignUpButton), for: .touchUpInside)
        return button
    }()
    private let alreadyAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "이미 계정이있다면  ", secondPart: "로그인 화면으로")
        button.addTarget(self, action: #selector(showloginPage), for: .touchUpInside)
        return button
    }()
    private let termsAndConditions: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "", secondPart: "가입함으로 이용약관 및 개인정보 보호정책에 동의합니다.")
        button.addTarget(self, action: #selector(showTermsAndConditions), for: .touchUpInside)
        return button
    }()
    //MARK: - Actions
    @objc func showTermsAndConditions(){
        let vc = SFSafariViewController(url: URL(string: "https://dev-geeyong.tistory.com/39")!)
        present(vc, animated: true)
    }
    @objc func showloginPage(){
        navigationController?.popViewController(animated: true)
    }
    @objc func pushSignUpButton(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let nickname = nicknameTextField.text else {return}

        let credentials = AuthCredentials(email: email, password: password, nickname: nickname)
  
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password){
            (result, error) in
            if let error = error {
                print("debug failed to register user \(error.localizedDescription)")
                self.showMessage(withTitle: "회원가입 실패", message: "이미 사용 중인 이메일이거나 입력이 잘못됐습니다.")

            }
            guard let uid = result?.user.uid else{return}
            AuthService.registerUser(withCredential: credentials, uid: uid) { (error) in
                if let error = error {
                    
                    print("debug failed to register user \(error.localizedDescription)")
                    
                }
                self.delegate?.authenticationDidComplete()
            }
        }
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField{
            viewModel.email = sender.text
        }
        else if sender == passwordTextField{
            viewModel.password = sender.text
        }
        else if sender == nicknameTextField{
            viewModel.nickname = sender.text
        }
        updateForm()

    }
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    //MARK: - Helpers
    
    func configureUI(){
    
        view.backgroundColor = #colorLiteral(red: 0.3216842711, green: 0.4426019192, blue: 1, alpha: 1)
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,nicknameTextField,signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        
        stackView.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 32, paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(termsAndConditions)
        termsAndConditions.centerX(inView: view)
        termsAndConditions.anchor(top: stackView.bottomAnchor, paddingTop: 22)
        
        view.addSubview(alreadyAccountButton)
        alreadyAccountButton.centerX(inView: view)
        alreadyAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 32)
    
    }
    func configureNotificationObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        nicknameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

//MARK: - FormViewModel
extension RegistrationController: FormViewModel{
    func updateForm() {
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signUpButton.isEnabled = true
    }
}

