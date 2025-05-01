# 📦 Pharmacy Management App

A **Flutter-based mobile application** for managing pharmacy operations, including **medicine inventory, order processing, and user authentication**. The app uses **Firebase** for backend services, **BLoC for state management**, and a modern, responsive UI design.

---

## 📑 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Dependencies](#dependencies)
- [ScreenRecording](#screenrecording)
  

---

## ✨ Features

- **User Authentication**
  - Login and Sign-Up with Email/Password.
  - Google Sign-In integration.

- **Medicine Management**
  - Add, edit, and delete medicines.
  - View medicine inventory with details (name, price, quantity, expiry date).

- **Order Management**
  - Place, update, and track orders.
  - Filter orders by pharmacy.

- **Responsive UI**
  - Modern design with gradient buttons and custom text fields.
  - Smooth animations for navigation and form transitions.

- **Real-time Data**
  - Firestore integration for real-time medicine and order updates.

- **State Management**
  - BLoC pattern for scalable state management.

- **Screen Recording**
  - App demo provided through screen recording (no screenshots).

---

## 🛠 Tech Stack

- **Frontend:** Flutter, Dart  
- **Backend:** Firebase (Authentication, Firestore)  
- **State Management:** flutter_bloc  

---

## ⚙️ Installation

### Prerequisites:
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Firebase project (with Authentication & Firestore)
- Android Studio / Xcode (for emulator or physical devices)

### Run the App:
flutter pub get
flutter run

## 🚀 Usage

### Launch the App:
- Open the app on an **emulator** or **physical device** after running it using `flutter run`.
- The initial screen that appears is the **Login Screen**.

### Authenticate:
- **Login** with your **email/password** or use **Google Sign-In** for authentication.
- If you're a new user, you can **sign up** by providing the required details (email/password).

### Manage Medicines:
- Navigate to the **Medicine Screen** where you can:
  - **Add new medicines** by clicking the “Add Medicine” button and filling out the necessary details (e.g., medicine name, price, quantity, expiry date).
  - **Edit existing medicines** by selecting a medicine and updating the details.
  - **Delete medicines** by selecting a medicine and confirming the deletion.

### Manage Orders:
- Go to the **Order Screen** where you can:
  - **Place new orders** for medicines by selecting the items from the inventory and adding quantity.
  - **Update order status** once the order has been processed (e.g., from "Pending" to "Completed").
  - **View existing orders** and filter them by pharmacy or status.

### Sign Out:
- To log out of the app, simply tap on the **logout** button available in the app bar. This will redirect you back to the **Login Screen**.

---

This section describes how to interact with the app, manage user authentication, add/edit medicines, place/manage orders, and sign out once done.

## 📂 Project Structure
pharmacy_management/
├── android/                   
├── ios/                       
├── lib/
│   ├── core/
│   │   ├── routes/            
│   │   ├── theme/             
│   ├── features/
│   │   ├── auth/              
│   │   │   ├── data/          
│   │   │   ├── domain/        
│   │   │   ├── presentation/  
│   │   ├── medicine/          
│   │   │   ├── data/          
│   │   │   ├── domain/        
│   │   │   ├── presentation/  
│   │   ├── order/             
│   │   │   ├── data/          
│   │   │   ├── domain/        
│   │   │   ├── presentation/  
│   ├── app.dart               
│   ├── main.dart              
├── pubspec.yaml               
├── README.md                  


---

### Structure Explanation:

- **android/**: Android-specific files and configurations for building the app.
- **ios/**: iOS-specific files and configurations.
- **lib/**: All Dart code lives here.
  - **core/**: Contains core functionalities like routing and app theme settings.
  - **features/**: Holds different features of the app, separated into specific folders like `auth`, `medicine`, and `order`.
    - **auth/**: Manages authentication (Login/Sign-Up).
    - **medicine/**: Handles all medicine-related operations (adding, editing, viewing).
    - **order/**: Manages order placements, updates, and views.
  - **app.dart**: Main widget that initializes the app.
  - **main.dart**: Entry point of the app, where execution begins.
- **pubspec.yaml**: Contains all dependencies and metadata for the project.
- **README.md**: This file, which holds documentation for the project.

---

This structure will guide you through understanding the organization of the entire project and its modules.

## 🛠️ Dependencies

### 1. **firebase_core**: ^3.0.0
   - Initializes Firebase in your Flutter project. It is required to connect and configure Firebase services, such as Firestore and Firebase Authentication.

### 2. **firebase_auth**: ^5.0.0
   - Provides Firebase Authentication functionalities like email/password sign-in, Google Sign-In, and other authentication methods.

### 3. **cloud_firestore**: ^5.0.0
   - Enables Firestore integration, allowing you to manage data in real-time with CRUD operations (Create, Read, Update, Delete).

### 4. **google_sign_in**: ^7.0.0
   - Integrates Google Sign-In functionality for logging in users using their Google accounts.

### 5. **flutter_bloc**: ^8.1.3
   - Implements BLoC (Business Logic Component) for state management in your app. It separates business logic from UI to make the app scalable and maintainable.

### 6. **flutter_spinkit**: ^5.2.1
   - Provides loading spinners and animations to enhance the user interface by adding visual feedback during waiting times (e.g., loading data).

### 7. **uuid**: ^4.0.0
   - Generates universally unique identifiers (UUIDs) for creating unique keys or IDs, for example, when adding medicines or orders.

### 8. **google_nav_bar**: ^5.0.6
   - A modern bottom navigation bar widget for Flutter, used to create an attractive, customizable navigation bar in your app.

### 9. **intl**: ^0.19.0
   - Provides internationalization support, like formatting dates, times, and numbers, and handling locale-specific text.

### 10. **get_it**: ^7.0.0
   - A simple service locator for Flutter, used for dependency injection to manage app-wide instances of services like repositories and BLoCs.

---

These dependencies are critical for the core functionality of the app, including Firebase integration, state management, UI components, and more.

## ScreenRecording:-

https://github.com/user-attachments/assets/1657ee46-2612-4d04-a6c9-4255b5f7b81b




