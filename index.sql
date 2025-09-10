-- Create database
CREATE DATABASE finance_tracker;
USE finance_tracker;

-- Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL
);

-- Categories table
CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    category_type ENUM('income', 'expense') NOT NULL
);

-- Income table
CREATE TABLE income (
    income_id INT PRIMARY KEY,
    user_id INT,
    category_id INT,
    amount DECIMAL(10,2),
    tx_date DATE,
    note VARCHAR(200),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Expenses table
CREATE TABLE expenses (
    expense_id INT PRIMARY KEY,
    user_id INT,
    category_id INT,
    amount DECIMAL(10,2),
    tx_date DATE,
    payment_method VARCHAR(50),
    note VARCHAR(200),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

--INSERT DUMMY DATA

-- Insert Users
INSERT INTO users VALUES 
(1, 'Uma Maheswari'),
(2, 'Vasanth Kumar'),
(3, 'Priya Sharma');

-- Insert Categories
INSERT INTO categories VALUES
(1, 'Salary', 'income'),
(2, 'Freelance', 'income'),
(3, 'Food', 'expense'),
(4, 'Transport', 'expense'),
(5, 'Rent', 'expense'),
(6, 'Shopping', 'expense'),
(7, 'Bills', 'expense');

-- Insert Income
INSERT INTO income VALUES
(1, 1, 1, 50000.00, '2025-06-01', 'June Salary'),
(2, 1, 2, 6000.00, '2025-06-15', 'Freelance Work'),
(3, 2, 1, 40000.00, '2025-06-05', 'June Salary'),
(4, 2, 2, 3000.00, '2025-06-20', 'Part-time Job'),
(5, 3, 1, 55000.00, '2025-06-01', 'June Salary');

-- Insert Expenses
INSERT INTO expenses VALUES
(1, 1, 5, 15000.00, '2025-06-02', 'UPI', 'Rent'),
(2, 1, 3, 3500.00, '2025-06-05', 'Card', 'Groceries'),
(3, 2, 5, 10000.00, '2025-06-03', 'Cash', 'Rent'),
(4, 2, 4, 800.00, '2025-06-06', 'Cash', 'Bus Pass'),
(5, 3, 5, 12000.00, '2025-06-01', 'Card', 'Rent'),
(6, 3, 7, 2000.00, '2025-06-07', 'Card', 'Electricity Bill');
 
 --Queries to Summarize Expenses Monthly

 --Total expenses per user per month:

SELECT  
    u.name,
    DATE_FORMAT(e.tx_date, '%Y-%m') AS month,
    SUM(e.amount) AS total_expense
FROM expenses e
JOIN users u ON e.user_id = u.user_id
GROUP BY u.name, month;


--Category-Wise Spending (with GROUP BY)

SELECT 
    u.name,
    c.name,
    SUM(e.amount) AS total_spent
FROM expenses e
JOIN users u ON e.user_id = u.user_id
JOIN categories c ON e.category_id = c.category_id
GROUP BY u.name, c.name
ORDER BY u.name;

--Create Views for Balance Tracking

--View to calculate Income - Expense = Balance
CREATE VIEW user_balance AS
SELECT 
    u.user_id,
    u.name,
    IFNULL((SELECT SUM(amount) FROM income i WHERE i.user_id = u.user_id), 0) AS total_income,
    IFNULL((SELECT SUM(amount) FROM expenses e WHERE e.user_id = u.user_id), 0) AS total_expense,
    (IFNULL((SELECT SUM(amount) FROM income i WHERE i.user_id = u.user_id), 0) -
     IFNULL((SELECT SUM(amount) FROM expenses e WHERE e.user_id = u.user_id), 0)) AS balance
FROM users u;

--Check balances:
SELECT * FROM user_balance;

--query for monthly report:
SELECT  
    u.user_id,
    u.name,
    t.month,
    t.total_income,
    IFNULL(e.total_expense, 0) AS total_expense,
    (t.total_income - IFNULL(e.total_expense, 0)) AS balance
FROM (
    -- Income grouped by user and month
    SELECT  
        i.user_id,
        DATE_FORMAT(i.tx_date, '%Y-%m') AS month,
        SUM(i.amount) AS total_income
    FROM income i
    GROUP BY i.user_id, DATE_FORMAT(i.tx_date, '%Y-%m')
) t
JOIN users u ON t.user_id = u.user_id
LEFT JOIN (
    -- Expenses grouped by user and month
    SELECT  
        e.user_id,
        DATE_FORMAT(e.tx_date, '%Y-%m') AS month,
        SUM(e.amount) AS total_expense
    FROM expenses e
    GROUP BY e.user_id, DATE_FORMAT(e.tx_date, '%Y-%m')
) e
ON t.user_id = e.user_id AND t.month = e.month
ORDER BY u.user_id, t.month;


