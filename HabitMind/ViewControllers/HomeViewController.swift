//
//  HomeViewController.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import UIKit

class HomeViewController: RootViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressSummaryCard: ProgressSummaryCardView = {
        let card = ProgressSummaryCardView()
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    private let habitsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView.noHabitsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let aiSuggestionCard: AISuggestionCardView = {
        let card = AISuggestionCardView()
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    // MARK: - Properties
    private var todayHabits: [Habit] = []
    private var allHabits: [Habit] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        updateGreeting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHabits()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.aiSuggestionCard.animateToCompactMode()
        }
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "HabitMind"
        
        // Add navigation bar items
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chart.bar"),
            style: .plain,
            target: self,
            action: #selector(statisticsTapped)
        )
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerView)
        headerView.addSubview(headerStack)
        headerStack.addArrangedSubview(greetingLabel)
        headerStack.addArrangedSubview(aiSuggestionCard)
        headerView.addSubview(dateLabel)
        
        contentView.addSubview(progressSummaryCard)
        
        contentView.addSubview(habitsStackView)
        contentView.addSubview(emptyStateView)
        
        // Set up AI card delegate
        aiSuggestionCard.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            // HeaderStack (greeting + ai card)
            headerStack.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            aiSuggestionCard.widthAnchor.constraint(equalToConstant: 120),
            aiSuggestionCard.heightAnchor.constraint(equalToConstant: 40),
            // Date label below stack
            dateLabel.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            // Progress Summary Card
            progressSummaryCard.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            progressSummaryCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressSummaryCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            progressSummaryCard.heightAnchor.constraint(equalToConstant: 200),
            
            // Habits Stack View
            habitsStackView.topAnchor.constraint(equalTo: progressSummaryCard.bottomAnchor, constant: 24),
            habitsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            habitsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Empty State
            emptyStateView.topAnchor.constraint(equalTo: habitsStackView.bottomAnchor, constant: 20),
            emptyStateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emptyStateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emptyStateView.heightAnchor.constraint(equalToConstant: 200),
            emptyStateView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    
    // MARK: - Data Loading
    private func loadHabits() {
        allHabits = HabitDataManager.shared.getAllHabits()
        todayHabits = HabitDataManager.shared.getHabitsForToday()
    }
    
    // MARK: - UI Updates
    private func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        let greeting: String
        
        switch hour {
        case 5..<12:
            greeting = "Good Morning"
        case 12..<17:
            greeting = "Good Afternoon"
        case 17..<22:
            greeting = "Good Evening"
        default:
            greeting = "Good Night"
        }
        
        greetingLabel.text = greeting
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        dateLabel.text = dateFormatter.string(from: Date())
    }
    
    private func updateUI() {
        updateProgressView()
        updateHabitsList()
        updateEmptyState()
        updateAISuggestion()
    }
    
    private func updateProgressView() {
        let completedCount = todayHabits.filter { $0.isCompleted(for: Date()) }.count
        let totalCount = todayHabits.count
        print("completedCount: \(completedCount)")
        print("totalCount: \(totalCount)")
        print("Todays Habits: \(todayHabits)")
        
        progressSummaryCard.configure(completed: completedCount, total: totalCount)
    }
    
    private func updateHabitsList() {
        // Clear existing habit cards
        habitsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for habit in todayHabits {
            let habitCard = HabitCardView()
            habitCard.configure(with: habit)
            habitCard.onCompletionToggled = { [weak self] _, _ in
                self?.loadHabits()
                self?.updateUI()
            }
            habitsStackView.addArrangedSubview(habitCard)
        }
    }
    
    private func updateEmptyState() {
        emptyStateView.isHidden = !todayHabits.isEmpty
    }
    
    private func updateAISuggestion() {
        // Use a short suggestion for the top-right box
        if todayHabits.isEmpty {
            aiSuggestionCard.configure(text: "Try a new habit!")
        } else {
            aiSuggestionCard.configure(text: "AI Suggest...")
        }
    }
    
    private func showAISuggestion() {
        let suggestion = AIManager.shared.getHabitSuggestion(
            for: allHabits,
            timeOfDay: TimeOfDay.current()
        )
        
        let aiVC = AISuggestionViewController(suggestion: suggestion) { [weak self] suggestion in
            self?.createHabitFromSuggestion(suggestion)
        }
        
        aiVC.modalPresentationStyle = .overFullScreen
        aiVC.modalTransitionStyle = .crossDissolve
        present(aiVC, animated: true)
    }
    
    private func createHabitFromSuggestion(_ suggestion: HabitSuggestion) {
        let formVC = HabitFormViewController()
        formVC.presetHabitData(
            title: suggestion.title,
            description: suggestion.description,
            category: suggestion.category
        )
        
        presentWithNavigation(formVC)
    }
    
    // MARK: - Actions
    @objc private func addHabitTapped() {
        let formVC = HabitFormViewController()
        presentWithNavigation(formVC)
    }
    
    @objc private func statisticsTapped() {
        // TODO: Navigate to statistics screen
        print("Statistics tapped")
    }
    
    private func handleHabitCompletion(_ habit: Habit, isCompleted: Bool) {
        HabitDataManager.shared.updateHabitCompletion(habit, isCompleted: isCompleted)
        updateProgressView()
        updateAISuggestion()
    }
}

extension HomeViewController {
    override func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        loadHabits()
        updateUI()
    }
}

extension HomeViewController: AISuggestionCardViewDelegate {
    func aiCardTapped() {
        showAISuggestion()
    }
} 
