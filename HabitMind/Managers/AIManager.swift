//
//  AIManager.swift
//  HabitMind
//
//  Created by Elnur Valizada on 11.07.25.
//

import Foundation
import CoreML

class AIManager {
    static let shared = AIManager()
    
    private init() {}
    
    // MARK: - Simple Rule-Based AI (No Core ML yet)
    // This is where we'll start learning. Later we'll add actual Core ML models
    
    func getHabitSuggestion(for habits: [Habit], timeOfDay: TimeOfDay) -> HabitSuggestion {
        // Step 1: Analyze current habits
        let habitCategories = analyzeHabitCategories(habits)
        let completionRate = calculateCompletionRate(habits)
        
        // Step 2: Generate suggestion based on patterns
        let suggestion = generateSuggestion(
            existingCategories: habitCategories,
            completionRate: completionRate,
            timeOfDay: timeOfDay
        )
        
        return suggestion
    }
    
    // MARK: - Helper Methods
    
    private func analyzeHabitCategories(_ habits: [Habit]) -> [HabitCategory] {
        var categories: [HabitCategory] = []
        
        for habit in habits {
            let category = categorizeHabit(habit)
            if !categories.contains(category) {
                categories.append(category)
            }
        }
        
        return categories
    }
    
    private func categorizeHabit(_ habit: Habit) -> HabitCategory {
        let name = habit.name.lowercased()
        let category = habit.category.lowercased()
        
        // First check the actual category
        switch category {
        case "fitness":
            return .fitness
        case "learning":
            return .learning
        case "mindfulness":
            return .wellness
        case "health":
            return .health
        case "productivity":
            return .productivity
        default:
            break
        }
        
        // Then check the name for keywords
        if name.contains("workout") || name.contains("exercise") || name.contains("gym") {
            return .fitness
        } else if name.contains("read") || name.contains("study") || name.contains("learn") {
            return .learning
        } else if name.contains("meditation") || name.contains("mindfulness") {
            return .wellness
        } else if name.contains("water") || name.contains("drink") {
            return .health
        } else if name.contains("clean") || name.contains("organize") {
            return .productivity
        } else {
            return .personal
        }
    }
    
    private func calculateCompletionRate(_ habits: [Habit]) -> Double {
        guard !habits.isEmpty else { return 0.0 }
        
        let totalCompletions = habits.reduce(0) { sum, habit in
            // Safely handle empty completionHistory
            guard !habit.completionHistory.isEmpty else { return sum }
            let completedCount = habit.completionHistory.values.filter { $0 }.count
            return sum + completedCount
        }
        
        let totalPossible = habits.count * 7 // Assuming weekly view
        return Double(totalCompletions) / Double(totalPossible)
    }
    
    private func generateSuggestion(
        existingCategories: [HabitCategory],
        completionRate: Double,
        timeOfDay: TimeOfDay
    ) -> HabitSuggestion {
        
        // Simple rule-based logic (we'll improve this with Core ML later)
        let missingCategories = HabitCategory.allCases.filter { !existingCategories.contains($0) }
        
        if completionRate < 0.3 {
            // Low completion rate - suggest easier habits
            return HabitSuggestion(
                title: "Start Small",
                description: "Try a simple 2-minute habit to build momentum",
                category: .personal,
                difficulty: .easy
            )
        } else if missingCategories.isEmpty {
            // All categories covered - suggest optimization
            return HabitSuggestion(
                title: "Optimize Routine",
                description: "Consider combining related habits for efficiency",
                category: .productivity,
                difficulty: .medium
            )
        } else {
            // Suggest missing category based on time
            let suggestedCategory = suggestCategoryForTime(missingCategories, timeOfDay)
            return HabitSuggestion(
                title: getSuggestionTitle(for: suggestedCategory),
                description: getSuggestionDescription(for: suggestedCategory),
                category: suggestedCategory,
                difficulty: .medium
            )
        }
    }
    
    private func suggestCategoryForTime(_ categories: [HabitCategory], _ timeOfDay: TimeOfDay) -> HabitCategory {
        switch timeOfDay {
        case .morning:
            return categories.first { $0 == .wellness || $0 == .fitness } ?? categories.first ?? .personal
        case .afternoon:
            return categories.first { $0 == .learning || $0 == .productivity } ?? categories.first ?? .personal
        case .evening:
            return categories.first { $0 == .wellness || $0 == .health } ?? categories.first ?? .personal
        case .night:
            return categories.first { $0 == .wellness } ?? categories.first ?? .personal
        }
    }
    
    private func getSuggestionTitle(for category: HabitCategory) -> String {
        switch category {
        case .fitness:
            return "Get Moving"
        case .learning:
            return "Learn Something New"
        case .wellness:
            return "Mindful Moment"
        case .health:
            return "Health Boost"
        case .productivity:
            return "Stay Organized"
        case .personal:
            return "Personal Growth"
        }
    }
    
    private func getSuggestionDescription(for category: HabitCategory) -> String {
        switch category {
        case .fitness:
            return "Try a quick 10-minute workout"
        case .learning:
            return "Read 10 pages or watch an educational video"
        case .wellness:
            return "Take 5 minutes to meditate or breathe"
        case .health:
            return "Drink a glass of water or take vitamins"
        case .productivity:
            return "Organize your workspace or plan tomorrow"
        case .personal:
            return "Write in a journal or call a friend"
        }
    }
}

// MARK: - Supporting Types

enum TimeOfDay {
    case morning
    case afternoon
    case evening
    case night
    
    static func current() -> TimeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return .morning
        case 12..<17:
            return .afternoon
        case 17..<22:
            return .evening
        default:
            return .night
        }
    }
}

enum HabitCategory: CaseIterable {
    case fitness
    case learning
    case wellness
    case health
    case productivity
    case personal
}

enum HabitDifficulty {
    case easy
    case medium
    case hard
}

struct HabitSuggestion {
    let title: String
    let description: String
    let category: HabitCategory
    let difficulty: HabitDifficulty
} 