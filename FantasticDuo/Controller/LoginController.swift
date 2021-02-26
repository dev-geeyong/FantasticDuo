//
//  LoginController.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/02.
//

import UIKit
import AuthenticationServices
import CryptoKit
import Firebase

protocol AuthenticationDelegate: class {
    func authenticationDidComplete()
}
class LoginController: UIViewController {

    //MARK: - Properties
    var viewModel = LoginViewModel()
    var appleLoginUid: String?
    var usernickname: String?
    private var currentNonce: String?
    weak var delegate: AuthenticationDelegate?
    
    private let iconImage: UIImageView = {
       let iv = UIImageView(image: #imageLiteral(resourceName: "제목 추가 (3)"))
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    private let emailTextField: CustomTextField = {
        
        let tf = CustomTextField(placeholder: "이메일")
        tf.layer.cornerRadius = 10
        tf.setHeight(50)
        
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
       let tf = CustomTextField(placeholder: "비밀번호")
        tf.layer.cornerRadius = 10
        tf.setHeight(50)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let appleLoginButton: UIControl = {
       let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(handleSignInWithAppleTapped), for: .touchUpInside)
        button.setHeight(50)
        return button
    }()
    ////////////////////
    
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(pushLoginButton), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "계정이 없으신가요 ? ", secondPart: "간편 회원가입 ! ")
        button.addTarget(self, action: #selector(showSignUpPage), for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        configureNotificationObservers()
    }

    //MARK: - Actions
    @objc func handleSignInWithAppleTapped(){
        currentNonce = randomNonceString()
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email,.fullName]
        request.nonce = sha256(currentNonce!)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    @objc func pushLoginButton(){
        guard let email = emailTextField.text else{return}
        guard let password = passwordTextField.text else{return}
        
        AuthService.logUserIn(withEmail: email, password: password){(result, error) in
            if let error = error {
                print("debug failed to log user in \(error.localizedDescription)")
                self.showMessage(withTitle: "로그인 실패", message: "계정을 다시 확인해주세요")
                return
            }
            self.delegate?.authenticationDidComplete()
            //self.dismiss(animated: true, completion: nil)

        }
    }
    @objc func handleShowResetPassword(){
//        let controller = ResetPasswordController()
//        controller.delegate = self
//        navigationController?.pushViewController(controller, animated: true)
    }
    @objc func showSignUpPage(){
        let page = RegistrationController()
        page.delegate = delegate
        navigationController?.pushViewController(page, animated: true)
        
    }
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField{
            viewModel.email = sender.text
        }
        else{
            viewModel.password = sender.text
        }
        updateForm()
    }
    //MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = #colorLiteral(red: 0.3216842711, green: 0.4426019192, blue: 1, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        //configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton,appleLoginButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 32, paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor ,paddingBottom: 32)
        
        
    }
    func configureNotificationObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    func showAlert(completions: @escaping(String)->Void){
        
        let alert = UIAlertController(title: "소환사 이름입력", message: "환상의 듀오를 찾을 소환사 이름을 입력해주세요", preferredStyle: .alert)
        alert.addTextField()
        alert.textFields![0].placeholder = "소환사 이름"
        alert.addAction(UIAlertAction(title: "입력", style: .default, handler: { (action) in
            if let userNickname = alert.textFields![0].text {
                if userNickname == ""{
                    self.showMessage(withTitle: "소환사 이름을 다시 입력해주세요", message: "이름에러")
                    return
                }
                completions(userNickname)
                
            }
        }))
        
        self.present(alert, animated: true )
        
        
        
    }
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName,.email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
    }
    //https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
   

    // Unhashed nonce.


    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}

extension LoginController: FormViewModel{
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = true
    }

}
//MARK: - apple login

extension LoginController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    
    if let nonce = currentNonce,
       let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
       let appleIDToken = appleIDCredential.identityToken,
       let appleIDTokenString = String(data: appleIDToken, encoding: .utf8){
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: appleIDTokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                print("apple eeor ", error)
                self.showMessage(withTitle: "로그인 실패", message: "계정을 다시 확인해주세요")
            }
            self.showAlert(){ nickname in
                self.usernickname = nickname
                if let nickName = self.usernickname {
                    print("cjt samsung",nickName)
                    if let uid = result?.user.uid{
                        print("samsung",uid)
                            AuthService.registerAppleLogin(uid: uid, nickname: nickName) { (error) in
                                if let error = error {
                                    print(error)
                                    return
                                }
                                print("succes")
                                self.delegate?.authenticationDidComplete()
                            }
     
                    }
                }
                
            }
            
          
        }
    }
  }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}
  
    
  
