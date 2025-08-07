//
//  EmptyStateView.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import UIKit

class EmptyStateView: UIView {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionButton: CustomButton = {
        let button = CustomButton(title: "Get Started", style: .primary)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    var onActionTapped: (() -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    convenience init(title: String, subtitle: String, icon: String, actionTitle: String? = nil) {
        self.init(frame: .zero)
        configure(title: title, subtitle: subtitle, icon: icon, actionTitle: actionTitle)
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(actionButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            // Icon
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            // Action button
            actionButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func setupActions() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func actionButtonTapped() {
        onActionTapped?()
    }
    
    // MARK: - Public Methods
    func configure(title: String, subtitle: String, icon: String, actionTitle: String? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        iconImageView.image = UIImage(systemName: icon)
        
        if let actionTitle = actionTitle {
            actionButton.setTitle(actionTitle)
            actionButton.isHidden = false
        } else {
            actionButton.isHidden = true
        }
    }
    
    func setActionButton(title: String, style: ButtonStyle = .primary) {
        actionButton.setTitle(title)
        actionButton.setStyle(style)
        actionButton.isHidden = false
    }
    
    func hideActionButton() {
        actionButton.isHidden = true
    }
    
    func showActionButton() {
        actionButton.isHidden = false
    }
    
    // MARK: - Predefined Configurations
    static func noHabitsView() -> EmptyStateView {
        return EmptyStateView(
            title: "No Habits Yet",
            subtitle: "Start building better habits by adding your first one. Small steps lead to big changes!",
            icon: "list.bullet.clipboard",
            actionTitle: "Add Your First Habit"
        )
    }
    
    static func noCompletedHabitsView() -> EmptyStateView {
        return EmptyStateView(
            title: "No Completed Habits",
            subtitle: "Complete your first habit today to start building momentum and see your progress!",
            icon: "checkmark.circle",
            actionTitle: "Complete a Habit"
        )
    }
    
    static func noDataView() -> EmptyStateView {
        return EmptyStateView(
            title: "No Data Available",
            subtitle: "There's no data to display at the moment. Check back later!",
            icon: "chart.bar",
            actionTitle: nil
        )
    }
    
    static func errorView() -> EmptyStateView {
        return EmptyStateView(
            title: "Something Went Wrong",
            subtitle: "We encountered an error. Please try again or contact support if the problem persists.",
            icon: "exclamationmark.triangle",
            actionTitle: "Try Again"
        )
    }
} 