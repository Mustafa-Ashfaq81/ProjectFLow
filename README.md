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
IMAGE_BUCKET="gs://ideaenhancerapp.appspot.com"
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

Once the app is started, it will prompt you to register/signup or log in. For the initial setup, register by providing your username, email, and password. The password requirement are as follow:
1. Lowercase character required
2. Uppercase character required
3. Numeric character required
4. Non-alphanumeric character required
5. Minimum password length (ranges from 6 to 30 characters; defaults to 6)
6. Maximum password length (maximum length of 4096 characters)

The system will store your credentials in the Firebase database.

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



## Use Cases:

The **Home Page** contains a search bar, from where you can search for your tasks.

The **Add Task Page** can be used to add a new task in the tasks list. You can add the title and details of the task. You can also add the due date and time. You have the option to add collaborators through their usernames which will send a collaboration request to the collaborator.

The **collaborators request page** is used to manage the collaboration requests. You can either accept or reject the request.

The **Task Details/ Note details page** show the details of the tasks. You can also edit those tasks.

The **Calendar page** shows you the deadlines of the tasks through calendar, you can also edit them, through this page.
 
At the bottom of the screen, there is a **navigating bar**, from where you can navigate to different pages including **Task details, Calendar, Add Task, Collaborators request page** to manage the collaborators requests.

The setting and other use cases are not yet implemented.


---


## Log Out
There is also a **Logout** and **Setting** option in the right upper corner. (Labeled as **Debug**)

---


The App uses **Firebase database** to efficiently manage its functionality as it provides the following features:

**1. Real-Time Data Sync:**
   - Firebase Realtime Database provides real-time synchronization. Any changes made to the data are immediately reflected across all connected clients in real time.
   - This is particularly useful for collaborative applications, where you need instant updates across devices.


**2. Scalability:**
 
- Firebase is designed to scale automatically based on the demand. As your app grows, Firebase can handle an increasing number of users and data without requiring you to manage the infrastructure.
   - Firebase's infrastructure is maintained and scaled by Google, allowing you to focus on developing your app rather than managing servers.


**3. Authentication:**
   - Firebase provides built-in authentication services, making it easy to integrate secure user authentication in your app.


**4. Cloud Functions:**
   - Firebase allows you to deploy serverless functions known as Cloud Functions. These functions can be triggered by various events in your app.
   - Cloud Functions enable you to perform server-side logic without maintaining a separate server, improving efficiency in handling backend operations.


**5. Offline Support:**
   - Firebase Realtime Database provides offline support, allowing users to interact with your app even when they are not connected to the internet.
   - Offline data is automatically synchronized when the device regains an internet connection.




## Screen Flow


![Alt SignUp page screen](/my_app/Screenshots/SignUp.png "SignUp")

   This is the Signup page. Users are required to put their credentials to register their account.

<hr>

![Alt Login page screen](/my_app/Screenshots/Login.png "Login")

   This is the Login page. Users are prompted to log in by providing their username or email and password.

<hr>

![Alt HomePage page screen](/my_app/Screenshots/HomePage.png "HomePage")

   This is the HomePage screen. Users can search for tasks, view completed and pending tasks.

<hr>

![Alt MyNotes page screen](/my_app/Screenshots/MyNotes.png "MyNotes")

   This is the MyNotes page. It likely displays a collection of notes or written content. Users may utilize this page to manage their notes, search for existing notes and view the details of notes.

<hr>

![Alt AddTask page screen](/my_app/Screenshots/AddTask.png "AddTask")

   This is the AddTask page. Users can utilize this page to add new tasks to their task list or schedule. It likely includes input fields for task details such as title, description, due date, priority, etc.

<hr>

![Alt Calendar page screen](/my_app/Screenshots/Calender.png "Calendar")

   This is the Calendar page. It displays a calendar interface where users can view and manage their schedule, appointments, or events. Users can likely navigate through dates, add new events, and view existing ones.

<hr>

![Alt Calendar page screen](/my_app/Screenshots/LoadTimeDisplay.png "LoadTimeDisplay")

   This is the load time display page, which is shown when some thing is loading.

<hr>

![Alt Collaborators page screen](/my_app/Screenshots/Collabs.png "Collaborators Page")

   This is the Collaborators page. It likely allows users to manage collaborators or team members for a project or task. Users may be able to add, remove, or edit collaborators' access and permissions.

<hr>

![Alt Settings page screen](/my_app/Screenshots/SettingPage.png "Settings Page")

   This is the Settings page. Users can access and modify various settings related to their account or the application itself. This page may include options for account management, notification preferences, theme customization, etc.

<hr>

![Alt TaskDetails page screen](/my_app/Screenshots/OngoingProjectPage.png "OngoingTasks page")

   This is the TaskDetails page. It likely displays detailed information about a specific ongoing task. Users may view task title, description, due date, priority, status, and any associated subtasks or notes.

<hr>

![Alt TaskDetails page screen](/my_app/Screenshots/CompletedProjectPage.png "Completed Tasks page")

   This is the TaskDetails page. It likely displays detailed information about a specific Completed task. Users may view all the details associated to that task or project.

<hr>

![Alt TaskDetails page screen](/my_app/Screenshots/AboutPage.png "About page")

   This is the about page. It likely displays the information regarding the application.

<hr>

![Alt TaskDetails page screen](/my_app/Screenshots/AccountSettingPage.png "Account setting page")

   This is the sub page with in setting page and display the option to change the account credentials.

<hr>

![Alt TaskDetails page screen](/my_app/Screenshots/Myimage.png "Image review")

   This is the image setting page. It display the option to view or change the image profile.

<hr>

![Alt TaskDetails page screen](/my_app/Screenshots/CustomerSupportPage.png "Customer Support page page")

   It is customer support page, it gives the user the option to chat with the managing team to ask queries.

<hr>

![Alt TaskDetails page screen](/my_app/Screenshots/ConfirmationPopUpDisplay.png "Confirmation Pop Up page")

   This is the confirmation pop up page, which gets displayed when the user wants to enhance the ideas through chatgpt.

<hr>

![Alt TaskDetails page screen](/my_app/Screenshots/CalenderAPI.png "Calender API page")

 This is the calender API page. It is used to set the date and time for due dates etc.
<hr>


