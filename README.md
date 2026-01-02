# SemaphoreFlow

A Flutter mobile application for learning, translating, and quizzing yourself on the flag semaphore signalling system.

## Features

- **Real-time Translator**: Input text and see the corresponding semaphore signals animated live. Control the speed of the animation, pause, or restart.
- **Interactive Dictionary**: A complete grid of the semaphore alphabet (including numbers) for quick reference.
- **Engaging Quiz Mode**: Test your knowledge by identifying semaphore signals. The quiz tracks your score and streak to make learning fun.
- **Sleek, Modern UI**: A clean, themed interface with support for both light and dark modes.

(https://vujwwxyaacfxgiqajyby.supabase.co/storage/v1/object/public/notepad-images/images/2385345a-8320-4ce5-9767-524ba2e2760e.png)


## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing.

### Prerequisites

- You must have the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your machine.
- An IDE like [Android Studio](https://developer.android.com/studio) (with the Flutter plugin) or [VS Code](https://code.visualstudio.com/) (with the Dart and Flutter extensions).
- An Android emulator or a physical device.

### Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/alaric-visi/semaphore
    ```

2.  **Navigate to the project directory:**
    ```bash
    cd semaphore
    ```

3.  **Install dependencies:**
    Run the following command in your terminal to download all the necessary packages.
    ```bash
    flutter pub get
    ```

4.  **Run the application:**
    Open the project in your IDE and run it on a selected emulator or physical device. You can also run it from the terminal:
    ```bash
    flutter run
    ```

## Project Structure

The project is organised into logical directories to maintain clean and scalable code.

-   `lib/` - The main folder containing all the Dart code.
    -   `main.dart`: The entry point of the application.
    -   `nav.dart`: Configures the app's routing using `go_router`.
    -   `theme.dart`: Contains all the theming information, including colours, fonts, and widget styles for both light and dark modes.
    -   `models/`: Contains the data model classes.
        -   `semaphore_position.dart`: Defines the data structure for a single semaphore signal (angles and character).
        -   `translation_state.dart`: Defines the enum for the translator's current state.
    -   `screens/`: Contains the main pages (views) of the application.
        -   `home_page.dart`: The main screen that hosts the bottom navigation bar and switches between the other pages.
        -   `translator_page.dart`: The UI and logic for the text-to-semaphore translation feature.
        -   `dictionary_page.dart`: The UI for displaying the grid of all semaphore signals.
        -   `quiz_page.dart`: The UI and logic for the interactive quiz.
    -   `services/`: Contains the core business logic.
        -   `semaphore_service.dart`: The brain of the application. It holds the definitive mapping of characters to semaphore angles and provides methods for translation.
    -   `widgets/`: Contains reusable custom widgets used across different screens.
        -   `flag_display.dart`: A self-contained card widget for displaying a single semaphore signal.
        -   `semaphore_man_painter.dart`: The `CustomPainter` that handles the drawing of the semaphore man, arms, and flags.
        -   `status_bar.dart`: The widget used in the translator to show the current translation status and progress.

## Semaphore Logic

The core translation logic is centralised in `lib/services/semaphore_service.dart`. This service contains a map that defines the left and right arm angles for every character in the semaphore alphabet, including numbers. The painter, `SemaphoreManPainter`, uses a coordinate system where **0° is Down** and angles increase counter-clockwise.

This ensures that both the translator and the quiz use the exact same, definitive source for displaying signals, guaranteeing consistency across the app.
