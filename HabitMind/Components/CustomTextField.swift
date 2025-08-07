//
//  CustomTextField.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import UIKit

enum TextFieldStyle {
    case standard
    case rounded
    case outlined
}

class CustomTextField: UITextField {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    private var textFieldStyle: TextFieldStyle = .standard
    private var validationRule: ((String) -> Bool)?
    private var errorMessage: String = "Invalid input"
    
    var isValid: Bool {
        guard let text = text, !text.isEmpty else { return false }
        return validationRule?(text) ?? true
    }
    
    var onTextChanged: ((String) -> Void)?
    var onValidationChanged: ((Bool) -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    convenience init(placeholder: String, style: TextFieldStyle = .standard) {
        self.init(frame: .zero)
        self.textFieldStyle = style
        self.placeholder = placeholder
        setupTextField()
    }
    
    // MARK: - Setup
    private func setupTextField() {
        font = .systemFont(ofSize: 16, weight: .medium)
        textColor = .label
        backgroundColor = .clear
        borderStyle = .none
        
        // Set minimum height
        heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        applyStyle()
        setupActions()
    }
    
    private func applyStyle() {
        switch textFieldStyle {
        case .standard:
            layer.cornerRadius = 8
            layer.borderWidth = 1
            layer.borderColor = UIColor.systemGray4.cgColor
            backgroundColor = .systemGray6
            
        case .rounded:
            layer.cornerRadius = 22
            layer.borderWidth = 1
            layer.borderColor = UIColor.systemGray4.cgColor
            backgroundColor = .systemGray6
            
        case .outlined:
            layer.cornerRadius = 12
            layer.borderWidth = 2
            layer.borderColor = UIColor.systemBlue.cgColor
            backgroundColor = .clear
        }
    }
    
    private func setupActions() {
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange() {
        let text = self.text ?? ""
        onTextChanged?(text)
        validateInput()
    }
    
    @objc private func textFieldDidBeginEditing() {
        UIView.animate(withDuration: 0.2) {
            self.layer.borderColor = UIColor.systemBlue.cgColor
            self.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
        }
    }
    
    @objc private func textFieldDidEndEditing() {
        UIView.animate(withDuration: 0.2) {
            self.layer.borderColor = UIColor.systemGray4.cgColor
            self.transform = .identity
        }
        validateInput()
    }
    
    // MARK: - Validation
    private func validateInput() {
        let valid = isValid
        onValidationChanged?(valid)
        
        if !valid && !(text?.isEmpty ?? true) {
            showError(errorMessage)
        } else {
            hideError()
        }
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        
        UIView.animate(withDuration: 0.2) {
            self.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
    
    private func hideError() {
        errorLabel.isHidden = true
        
        UIView.animate(withDuration: 0.2) {
            self.layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
    
    // MARK: - Public Methods
    func setStyle(_ style: TextFieldStyle) {
        textFieldStyle = style
        applyStyle()
    }
    
    func setIcon(_ iconName: String) {
        iconImageView.image = UIImage(systemName: iconName)
        
        // Add left view with icon
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        iconContainer.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor, constant: 10),
            iconImageView.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor),
            iconImageView.topAnchor.constraint(equalTo: iconContainer.topAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 22),
            iconImageView.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        leftView = iconContainer
        leftViewMode = .always
    }
    
    func setValidation(rule: @escaping (String) -> Bool, errorMessage: String) {
        self.validationRule = rule
        self.errorMessage = errorMessage
    }
    
    func setErrorLabel(_ label: UILabel) {
        errorLabel.removeFromSuperview()
        errorLabel = label
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func clearText() {
        text = ""
        hideError()
    }
    
    // MARK: - Override Methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.placeholderRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
} 
