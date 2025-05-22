# 🏛️ Edir Management System

A relational database system designed to manage member contributions, loans, repayments, and event-based support for traditional Ethiopian Edirs.

---

## 📘 Overview

This project aims to digitize the core operations of a local Edir by implementing a structured, normalized MySQL database. It covers:
- Monthly contribution tracking
- Loan request and repayment management
- Edir event disbursement recording (e.g., funerals, weddings)
- Real-time fund balance and reporting

---

## 🔧 Technologies Used

- **Database**: MySQL
- **Design Tool**: dbdiagram.io (DBML)
- **Development Tools**: VS Code, MySQL Workbench
- **Documentation**: Markdown, IEEE format

---

## 🗂️ Project Structure

| File | Description |
|------|-------------|
| `tables.sql` | SQL script to create all tables and relationships |
| `insert_sample_data.sql` | Test data for members, loans, events, etc. |
| `README.md` | Project overview and setup instructions |
| `test_queries.sql` | Sample queries to demonstrate reports and checks |
| `erd.dbml` | ER diagram code (DBML format for dbdiagram.io) |

---

## 🧪 Features

- Member registration and contribution tracking  
- Loan creation, approval, and repayment logging  
- Event-based fund disbursement (funerals, weddings, medical)  
- Query-based reporting: fund balance, unpaid members, active loans  
- Junction tables for all relationships (1:M explicitly modeled)

---

## ✅ Requirements

- MySQL 8.0 or later  
- MySQL Workbench or command-line access  
- (Optional) [dbdiagram.io](https://dbdiagram.io) for ERD visualization

---

## 🚀 Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/edir-management-system.git
