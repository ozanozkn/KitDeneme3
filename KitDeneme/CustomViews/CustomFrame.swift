import UIKit

class CustomLabel: UILabel {
    // MARK: - Properties
    
    var hasBackground: Bool = false {
        didSet {
            updateBackground()
        }
    }
    
    // MARK: - Initializers
    
    init(text: String, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.text = text
        self.font = UIFont.systemFont(ofSize: fontSize)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        updateBackground()
        self.textAlignment = .center
    }
    
    // MARK: - Update Background
    
    private func updateBackground() {
        if hasBackground {
            backgroundColor = .white
            textColor = .black
            layer.cornerRadius = 12
            clipsToBounds = true
        } else {
            backgroundColor = .clear
            textColor = .black
            layer.cornerRadius = 0
            clipsToBounds = false
        }
    }
}
