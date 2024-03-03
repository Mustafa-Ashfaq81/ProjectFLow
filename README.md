




# Flutter Note-Taking App Setup Instructions

Welcome to our Flutter Note-Taking App! This app has been built using the Flutter framework, and the database is managed with Firebase. Follow these step-by-step instructions to set up the development environment and run the app on your local machine.

## Prerequisites

Before you begin, ensure that you have the following installed on your system:

- **Flutter SDK:** Install the latest version of Flutter by following the instructions on the official Flutter website: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

- **Code Editor:** Choose a code editor of your preference. You can use VS Code or Android Studio. We recommend Visual Studio Code, which has excellent Flutter support. Download and install it from [Visual Studio Code](https://code.visualstudio.com/).

- **Device or Emulator:** You can run the app on a physical device or use an emulator. Make sure to set up your device or emulator based on your operating system.

## Clone the Repository

1. Open a terminal or command prompt.

2. Clone the Flutter Note-Taking App repository from GitHub:

   ```bash
   git clone https://github.com/Mustafa-Ashfaq81/SE-PROJECT
   ```

3. Change into the project directory:

   ```bash
   cd my_app
   ```

## Install Dependencies

Run the following command to fetch and install the project dependencies:

```bash
flutter pub get
```

This command will download and install the required packages specified in the `pubspec.yaml` file.

To upgrade, run:

```bash
flutter pub upgrade web
```

Create a `.env` file in the `my_app` folder and copy-paste the following credentials. This will connect you to the database:

```env
API_KEY=AIzaSyBSh7QG4ajePtUK-eA0EMQf9J-spxo_Djs
PROJECT_ID=ideaenhancerapp
MSG_SENDER_ID=12273615091
APP_ID=1:12273615091:web:16e75bf6226f9122d37786
```

## Run the App

If you are using Android Studio or are running the code on any device, connect your device or start an emulator. Then, run the app using the following command:

```bash
flutter run
```

If you want to run it on Chrome, use the following command:

```bash
flutter run -d chrome
```

This command will build the app and open it either on your device/emulator or in the Chrome browser. You should now see the Flutter Note-Taking App running on your screen!

---

## SignUp

Once the app is started, it will prompt you to register/signup or log in. For the initial setup, register by providing your username, email, and password. The system will store your credentials in the Firebase database.

## LogIn

After registering, go to the login page and log in with your credentials (email and password). If logged in successfully, the home page will appear on your screen.

---
