//
//  HabitFormViewController.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import UIKit

class HabitFormViewController: RootViewController {
    
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
    private let nameTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Habit name", style: .standard)
        tf.setIcon("pencil")
        tf.setValidation(rule: { $0.count >= 3 }, errorMessage: "At least 3 characters")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let categoryTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Category", style: .standard)
        tf.setIcon("folder")
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isUserInteractionEnabled = true
        return tf
    }()
    
    private let timePickerView: TimePickerView = {
        let picker = TimePickerView(initialTime: Date())
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.isButtonEnabled = false
        return picker
    }()
    
    private let daySelectorView: DaySelectorView = {
        let selector = DaySelectorView()
        selector.setSelectedDays([2,3,4,5,6]) // Default to weekdays
        selector.translatesAutoresizingMaskIntoConstraints = false
        return selector
    }()
    
    private let targetValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Target Value"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let targetValueStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 100
        stepper.value = 1
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    private let targetValueDisplayLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let targetValueDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "How many times should this habit be completed?"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let saveButton: CustomButton = {
        let button = CustomButton(title: "Save Habit", style: .primary)
        button.addIcon("checkmark", position: .leading)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cancelButton: CustomButton = {
        let button = CustomButton(title: "Cancel", style: .secondary)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    private var habitToEdit: Habit?
    private var isEditMode: Bool = false
    var onHabitSaved: (() -> Void)?
    private var selectedCategory: String? {
        didSet {
            categoryTextField.text = selectedCategory
        }
    }
    
    // MARK: - Initialization
    init(habit: Habit? = nil) {
        self.habitToEdit = habit
        self.isEditMode = habit != nil
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        populateFormIfEditing()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView?.backgroundColor = .red
        title = isEditMode ? "Edit Habit" : "New Habit"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(nameTextField)
        contentView.addSubview(categoryTextField)
        contentView.addSubview(timePickerView)
        contentView.addSubview(daySelectorView)
        contentView.addSubview(targetValueLabel)
        contentView.addSubview(targetValueStepper)
        contentView.addSubview(targetValueDisplayLabel)
        contentView.addSubview(targetValueDescriptionLabel)
        contentView.addSubview(saveButton)
        contentView.addSubview(cancelButton)
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
            
            // Name TextField
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Category TextField
            categoryTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            categoryTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            categoryTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Time Picker
            timePickerView.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 20),
            timePickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timePickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            timePickerView.heightAnchor.constraint(equalToConstant: 200),
            
            // Day Selector
            daySelectorView.topAnchor.constraint(equalTo: timePickerView.bottomAnchor, constant: 20),
            daySelectorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            daySelectorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            daySelectorView.heightAnchor.constraint(equalToConstant: 70),
            
            // Target Value Section
            targetValueLabel.topAnchor.constraint(equalTo: daySelectorView.bottomAnchor, constant: 30),
            targetValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            targetValueStepper.topAnchor.constraint(equalTo: targetValueLabel.bottomAnchor, constant: 16),
            targetValueStepper.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            targetValueDisplayLabel.centerYAnchor.constraint(equalTo: targetValueStepper.centerYAnchor),
            targetValueDisplayLabel.leadingAnchor.constraint(equalTo: targetValueStepper.trailingAnchor, constant: 20),
            targetValueDisplayLabel.widthAnchor.constraint(equalToConstant: 60),
            
            targetValueDescriptionLabel.topAnchor.constraint(equalTo: targetValueStepper.bottomAnchor, constant: 8),
            targetValueDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            targetValueDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Buttons
            saveButton.topAnchor.constraint(equalTo: targetValueDescriptionLabel.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        targetValueStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryFieldTapped))
        categoryTextField.addGestureRecognizer(tapGesture)
        categoryTextField.inputView = UIView() // Disable keyboard
    }
    
    private func populateFormIfEditing() {
        guard let habit = habitToEdit else { return }
        nameTextField.text = habit.name
        selectedCategory = habit.category
        daySelectorView.setSelectedDays(habit.repeatDays)
        targetValueStepper.value = Double(habit.targetValue)
        targetValueDisplayLabel.text = "\(habit.targetValue)"
    }
    
    // MARK: - Public Methods
    func presetHabitData(title: String, description: String, category: HabitCategory) {
        nameTextField.text = title
        selectedCategory = category.rawValue
        // You can add more preset logic here if needed
    }
    
    // MARK: - Actions
    @objc private func saveTapped() {
        guard validateForm() else { return }
        
        let habit = createHabitFromForm()
        
        HabitDataManager.shared.saveHabit(habit)
        onHabitSaved?()
        print(HabitDataManager.shared.getAllHabits())
        dismiss(animated: true)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func stepperValueChanged() {
        let value = Int(targetValueStepper.value)
        targetValueDisplayLabel.text = "\(value)"
    }
    
    @objc private func categoryFieldTapped() {
        let alert = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
        for category in Habit.categories {
            alert.addAction(UIAlertAction(title: category, style: .default, handler: { [weak self] _ in
                self?.selectedCategory = category
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if let popover = alert.popoverPresentationController {
            popover.sourceView = categoryTextField
            popover.sourceRect = categoryTextField.bounds
        }
        present(alert, animated: true)
    }
    
    // MARK: - Helper Methods
    private func validateForm() -> Bool {
        guard let name = nameTextField.text, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(title: "Invalid Input", message: "Please enter a habit name.")
            return false
        }
        guard let category = selectedCategory, !category.isEmpty else {
            showAlert(title: "Invalid Input", message: "Please select a category.")
            return false
        }
        let selectedDays = daySelectorView.getSelectedDays()
        guard !selectedDays.isEmpty else {
            showAlert(title: "Invalid Input", message: "Please select at least one day.")
            return false
        }
        return true
    }
    
    private func createHabitFromForm() -> Habit {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let category = selectedCategory ?? "Other"
        let time = timePickerView.getSelectedTime()
        let repeatDays = daySelectorView.getSelectedDays()
        let targetValue = Int(targetValueStepper.value)
        if let existingHabit = habitToEdit {
            var updatedHabit = existingHabit
            updatedHabit.name = name
            updatedHabit.category = category
            updatedHabit.time = time
            updatedHabit.repeatDays = repeatDays
            updatedHabit.targetValue = targetValue
            updatedHabit.lastModified = Date()
            return updatedHabit
        } else {
            return Habit(
                name: name,
                category: category,
                time: time,
                repeatDays: repeatDays,
                targetValue: targetValue
            )
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
} 
