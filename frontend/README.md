<div align="center">

<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
<img src="https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" />
<img src="https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white" />
<img src="https://img.shields.io/badge/Status-In%20Development-orange?style=for-the-badge" />

# 🏥 Saksham App

**A comprehensive multi-role healthcare & caretaker management mobile application**

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
| Caretaker Dashboard | ✅ Done |
| Medicine Tracker | ✅ Done |
| Daily Checklist | ✅ Done |
| Emergency SOS | ✅ Done |
| Family Dashboard | ✅ Done |
| Reports Module | ✅ Done |
| Task Management | ✅ Done |
| Backend Integration (Node.js + MongoDB) | ⏳ Planned |
| JWT Authentication | ⏳ Planned |
| Real-time Notifications | ⏳ Planned |
| Image Upload | ⏳ Planned |

---

---

## 📱 App Flow

```
Splash Screen → Login → Role Selection → Dashboard
```

Each role lands in its own dedicated dashboard with tailored functionality:

- **Admin**: Full management access to residents, staff, reports, and tasks
- **Caretaker**: Focus on daily care activities, medicine tracking, and emergency response
- **Family**: Health monitoring and resident well-being updates

---

## 🚀 Current Development Status

**Frontend Complete** ✅
- All core features implemented and functional
- Multi-platform support (Android, iOS, Web, Desktop)
- Pixel-perfect UI with custom design system
- Comprehensive user flows for all three roles

**Backend Integration** ⏳
- Ready for API integration
- Data models defined
- Authentication system planned

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
- **Reports** — Detailed analytics and reports
- **Task Management** — Assign and track tasks

### 👩‍⚕️ Caretaker Module
- **Dashboard** — Caretaker-specific overview
- **Medicine Tracker** — Track medication schedules and administration
- **Daily Checklist** — Daily care routine checklists
- **Emergency SOS** — Quick emergency response system
- **Resident Management** — View and update resident information

### 👨‍👩‍👧 Family Module
- **Dashboard** — Family member overview
- **Health Snapshot** — Real-time health metrics and updates
- **Resident Monitoring** — Track resident well-being
- **Notifications** — Health alerts and updates

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
- **Custom Fonts** — Lexend font family
- **Percent Indicator** — Progress indicators library

### Platform Support
- **Android** — Native Android apps
- **iOS** — Native iOS apps
- **Web** — Progressive Web App
- **Windows** — Desktop application
- **Linux** — Desktop application
- **macOS** — Desktop application

### Backend *(Planned)*
- **Node.js** + **Express** — REST API server
- **MongoDB** — Database
- **JWT** — Authentication & authorization

---

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   └── medicine.dart                  # Medicine data model
├── screens/
│   ├── login_screen.dart              # Authentication screen
│   ├── loading_screen.dart            # Loading indicator
│   ├── forgot_password.dart           # Password recovery
│   ├── dashboard_screen.dart          # Admin dashboard
│   ├── resident_list.dart             # Resident list view
│   ├── resident_profile.dart          # Resident profile details
│   ├── add_resident.dart              # Add new resident
│   ├── edit_resident.dart             # Edit resident info
│   ├── manage_staff.dart              # Staff management
│   ├── add_staff_screen.dart          # Add new staff
│   ├── add_task_screen.dart           # Task assignment
│   ├── reports_screen.dart            # Reports overview
│   ├── detailed_report.dart           # Detailed analytics
│   ├── caretaker_dashboard.dart       # Caretaker dashboard
│   ├── caretaker_resident_list.dart   # Caretaker resident view
│   ├── caretaker_resident_profile.dart # Caretaker resident profile
│   ├── caretaker_edit_resident.dart   # Caretaker edit resident
│   ├── medicine_tracker.dart          # Medication management
│   ├── daily_checklist_screen.dart    # Daily care checklist
│   ├── emergency_sos.dart             # Emergency response
│   └── family_dashboard.dart          # Family dashboard
├── utils/                             # Utility functions
└── widgets/                           # Reusable UI components
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

#### Platform-Specific Commands

**Android APK:**
```bash
flutter build apk --release
```
*Output:* `build/app/outputs/flutter-apk/app-release.apk`

**iOS (macOS only):**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter run -d chrome
# or
flutter build web
```

**Windows (Windows only):**
```bash
flutter run -d windows
```

**Linux (Linux only):**
```bash
flutter run -d linux
```

**macOS (macOS only):**
```bash
flutter run -d macos
```

---

## 🗺️ Roadmap

- [x] Admin UI & navigation flow
- [x] Resident management system
- [x] Staff management system
- [x] Caretaker dashboard & features
- [x] Medicine tracking system
- [x] Daily checklist functionality
- [x] Emergency SOS system
- [x] Family dashboard
- [x] Reports & analytics
- [x] Task management
- [x] Multi-platform deployment
- [ ] Backend REST API (Node.js + Express)
- [ ] MongoDB database integration
- [ ] JWT authentication system
- [ ] Role-based access control
- [ ] Real-time notifications
- [ ] Image upload functionality
- [ ] Push notifications
- [ ] Offline data synchronization

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

This project is developed for **educational and academic purposes**. All rights reserved.

---

<div align="center">

**👨‍💻 Developer**

**Pratham**

[GitHub: @Prathamcoder3000](https://github.com/Prathamcoder3000)

*Built with ❤️ using Flutter*

**Version:** 1.0.0

</div>
