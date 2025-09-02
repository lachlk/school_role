# *School Role*

*School Role* is a versatile project designed for teachers to take the role. This comprehensive guide will provide you with everything you need to know to get started with the project, from installation instructions to a detailed description of its features.

## Table of Contents

- [Features](#features)

- [Usage](#usage)

- [Start Development](#start-development)

  - [Prerequisites](#prerequisites)

  - [Clone the Repository](#clone-the-repository)
  - [Requisites](#requisites)
  - [Firebase Setup](#firebase-setup)
  - [Firebase Auth Setup](#firebase-auth-setup)
  - [Firebase:Firestore Database Setup](#firebasefirestore-database-setup)

  - [Build and Run](#build-and-run)

- [Contributing](#contributing)

- [Development log](#development-log)

- [License](#license)

## Features

Key features and functionalities of *School Role*:

- Multi-sign in with a Google account or email and password

- Password Recovery

- Account Sign-up

- Automatic Theming

- Classes Selection

- Presence Selection

- Cross-platform

- Firestore Database Reading

- Draggable Classes Grid

- Autocomplete Student Search

- Attendance Schedule Writing to Database

- Attendance Schedule Exporting as .json File

- Class Editing and Deletion

- Student Editing and Removal

## Usage

1. To run current version on Android, Windows or Web go to [releases](https://github.com/lachlk/school_role/releases).

2. Download the desired platform file.

3. For Android phones open the .apk. For Windows open the .exe located in Release folder. For web, follow this [tutorial](https://dev.to/tyu1996/deploying-flutter-web-app-on-live-server-5c5).

## Start Development

Follow these steps to develop *School Role* on your system.

### Prerequisites

Before you begin, ensure you have the following dependencies and tools installed:

- Vscode [Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

- Vscode [Dart Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)


### Clone the Repository

1. Open your terminal or command prompt.

2. Use the following command to clone the school_role repository:

```Powershell
git clone https://github.com/lachlk/school_role.git
```

   Replace lachlk with your GitHub username.

### Requisites

Ensure these packages are installed by running:
```
flutter pub add (package_name)
```
- Flutter package [dynamic_color](https://pub.dev/packages/dynamic_color)

- Flutter package: [firebase_core](https://pub.dev/packages/firebase_core)

- Flutter package: [firebase_auth](https://pub.dev/packages/firebase_auth)

- Flutter package: [firebase_ui_auth](https://pub.dev/packages/firebase_ui_auth)

- Flutter package: [google_sign_in](https://pub.dev/packages/google_sign_in)

- Flutter package: [firebase_ui_oauth_google](https://pub.dev/packages/firebase_ui_oauth_google)
- Flutter package: [flutter_draggable_gridview](https://pub.dev/packages/flutter_draggable_gridview)
- Flutter package: [share_plus](https://pub.dev/packages/share_plus)
- Flutter package: [path_provider](https://pub.dev/packages/path_provider)
- Flutter package: [file_saver](https://pub.dev/packages/file_saver)

### Firebase Setup
1. Go to [firebase.google.com](https://firebase.google.com/)
2. Click on go to console
3. Add projecta and follow the instructions
4. In project overview under "Get started by adding Firebase to your app" Click on the flutter logo
5. Follow the firebase provided instructions

If you need more help I recommend this [tutorial](https://firebase.google.com/docs/flutter/setup?platform=ios)

### Firebase Auth Setup
1. Click on build then the authentication tab
2. Click "get started" then "Email/Password"
3. Enable Email/Password
4. Click on "Add new provider" then "Google" 
5. Enable Google and fill in "Support email for project"
6. Click save then hover over the google and click on "edit configuration"
7. Under Web SDK configuration copy the Web client ID
8. In the auth_gate.dart file replace the GoogleProvider(clientId: "My ID") with your Web client ID

### Firebase:Firestore database Setup
1. Click "Create database"
2. Start in **production mode** then "Create"
3. Using the database structure in the [db.json](db.json) file create collentions and documents
4. In the "Rules" tab copy and paste the securty rules in the [db_security_rules.txt](db_security_rules.txt)

### Build and Run

1. Connect your device or start an emulator.

2. To build and run the project, use the following command:

```
flutter run
```
or
```
flutter build
```

This will build the project and install it on your connected device or emulator.

## Contributing

We welcome contributions to *School Role*. If you would like to contribute to the development or report issues, please follow these guidelines:

1. Fork the repository.

2. Create a new branch for your feature or bug fix.

3. Make your changes and commit them with descriptive messages.

4. Push your changes to your fork.

5. Submit a pull request to the main repository.

## License

*School Role* is licensed under the [GNU General Public License v3.0](https://github.com/lachlk/school_role/blob/main/LICENSE).

Thank you for choosing School Role! If you encounter any issues or have suggestions for improvements, please don't hesitate to [create an issue](https://github.com/lachlk/school_role/issues/new/choose) or [contribute to the project](#contributing). We look forward to your feedback and collaboration.

[Back to top](#school_role)