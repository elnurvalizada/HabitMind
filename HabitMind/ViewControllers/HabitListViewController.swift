//
//  HabitListViewController.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import UIKit

class HabitListViewController: RootViewController {
    
    // MARK: - UI Components
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search habits..."
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView.noHabitsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    private var allHabits: [Habit] = []
    private var filteredHabits: [Habit] = []
    private var selectedCategory: String?
    private var selectedStatus: HabitStatus = .all
    
    private enum HabitStatus {
        case all, active, completed, incomplete
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupSearchController()
        getAllHabits()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllHabits()
        tableView.reloadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "All Habits"
        
        // Add navigation bar items
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addHabitTapped)
        )
        
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        
        // Add filter button to navigation bar
        let filterBarButton = UIBarButtonItem(customView: filterButton)
        navigationItem.leftBarButtonItem = filterBarButton
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HabitTableViewCell.self, forCellReuseIdentifier: "HabitCardCell")
        
        tableView.setConstraints(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: view.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor)
        emptyStateView.setConstraints(leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, centerYAnchor: view.centerYAnchor, centerXAnchor: view.centerXAnchor, leadingConstant: 20, trailingConstant: -20)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        definesPresentationContext = true
    }
    
    // MARK: - Data Loading
    private func getAllHabits() {
        allHabits = HabitDataManager.shared.getAllHabits()
        
        applyFilters()
    }
    
    // MARK: - Filtering
    private func applyFilters() {
        var filtered = allHabits
        // Apply category filter
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        // Apply status filter
        switch selectedStatus {
        case .all:
            break
        case .active:
            filtered = filtered.filter { $0.isActive }
        case .completed:
            filtered = filtered.filter { $0.isCompleted(for: Date()) }
        case .incomplete:
            filtered = filtered.filter { !$0.isCompleted(for: Date()) }
        }
        
        // Apply search filter
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filtered = filtered.filter { habit in
                habit.name.localizedCaseInsensitiveContains(searchText) ||
                habit.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filteredHabits = filtered
        tableView.reloadData()
        updateEmptyState()
    }
    
    private func updateEmptyState() {
        emptyStateView.isHidden = !filteredHabits.isEmpty
    }
    
    // MARK: - Actions
    @objc private func addHabitTapped() {
        let formVC = HabitFormViewController()
        formVC.onHabitSaved = { [weak self] in
            self?.getAllHabits()
            self?.tableView.reloadData()
        }
        
        presentWithNavigation(formVC, style: .fullScreen)
    }
    
    @objc private func filterButtonTapped() {
        showFilterOptions()
    }
    
    private func showFilterOptions() {
        let alertController = UIAlertController(title: "Filter Habits", message: nil, preferredStyle: .actionSheet)
        
        // Category filter
        let categories = Array(Set(allHabits.map { $0.category })).sorted()
        for category in categories {
            let action = UIAlertAction(title: category, style: .default) { [weak self] _ in
                self?.selectedCategory = category
                self?.applyFilters()
            }
            alertController.addAction(action)
        }
        
        // Status filter
        alertController.addAction(UIAlertAction(title: "All Status", style: .default) { [weak self] _ in
            self?.selectedStatus = .all
            self?.applyFilters()
        })
        
        alertController.addAction(UIAlertAction(title: "Active Only", style: .default) { [weak self] _ in
            self?.selectedStatus = .active
            self?.applyFilters()
        })
        
        alertController.addAction(UIAlertAction(title: "Completed Today", style: .default) { [weak self] _ in
            self?.selectedStatus = .completed
            self?.applyFilters()
        })
        
        alertController.addAction(UIAlertAction(title: "Incomplete Today", style: .default) { [weak self] _ in
            self?.selectedStatus = .incomplete
            self?.applyFilters()
        })
        
        // Clear filters
        alertController.addAction(UIAlertAction(title: "Clear Filters", style: .destructive) { [weak self] _ in
            self?.selectedCategory = nil
            self?.selectedStatus = .all
            self?.applyFilters()
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HabitListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredHabits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCardCell", for: indexPath) as! HabitTableViewCell
        
        let habit = filteredHabits[indexPath.row]
        cell.configure(with: habit) { [weak self] _, _ in
            self?.getAllHabits()
            self?.tableView.reloadData()
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HabitListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170 // Approximate height for habit card
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habit = filteredHabits[indexPath.row]
        // TODO: Navigate to habit detail screen
        print("Selected habit: \(habit.name)")
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let habit = filteredHabits[indexPath.row]
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completion in
            self?.editHabit(habit)
            completion(true)
        }
        editAction.backgroundColor = .systemBlue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.deleteHabit(habit)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

// MARK: - UISearchResultsUpdating
extension HabitListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        applyFilters()
    }
}

// MARK: - UISearchControllerDelegate
extension HabitListViewController: UISearchControllerDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        applyFilters()
    }
}

// MARK: - Helper Methods
extension HabitListViewController {
    private func handleHabitCompletion(_ habit: Habit, isCompleted: Bool) {
        HabitDataManager.shared.updateHabitCompletion(habit, isCompleted: isCompleted)
        tableView.reloadData()
    }
    
    private func editHabit(_ habit: Habit) {
        let formVC = HabitFormViewController(habit: habit)
        formVC.onHabitSaved = { [weak self] in
            self?.getAllHabits()
            self?.tableView.reloadData()
        }
        
        presentWithNavigation(formVC)
    }
    
    private func deleteHabit(_ habit: Habit) {
        let alertController = UIAlertController(
            title: "Delete Habit",
            message: "Are you sure you want to delete '\(habit.name)'? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            HabitDataManager.shared.deleteHabit(habit)
            self?.getAllHabits()
        })
        
        present(alertController, animated: true)
    }
} 

// MARK: - HabitTableViewCell
class HabitTableViewCell: UITableViewCell {
    
    let habitCard: HabitCardView = {
        let card = HabitCardView()
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(habitCard)
        
        habitCard.setConstraints(topAnchor: contentView.topAnchor, bottomAnchor: contentView.bottomAnchor, leadingAnchor: contentView.leadingAnchor, trailingAnchor: contentView.trailingAnchor, topConstant: 8, bottomConstant: -8, leadingConstant: 16, trailingConstant: -16)
    }
    
    func configure(with habit: Habit, onCompletionToggled: @escaping (Habit, Bool) -> Void) {
        habitCard.configure(with: habit)
        habitCard.onCompletionToggled = onCompletionToggled
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        habitCard.onCompletionToggled = nil
    }
} 

extension HabitListViewController {
    override func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        getAllHabits()
        tableView.reloadData()
    }
} 
