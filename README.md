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

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart ≥ 3.0.0
- Android Studio / VS Code

### 1. Clone the Repository

```bash
git clone https://github.com/Prathamcoder3000/saksham-app.git
cd saksham-app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

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
