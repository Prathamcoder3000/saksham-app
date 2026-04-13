<div align="center">

<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
<img src="https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" />
<img src="https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white" />
<img src="https://img.shields.io/badge/Status-Beta-blue?style=for-the-badge" />

# 🏥 Saksham Platform

**A comprehensive multi-role healthcare & caretaker management platform**

*Empowering administrators, caretakers, and families to manage healthcare activities — all in one place.*

[Features](#-features) · [Project Structure](#-project-structure) · [Tech Stack](#%EF%B8%8F-tech-stack) · [Getting Started](#%EF%B8%8F-getting-started) · [Roadmap](#-roadmap)

</div>

---

## 📁 Project Structure

This repository is organized into two main components:

- **`saksham-app/frontend`**: The Flutter mobile application for all user roles.
- **`saksham-app/backend`**: The Node.js/Express server and REST API.

---

## ✨ Features

| Feature | Status |
|---|---|
| Multi-role login (Admin / Caretaker / Family) | ✅ Done |
| Admin Dashboard | ✅ Done |
| Resident Management (Add / Edit / View / Profile) | ✅ Done |
| Staff Management (Add / View) | ✅ Done |
| Caretaker Dashboard | ✅ Done |
| Medicine Tracker | ✅ Done |
| Daily Checklist | ✅ Done |
| Emergency SOS | ✅ Done |
| Family Dashboard | ✅ Done |
| Reports Module | ✅ Done |
| Task Management | ✅ Done |
| Backend API (Node.js + MongoDB) | ✅ Done |
| JWT Authentication | ✅ Done |
| Real-time Notifications | ⏳ In Progress |
| Image Upload & Profile Photos | ✅ Done |

---

## 🛠️ Tech Stack

### Frontend
- **Flutter** — Cross-platform mobile framework
- **Dart** — Programming language
- **Material UI** — Component library
- **Custom Fonts** — Lexend font family
- **Percent Indicator** — Progress indicators library

### Backend
- **Node.js** & **Express** — REST API server
- **MongoDB** & **Mongoose** — Database & ORM
- **JWT** — Authentication & authorization
- **Multer** — File upload handling
- **Bcryptjs** — Password hashing

---

## ⚙️ Getting Started

### 🟢 Backend Setup (Node.js)

1. **Navigate to backend**:
   ```bash
   cd saksham-app/backend
   ```
2. **Install dependencies**:
   ```bash
   npm install
   ```
3. **Configure Environment**:
   - Create a `.env` file in `saksham-app/backend/`:
   ```env
   PORT=5000
   MONGO_URI=your_mongodb_connection_string
   JWT_SECRET=your_jwt_secret
   NODE_ENV=development
   ```
4. **Run the server**:
   ```bash
   npm run dev
   ```

---

### 🔵 Frontend Setup (Flutter)

1. **Navigate to frontend**:
   ```bash
   cd saksham-app/frontend
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the app**:
   ```bash
   flutter run
   ```

---

## 📱 Detailed Flutter Setup

If you are setting up Flutter for the first time, follow these steps:

### 🪟 Step 1 — Install Android Studio
1. Go to 👉 [https://developer.android.com/studio](https://developer.android.com/studio)
2. Click **Download Android Studio** and run the installer
3. During setup, make sure these components are checked:
   - ✅ Android SDK, Android SDK Platform, Android Virtual Device (AVD)
4. Complete the installation and launch Android Studio
5. Go through the **Setup Wizard** to download the required SDK components (Recommended: API Level 33 or higher)

### 🔧 Step 2 — Configure Android SDK
1. Open Android Studio → **More Actions** → **SDK Manager**
2. Under **SDK Platforms**, check **Android 13.0 (Tiramisu) — API 33**
3. Under **SDK Tools**, check **Android SDK Build-Tools**, **Android Emulator**, **Android SDK Platform-Tools**, and **HAXM**
4. Click **Apply** to download

### 📱 Step 3 — Create a Virtual Device (Emulator)
1. In Android Studio → **More Actions** → **Virtual Device Manager**
2. Click **Create Device**, select a device (e.g., Pixel 6), and a system image (API 33).
3. Click **Finish** and press the ▶️ **Play** button to start the emulator.

### 🐦 Step 4 — Install Flutter SDK
1. Download from 👉 [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
2. Extract to a location like `C:\flutter`.
3. Add `C:\flutter\bin` to your system **Path** environment variable.
4. Run `flutter doctor` in a terminal to verify installation and accept licenses with `flutter doctor --android-licenses`.

---

## 🗺️ Roadmap

- [x] Full UI/UX Implementation
- [x] Multi-platform Support (Android/iOS/Web/Windows)
- [x] Backend API Development
- [x] JWT & Secure Authentication
- [x] Resident & Staff Management
- [x] Medicine Tracking & Daily Checklists
- [x] Image Upload Integration
- [ ] Real-time Notifications & Chat
- [ ] Push Notifications
- [ ] Offline Data Sync
- [ ] Advanced Analytics Dashboard

---

## 📄 License
This project is developed for **educational and academic purposes**. All rights reserved.

<div align="center">

**👨‍💻 Developer**
**Pratham**
[GitHub: @Prathamcoder3000](https://github.com/Prathamcoder3000)

*Built with ❤️ using Flutter & Node.js*
**Version:** 1.0.0
</div>
