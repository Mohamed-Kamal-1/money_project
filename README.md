# 💰 Personal Finance Tracker 

A robust and highly maintainable mobile application designed to help users track expenses, categorize transactions, and generate clear financial reports. 

Built with a strict adherence to **Clean Architecture** and **SOLID principles** to ensure scalability, decoupled logic, and a seamless developer experience.

---

## 🚀 Key Features
* **Expense & Income Tracking:** Easily log and monitor daily financial transactions.
* **Smart Categorization:** Organize transactions into customizable categories for better financial overview.
* **Financial Reporting:** Generate insights and summaries to track spending habits over time.
* **Real-Time Synchronization:** Secure and instant data updates powered by Firebase.
* **Instant Updates (OTA):** Seamlessly receive bug fixes and feature updates without App Store/Google Play delays, using Shorebird.

---

## 🏗️ Architecture & Tech Stack
This project is engineered with a deep focus on separating concerns, making the codebase highly testable and easy to maintain.

* **Framework:** [Flutter](https://flutter.dev) & Dart
* **Architecture:** Clean Architecture (Domain, Data, and Presentation layers)
* **State Management:** [BLoC / Cubit](https://pub.dev/packages/flutter_bloc) for predictable state transitions and centralized business logic.
* **Backend & Database:** Firebase (Authentication & Cloud Firestore) for secure, real-time data handling.
* **Over-The-Air (OTA) Updates:** [Shorebird](https://shorebird.dev)

---

## 📂 Folder Structure (Clean Architecture)
The application strictly follows a layered architecture:
* **`domain/`**: Contains core business rules, Entities, and Repository Interfaces (Completely independent of any framework).
* **`data/`**: Implements repositories, handles API calls, Firebase interactions, and data models.
* **`presentation/`**: Contains UI components (Widgets, Screens) and State Management (Cubits), responding to user inputs and displaying states.

---

## ✨ Technical Highlights
* **Decoupled Logic:** Business logic is entirely separated from the UI layer using Cubit.
* **Scalable Foundation:** The project structure is ready to accommodate new features without refactoring core logic.
* **Clean Code:** Adheres to SOLID principles with descriptive naming conventions and modularized code.

---

## 📸 Screenshots
*(Add your application screenshots here to showcase the UI)*
| Home Screen | Transactions | Reports |
| ----------- | ----------- | ----------- |
| <img src="" width="200"> | <img src="" width="200"> | <img src="" width="200"> |

---

## 🛠️ Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/Mohamed-Kamal-1/money_project.git](https://github.com/Mohamed-Kamal-1/money_project.git)
