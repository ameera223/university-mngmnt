
-- University Management System

-- Create Departments Table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Create Professors Table
CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary NUMERIC(10, 2),
    department_id INTEGER REFERENCES departments(department_id) ON DELETE SET NULL
);

-- Create Students Table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    enrollment_year INT CHECK (enrollment_year >= 2000),
    department_id INTEGER REFERENCES departments(department_id) ON DELETE SET NULL
);

-- Create Courses Table
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    credits INTEGER CHECK (credits > 0),
    department_id INTEGER REFERENCES departments(department_id) ON DELETE SET NULL,
    professor_id INTEGER REFERENCES professors(professor_id) ON DELETE SET NULL
);

-- Insert Departments
INSERT INTO departments (name)
VALUES 
  ('Computer Science'),
  ('Mathematics'),
  ('Physics');

-- Insert Professors
INSERT INTO professors (name, email, salary, department_id)
VALUES 
  ('Dr. Alan Turing', 'turing@univ.edu', 100000, 1),
  ('Dr. Ada Lovelace', 'ada@univ.edu', 95000, 1),
  ('Dr. Carl Gauss', 'gauss@univ.edu', 90000, 2),
  ('Dr. Richard Feynman', 'feynman@univ.edu', 98000, 3),
  ('Dr. Emmy Noether', 'noether@univ.edu', 97000, 2);

-- Insert Students
INSERT INTO students (name, email, enrollment_year, department_id)
VALUES 
  ('Alice', 'alice@student.edu', 2022, 1),
  ('Bob', 'bob@student.edu', 2022, 1),
  ('Charlie', 'charlie@student.edu', 2021, 2),
  ('David', 'david@student.edu', 2023, 2),
  ('Eve', 'eve@student.edu', 2022, 3),
  ('Frank', 'frank@student.edu', 2021, 1),
  ('Grace', 'grace@student.edu', 2023, 3),
  ('Hank', 'hank@student.edu', 2023, 2),
  ('Ivy', 'ivy@student.edu', 2021, 1),
  ('Jack', 'jack@student.edu', 2023, 3);

-- Insert Courses
INSERT INTO courses (title, credits, department_id, professor_id)
VALUES 
  ('Data Structures', 4, 1, 1),
  ('Algorithms', 4, 1, 2),
  ('Linear Algebra', 3, 2, 3),
  ('Calculus', 3, 2, 5),
  ('Quantum Mechanics', 4, 3, 4),
  ('Thermodynamics', 3, 3, 4),
  ('Computer Networks', 4, 1, 1),
  ('Statistics', 3, 2, 5);

-- CRUD Operations

-- Update professor salary by 10%
UPDATE professors
SET salary = salary * 1.10;

-- Select students in Computer Science department
SELECT s.name, s.email
FROM students s
JOIN departments d ON s.department_id = d.department_id
WHERE d.name = 'Computer Science';

-- Delete course
DELETE FROM courses
WHERE course_id = 6;

-- Create Indexes for performance
CREATE INDEX idx_students_department ON students(department_id);
CREATE INDEX idx_professors_department ON professors(department_id);
CREATE INDEX idx_courses_department ON courses(department_id);
