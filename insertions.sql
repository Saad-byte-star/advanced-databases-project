-- Insert Departments
INSERT INTO Departments (name) VALUES 
('Computer Science'),
('Electrical Engineering'),
('Mechanical Engineering'),
('Business Administration'),
('Psychology');

-- Insert Teachers
INSERT INTO Teachers (name, email, category) VALUES 
('Dr. Asma Qureshi', 'asma.qureshi@university.pk', 'Professor'),
('Dr. Imran Naveed', 'imran.naveed@university.pk', 'Associate Professor'),
('Dr. Hina Tariq', 'hina.tariq@university.pk', 'Assistant Professor'),
('Dr. Kamran Saeed', 'kamran.saeed@university.pk', 'Associate Professor'),
('Dr. Nadia Shah', 'nadia.shah@university.pk', 'Professor');

-- Insert Subjects (5 total)
INSERT INTO Subjects (subject_name, subject_description, teacher_id) VALUES
('Data Structures', 'Study of data organization techniques', 1),
('Circuit Analysis', 'Basics of electrical circuit theory', 2),
('Thermodynamics', 'Study of heat and energy systems', 3),
('Marketing Principles', 'Introduction to marketing strategies', 4),
('Cognitive Psychology', 'Study of mental processes', 5);

-- Insert Students (10 total)
INSERT INTO Students (name, email, date_of_birth, password) VALUES 
('Ahmed Ali', 'ahmed.ali@student.pk', '2000-05-21', 'password123'),
('Sara Khan', 'sara.khan@student.pk', '2001-08-15', 'password123'),
('Zainab Fatima', 'zainab.fatima@student.pk', '2002-01-10', 'password123'),
('Hassan Raza', 'hassan.raza@student.pk', '1999-12-05', 'password123'),
('Ayesha Siddiqui', 'ayesha.siddiqui@student.pk', '2000-03-30', 'password123'),
('Usman Javed', 'usman.javed@student.pk', '2001-07-18', 'password123'),
('Fatima Noor', 'fatima.noor@student.pk', '2002-10-12', 'password123'),
('Bilal Haider', 'bilal.haider@student.pk', '1998-11-25', 'password123'),
('Nida Hassan', 'nida.hassan@student.pk', '2000-09-14', 'password123'),
('Ali Rehman', 'ali.rehman@student.pk', '2001-04-03', 'password123');

-- Insert Student_Department (mapping students to departments)
INSERT INTO Student_department (student_id, department_id) VALUES 
(1, 1), (2, 2), (3, 1), (4, 3), (5, 4), 
(6, 5), (7, 1), (8, 2), (9, 3), (10, 4);

-- Insert Learning_styles
INSERT INTO Learning_styles (student_id, style) VALUES 
(1, 'Visual'), (2, 'Auditory'), (3, 'Read/Write'), (4, 'Kinaesthetic'),
(5, 'Visual'), (6, 'Auditory'), (7, 'Read/Write'), (8, 'Kinaesthetic'),
(9, 'Visual'), (10, 'Auditory');

-- Insert Placement_tests
INSERT INTO Placement_tests (student_id, subject_id, score) VALUES 
(1, 1, 0.850), (1, 2, 0.650),
(2, 2, 0.900), (2, 3, 0.700),
(3, 1, 0.780), (3, 5, 0.880),
(4, 3, 0.810), (4, 4, 0.600),
(5, 4, 0.950), (5, 1, 0.660),
(6, 5, 0.875), (6, 3, 0.720),
(7, 1, 0.940), (8, 2, 0.680),
(9, 3, 0.890), (10, 4, 0.790);

-- Insert Subjects_good_at
INSERT INTO Subjects_good_at (student_id, subject_id, current_level) VALUES 
(1, 1, 'Advanced'), (2, 2, 'Intermediate'), (3, 5, 'Advanced'),
(4, 3, 'Intermediate'), (5, 4, 'Advanced'), (6, 5, 'Advanced'),
(7, 1, 'Advanced'), (8, 2, 'Beginner'), (9, 3, 'Intermediate'),
(10, 4, 'Intermediate');

-- Insert Courses
INSERT INTO Courses (course_name, course_description, department_id) VALUES 
('BS Computer Science', '4-year CS program', 1),
('BE Electrical', 'Engineering in Electrical domain', 2),
('BSc Mechanical', 'Study of mechanics and energy systems', 3),
('BBA', 'Bachelor of Business Administration', 4),
('BS Psychology', 'Study of human behavior and mental health', 5);

-- Insert Course_Subjects
INSERT INTO Course_Subjects (course_id, subject_id) VALUES 
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- Insert Enrollments
INSERT INTO Enrollments (student_id, course_id, completion_date, current_status) VALUES 
(1, 1, '2025-12-01', 'enrolled'), (2, 2, '2025-12-01', 'enrolled'),
(3, 1, '2025-12-01', 'enrolled'), (4, 3, '2025-12-01', 'enrolled'),
(5, 4, '2025-12-01', 'enrolled'), (6, 5, '2025-12-01', 'enrolled'),
(7, 1, '2025-12-01', 'enrolled'), (8, 2, '2025-12-01', 'enrolled'),
(9, 3, '2025-12-01', 'enrolled'), (10, 4, '2025-12-01', 'enrolled');

-- Insert Assignments
INSERT INTO Assignments (student_id, subject_id, course_id, description, due_date) VALUES 
(1, 1, 1, 'Linked List implementation', '2025-06-10 23:59:59'),
(2, 2, 2, 'Solve 10 circuit problems', '2025-06-15 23:59:59'),
(3, 5, 1, 'Research on mental models', '2025-06-20 23:59:59');

-- Insert Submissions
INSERT INTO Submissions (assignment_id, student_id, submission_datetime, grade, feedback) VALUES 
(1, 1, NOW(), 'A+', 'Excellent job'),
(2, 2, NOW(), 'B+', 'Well done'),
(3, 3, NOW(), 'A-', 'Great research');

-- Insert Exams
INSERT INTO Exams (subject_id, exam_date) VALUES 
(1, '2025-07-01 09:00:00'), (2, '2025-07-02 09:00:00'),
(3, '2025-07-03 09:00:00'), (4, '2025-07-04 09:00:00'),
(5, '2025-07-05 09:00:00');

-- Insert Recommendations
INSERT INTO Recommendations (student_id, recommended_department_id, report) VALUES 
(1, 1, 'Strong in programming and logic.'),
(2, 2, 'Good grasp of electrical concepts.'),
(3, 5, 'Excels in psychology-related assessments.');
