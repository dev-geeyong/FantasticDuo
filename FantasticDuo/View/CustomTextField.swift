

import UIKit

class CustomTextField: UITextField {
    init(placeholder: String){
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        layer.cornerRadius = 10
        keyboardType = .emailAddress
        borderStyle = .none
        textColor = .black
        keyboardAppearance = .dark
        backgroundColor = .systemGray6
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(red: 0.3451, green: 0.4392, blue: 0.9647, alpha: 1.0) ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
