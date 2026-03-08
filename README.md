# Sports UI Reconstruction

A production-quality Flutter application demonstrating pixel-perfect UI reconstruction, robust state management with BLoC, and persistent local storage.

## 🚀 Project Overview
This project focuses on recreating a complex sports match schedule and statistics UI with a focus on responsiveness, micro-animations, and clean architecture. It includes features like live/scheduled match tracking, a "My Games" favorite system, and detailed player statistics.

## 🛠 Technical Stack
- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) (BLoC Pattern)
- **Local Storage**: [Hive](https://pub.dev/packages/hive) (NoSQL Database for persistence)
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it) (Service Locator)
- **Networking**: [Dio](https://pub.dev/packages/dio) (Mocked for this reconstruction)
- **Image Handling**: `cached_network_image`, `flutter_svg`
- **Serialization**: `json_annotation`, `json_serializable`

## 📁 Project Structure & Approaches
The project follows a **Feature-First Clean Architecture** to ensure separation of concerns, testability, and scalability.

- **Presentation Layer**: 
  - `SportsBloc`: Manages the state of matches, favorites, and notifications.
  - `SportsPage`: The main entry point using `NestedScrollView` and `SliverAppBar` for a sticky header experience.
  - `MatchCard`: A reusable, interactive utility widget for match displays.
- **Domain Layer**: 
  - `MatchEvent`, `PlayerStat`: Core entities representing the business logic.
  - `SportsRepository`: Interface defining the data contract.
- **Data Layer**: 
  - `MatchEventModel`: Data Transfer Object (DTO) with JSON serialization.
  - `SportsRemoteDataSource`: Handles API calls (mocked data for UI faithfulness).
  - `SportsLocalDataSource`: Manages Hive boxes for favorites and settings.

## 🤖 Generative AI Usage
This project utilized **Antigravity (Google DeepMind)** for rapid prototyping, architectural refactoring, and UI auditing. 

### Essential Prompts
- *"Recreate the provided UI with pixel-perfect accuracy focusing on multi-layered UX handling."*
- *"Implement a clean layered architecture with BLoC for state management and local data persistence."*
- *"Fix the 8.0px bottom overflow in the TabBar and ensure the UI fits different device sizes."*
- *"Implement a per-match notification toggle that requires a global permission check on the first tap."*

## 🏃 How to Run
1. **Clone the Repo**:
   ```bash
   git clone <repository_url>
   cd ui_reconstruction
   ```
2. **Get Dependencies**:
   ```bash
   flutter pub get
   ```
3. **Generate Code** (for Hive and JSON):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. **Run the App**:
   ```bash
   flutter run --release
   ```

## 📸 Screenshots
The application is validated against 6 primary UI states. Refer to the `assets/screenshots/` directory for full visual comparisons.

- **Schedule View**: Live and upcoming matches.
- **My Games**: Persistent favorite list.
- **Statistics**: Top player rankings with profile avatars.

---
**Note**: To generate the release APK, run `flutter build apk --release`. The output will be located in `build/app/outputs/flutter-apk/app-release.apk`.
