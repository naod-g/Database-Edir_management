-- === creating all tables===
-- 1. Member Table
CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    join_date DATE NOT NULL
);

-- 2. Contribution Table
CREATE TABLE Contribution (
    contribution_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    amount DECIMAL(10,2) NOT NULL,
    contribution_date DATE NOT NULL,
    status ENUM('paid', 'unpaid') DEFAULT 'paid',
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- 3. Loan Table
CREATE TABLE Loan (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    loan_amount DECIMAL(10,2) NOT NULL,
    date_requested DATE NOT NULL,
    status ENUM('pending', 'approved', 'rejected', 'repaid') DEFAULT 'pending',
    approved_by VARCHAR(100),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- 4. Repayment Table
CREATE TABLE Repayment (
    repayment_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT,
    amount_paid DECIMAL(10,2) NOT NULL,
    date_paid DATE NOT NULL,
    FOREIGN KEY (loan_id) REFERENCES Loan(loan_id)
);

-- Enforce repayment cannot exceed loan amount
-- Note: MySQL does not support subqueries in CHECK constraints, so this must be enforced via triggers or application logic
ALTER TABLE Repayment
ADD CONSTRAINT chk_repayment_valid
CHECK (
  amount_paid > 0
);

-- 5. EdirEvent Table
CREATE TABLE EdirEvent (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_type ENUM('Funeral Support', 'Wedding Gift', 'Medical Assistance'),
    recipient_id INT,
    amount_disbursed DECIMAL(10,2) NOT NULL,
    event_date DATE NOT NULL,
    FOREIGN KEY (recipient_id) REFERENCES members(member_id)
);


-- Insert members
INSERT INTO members (full_name, phone, join_date) VALUES
('Alem Kebede', '0912345678', '2023-01-15'),
('Meklit Yonas', '0912345679', '2023-01-20'),
('Biniam Tesfaye', '0912345680', '2023-02-01'),
('Natan Habte', '0912345681', '2023-02-10'),
('Nathnael Girma', '0912345682', '2023-02-15'),
('Mohammed Ali', '0912345683', '2023-02-20'),
('Ruth Tadesse', '0912345684', '2023-03-01'),
('Rodas Desta', '0912345685', '2023-03-05'),
('Mahder Alemu', '0912345686', '2023-03-10'),
('Selam Berhane', '0912345687', '2023-03-12'),
('Yonatan Haile', '0912345688', '2023-03-15'),
('Lidiya Fekadu', '0912345689', '2023-03-18');

-- Insert contribution
INSERT INTO Contribution (member_id, amount, contribution_date) VALUES
(1, 50.00, '2023-03-01'),
(2, 50.00, '2023-03-01'),
(3, 70.00, '2023-03-01'),
(4, 80.00, '2023-03-01'),
(5, 57.00, '2023-03-01'),
(6, 52.00, '2023-03-01'),
(7, 50.00, '2023-03-01'),
(8, 34.00, '2023-03-01');

-- Insert Loans
INSERT INTO Loan (member_id, loan_amount, date_requested, status, approved_by) VALUES
(2, 700.00, '2023-03-15', 'approved', 'NAOD'),
(3, 300.00, '2023-03-20', 'pending', NULL),
(4, 1000.00, '2023-03-25', 'approved', 'NAOD'),
(5, 450.00, '2023-04-01', 'approved', 'Committee '),
(6, 800.00, '2023-04-05', 'approved', 'Committee '),
(7, 200.00, '2023-04-10', 'repaid', 'NAOD');

-- Insert Repayments
INSERT INTO Repayment (loan_id, amount_paid, date_paid) VALUES
(2, 350.00, '2023-04-15'),
(2, 350.00, '2023-05-15'),
(4, 500.00, '2023-04-30'),
(4, 500.00, '2023-05-30'),
(5, 450.00, '2023-05-01'),
(7, 200.00, '2023-05-05');

-- Insert Edir Event
INSERT INTO EdirEvent (event_type, recipient_id, amount_disbursed, event_date) VALUES
('Funeral Support', 2, 100.00, '2023-04-05'),
('Wedding Gift', 3, 150.00, '2023-04-10'),
('Medical Assistance', 4, 200.00, '2023-04-12'),
('Funeral Support', 5, 100.00, '2023-04-20'),
('Wedding Gift', 6, 150.00, '2023-04-25'),
('Funeral Support', 7, 100.00, '2023-04-30'),
('Medical Assistance', 8, 200.00, '2023-05-05'),
('Wedding Gift', 9, 150.00, '2023-05-10'),
('Funeral Support', 10, 100.00, '2023-05-15'),
('Medical Assistance', 11, 250.00, '2023-05-20'),
('Wedding Gift', 12, 180.00, '2023-05-25');

-- 1. View all members
SELECT * FROM members;

-- 2. Show contributions for March
SELECT M.full_name, C.amount, C.contribution_date
FROM Contribution C
JOIN members M ON C.member_id = M.member_id
WHERE MONTH(C.contribution_date) = 3;

-- 3. Active loans
SELECT M.full_name, L.loan_amount, L.status
FROM Loan L
JOIN members M ON L.member_id = M.member_id
WHERE L.status IN ('approved', 'pending');

-- 4. Total fund balance
SELECT 
    (SELECT IFNULL(SUM(amount),0) FROM Contribution) -
    (SELECT IFNULL(SUM(loan_amount),0) FROM Loan WHERE status != 'repaid') -
    (SELECT IFNULL(SUM(amount_disbursed),0) FROM EdirEvent) AS fund_balance;

-- 5. Members with unpaid contributions
SELECT M.full_name, C.contribution_date
FROM Contribution C
JOIN members M ON C.member_id = M.member_id
WHERE C.status = 'unpaid';
