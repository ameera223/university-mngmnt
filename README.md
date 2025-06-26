# university-mngmnt
📘 University Management System – PostgreSQL
This project implements a simple University Management System using PostgreSQL. It covers schema design, table creation, constraints, sample data insertion, CRUD operations, and indexing for performance optimization.

📂 Project Structure
.
├── university_management_system.sql  # Full SQL script
└── README.md                         # Project documentation

🧱 Schema Overview
ER Diagram 
[departments]
- department_id (PK)
- name (UNIQUE, NOT NULL)

[professors]
- professor_id (PK)
- name (NOT NULL)
- email (UNIQUE)
- salary
- department_id (FK → departments.department_id)

[students]
- student_id (PK)
- name (NOT NULL)
- email (UNIQUE)
- enrollment_year (>= 2000)
- department_id (FK → departments.department_id)

[courses]
- course_id (PK)
- title (NOT NULL)
- credits (> 0)
- department_id (FK → departments.department_id)
- professor_id (FK → professors.professor_id)

  
Relationships
A Department has many Professors, Students, and Courses.

A Professor teaches many Courses.

A Course belongs to one Department and is taught by one Professor.

A Student belongs to one Department.

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
