

import UIKit

class CustomTextField: UITextField {
    init(placeholder: String){
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        keyboardType = .emailAddress
        borderStyle = .none
        textColor = .black
        keyboardAppearance = .dark
        backgroundColor = .systemGray6
     
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(red: 1, green: 165/255, blue: 0, alpha: 1)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
