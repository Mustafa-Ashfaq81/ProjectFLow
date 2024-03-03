# Flutter Note-Taking App Setup Instructions

Welcome to our **Flutter Note-Taking App**! This app has been built using the Flutter framework, and the database is managed with **Firebase**. Follow these step-by-step instructions to set up the development environment and run the app on your local machine.

## **Prerequisites**

Before you begin, ensure that you have the following installed on your system:

- **Flutter SDK:** Install the latest version of Flutter by following the instructions on the official Flutter website: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

- **Code Editor:** Choose a code editor of your preference. You can use **VS Code** or **Android Studio**. We recommend **Visual Studio Code**, which has excellent Flutter support. Download and install it from [Visual Studio Code](https://code.visualstudio.com/).

- **Device or Emulator:** You can run the app on a physical device or use an emulator. Make sure to set up your device or emulator based on your operating system.

## **Clone the Repository**

1. Open a terminal or command prompt.

2. Clone the Flutter Note-Taking App repository from GitHub:

   ```bash
   git clone https://github.com/Mustafa-Ashfaq81/SE-PROJECT
   ```

3. Change into the project directory:

   ```bash
   cd my_app
   ```

## **Install Dependencies**

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

## **Run the App**

If you are using Android Studio or are running the code on any device, connect your device or start an emulator. Then, run the app using the following command:

```bash
flutter run
```

Else if you want to run it on Chrome, use the following command:

```bash
flutter run -d chrome
```

This command will build the app and open it either on your device/emulator or in the Chrome browser. You should now see the Flutter Note-Taking App running on your screen!

---

## SignUp:

Once the app is started, it will ask you to register/signup or to login. You initially have to register, where it will ask your username email and password.
The system will store your credentials in the firebase database.

---

## Log In:

Once you have signed up, Go to the login page, login with your credentials (email and password). If logged in successfully, the home page will pop up on your screen.

---


## **Use Cases:**

- **Home Page:**
  The Home Page contains a search bar, from where you can search for your tasks (both pending and completed).

- **Add Task Page:**
  The Add Task Page can be used to add a new task to the tasks list. You can add the title, details of the task, due date, and time. Collaborators can be added through their usernames, sending a request for acceptance or rejection.

- **Collaborators Requests Page:**
  The Collaborators Request Page is used to manage collaboration requests. You can accept or reject the requests.

- **Task Details/Note Details Page:**
  The Task Details/Note Details Page shows the details of the tasks. You can also edit the tasks from this page.

- **Calendar Page:**
  The Calendar Page displays the deadlines of the tasks through a calendar, allowing you to edit them.

- **Footer Navigation Bar:**
  At the footer of the screen, there is a navigating bar to switch between different pages, including Task Details, Calendar, Add Task, and a page to manage collaboration requests.

- **Settings and Other Use Cases:**
  The setting and other functionalities are not yet implemented.

- **Log Out:**
  There is also a Logout and Setting option in the right upper corner (labeled as Debug).

---

The app efficiently utilizes Firebase database to manage its functionality, benefiting from:

- **Real-Time Data Sync:**
  Firebase Realtime Database provides real-time synchronization, reflecting changes across connected clients instantly, beneficial for collaborative applications.

- **Scalability:**
  Firebase scales automatically based on demand, handling an increasing number of users and data without infrastructure management.

- **Authentication:**
  Firebase offers built-in authentication services, making it easy to integrate secure user authentication in the app.

- **Cloud Functions:**
  Firebase allows deployment of serverless functions (Cloud Functions) triggered by various app events, improving efficiency in handling backend operations.

- **Offline Support:**
  Firebase Realtime Database supports offline functionality, allowing users to interact with the app even when not connected to the internet.

These features collectively contribute to a robust and efficient app experience.
