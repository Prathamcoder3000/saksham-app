<div align="center">

# 🏥 Saksham Smart Care Management System

**Empowering caretakers. Reassuring families. Connecting care.**

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://nodejs.org/)
[![MongoDB](https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=for-the-badge&logo=mongodb&logoColor=white)](https://www.mongodb.com/)
[![Express.js](https://img.shields.io/badge/express.js-%23404d59.svg?style=for-the-badge&logo=express&logoColor=white)](https://expressjs.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

<p align="center">
    <a href="#-problem-statement">Problem</a> •
    <a href="#-features">Features</a> •
    <a href="#-how-it-works">How It Works</a> •
    <a href="#-tech-stack">Tech Stack</a> •
    <a href="#-installation--setup">Setup</a> •
    <a href="#-roadmap">Roadmap</a>
</p>

</div>

---

## 🛑 Problem Statement

Fragmented paper logs in elderly care facilities cause miscommunication, delayed medical responses, and inefficient management. Saksham replaces this chaos with a transparent digital ecosystem, giving families real-time visibility and peace of mind while streamlining daily operations for staff.

---

## ✨ Features

- 🏢 **Streamline Operations**: Manage staff and resident records centrally through an intuitive Admin Dashboard.
- 💊 **Ensure Medication Accuracy**: Track exact doses and timestamps digitally to eliminate missed or duplicate medications.
- ❤️ **Monitor Vitals Instantly**: Record and visualize critical health data (Blood Pressure, Heart Rate, SpO2) effortlessly.
- 👨‍👩‍👧‍👦 **Reassure Loved Ones**: Provide families with a dedicated portal for real-time health updates, event calendars, and peace of mind.
- 🚨 **Respond Rapidly**: Trigger facility-wide SOS alerts instantly during emergencies via seamless WebSocket integration.

---

## 🔄 How It Works

**Step 1: Facility Setup**  
Administrators onboard medical staff, register elderly residents, and establish daily care and medication schedules through the Admin panel.

**Step 2: Daily Care Execution**  
Caretakers use the intuitive mobile interface to follow their daily checklists, log vital signs, and verify medication administration at the bedside.

**Step 3: Family Monitoring**  
Relatives securely log into the Family Portal to monitor their loved one's real-time health status, view care logs, and stay informed about upcoming appointments.

---

## 📸 Screenshots

<div align="center">
  <table style="width:100%">
    <tr>
      <td width="33%"><img src="https://via.placeholder.com/300x600?text=Admin+Dashboard" alt="Admin Dashboard Interface"/><br/><sub><b>Admin Dashboard: Central Command</b></sub></td>
      <td width="33%"><img src="https://via.placeholder.com/300x600?text=Caretaker+Workspace" alt="Caretaker Workspace Interface"/><br/><sub><b>Caretaker Workspace: Daily Tasks</b></sub></td>
      <td width="33%"><img src="https://via.placeholder.com/300x600?text=Family+Portal" alt="Family Portal Interface"/><br/><sub><b>Family Portal: Real-time Updates</b></sub></td>
    </tr>
    <tr>
      <td width="33%"><img src="https://via.placeholder.com/300x600?text=Medicine+Tracker" alt="Medicine Tracker Interface"/><br/><sub><b>Medicine Tracker: Dose Verification</b></sub></td>
      <td width="33%"><img src="https://via.placeholder.com/300x600?text=Vitals+Graph" alt="Vitals Graph Interface"/><br/><sub><b>Vitals History: Health Trends</b></sub></td>
      <td width="33%"><img src="https://via.placeholder.com/300x600?text=Resident+Profile" alt="Resident Profile Interface"/><br/><sub><b>Resident Profile: Digital Records</b></sub></td>
    </tr>
  </table>
</div>

---

## 💻 Tech Stack

| Category | Technologies |
| :--- | :--- |
| **Frontend Mobile App** | Flutter, Dart, Provider, `fl_chart` |
| **Backend Server** | Node.js, Express.js |
| **Database & ODM** | MongoDB Atlas, Mongoose |
| **Real-Time Comm.** | Socket.io |
| **Security & Auth** | JSON Web Tokens (JWT), Bcrypt.js |
| **Hosting (Backend)** | Render |

---

## ⚙️ Installation & Setup

### 📦 Prerequisites
- **Node.js**: v18.0+
- **Flutter SDK**: v3.10+
- **MongoDB**: Active Atlas cluster or local instance

### 1️⃣ Backend Setup
1. Clone the repository and navigate to the backend:
   ```bash
   git clone https://github.com/Prathamcoder3000/saksham-app.git
   cd saksham-app/backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Set up your environment variables by creating a `.env` file:

   | Variable | Description | Example |
   | :--- | :--- | :--- |
   | `PORT` | Backend port | `5000` |
   | `MONGO_URI` | MongoDB connection string | `mongodb+srv://user:pass@cluster...` |
   | `JWT_SECRET` | Secret key for Auth tokens | `supersecretkey_123` |
   | `JWT_EXPIRE` | Token expiration time | `7d` |
   | `NODE_ENV` | Environment mode | `development` |

4. Run the server locally:
   ```bash
   npm run dev
   ```

### 2️⃣ Frontend Setup
1. Navigate to the frontend directory:
   ```bash
   cd ../frontend
   ```
2. Install Flutter packages:
   ```bash
   flutter pub get
   ```
3. Update the API Base URL in `lib/services/api_service.dart` to point to your local machine (`http://10.0.2.2:5000` for Android emulator) if running locally.
4. Run the application:
   ```bash
   flutter run
   ```

---

## 🗺️ Roadmap

- [x] Secure Role-Based Access Control (Admin, Caretaker, Family)
- [x] Caretaker Daily Checklist & Medication Tracker
- [x] Real-time Health Feed & Vitals Logging
- [ ] AI-Powered Health Anomaly Prediction
- [ ] Wearable Device Integration (Apple Watch, Fitbit)
- [ ] Secure Video Consultation Portal
- [ ] Offline-first architecture for internet dead-zones

---

## 🤝 Contributing

We welcome contributions to help build a smarter, safer future in care!

1. **Fork** the repository.
2. **Clone** your fork locally.
3. **Create a branch** for your feature (`git checkout -b feature/AmazingFeature`).
4. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`).
5. **Push** to the branch (`git push origin feature/AmazingFeature`).
6. Open a **Pull Request** and describe your changes.

---

## 🎓 Project Credits

| | |
|:---|:---|
| 🏫 **Institution** | [Vivekanand Education Society's Institute of Technology (VESIT)](https://www.ves.ac.in/), Chembur, Mumbai |
| 📚 **Department** | Computer Engineering |
| 📅 **Year** | 2nd Year, Division D7A |
| 🧑‍🏫 **Project Guide** | Dr. Indu Dokare |

**👥 Team Members**

| Name |
|:---|
| Prathamesh Shelar |
| Awwab Mhaiskar |
| Swarangi Savekar |
| Ketaki Patil |

---

## 📄 License & Author

**Author**: Prathamesh Shelar ([GitHub](https://github.com/Prathamcoder3000))  
**License**: This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

<div align="center">
  <i>Made with ❤️ at VESIT, Mumbai — for a Smarter Future in Care.</i>
</div>