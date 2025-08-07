//
//  AISuggestionCardView.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import UIKit

protocol AISuggestionCardViewDelegate: AnyObject {
    func aiCardTapped()
}

class AISuggestionCardView: UIView {
    weak var delegate: AISuggestionCardViewDelegate?
    
    private let gradientLayer = CAGradientLayer()
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label;
    }()
    private let aiLabel: UILabel = {
        let label = UILabel()
        label.text = "AI"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.alpha = 0 // hidden initially
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var compactMode = false
    private var widthConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 14
        layer.masksToBounds = true
        setupGradient()
        setupTapGesture()
        addSubview(label)
        addSubview(aiLabel)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            aiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            aiLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        widthConstraint = widthAnchor.constraint(equalToConstant: 120)
        widthConstraint?.isActive = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGradient() {
        gradientLayer.colors = [UIColor.systemPurple.cgColor, UIColor.systemIndigo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        // Add a subtle animation for feedback
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }
        
        delegate?.aiCardTapped()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func configure(text: String) {
        label.text = text
    }
    
    func animateToCompactMode() {
        guard !compactMode else { return }
        compactMode = true
        guard let superview = superview else { return }
        let targetHeight = frame.height
        widthConstraint?.isActive = false
        widthConstraint = widthAnchor.constraint(equalToConstant: targetHeight)
        widthConstraint?.isActive = true
        // Animate layout and corner radius together
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseInOut], animations: {
            self.layer.cornerRadius = targetHeight / 2
            self.layoutIfNeeded()
        }, completion: nil)
        // Crossfade label and AI label
        UIView.transition(with: self, duration: 0.4, options: [.transitionCrossDissolve], animations: {
            self.label.alpha = 0
            self.aiLabel.alpha = 1
        }, completion: nil)
    }
} 
