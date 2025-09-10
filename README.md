#  Finance Tracker Database

This project provides a **MySQL-based Finance Tracker** to manage users, income, and expenses with category-wise tracking and monthly balance reporting.  

It is designed to help you **analyze income, expenses, and balances** for multiple users with built-in reports and views.  

---

##  Project Structure
- **Database**: `finance_tracker`
- **Tables**:
  - `users` → Stores user details  
  - `categories` → Stores income/expense categories  
  - `income` → Stores all income transactions  
  - `expenses` → Stores all expense transactions  
- **Views**:
  - `user_balance` → Calculates total income, total expense, and balance for each user  

---

##  Features
- Track **multiple users** with unique income and expense records.  
- Categorize transactions as **income** or **expense** (Salary, Rent, Food, etc.).  
- Generate **monthly reports**:
  - Total income and expenses per month  
  - Category-wise spending summary  
  - Net balance (Income − Expense)  
- Preloaded with **dummy data** for quick testing.  

---

##  Setup Instructions
1. Clone this repository:
  git clone https://github.com/your-username/finance-tracker.git
  cd finance-tracker
2. Open MySQL Workbench or your preferred SQL client.
3. Run the `index.sql` script to:

   * Create the database
   * Create tables and relationships
   * Insert sample data
   * Create useful views and queries

---

##  Example Reports

* **Total Expenses per User per Month**
* **Category-Wise Spending Analysis**
* **Monthly Income vs Expenses vs Balance**

---

##  Tech Stack

* **Database**: MySQL
* **Language**: SQL (DDL + DML + Views)

---




