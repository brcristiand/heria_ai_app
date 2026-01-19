# Heria AI App - Project History & Changelog

This document provides a chronological overview of the prompts, objectives, and technical changes implemented during the development of the Heria AI Flutter application.

---

## Phase 1: Tech Stack Selection & Initial Setup

**Date Range: Jan 03, 2026**

- **Initial Concept**: Started with a React Native project concept for cross-platform fitness.
- **Pivot to Flutter**: Decided to use Flutter for a more premium, high-performance UI experience across iOS, Android, and Web.
- **Environment Troubleshooting**: Resolved issues with the `flutter` command not being found by configuring PATH and ensuring SDK installation.
- **Project Structure**: Initialized the project `heria_ai_app` with support for all platforms.

### Key Implementation: `pubspec.yaml` Initial State

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  firebase_core: ^3.10.1
  cloud_firestore: ^5.6.1
```

---

## Phase 2: Design Language & Core UI

**Date Range: Jan 03 - Jan 04, 2026**

- **Aesthetic Goal**: "Formula 1" inspired dark theme. Cinematic typography, glassmorphism, and high-contrast accents.
- **Custom Components**:
  - `GlassCard`: A blurred, semi-transparent container for metrics.
  - `PrimaryButton`: Styled action buttons with specific padding and branding.
  - `InfoCard`: Interactive card for user information display.
- **Gradient Backgrounds**: Implementation of `GradientScaffold` to maintain a consistent immersive look.
- **Feature Exploration**: Added "Generate Workout" and "Talk with AI" buttons to the dashboard layout.

### Key Implementation: `PrimaryButton` Logic

```dart
// Standardized button used across the app
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const PrimaryButton({required this.text, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFC0A475), // Gold accent
        foregroundColor: Colors.black,
        // ... styling details
      ),
      child: Text(text),
    );
  }
}
```

---

## Phase 3: Debugging & Stabilization

**Date Range: Jan 13 - Jan 14, 2026**

- **Critical Fixes**:
  - Resolved "Expected an identifier" errors in `main.dart`.
  - Fixed `MyApp` class reference errors in `test/widget_test.dart`.
- **UI Alignment**:
  - Adjusted `NameScreen` and others to prevent overlapping of elements.
  - Implemented precise CSS-like overlaps for the `CircleIcon` and `PrimaryButton` (negative margins/offsets).
- **Environment Testing**: Verified builds on Android Emulator and Chrome.

---

## Phase 4: UX Refinement & Optimization

**Date Range: Jan 16 - Jan 17, 2026**

- **Instant Transitions**: Removed visual "white flashes" by matching theme colors and disabling navigation animations for an "instant" feel.
- **Button Logic**: Updated `NameScreen` so the "Continue" button remains inactive until user input is detected.
- **Component Standardization**: Refactored `PrimaryButton` to remove the `isSmall` property and standardized padding across the app.
- **Scrollable Layouts**: Implemented `SingleChildScrollView` on the Home screen and others to ensure visibility on smaller devices.

### Key Implementation: Input-Based Button State (`NameScreen`)

```dart
void _onNameChanged() {
  setState(() {
    _isButtonEnabled = _nameController.text.trim().isNotEmpty;
  });
}
// ... in build ...
PrimaryButton(
  text: 'Continue',
  onPressed: _isButtonEnabled ? () => _navigateNext() : null,
)
```

---

## Phase 5: Advanced Features & Database Integration

**Date Range: Jan 18 - Jan 19, 2026**

- **Theme Centralization**: Moved background gradients from individual `GradientScaffold` widgets into the global `ThemeData`.
- **Progression System**:
  - Integrated database queries to fetch workout progressions.
  - Created the `UserDashboard` interface to display available progressions with "Start Progression" actions.
- **Screen Implementations**: Finalized screens like `CompleteBeginner` and `UserDashboard`.

### Key Implementation: Global Gradient Theme (`main.dart`)

```dart
builder: (context, child) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFFECECEC), Color(0xFF515459)],
      ),
    ),
    child: child,
  );
}
```

### Key Implementation: Firestore Query (`UserDashboard`)

```dart
stream: FirebaseFirestore.instance
    .collection('progressions')
    .orderBy('createdAt', descending: true)
    .snapshots(),
```

---

## Phase 6: User Onboarding Data Sync & Version Control

**Date Range: Jan 19, 2026**

- **Sequential Onboarding**: Established a strict navigation flow: `HomeScreen` -> `NameScreen` -> `AgeScreen` -> `WeightScreen`

### Phase 7: Global Progression Sync (Admin Panel)

- **Goal**: Ensure new progressions added by admins are immediately pushed to all users' profiles.
- **Implementation**:
  - Updated `AdminDashboard._addProgression` to fetch all user documents and use a `WriteBatch` to add the new progression ID to each.
  - Updated `AdminDashboard._deleteProgression` to also remove the progression ID from all users.
  - Refactored `UserDashboard` for cleaner UI and efficient `StreamBuilder` usage.
- **Key Files**:
  - `lib/screens/admin_dashboard.dart`
  - `lib/screens/user_dashboard.dart`

* **Progression Synchronization**:
  - Initialized users with a `progressionLevels` map containing all available progressions at Level 1.
  - Added a sync mechanism in `UserDashboard` to automatically detect and add newly created progressions from the database to the user's profile.
* **Git Integration**: Successfully initialized Git, connected to a remote GitHub repository, and resolved authentication issues (PAT usage) to facilitate version control.

### Key Implementation: Progression Sync Logic (`user_service.dart`)

```dart
Future<void> syncUserProgressions(String userId) async {
  final userDoc = await _firestore.collection('users').doc(userId).get();
  final userData = userDoc.data() as Map<String, dynamic>;
  final userProgressionLevels = Map<String, dynamic>.from(userData['progressionLevels'] ?? {});

  final progressionsSnapshot = await _firestore.collection('progressions').get();

  for (var doc in progressionsSnapshot.docs) {
    if (!userProgressionLevels.containsKey(doc.id)) {
      userProgressionLevels[doc.id] = 1; // Default starting level
      updated = true;
    }
  }
}
```

---

_Last Updated: Jan 19, 2026_
