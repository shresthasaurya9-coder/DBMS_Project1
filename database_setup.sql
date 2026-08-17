
CREATE DATABASE IF NOT EXISTS school_db;

USE school_db;


-- ============================================================
-- TABLE 1: TEACHERS
-- ============================================================

CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY,
    teacher_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    subject VARCHAR(50) NOT NULL
);


-- ============================================================
-- TABLE 2: COURSES
-- ============================================================

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL CHECK (credits > 0),
    teacher_id INT NOT NULL,

    FOREIGN KEY (teacher_id)
        REFERENCES teachers(teacher_id)
);


-- ============================================================
-- TABLE 3: STUDENTS
-- ============================================================

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    age INT NOT NULL CHECK (age >= 16),
    gender VARCHAR(10) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);


-- ============================================================
-- TABLE 4: ENROLLMENTS
-- ============================================================

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    grade DECIMAL(5,2) DEFAULT 0 CHECK (grade >= 0 AND grade <= 100),

    FOREIGN KEY (student_id)
        REFERENCES students(student_id),

    FOREIGN KEY (course_id)
        REFERENCES courses(course_id),

    UNIQUE (student_id, course_id)
);


-- ============================================================
-- PHASE 2: DATA INSERTION
-- ============================================================


-- ------------------------------------------------------------
-- INSERT TEACHERS
-- ------------------------------------------------------------

INSERT INTO teachers
(teacher_id, teacher_name, email, subject)
VALUES
(1, 'Anil Sharma', 'anil.sharma@school.edu', 'Computer Science'),
(2, 'Maya Thapa', 'maya.thapa@school.edu', 'Mathematics'),
(3, 'Ramesh Gurung', 'ramesh.gurung@school.edu', 'Physics'),
(4, 'Sita Rai', 'sita.rai@school.edu', 'English'),
(5, 'Bikash Karki', 'bikash.karki@school.edu', 'Chemistry');


-- ------------------------------------------------------------
-- INSERT COURSES
-- ------------------------------------------------------------

INSERT INTO courses
(course_id, course_name, credits, teacher_id)
VALUES
(101, 'Computer Science', 4, 1),
(102, 'Mathematics', 3, 2),
(103, 'Physics', 4, 3),
(104, 'English', 2, 4),
(105, 'Chemistry', 4, 5);


-- ------------------------------------------------------------
-- INSERT STUDENTS
-- ------------------------------------------------------------

INSERT INTO students
(student_id, student_name, age, gender, email)
VALUES
(1, 'Ram Sharma', 17, 'Male', 'ram@example.com'),
(2, 'Sita Thapa', 18, 'Female', 'sita@example.com'),
(3, 'Hari Gurung', 17, 'Male', 'hari@example.com'),
(4, 'Anita Rai', 18, 'Female', 'anita@example.com'),
(5, 'Bikash Tamang', 17, 'Male', 'bikash@example.com'),
(6, 'Puja Shrestha', 18, 'Female', 'puja@example.com'),
(7, 'Suman Karki', 17, 'Male', 'suman@example.com'),
(8, 'Nisha Adhikari', 18, 'Female', 'nisha@example.com'),
(9, 'Rohan KC', 17, 'Male', 'rohan@example.com'),
(10, 'Mina Gurung', 18, 'Female', 'mina@example.com');


-- ------------------------------------------------------------
-- INSERT ENROLLMENTS
-- ------------------------------------------------------------

INSERT INTO enrollments
(enrollment_id, student_id, course_id, enrollment_date, grade)
VALUES
(1, 1, 101, '2026-01-10', 88.50),
(2, 1, 102, '2026-01-10', 91.00),
(3, 2, 101, '2026-01-11', 94.00),
(4, 2, 103, '2026-01-11', 87.50),
(5, 3, 102, '2026-01-12', 76.00),
(6, 3, 104, '2026-01-12', 82.00),
(7, 4, 101, '2026-01-13', 96.00),
(8, 4, 105, '2026-01-13', 89.00),
(9, 5, 103, '2026-01-14', 73.50),
(10, 5, 105, '2026-01-14', 79.00);


-- ============================================================
-- PHASE 3: DATABASE QUERYING & ANALYTICS
-- ============================================================


-- ============================================================
-- QUERY 1: BASIC RETRIEVAL
-- WHERE + ORDER BY + LIMIT
--
-- Find students aged 18 or above and display them
-- from oldest to youngest. Show only the first 5.
-- ============================================================

SELECT *
FROM students
WHERE age >= 18
ORDER BY age DESC
LIMIT 5;


-- ============================================================
-- QUERY 2: AGGREGATE FUNCTIONS
-- GROUP BY + HAVING
--
-- Find the average grade for each course.
-- Only display courses whose average grade is above 80.
-- ============================================================

SELECT
    course_id,
    AVG(grade) AS average_grade
FROM enrollments
GROUP BY course_id
HAVING AVG(grade) > 80;


-- ============================================================
-- QUERY 3: SUBQUERY
--
-- Find students whose age is greater than the average
-- age of all students.
-- ============================================================

SELECT
    student_id,
    student_name,
    age
FROM students
WHERE age > (
    SELECT AVG(age)
    FROM students
);


-- ============================================================
-- QUERY 4: INNER JOIN
--
-- Display students along with the courses they are
-- enrolled in and their grades.
-- ============================================================

SELECT
    s.student_name,
    c.course_name,
    e.enrollment_date,
    e.grade
FROM students s
INNER JOIN enrollments e
    ON s.student_id = e.student_id
INNER JOIN courses c
    ON e.course_id = c.course_id;


-- ============================================================
-- QUERY 5: LEFT JOIN
--
-- Display all students, including students who may not
-- currently be enrolled in a course.
-- ============================================================

SELECT
    s.student_id,
    s.student_name,
    c.course_name,
    e.grade
FROM students s
LEFT JOIN enrollments e
    ON s.student_id = e.student_id
LEFT JOIN courses c
    ON e.course_id = c.course_id;


-- ============================================================
-- QUERY 6: UPDATE
--
-- Update the grade of enrollment ID 1.
-- The WHERE clause ensures that only one record is changed.
-- ============================================================

UPDATE enrollments
SET grade = 90.00
WHERE enrollment_id = 1;


-- Verify the UPDATE
SELECT *
FROM enrollments
WHERE enrollment_id = 1;


-- ============================================================
-- QUERY 7: DELETE
--
-- Delete enrollment ID 10.
-- The WHERE clause prevents accidental deletion of
-- every enrollment.
-- ============================================================

DELETE FROM enrollments
WHERE enrollment_id = 10;


-- Verify the DELETE
SELECT *
FROM enrollments
WHERE enrollment_id = 10;


-- ============================================================
-- ADDITIONAL USEFUL QUERIES
-- ============================================================


-- Display all students
SELECT *
FROM students;


-- Display all teachers
SELECT *
FROM teachers;


-- Display all courses
SELECT *
FROM courses;


-- Display all enrollments
SELECT *
FROM enrollments;


-- Count total students
SELECT COUNT(*) AS total_students
FROM students;


-- Count students by gender
SELECT
    gender,
    COUNT(*) AS number_of_students
FROM students
GROUP BY gender;


-- Display students with grades above 85
SELECT
    s.student_name,
    c.course_name,
    e.grade
FROM students s
INNER JOIN enrollments e
    ON s.student_id = e.student_id
INNER JOIN courses c
    ON e.course_id = c.course_id
WHERE e.grade > 85
ORDER BY e.grade DESC;