//
//  TimePickerView.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import UIKit

class TimePickerView: UIView {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let selectButton: CustomButton = {
        let button = CustomButton(title: "Select Time", style: .primary)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cancelButton: CustomButton = {
        let button = CustomButton(title: "Cancel", style: .secondary)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    private var selectedTime: Date = Date()
    var onTimeSelected: ((Date) -> Void)?
    var onCancelled: (() -> Void)?
    var isButtonEnabled: Bool = true {
        didSet {
            selectButton.isHidden = !isButtonEnabled
            cancelButton.isHidden = !isButtonEnabled
        }
    }
    
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
    
    convenience init(initialTime: Date = Date()) {
        self.init(frame: .zero)
        selectedTime = initialTime
        timePicker.date = initialTime
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        addSubview(containerView)
        containerView.addSubview(timePicker)
        if isButtonEnabled {
            containerView.addSubview(selectButton)
            containerView.addSubview(cancelButton)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Time picker
            timePicker.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            timePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            timePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            timePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            timePicker.heightAnchor.constraint(equalToConstant: 200),
        ])
        // Buttons stack
        if isButtonEnabled {
            NSLayoutConstraint.activate([
                selectButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 20),
                selectButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                selectButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                
                cancelButton.topAnchor.constraint(equalTo: selectButton.bottomAnchor, constant: 12),
                cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
            ])
        }
        
    }
    
    private func setupActions() {
        timePicker.addTarget(self, action: #selector(timePickerChanged), for: .valueChanged)
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func timePickerChanged() {
        selectedTime = timePicker.date
    }
    
    @objc private func selectButtonTapped() {
        onTimeSelected?(selectedTime)
    }
    
    @objc private func cancelButtonTapped() {
        onCancelled?()
    }
    
    
    func getSelectedTime() -> Date {
        return selectedTime
    }
    
    func setMinuteInterval(_ interval: Int) {
        timePicker.minuteInterval = interval
    }
    
    func setDatePickerMode(_ mode: UIDatePicker.Mode) {
        timePicker.datePickerMode = mode
    }
    
    func setPreferredDatePickerStyle(_ style: UIDatePickerStyle) {
        timePicker.preferredDatePickerStyle = style
    }
}
