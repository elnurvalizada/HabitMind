//
//  DaySelectorView.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import UIKit

class DaySelectorView: UIView {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.text = "Repeat on"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Properties
    private var dayButtons: [UIButton] = []
    private var selectedDays: Set<Int> = []
    
    var onDaysChanged: (([Int]) -> Void)?
    
    private let dayNames = ["S", "M", "T", "W", "T", "F", "S"]
    private let dayValues = [1, 2, 3, 4, 5, 6, 7] // Sunday = 1, Saturday = 7
    
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
        addSubview(titleLabel)
        addSubview(stackView)
        
        createDayButtons()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Stack view
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func createDayButtons() {
        for (index, dayName) in dayNames.enumerated() {
            let button = createDayButton(title: dayName, tag: dayValues[index])
            dayButtons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func createDayButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.tag = tag
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.backgroundColor = .clear
        button.setTitleColor(.systemGray4, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Set fixed size
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    // MARK: - Actions
    @objc private func dayButtonTapped(_ sender: UIButton) {
        let dayValue = sender.tag
        
        if selectedDays.contains(dayValue) {
            selectedDays.remove(dayValue)
            updateButtonAppearance(sender, isSelected: false)
        } else {
            selectedDays.insert(dayValue)
            updateButtonAppearance(sender, isSelected: true)
        }
        
        onDaysChanged?(Array(selectedDays).sorted())
    }
    
    private func updateButtonAppearance(_ button: UIButton, isSelected: Bool) {
        UIView.animate(withDuration: 0.2) {
            if isSelected {
                button.backgroundColor = .systemBlue
                button.layer.borderColor = UIColor.systemBlue.cgColor
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .clear
                button.layer.borderColor = UIColor.systemGray4.cgColor
                button.setTitleColor(.systemGray4, for: .normal)
            }
        }
    }
    
    // MARK: - Public Methods
    func setSelectedDays(_ days: [Int]) {
        selectedDays = Set(days)
        updateAllButtonAppearances()
        onDaysChanged?(Array(selectedDays).sorted())
    }
    
    func getSelectedDays() -> [Int] {
        return Array(selectedDays).sorted()
    }
    
    func selectAllDays() {
        selectedDays = Set(dayValues)
        updateAllButtonAppearances()
        onDaysChanged?(Array(selectedDays).sorted())
    }
    
    func clearSelection() {
        selectedDays.removeAll()
        updateAllButtonAppearances()
        onDaysChanged?(Array(selectedDays).sorted())
    }
    
    private func updateAllButtonAppearances() {
        for button in dayButtons {
            let isSelected = selectedDays.contains(button.tag)
            updateButtonAppearance(button, isSelected: isSelected)
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
} 