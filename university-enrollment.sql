--Extend the University Management System database to include enrollments and grade history tables

-- Create Enrollments Table
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES students(student_id) ON DELETE CASCADE,
    course_id INT NOT NULL REFERENCES courses(course_id) ON DELETE CASCADE,
    grade NUMERIC(5,2) CHECK (grade >= 0 AND grade <= 100),
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(20) CHECK (status IN ('enrolled', 'completed', 'dropped'))
);

-- Create Grade History Table
CREATE TABLE grade_history (
    history_id SERIAL PRIMARY KEY,
    enrollment_id INT REFERENCES enrollments(enrollment_id) ON DELETE CASCADE,
    grade NUMERIC(5,2),
    recorded_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    recorded_by VARCHAR(100)
);


INSERT INTO enrollments (student_id, course_id, grade, enrollment_date, status) VALUES
  (1, 1, 92.5, '2024-01-10', 'completed'),
  (2, 1, 85.0, '2024-01-10', 'completed'),
  (3, 3, 78.5, '2024-01-15', 'completed'),
  (4, 4, 88.0, '2024-01-20', 'completed'),
  (5, 5, 91.0, '2024-01-25', 'completed'),
  (6, 7, 75.0, '2024-02-01', 'completed'),
  (7, 6, 80.0, '2024-02-05', 'completed'),
  (8, 8, 83.0, '2024-02-10', 'completed'),
  (9, 2, 95.0, '2024-02-15', 'completed'),
  (10, 5, 89.5, '2024-02-20', 'completed');


INSERT INTO grade_history (enrollment_id, grade, recorded_date, recorded_by) VALUES
  (1, 90.0, '2024-01-11', 'Dr. Turing'),
  (1, 92.5, '2024-01-18', 'Dr. Turing'),

  (2, 82.0, '2024-01-11', 'Dr. Turing'),
  (2, 85.0, '2024-01-18', 'Dr. Turing'),

  (3, 76.0, '2024-01-16', 'Dr. Gauss'),
  (3, 78.5, '2024-01-23', 'Dr. Gauss'),

  (4, 85.0, '2024-01-21', 'Dr. Noether'),
  (4, 88.0, '2024-01-27', 'Dr. Noether'),

  (5, 89.0, '2024-01-26', 'Dr. Feynman'),
  (5, 91.0, '2024-01-30', 'Dr. Feynman'),

  (6, 73.0, '2024-02-02', 'Dr. Turing'),
  (6, 75.0, '2024-02-08', 'Dr. Turing'),

  (7, 77.0, '2024-02-06', 'Dr. Feynman'),
  (7, 80.0, '2024-02-13', 'Dr. Feynman'),

  (8, 80.0, '2024-02-11', 'Dr. Noether'),
  (8, 83.0, '2024-02-18', 'Dr. Noether'),

  (9, 93.0, '2024-02-16', 'Dr. Lovelace'),
  (9, 95.0, '2024-02-22', 'Dr. Lovelace'),

  (10, 86.0, '2024-02-21', 'Dr. Feynman'),
  (10, 89.5, '2024-02-28', 'Dr. Feynman');


-- Indexes on foreign keys and join columns in enrollments
CREATE INDEX idx_enrollments_student ON enrollments(student_id);
CREATE INDEX idx_enrollments_course ON enrollments(course_id);
CREATE INDEX idx_enrollments_status ON enrollments(status);

-- Indexes on grade history
CREATE INDEX idx_grade_history_enrollment ON grade_history(enrollment_id);
CREATE INDEX idx_grade_history_recorded_by ON grade_history(recorded_by);


-- Students and their courses
 SELECT s.name AS student_name, c.title AS course_name, e.grade
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN courses c ON e.course_id = c.course_id;

-- Enrollment count and average grade per course
SELECT c.title, COUNT(e.enrollment_id) AS total_enrollments, ROUND(AVG(e.grade), 2) AS avg_grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.title;

-- Students with GPA > 3.5
SELECT s.student_id, s.name, AVG(
    CASE 
        WHEN e.grade >= 90 THEN 4.0
        WHEN e.grade >= 80 THEN 3.0
        WHEN e.grade >= 70 THEN 2.0
        WHEN e.grade >= 60 THEN 1.0
        ELSE 0.0
    END
) AS gpa
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.name
HAVING AVG(
    CASE 
        WHEN e.grade >= 90 THEN 4.0
        WHEN e.grade >= 80 THEN 3.0
        WHEN e.grade >= 70 THEN 2.0
        WHEN e.grade >= 60 THEN 1.0
        ELSE 0.0
    END
) > 3.5;

-- Enrollment trends by year
WITH semester_stats AS (
    SELECT EXTRACT(YEAR FROM enrollment_date) AS year,
           COUNT(*) AS total_enrollments,
           ROUND(AVG(grade), 2) AS avg_grade
    FROM enrollments
    GROUP BY year
)
SELECT * FROM semester_stats ORDER BY year;

-- Professors teaching more than 1 courses
SELECT p.name AS professor_name, COUNT(c.course_id) AS course_count
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.name
HAVING COUNT(c.course_id) > 1;


-- Top 3 students per department by average grade
SELECT * FROM (
    SELECT s.student_id, s.name, d.name AS department, AVG(e.grade) AS avg_grade,
           RANK() OVER (PARTITION BY s.department_id ORDER BY AVG(e.grade) DESC) as rank
    FROM students s
    JOIN departments d ON s.department_id = d.department_id
    JOIN enrollments e ON s.student_id = e.student_id
    GROUP BY s.student_id, s.name, d.name, s.department_id
) ranked
WHERE rank <= 3;

-- Students with improved grades over time
--EXPLAIN ANALYZE
SELECT DISTINCT s.student_id, s.name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.grade > (
    SELECT AVG(gh.grade)
    FROM grade_history gh
    WHERE gh.enrollment_id = e.enrollment_id
);
