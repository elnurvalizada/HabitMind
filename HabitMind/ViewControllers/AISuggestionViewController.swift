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
        containerView.setConstraints(leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, centerYAnchor: view.centerYAnchor, centerXAnchor: view.centerXAnchor, leadingConstant: 20, trailingConstant: -20, heightAnchor: view.heightAnchor, heightAnchorConstant: -0.2)
        headerView.setConstraints(topAnchor: containerView.topAnchor, leadingAnchor: containerView.leadingAnchor, trailingAnchor: containerView.trailingAnchor, topConstant: 24, leadingConstant: 24, trailingConstant: -24)
        titleLabel.setConstraints(topAnchor: headerView.topAnchor, leadingAnchor: headerView.leadingAnchor, trailingAnchor: headerView.trailingAnchor)
        subtitleLabel.setConstraints(topAnchor: titleLabel.bottomAnchor, bottomAnchor: headerView.bottomAnchor, leadingAnchor: headerView.leadingAnchor, trailingAnchor: headerView.trailingAnchor, topConstant: 8)
        suggestionCard.setConstraints(topAnchor: headerView.bottomAnchor, leadingAnchor: containerView.leadingAnchor, trailingAnchor: containerView.trailingAnchor, topConstant: 24, leadingConstant: 24, trailingConstant: -24)
        suggestionTitleLabel.setConstraints(topAnchor: suggestionCard.topAnchor, leadingAnchor: suggestionCard.leadingAnchor, trailingAnchor: suggestionCard.trailingAnchor, topConstant: 20, leadingConstant: 20, trailingConstant: -20)
        suggestionDescriptionLabel.setConstraints(topAnchor: suggestionTitleLabel.bottomAnchor, leadingAnchor: suggestionCard.leadingAnchor, trailingAnchor: suggestionCard.trailingAnchor, topConstant: 12, leadingConstant: 20, trailingConstant: -20)
        categoryLabel.setConstraints(topAnchor: suggestionDescriptionLabel.bottomAnchor, leadingAnchor: suggestionCard.leadingAnchor, topConstant: 16, leadingConstant: 20)
        difficultyLabel.setConstraints(topAnchor: suggestionDescriptionLabel.bottomAnchor, bottomAnchor: suggestionCard.bottomAnchor, trailingAnchor: suggestionCard.trailingAnchor, topConstant: 16, bottomConstant: -20, trailingConstant: -20)
        addHabitButton.setConstraints(topAnchor: suggestionCard.bottomAnchor, leadingAnchor: containerView.leadingAnchor, trailingAnchor: containerView.trailingAnchor, topConstant: 24, leadingConstant: 24, trailingConstant: -24, height: 50)
        dismissButton.setConstraints(topAnchor: addHabitButton.bottomAnchor, bottomAnchor: containerView.bottomAnchor, centerXAnchor: containerView.centerXAnchor, topConstant: 12, bottomConstant: -24)
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
