//
//  Habit.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import Foundation

struct Habit: Codable, Identifiable {
    static let categories = [
        "Health",
        "Productivity",
        "Learning",
        "Fitness",
        "Mindfulness",
        "Other"
    ]
    let id: String // Changed from UUID to String
    var name: String
    var category: String
    var time: Date
    var repeatDays: [Int] // 1=Sun, 7=Sat
    var completionHistory: [String: Bool] // Changed from [Date: Bool] to [String: Bool]
    var isActive: Bool
    var createdAt: Date
    var lastModified: Date
    
    // Partial progress support
    var currentValue: Int
    var targetValue: Int
    
    init(name: String, category: String, time: Date, repeatDays: [Int] = [], targetValue: Int = 1) {
        self.id = UUID().uuidString
        self.name = name
        self.category = category
        self.time = time
        self.repeatDays = repeatDays
        self.completionHistory = [:]
        self.isActive = true
        self.createdAt = Date()
        self.lastModified = Date()
        self.currentValue = 0
        self.targetValue = targetValue
    }
    
    mutating func markCompleted(for date: Date) {
        let formatter = ISO8601DateFormatter()
        let key = formatter.string(from: date.startOfDay)
        completionHistory[key] = true
        lastModified = Date()
        currentValue = targetValue
    }
    
    mutating func markIncomplete(for date: Date) {
        let formatter = ISO8601DateFormatter()
        let key = formatter.string(from: date.startOfDay)
        completionHistory[key] = false
        lastModified = Date()
        currentValue = 0
    }
    
    func isCompleted(for date: Date) -> Bool {
        let formatter = ISO8601DateFormatter()
        let key = formatter.string(from: date.startOfDay)
        return completionHistory[key] ?? false || progress >= 1.0
    }
    
    func shouldShowToday() -> Bool {
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date())
        return repeatDays.contains(today)
    }
    
    var completionRate: Double {
        guard !completionHistory.isEmpty else { return 0.0 }
        let completedCount = completionHistory.values.filter { $0 }.count
        return Double(completedCount) / Double(completionHistory.count)
    }
    
    // Progress for partial habits (0.0 to 1.0)
    var progress: Double {
        guard targetValue > 0 else { return 0.0 }
        return min(Double(currentValue) / Double(targetValue), 1.0)
    }
    
    // Increment progress for partial habits
    mutating func incrementProgress(by amount: Int = 1) {
        currentValue = min(currentValue + amount, targetValue)
        if currentValue >= targetValue {
            markCompleted(for: Date())
        }
        lastModified = Date()
    }
    
    // Reset progress for a new day/period
    mutating func resetProgress() {
        currentValue = 0
        markIncomplete(for: Date())
    }
}

// MARK: - Extensions
extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var dayOfWeek: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var hourOfDay: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
} 
