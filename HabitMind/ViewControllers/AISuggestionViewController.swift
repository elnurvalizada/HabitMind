//
//  AISuggestionViewController.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import UIKit

class AISuggestionViewController: RootViewController {
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "AI Suggestion"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Based on your habits and patterns"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let suggestionCard: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple.withAlphaComponent(0.1)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemPurple.withAlphaComponent(0.3).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let suggestionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let suggestionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let difficultyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addHabitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add This Habit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Maybe Later", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    private var suggestion: HabitSuggestion?
    private var onAddHabit: ((HabitSuggestion) -> Void)?
    
    // MARK: - Initialization
    init(suggestion: HabitSuggestion, onAddHabit: @escaping (HabitSuggestion) -> Void) {
        self.suggestion = suggestion
        self.onAddHabit = onAddHabit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        configureWithSuggestion()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addSubview(containerView)
        containerView.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        
        containerView.addSubview(suggestionCard)
        suggestionCard.addSubview(suggestionTitleLabel)
        suggestionCard.addSubview(suggestionDescriptionLabel)
        suggestionCard.addSubview(categoryLabel)
        suggestionCard.addSubview(difficultyLabel)
        
        containerView.addSubview(addHabitButton)
        containerView.addSubview(dismissButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container View
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.8),
            
            // Header
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            // Suggestion Card
            suggestionCard.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            suggestionCard.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            suggestionCard.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            suggestionTitleLabel.topAnchor.constraint(equalTo: suggestionCard.topAnchor, constant: 20),
            suggestionTitleLabel.leadingAnchor.constraint(equalTo: suggestionCard.leadingAnchor, constant: 20),
            suggestionTitleLabel.trailingAnchor.constraint(equalTo: suggestionCard.trailingAnchor, constant: -20),
            
            suggestionDescriptionLabel.topAnchor.constraint(equalTo: suggestionTitleLabel.bottomAnchor, constant: 12),
            suggestionDescriptionLabel.leadingAnchor.constraint(equalTo: suggestionCard.leadingAnchor, constant: 20),
            suggestionDescriptionLabel.trailingAnchor.constraint(equalTo: suggestionCard.trailingAnchor, constant: -20),
            
            categoryLabel.topAnchor.constraint(equalTo: suggestionDescriptionLabel.bottomAnchor, constant: 16),
            categoryLabel.leadingAnchor.constraint(equalTo: suggestionCard.leadingAnchor, constant: 20),
            
            difficultyLabel.topAnchor.constraint(equalTo: suggestionDescriptionLabel.bottomAnchor, constant: 16),
            difficultyLabel.trailingAnchor.constraint(equalTo: suggestionCard.trailingAnchor, constant: -20),
            difficultyLabel.bottomAnchor.constraint(equalTo: suggestionCard.bottomAnchor, constant: -20),
            
            // Buttons
            addHabitButton.topAnchor.constraint(equalTo: suggestionCard.bottomAnchor, constant: 24),
            addHabitButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            addHabitButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            addHabitButton.heightAnchor.constraint(equalToConstant: 50),
            
            dismissButton.topAnchor.constraint(equalTo: addHabitButton.bottomAnchor, constant: 12),
            dismissButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
    }
    
    private func configureWithSuggestion() {
        guard let suggestion = suggestion else { return }
        
        suggestionTitleLabel.text = suggestion.title
        suggestionDescriptionLabel.text = suggestion.description
        categoryLabel.text = suggestion.category.rawValue.capitalized
        difficultyLabel.text = suggestion.difficulty.rawValue.capitalized
    }
    
    private func setupActions() {
        addHabitButton.addTarget(self, action: #selector(addHabitTapped), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        
        // Add tap to dismiss on background
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func addHabitTapped() {
        guard let suggestion = suggestion else { return }
        onAddHabit?(suggestion)
        dismiss(animated: true)
    }
    
    @objc private func dismissTapped() {
        dismiss(animated: true)
    }
}

// MARK: - Extensions for better display
extension HabitCategory {
    var rawValue: String {
        switch self {
        case .fitness:
            return "fitness"
        case .learning:
            return "learning"
        case .wellness:
            return "wellness"
        case .health:
            return "health"
        case .productivity:
            return "productivity"
        case .personal:
            return "personal"
        }
    }
}

extension HabitDifficulty {
    var rawValue: String {
        switch self {
        case .easy:
            return "easy"
        case .medium:
            return "medium"
        case .hard:
            return "hard"
        }
    }
} 
