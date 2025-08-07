import UIKit

class ProgressSummaryCardView: UIView {
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.08)
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowRadius = 20
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Today's Progress"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let progressRing: ProgressRingView = {
        let ring = ProgressRingView()
        ring.translatesAutoresizingMaskIntoConstraints = false
        ring.setRingWidth(16)
        ring.setGradientColors([UIColor.systemBlue, UIColor.systemGreen])
        return ring
    }()
    private let statsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
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
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(progressRing)
        stackView.addArrangedSubview(statsLabel)
        stackView.addArrangedSubview(messageLabel)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -18),
            progressRing.widthAnchor.constraint(equalToConstant: 90),
            progressRing.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    func configure(completed: Int, total: Int) {
        let percent = total > 0 ? Int((Double(completed) / Double(total)) * 100) : 0
        progressRing.setProgressWithPercentage(percent, subtitle: "")
        statsLabel.text = "\(completed) of \(total) habits completed"
        if total == 0 {
            messageLabel.text = "Add your first habit!"
        } else if completed == 0 {
            messageLabel.text = "Let's get started! 💪"
        } else if completed < total {
            messageLabel.text = "Keep going! You're almost there!"
        } else {
            messageLabel.text = "You did it! ��"
        }
    }
} 