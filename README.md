# 💰 Personal Finance Tracker

A robust, production‑ready mobile application for tracking personal expenses and income. Built with **Clean Architecture**, **BLoC (Cubit)** for state management, and **Firebase** for real‑time backend services – with full **Arabic (RTL) support** for PDF reports.

[![Flutter](https://img.shields.io/badge/Flutter-3.22+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.4+-blue.svg)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-10.0+-orange.svg)](https://firebase.google.com)
[![BLoC](https://img.shields.io/badge/BLoC-Cubit-007AFF.svg)](https://bloclibrary.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 🚀 Key Features

| Feature | Description |
|---------|-------------|
| **Expense & Income Tracking** | Add, edit, and delete transactions with custom categories (color + icon). Real‑time balance updates using **Firestore atomic batches** – balance never goes negative. |
| **Analytics Dashboard** | View monthly totals, daily averages, percentage change vs previous month, top spending categories, donut chart, and spending behavior insights. |
| **Monthly Reports** | Summary cards, top categories, spending insights, achievements, and **PDF export** with full **Arabic (RTL)** support – includes every transaction detail. |
| **Transaction History** | Searchable and filterable history (by type, description, or category) with total income/expenses summary. |
| **Authentication** | Secure sign‑in / sign‑up with email & password. User **display name** stored in Firestore. |
| **User Settings** | Dark mode toggle, notification preferences, user profile (name + email), and sign‑out – all persisted in Firestore. |
| **Real‑time Sync** | All data synchronizes instantly via Firestore streams – no manual refresh needed. |
| **Responsive UI** | Consistent dark theme with bottom navigation (Home, Analytics, Categories, Reports, Settings). |

---

## 🏗️ Architecture & Tech Stack

| Category | Technologies |
|----------|--------------|
| **Framework** | Flutter 3.22+, Dart 3.4+ |
| **Architecture** | Clean Architecture (Domain, Data, Presentation) |
| **State Management** | BLoC (Cubit) |
| **Backend** | Firebase (Authentication, Firestore) |
| **Dependency Injection** | Injectable + GetIt (code‑generated) |
| **PDF Generation** | pdf, printing, share_plus (with Cairo font for Arabic) |
| **OTA Updates** | Shorebird |
| **Local Storage** | SharedPreferences |
| **Charts** | fl_chart |
| **Internationalization** | intl, Google Fonts (Cairo) |

---

## 📁 Folder Structure (Clean Architecture)
