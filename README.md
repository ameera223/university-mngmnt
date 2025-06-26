# university-mngmnt
📘 University Management System – PostgreSQL
This project implements a simple University Management System using PostgreSQL. It covers schema design, table creation, constraints, sample data insertion, CRUD operations, and indexing for performance optimization.

📂 Project Structure
.
├── university_management_system.sql  # Full SQL script
└── README.md                         # Project documentation
🧱 Schema Overview
The system includes the following tables:

Table	Description
departments	Stores department details
professors	Stores professor information
students	Stores student information
courses	Stores course information linked to professors and departments

🔄 Relationships
Each department can have multiple professors, students, and courses.

Each course is taught by one professor and belongs to one department.

📥 How to Use
🛠 Prerequisites
PostgreSQL installed

📌 Features Implemented
✅ Relational Schema with Constraints
✅ Sample Data (Departments, Professors, Students, Courses)
✅ CRUD Operations
✅ Indexes for Query Optimization
✅ Referential Integrity and Validation Checks

🔍 Example Queries

-- Get all students in Computer Science department
SELECT s.name
FROM students s
JOIN departments d ON s.department_id = d.department_id
WHERE d.name = 'Computer Science';

-- Increase professor salaries by 10%
UPDATE professors
SET salary = salary * 1.10;

📝 License
This project is licensed under the MIT License.
