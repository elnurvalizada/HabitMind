//
//  HabitCardView.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import UIKit

class HabitCardView: UIView {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        // Removed gradient background to avoid static height issues
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 16
        view.layer.shadowOpacity = 0.12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let habitNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressRing: ProgressRingView = {
        let ring = ProgressRingView()
        ring.translatesAutoresizingMaskIntoConstraints = false
        ring.setRingWidth(12)
        ring.setGradientColors([UIColor.systemBlue, UIColor.systemGreen])
        ring.setShadowColor(UIColor.systemBlue.withAlphaComponent(0.25))
        return ring
    }()
    
    private let completionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.tintColor = .systemGray3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Mark as completed"
        return button
    }()
    
    private let incrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Increment progress"
        return button
    }()
    private let decrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Decrement progress"
        return button
    }()
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    var sizeOfProgressLabel: CGFloat = 20 {
        didSet {
            progressLabel.font = .systemFont(ofSize: sizeOfProgressLabel, weight: .medium)
        }
    }
    var habit: Habit? {
        didSet {
            updateUI()
        }
    }
    var isCompleted: Bool = false {
        didSet {
            updateCompletionUI()
        }
    }
    var onCompletionToggled: ((Habit, Bool) -> Void)?
    
    private var progressRingWidthConstraint: NSLayoutConstraint?
    private var progressRingHeightConstraint: NSLayoutConstraint?
    
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
        addSubview(containerView)
        containerView.addSubview(habitNameLabel)
        containerView.addSubview(categoryLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(progressRing)
        containerView.addSubview(completionButton)
        containerView.addSubview(incrementButton)
        containerView.addSubview(decrementButton)
        containerView.addSubview(progressLabel)
        completionButton.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
        incrementButton.addTarget(self, action: #selector(incrementTapped), for: .touchUpInside)
        decrementButton.addTarget(self, action: #selector(decrementTapped), for: .touchUpInside)
        containerView.bringSubviewToFront(completionButton) // <-- Add this line
        progressRing.isUserInteractionEnabled = false
    }
    
    private func setupConstraints() {
        progressRingWidthConstraint = progressRing.widthAnchor.constraint(equalToConstant: 84)
        progressRingHeightConstraint = progressRing.heightAnchor.constraint(equalToConstant: 84)
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Progress ring (right side, larger)
            progressRing.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            progressRing.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -36),
            progressRingWidthConstraint!,
            progressRingHeightConstraint!,

            // Completion button (top right, above ring)
            completionButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            completionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            completionButton.widthAnchor.constraint(equalToConstant: 32),
            completionButton.heightAnchor.constraint(equalToConstant: 32),

            // Increment/Decrement buttons and progress label (below ring)
            incrementButton.topAnchor.constraint(equalTo: progressRing.bottomAnchor, constant: 8),
            incrementButton.centerXAnchor.constraint(equalTo: progressRing.centerXAnchor, constant: 18),
            incrementButton.widthAnchor.constraint(equalToConstant: 28),
            incrementButton.heightAnchor.constraint(equalToConstant: 28),
            decrementButton.topAnchor.constraint(equalTo: progressRing.bottomAnchor, constant: 8),
            decrementButton.centerXAnchor.constraint(equalTo: progressRing.centerXAnchor, constant: -18),
            decrementButton.widthAnchor.constraint(equalToConstant: 28),
            decrementButton.heightAnchor.constraint(equalToConstant: 28),
            progressLabel.topAnchor.constraint(equalTo: incrementButton.bottomAnchor, constant: 2),
            progressLabel.centerXAnchor.constraint(equalTo: progressRing.centerXAnchor),
            progressLabel.widthAnchor.constraint(equalToConstant: 60),
            progressLabel.heightAnchor.constraint(equalToConstant: 18),
            progressLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),

            // Habit name
            habitNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            habitNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            habitNameLabel.trailingAnchor.constraint(equalTo: progressRing.leadingAnchor, constant: -20),

            // Category
            categoryLabel.topAnchor.constraint(equalTo: habitNameLabel.bottomAnchor, constant: 6),
            categoryLabel.leadingAnchor.constraint(equalTo: habitNameLabel.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: habitNameLabel.trailingAnchor),

            // Time
            timeLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: habitNameLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: habitNameLabel.trailingAnchor)
        ])
    }
    
    // MARK: - UI Updates
    private func updateUI() {
        guard let habit = habit else { return }
        habitNameLabel.text = habit.name
        categoryLabel.text = habit.category.uppercased()
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeLabel.text = timeFormatter.string(from: habit.time)
        // Use partial progress if targetValue > 1
        if habit.targetValue > 1 {
            let percent = Int(habit.progress * 100)
            progressRing.setProgressWithPercentage(percent, subtitle: "Completed")
            progressLabel.text = "\(habit.currentValue)/\(habit.targetValue)"
            incrementButton.isHidden = false
            decrementButton.isHidden = false
            progressLabel.isHidden = false
            updateButtonStates()
        } else {
            let percent = habit.isCompleted(for: Date()) ? 100 : 0
            progressRing.setProgressWithPercentage(percent, subtitle: "Completed")
            progressLabel.isHidden = true
            incrementButton.isHidden = true
            decrementButton.isHidden = true
        }
        progressRing.setRingWidth(14)
        progressRing.setGradientColors([UIColor.systemBlue, UIColor.systemGreen])
        progressRing.setShadowColor(UIColor.systemBlue.withAlphaComponent(0.25))
        isCompleted = habit.progress >= 1.0
    }
    
    private func updateButtonStates() {
        guard let habit = habit else { return }
        
        // Increment button: enabled if current value is less than target value
        incrementButton.isEnabled = habit.currentValue < habit.targetValue
        
        // Decrement button: enabled if current value is greater than 0
        decrementButton.isEnabled = habit.currentValue > 0
    }

    private func updateCompletionUI() {
        if isCompleted {
            completionButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            completionButton.tintColor = .systemGreen
            // Only set ring to 100% if completed
            progressRing.setProgressWithPercentage(100, subtitle: "Completed")
        } else {
            completionButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            completionButton.tintColor = .systemGray3
            // Do NOT set progress ring here, let updateUI handle it
        }
    }

    @objc private func completionButtonTapped() {
        print("Pressed completion button")
        guard var habit = habit else {
            print("Errorr")
            return
        }
        isCompleted.toggle()
        if isCompleted {
            progressRing.setProgressWithPercentage(100, subtitle: "Completed")
            habit.currentValue = habit.targetValue
        } else {
            progressRing.setProgressWithPercentage(0, subtitle: "Completed")
            habit.currentValue = 0
        }
        // Save the updated habit
        HabitDataManager.shared.saveHabit(habit)
        // Reload the updated habit from storage
        if let updatedHabit = HabitDataManager.shared.getAllHabits().first(where: { $0.id == habit.id }) {
            self.habit = updatedHabit // triggers updateUI which calls updateButtonStates()
            onCompletionToggled?(updatedHabit, updatedHabit.progress >= 1.0)
        }
    }

    @objc private func incrementTapped() {
        guard let habit = habit else { return }
        HabitDataManager.shared.incrementHabitProgress(habit)
        // Reload the updated habit from storage
        if let updatedHabit = HabitDataManager.shared.getAllHabits().first(where: { $0.id == habit.id }) {
            self.habit = updatedHabit // triggers updateUI which calls updateButtonStates()
            onCompletionToggled?(updatedHabit, updatedHabit.progress >= 1.0)
        }
    }
    @objc private func decrementTapped() {
        guard let habit = habit else { return }
        // Custom logic for decrement: set currentValue to max(0, currentValue-1) and save
        var updatedHabit = habit
        if updatedHabit.currentValue > 0 {
            updatedHabit.currentValue -= 1
            if updatedHabit.currentValue < updatedHabit.targetValue {
                let formatter = ISO8601DateFormatter()
                let key = formatter.string(from: Date().startOfDay)
                updatedHabit.completionHistory[key] = false
            }
            updatedHabit.lastModified = Date()
            HabitDataManager.shared.saveHabit(updatedHabit)
            // Reload the updated habit from storage
            if let refreshedHabit = HabitDataManager.shared.getAllHabits().first(where: { $0.id == habit.id }) {
                self.habit = refreshedHabit // triggers updateUI which calls updateButtonStates()
                onCompletionToggled?(refreshedHabit, refreshedHabit.progress >= 1.0)
            }
        }
    }

    // MARK: - Public Methods
    func configure(with habit: Habit) {
        self.habit = habit
    }
    func setCompleted(_ completed: Bool) {
        isCompleted = completed
        if completed {
            progressRing.setProgressWithPercentage(100, subtitle: "Completed")
        } 
    }
} 
