//
//  CustomButton.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import UIKit

enum ButtonStyle {
    case primary
    case secondary
    case outline
    case destructive
    case success
}

class CustomButton: UIButton {
    
    // MARK: - Properties
    private var buttonStyle: ButtonStyle = .primary
    private var originalTitle: String?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    convenience init(title: String, style: ButtonStyle = .primary) {
        self.init(type: .system)
        self.buttonStyle = style
        self.originalTitle = title
        setTitle(title, for: .normal)
        setupButton()
    }
    
    // MARK: - Setup
    private func setupButton() {
        layer.cornerRadius = 12
        titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        translatesAutoresizingMaskIntoConstraints = false
        
        // Set minimum height
        heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        applyStyle()
    }
    
    private func applyStyle() {
        switch buttonStyle {
        case .primary:
            backgroundColor = .systemBlue
            setTitleColor(.white, for: .normal)
            layer.borderWidth = 0
            
        case .secondary:
            backgroundColor = .systemGray5
            setTitleColor(.label, for: .normal)
            layer.borderWidth = 0
            
        case .outline:
            backgroundColor = .clear
            setTitleColor(.systemBlue, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = UIColor.systemBlue.cgColor
            
        case .destructive:
            backgroundColor = .systemRed
            setTitleColor(.white, for: .normal)
            layer.borderWidth = 0
            
        case .success:
            backgroundColor = .systemGreen
            setTitleColor(.white, for: .normal)
            layer.borderWidth = 0
        }
    }
    
    // MARK: - Override Methods
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.alpha = self.isHighlighted ? 0.7 : 1.0
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    // MARK: - Public Methods
    func setStyle(_ style: ButtonStyle) {
        buttonStyle = style
        applyStyle()
    }
    
    func setTitle(_ title: String) {
        originalTitle = title
        setTitle(title, for: .normal)
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            originalTitle = title(for: .normal)
            setTitle("Loading...", for: .normal)
            isEnabled = false
        } else {
            setTitle(originalTitle, for: .normal)
            isEnabled = true
        }
    }
    
    func addIcon(_ iconName: String, position: NSDirectionalRectEdge = .leading) {
        let image = UIImage(systemName: iconName)
        setImage(image, for: .normal)
        
        if position == .leading {
            semanticContentAttribute = .forceLeftToRight
        } else {
            semanticContentAttribute = .forceRightToLeft
        }
        
        // Add spacing between icon and text
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
} 