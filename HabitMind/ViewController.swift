//
//  ViewController.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import UIKit

class ViewController: UIViewController {

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
    private let habitCard: HabitCardView = {
        let card = HabitCardView()
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    private let button: CustomButton = {
        let button = CustomButton(title: "Save Habit", style: .primary)
        button.addIcon("checkmark", position: .leading)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button;
    }()
    private let textField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Habit name", style: .standard)
        tf.setIcon("pencil")
        tf.setValidation(rule: { $0.count >= 3 }, errorMessage: "At least 3 characters")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    private let daySelector: DaySelectorView = {
        let selector = DaySelectorView()
        selector.setSelectedDays([2,3,4,5,6])
        selector.translatesAutoresizingMaskIntoConstraints = false
        return selector
    }()
    private let emptyView: EmptyStateView = {
        let view = EmptyStateView.noHabitsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let timePicker: TimePickerView = {
        let picker = TimePickerView(initialTime: Date())
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupDemoUI()
        
        // Setup completion handler for the habit card
        habitCard.onCompletionToggled = { [weak self] habit, isCompleted in
            print("Habit \(habit.name) completion toggled: \(isCompleted), progress: \(habit.currentValue)/\(habit.targetValue)")
            if isCompleted {
                self?.habitCard.setCompleted(true)
            } else {
                self?.habitCard.setCompleted(false)
            }
        }
    }

    private func setupDemoUI() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        let spacing: CGFloat = 32
        var lastView: UIView? = nil

        // 1. HabitCardView
        let dummyHabit = Habit(
            name: "Drink Water",
            category: "Health",
            time: Date(),
            repeatDays: [2,3,4,5,6],
            targetValue: 8 // e.g., 8 glasses of water
        )
        habitCard.configure(with: dummyHabit)
        contentView.addSubview(habitCard)
        NSLayoutConstraint.activate([
            habitCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            habitCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            habitCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        lastView = habitCard

        

        // 3. CustomButton
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: spacing),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
        lastView = button

        // 4. CustomTextField
        contentView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: spacing),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
        lastView = textField

        // 5. DaySelectorView
        contentView.addSubview(daySelector)
        NSLayoutConstraint.activate([
            daySelector.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: spacing),
            daySelector.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            daySelector.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            daySelector.heightAnchor.constraint(equalToConstant: 70)
        ])
        lastView = daySelector

        // 6. EmptyStateView
        contentView.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: spacing),
            emptyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emptyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emptyView.heightAnchor.constraint(equalToConstant: 220)
        ])
        lastView = emptyView

        // 7. TimePickerView
        contentView.addSubview(timePicker)
        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: spacing),
            timePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            timePicker.heightAnchor.constraint(equalToConstant: 340),
            timePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing)
        ])
    }
}

