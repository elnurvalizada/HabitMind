//
//  ProgressRingView.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import UIKit

class ProgressRingView: UIView {
    // MARK: - UI Elements
    private let backgroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    private let percentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Properties
    private var progress: CGFloat = 0.0
    private var ringWidth: CGFloat = 20.0 {
        didSet {
            backgroundLayer.lineWidth = ringWidth
            progressLayer.lineWidth = ringWidth
            setNeedsLayout()
        }
    }
    private var animationDuration: TimeInterval = 0.8
    private var gradientColors: [UIColor] = [UIColor.systemBlue, UIColor.systemGreen]
    private var shadowColor: UIColor = UIColor.systemBlue.withAlphaComponent(0.25)
    private var currentPercent: Int = 0
    // (Removed) Label animation state – label now updates instantly
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        // Background track
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = UIColor.systemGray5.withAlphaComponent(0.4).cgColor
        backgroundLayer.lineWidth = ringWidth
        backgroundLayer.lineCap = .round
        layer.addSublayer(backgroundLayer)
        // Progress ring
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.systemBlue.cgColor // fallback
        progressLayer.lineWidth = ringWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        // Gradient
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.mask = progressLayer
        layer.addSublayer(gradientLayer)
        // Shadow for progress
        progressLayer.shadowColor = shadowColor.cgColor
        progressLayer.shadowRadius = 10
        progressLayer.shadowOpacity = 0.25
        progressLayer.shadowOffset = CGSize(width: 0, height: 2)
        // Center label
        addSubview(percentLabel)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            percentLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePaths()
        gradientLayer.frame = bounds
    }
    private func updatePaths() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - ringWidth / 2
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        backgroundLayer.path = path.cgPath
        progressLayer.path = path.cgPath
    }
    // MARK: - Progress Updates
    private func updateProgress(animated: Bool, to percent: Int) {
        let clamped = max(0, min(100, percent))
        let fromValue = progressLayer.presentation()?.strokeEnd ?? progressLayer.strokeEnd
        let toValue = CGFloat(clamped) / 100.0
        // Always update label instantly (no label animation)
        percentLabel.text = "\(clamped)%"

        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.duration = animationDuration
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            progressLayer.strokeEnd = toValue
            progressLayer.add(animation, forKey: "progress")
        } else {
            progressLayer.strokeEnd = toValue
        }
        // Pulse on 100%
        if clamped == 100 && animated {
            UIView.animate(withDuration: 0.15, animations: {
                self.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            }) { _ in
                UIView.animate(withDuration: 0.15) {
                    self.transform = .identity
                }
            }
        }
        currentPercent = clamped
    }
    // (Removed) animateLabel and updateLabel – label updates are immediate
    // MARK: - Public Methods
    func setProgressWithPercentage(_ percentage: Int, subtitle: String? = nil, animated: Bool = true) {
        updateProgress(animated: animated, to: percentage)
    }
    func setRingWidth(_ width: CGFloat) {
        ringWidth = width
    }
    func setGradientColors(_ colors: [UIColor]) {
        gradientColors = colors
        gradientLayer.colors = colors.map { $0.cgColor }
    }
    func setShadowColor(_ color: UIColor) {
        shadowColor = color
        progressLayer.shadowColor = color.cgColor
    }
    func setAnimationDuration(_ duration: TimeInterval) {
        animationDuration = duration
    }
    func reset() {
        setProgressWithPercentage(0, animated: false)
    }
} 
