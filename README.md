# Astra - Workout Tracking App

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Hive](https://img.shields.io/badge/Hive-FFC107?style=for-the-badge&logo=hive&logoColor=black)](https://pub.dev/packages/hive)

Astra is a mobile application built with Flutter, designed to help you create, manage, and track your workouts effectively. Keep an eye on your progress with integrated statistics and stay focused with a built-in workout timer.

## ✨ Features

* **Custom Workout Creation**:
    * Define workouts with custom names and a series of tasks.
    * Assign specific durations to each task within a workout.
    * Easily add, delete, and reorder tasks in your workout routines.
* **Workout Management**:
    * View a list of all your saved workouts.
    * Edit existing workouts to adjust tasks or timings.
    * Delete workouts you no longer need.
* **Interactive Timer**:
    * Start a timer for any of your saved workouts.
    * Displays current time remaining for the entire workout and for the current task.
    * Shows the current task name and its allocated time.
    * Visual progress bar for the current task.
    * Ability to skip to the next task.
    * Automatically records completed workout sessions to your statistics.
* **Statistics Tracking**:
    * View your training frequency with weekly and monthly charts.
    * Data is visualized using sparkline charts.
    * Navigate through past weeks/months to see historical data.
* **User-Friendly Interface**:
    * Sleek dark theme for comfortable viewing.
    * Intuitive bottom navigation bar for easy access to Timer, Workouts, and Statistics sections.
    * Responsive design that adapts to different screen sizes (though primarily designed for portrait, with some landscape considerations for the timer).
* **Local Data Storage**:
    * All your workout and statistics data is stored locally on your device using Hive.
* **In-App Settings & Information**:
    * **About Us**: Information about the app and contact email (august.frigo@gmail.com).
    * **Support Us**: Link to a PayPal donation page.
    * **Wish List**: Submit feature requests directly within the app.
    * **Bug Report**: Report any issues you encounter.

## 🛠️ Tech Stack & Dependencies

* **Flutter**: For building the cross-platform mobile application.
* **Dart**: The programming language used for Flutter development.
* **Hive (Hive Flutter)**: A lightweight and fast NoSQL database for local storage.
* **flutter_tabler_icons**: For a rich set of icons.
* **chart_sparkline**: For creating simple and elegant sparkline charts in the statistics screen.
* **custom_sliding_segmented_control**: Used for the weekly/monthly toggle in statistics.
* **url_launcher**: To open external links (like the PayPal support link).
* **Other Flutter Widgets**: `MaterialApp`, `Scaffold`, `BottomNavigationBar`, `ListView`, `TextField`, `AnimationController`, `CupertinoPicker`, etc.

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

* Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
* An editor like VS Code or Android Studio.

### Installation

1.  Clone the repo:
    ```sh
    git clone [https://github.com/August-B-F/Workout-app](https://github.com/August-B-F/Workout-app)
    ```
2.  Navigate to the project directory:
    ```sh
    cd Astra
    ```
3.  Install dependencies:
    ```sh
    flutter pub get
    ```
4.  Run the app:
    ```sh
    flutter run
    ```

## 📖 How to Use

1.  **Navigate**: Use the bottom navigation bar to switch between the **Timer**, **Workouts**, and **Statistics** screens.
2.  **Create a Workout**:
    * Go to the "Workouts" screen.
    * Tap the "+" floating action button to add a new workout.
    * Enter a name for your workout.
    * Add tasks by tapping the "Add Task" (library_add icon) button.
    * For each task, provide a name and set its duration using the picker.
    * Reorder tasks using the drag handles or delete them.
    * Save the workout.
3.  **Start a Workout**:
    * On the "Workouts" screen, find your desired workout and tap "Start".
    * This will take you to the "Timer" screen, pre-configured with your selected workout.
    * The timer will automatically progress through tasks. You can also skip tasks manually.
4.  **View Statistics**:
    * Go to the "Statistics" screen.
    * Toggle between "Weekly" and "Monthly" views to see your training consistency.
    * Use the arrow buttons to view data for previous periods.
5.  **Explore Settings**:
    * On the "Timer" screen (when screen width is less than 600px), tap the settings icon in the top right.
    * Here you can find "About Us", "Support Us", "Wish List", and "Bug Report" options.

## 💡 Future Scope / Wishlist

Some ideas for future enhancements:
* More detailed statistics (e.g., time spent per exercise).
* Sound notifications for timer events.
* Cloud synchronization of workout data.
* Customizable themes.
* Workout sharing features.