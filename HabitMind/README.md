# HabitMind - iOS Habit Tracking App

A modern, intuitive habit tracking app built with Swift and UIKit, designed to help users build and maintain healthy habits through AI-powered insights and beautiful UI.

## 🏗️ Project Structure

### Core Architecture

```
HabitMind/
├── AppDelegate.swift              # App lifecycle management
├── SceneDelegate.swift            # Scene lifecycle management
├── ViewControllers/               # Main view controllers
│   ├── MainTabBarController.swift # Root tab bar controller
│   ├── HomeViewController.swift   # Today's dashboard
│   ├── HabitListViewController.swift # All habits list
│   └── HabitFormViewController.swift # Add/edit habits
├── Components/                    # Reusable UI components
│   ├── HabitCardView.swift        # Individual habit display
│   ├── ProgressRingView.swift     # Circular progress indicator
│   ├── CustomButton.swift         # Styled buttons
│   ├── CustomTextField.swift      # Input fields with validation
│   ├── DaySelectorView.swift      # Day of week selector
│   ├── TimePickerView.swift       # Time selection
│   ├── EmptyStateView.swift       # Empty state displays
│   └── AISuggestionCardView.swift # AI recommendation cards
├── Model/                         # Data models
│   └── Habit.swift               # Core habit data structure
└── Managers/                      # Business logic
    └── HabitDataManager.swift     # Data persistence and operations
```

## 📱 App Features

### 1. **Today's Dashboard** (`HomeViewController`)
- **Purpose**: Main landing page showing today's habits
- **Features**:
  - Personalized greeting based on time of day
  - Daily progress overview with visual progress ring
  - List of today's habits with quick completion actions
  - AI-powered suggestions for habit optimization
  - Empty state when no habits scheduled for today

### 2. **Habit Management** (`HabitListViewController`)
- **Purpose**: Comprehensive habit management interface
- **Features**:
  - Complete list of all habits with filtering options
  - Search functionality by name or category
  - Filter by status (active, completed, incomplete)
  - Swipe actions for quick edit/delete
  - Category-based organization

### 3. **Habit Creation/Editing** (`HabitFormViewController`)
- **Purpose**: Add new habits or modify existing ones
- **Features**:
  - Form validation with real-time feedback
  - Time picker for reminder scheduling
  - Day selector for repeat patterns
  - Target value setting for partial habits
  - Category assignment

### 4. **Statistics & Analytics** (Coming Soon)
- **Purpose**: Track progress and gain insights
- **Planned Features**:
  - Completion rate tracking
  - Streak counting
  - Weekly/monthly progress charts
  - Category-wise performance analysis

### 5. **Settings & Preferences** (Coming Soon)
- **Purpose**: App configuration and user preferences
- **Planned Features**:
  - Notification settings
  - Theme customization
  - Data export/import
  - Account management

## 🎯 Core Features

### **Habit Types**
1. **Binary Habits**: Simple yes/no completion (e.g., "Meditation")
2. **Partial Habits**: Progress-based completion (e.g., "Drink 8 glasses of water")

### **Smart Scheduling**
- Flexible day selection (any combination of weekdays)
- Time-based reminders
- Automatic daily progress reset

### **Progress Tracking**
- Visual progress indicators
- Completion history
- Streak counting
- Performance analytics

### **AI Integration**
- Personalized habit suggestions
- Optimization recommendations
- Pattern recognition
- Goal achievement insights

## 🏛️ Architecture Patterns

### **MVC Architecture**
- **Model**: `Habit.swift` - Core data structure
- **View**: UI components in `Components/` directory
- **Controller**: View controllers in `ViewControllers/` directory

### **Data Management**
- **Singleton Pattern**: `HabitDataManager.shared` for centralized data operations
- **Persistence**: UserDefaults for local storage
- **CRUD Operations**: Complete create, read, update, delete functionality

### **Component-Based UI**
- Reusable UI components for consistency
- Custom styling and theming
- Accessibility support
- Responsive design

## 🔧 Technical Implementation

### **Data Model**
```swift
struct Habit: Codable, Identifiable {
    let id: UUID
    var name: String
    var category: String
    var time: Date
    var repeatDays: [Int] // 1=Sun, 7=Sat
    var completionHistory: [Date: Bool]
    var isActive: Bool
    var currentValue: Int
    var targetValue: Int
    // ... additional properties
}
```

### **Key Components**

#### **HabitCardView**
- Displays individual habit information
- Handles completion toggling
- Shows progress for partial habits
- Increment/decrement controls

#### **ProgressRingView**
- Animated circular progress indicator
- Gradient color support
- Customizable ring width and colors
- Shadow effects for depth

#### **Custom Components**
- `CustomButton`: Styled buttons with icon support
- `CustomTextField`: Input fields with validation
- `DaySelectorView`: Interactive day selection
- `TimePickerView`: Time picker with custom styling

### **Navigation Flow**
```
MainTabBarController
├── Home (Dashboard)
│   └── → Habit Detail
├── Habits (List)
│   ├── → Habit Detail
│   ├── → Edit Habit
│   └── → Add Habit
├── Statistics
└── Settings
```

## 🚀 Getting Started

### **Prerequisites**
- Xcode 14.0+
- iOS 15.0+
- Swift 5.0+

### **Installation**
1. Clone the repository
2. Open `HabitMind.xcodeproj` in Xcode
3. Build and run the project

### **Sample Data**
The app automatically loads sample habits on first launch:
- Drink Water (Health category)
- Morning Exercise (Fitness category)
- Read Books (Learning category)
- Meditation (Wellness category)
- Journal Writing (Personal category)

## 🎨 Design Principles

### **User Experience**
- **Intuitive Navigation**: Clear tab-based navigation
- **Visual Feedback**: Progress indicators and animations
- **Accessibility**: VoiceOver support and semantic markup
- **Responsive Design**: Adapts to different screen sizes

### **Visual Design**
- **Modern UI**: Clean, minimalist design
- **Consistent Theming**: System colors and fonts
- **Visual Hierarchy**: Clear information organization
- **Micro-interactions**: Subtle animations and feedback

## 🔮 Future Enhancements

### **Planned Features**
1. **Cloud Sync**: iCloud integration for data backup
2. **Notifications**: Local push notifications for reminders
3. **Widgets**: iOS home screen widgets
4. **Social Features**: Share progress with friends
5. **Advanced Analytics**: Detailed insights and trends
6. **Custom Categories**: User-defined habit categories
7. **Export/Import**: Data portability options

### **Technical Improvements**
1. **Core Data**: Migration from UserDefaults to Core Data
2. **Unit Tests**: Comprehensive test coverage
3. **UI Tests**: Automated UI testing
4. **Performance**: Optimization for large datasets
5. **Accessibility**: Enhanced accessibility features

## 📄 License

This project is created for educational and personal use.

## 👨‍💻 Author

Created by Elnur Valizada

---

*HabitMind - Building better habits, one day at a time.* 