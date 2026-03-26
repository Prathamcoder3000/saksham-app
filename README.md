<div align="center">

<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
<img src="https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" />
<img src="https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white" />
<img src="https://img.shields.io/badge/Status-In%20Development-orange?style=for-the-badge" />

# 🏥 Saksham App

**A multi-role healthcare & caretaker management mobile application**

*Empowering administrators, caretakers, and families to manage healthcare activities — all in one place.*

[Features](#-features) · [App Flow](#-app-flow) · [Modules](#-modules) · [Tech Stack](#%EF%B8%8F-tech-stack) · [Getting Started](#%EF%B8%8F-getting-started) · [Project Structure](#-project-structure) · [Roadmap](#-roadmap)

</div>

---

## ✨ Features

| Feature | Status |
|---|---|
| Multi-role login (Admin / Caretaker / Family) | ✅ Done |
| Admin Dashboard | ✅ Done |
| Resident Management (Add / Edit / View / Profile) | ✅ Done |
| Staff Management (Add / View) | ✅ Done |
| Reports Module | 🚧 In Progress |
| Caretaker Dashboard | 🚧 In Progress |
| Family Dashboard | 🚧 In Progress |
| Backend Integration (Node.js + MongoDB) | ⏳ Planned |
| JWT Authentication | ⏳ Planned |
| Real-time Notifications | ⏳ Planned |

---

## 📱 App Flow

```
Splash Screen → Role Selection → Login → Loading → Dashboard
```

Each role lands in its own dedicated dashboard with tailored functionality.

---

## 🧩 Modules

### 👨‍💼 Admin Module
- **Dashboard** — Overview of residents, staff, and key metrics
- **Resident Management**
  - View resident list with status badges
  - Add / Edit / Delete residents
  - Detailed resident profile view
- **Staff Management**
  - View all staff members
  - Add new staff via FAB
- **Reports** — *(In Progress)*

### 👩‍⚕️ Caretaker Module *(Upcoming)*
- Medicine tracker
- Daily checklist
- Emergency alerts

### 👨‍👩‍👧 Family Module *(Upcoming)*
- Resident overview
- Health updates
- Notifications

---

## 🎨 UI/UX Highlights

- ✅ Pixel-perfect UI converted from HTML design references
- ✅ Glassmorphism app bars
- ✅ Card-based layouts with gradient sections
- ✅ Status badges for residents and staff
- ✅ FAB-based primary actions
- ✅ Smooth, consistent navigation flow

---

## 🛠️ Tech Stack

### Frontend
- **Flutter** — Cross-platform mobile framework
- **Dart** — Programming language
- **Material UI** — Component library

### Backend *(Planned)*
- **Node.js** + **Express** — REST API server
- **MongoDB** — Database
- **JWT** — Authentication & authorization

---

## 📂 Project Structure

```
lib/
├── main.dart
└── screens/
    ├── splash_screen.dart
    ├── role_selection.dart
    ├── login_screen.dart
    ├── loading_screen.dart
    ├── dashboard_screen.dart          # Admin
    ├── resident_list.dart
    ├── resident_profile.dart
    ├── add_resident.dart
    ├── edit_resident.dart
    ├── manage_staff.dart
    ├── add_staff_screen.dart
    ├── reports_screen.dart
    ├── detailed_report.dart
    ├── caretaker_dashboard.dart       # Caretaker
    └── family_dashboard.dart          # Family
```

---

## ⚙️ Getting Started

Follow the steps below to set up your development environment from scratch and run the Saksham App locally.

---

### 🪟 Step 1 — Install Android Studio

1. Go to 👉 [https://developer.android.com/studio](https://developer.android.com/studio)
2. Click **Download Android Studio** and run the installer
3. During setup, make sure these components are checked:
   - ✅ Android SDK
   - ✅ Android SDK Platform
   - ✅ Android Virtual Device (AVD)
4. Complete the installation and launch Android Studio
5. Go through the **Setup Wizard** — it will automatically download the required SDK components

> 💡 Recommended SDK version: **Android 13.0 (API Level 33)** or higher

---

### 🔧 Step 2 — Configure Android SDK

1. Open Android Studio → **More Actions** → **SDK Manager**
2. Under **SDK Platforms**, check:
   - ✅ Android 13.0 (Tiramisu) — API 33
   - ✅ Android 14.0 — API 34 *(optional but recommended)*
3. Under **SDK Tools**, check:
   - ✅ Android SDK Build-Tools
   - ✅ Android Emulator
   - ✅ Android SDK Platform-Tools
   - ✅ Intel x86 Emulator Accelerator (HAXM) *(Windows/Mac Intel)*
4. Click **Apply** → **OK** to download

---

### 📱 Step 3 — Create a Virtual Device (Emulator)

1. In Android Studio → **More Actions** → **Virtual Device Manager**
2. Click **Create Device**
3. Select a device (e.g., **Pixel 6**) → Click **Next**
4. Select a system image (e.g., **API 33 - Android 13**) → Download if needed → Click **Next**
5. Click **Finish**
6. Press the ▶️ **Play** button to start the emulator

---

### 🐦 Step 4 — Install Flutter SDK

1. Go to 👉 [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
2. Select your OS: **Windows / macOS / Linux**
3. Download the Flutter SDK zip and **extract** it to a location like:
   - Windows: `C:\flutter`
   - macOS/Linux: `~/flutter`

#### Add Flutter to PATH

**Windows:**
1. Search **"Environment Variables"** in Start Menu
2. Under **System Variables** → select `Path` → click **Edit**
3. Click **New** → add `C:\flutter\bin`
4. Click **OK** → restart terminal

**macOS / Linux:**
```bash
export PATH="$PATH:`pwd`/flutter/bin"
# Add this line to ~/.bashrc or ~/.zshrc for permanent setup
```

---

### ✅ Step 5 — Verify Flutter Installation

Open a terminal and run:

```bash
flutter doctor
```

You should see output like:

```
[✓] Flutter (Channel stable)
[✓] Android toolchain - develop for Android devices
[✓] Android Studio
[✓] Connected device
```

Fix any ❌ issues shown by following the suggestions in the output.

> If Android licenses are not accepted, run:
> ```bash
> flutter doctor --android-licenses
> ```
> Press `y` to accept all.

---

### 💻 Step 6 — Install VS Code *(Optional but Recommended)*

1. Download from 👉 [https://code.visualstudio.com](https://code.visualstudio.com)
2. Install the following extensions:
   - 🔵 **Flutter** (by Dart Code)
   - 🔵 **Dart** (by Dart Code)

---

### 📥 Step 7 — Clone the Repository

```bash
git clone https://github.com/Prathamcoder3000/saksham-app.git
cd saksham-app
```

---

### 📦 Step 8 — Install Dependencies

```bash
flutter pub get
```

---

### ▶️ Step 9 — Run the App

Make sure your emulator is running or a physical device is connected, then:

```bash
flutter run
```

To run on a specific device:

```bash
flutter devices          # lists available devices
flutter run -d <device_id>
```

To build a release APK:

```bash
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🗺️ Roadmap

- [x] Admin UI & navigation flow
- [ ] Reports module (in progress)
- [ ] Caretaker module
- [ ] Family module
- [ ] Backend REST API (Node.js + Express)
- [ ] MongoDB database integration
- [ ] JWT authentication system
- [ ] Role-based access control
- [ ] Real-time notifications
- [ ] Image upload functionality

---

## 🤝 Contributing

Contributions are welcome!

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'Add your feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## 📄 License

This project is developed for **educational and academic purposes**.

---

<div align="center">

**👨‍💻 Developer**

**Pratham**

[GitHub: @Prathamcoder3000](https://github.com/Prathamcoder3000)

*Built with ❤️ using Flutter*

</div>
