//
//  HabitDataManager.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import Foundation

class HabitDataManager {
    static let shared = HabitDataManager()
    
    private let fileName = "habits.json"
    private let fileManager = FileManager.default
    private var fileURL: URL {
        let bundleURL = Bundle.main.url(forResource: "habits_50", withExtension: "json")
        let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destURL = docsURL.appendingPathComponent(fileName)
        // Copy from bundle to documents if not present
        if !fileManager.fileExists(atPath: destURL.path), let bundleURL = bundleURL {
            try? fileManager.copyItem(at: bundleURL, to: destURL)
        }
        return destURL
    }
    
    private init() {}
    
    // MARK: - CRUD Operations
    func saveHabit(_ habit: Habit) {
        var habits = getAllHabits()
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
        } else {
            habits.append(habit)
        }
        saveHabits(habits)
    }
    
    func getAllHabits() -> [Habit] {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let habits = try decoder.decode([Habit].self, from: data)
            return habits
        } catch {
            print("[HabitDataManager] Failed to load or decode habits: \(error)")
            return []
        }
    }
    
    func getHabitsForToday() -> [Habit] {
        let allHabits = getAllHabits()
        let today = Calendar.current.component(.weekday, from: Date())
        return allHabits.filter { $0.repeatDays.contains(today) }
    }
    
    func deleteHabit(_ habit: Habit) {
        var habits = getAllHabits()
        habits.removeAll { $0.id == habit.id }
        saveHabits(habits)
    }
    
    func updateHabitCompletion(_ habit: Habit, isCompleted: Bool, for date: Date = Date()) {
        var updatedHabit = habit
        if isCompleted {
            updatedHabit.markCompleted(for: date)
        } else {
            updatedHabit.markIncomplete(for: date)
        }
        saveHabit(updatedHabit)
        print(updatedHabit)
    }
    
    func incrementHabitProgress(_ habit: Habit, by amount: Int = 1) {
        var updatedHabit = habit
        updatedHabit.incrementProgress(by: amount)
        saveHabit(updatedHabit)
    }
    
    func resetHabitProgress(_ habit: Habit) {
        var updatedHabit = habit
        updatedHabit.resetProgress()
        saveHabit(updatedHabit)
    }
    
    // MARK: - Analytics
    func getCompletionRate(for habit: Habit, in days: Int = 7) -> Double {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -days, to: endDate) ?? endDate
        var completedDays = 0
        var totalDays = 0
        var currentDate = startDate
        while currentDate <= endDate {
            if habit.repeatDays.contains(calendar.component(.weekday, from: currentDate)) {
                totalDays += 1
                if habit.isCompleted(for: currentDate) {
                    completedDays += 1
                }
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        return totalDays > 0 ? Double(completedDays) / Double(totalDays) : 0.0
    }
    
    func getStreak(for habit: Habit) -> Int {
        let calendar = Calendar.current
        var currentDate = Date()
        var streak = 0
        while true {
            if habit.repeatDays.contains(calendar.component(.weekday, from: currentDate)) {
                if habit.isCompleted(for: currentDate) {
                    streak += 1
                } else {
                    break
                }
            }
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) else {
                break
            }
            currentDate = previousDay
        }
        return streak
    }
    
    func getTodayProgress() -> (completed: Int, total: Int) {
        let todayHabits = getHabitsForToday()
        let completedCount = todayHabits.filter { $0.isCompleted(for: Date()) }.count
        return (completed: completedCount, total: todayHabits.count)
    }
    
    // MARK: - Private Methods
    private func saveHabits(_ habits: [Habit]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(habits) {
            try? data.write(to: fileURL)
        }
    }
    
    // MARK: - Sample Data
    func loadSampleData() {
        // Not needed, as we use the bundled JSON file
    }
    
    func clearAllData() {
        saveHabits([])
    }
} 
