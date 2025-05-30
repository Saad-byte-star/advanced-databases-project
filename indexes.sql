CREATE INDEX idx_students_email ON Students(email);
CREATE INDEX idx_students_department_id ON Students(department_id);

CREATE INDEX idx_departments_name ON Departments(name);

CREATE INDEX idx_teachers_email ON Teachers(email);

CREATE INDEX idx_subjects_teacher_id ON Subjects(teacher_id);

CREATE INDEX idx_courses_department_id ON Courses(department_id);

CREATE INDEX idx_learning_styles_student_id ON Learning_styles(student_id);
CREATE INDEX idx_placement_tests_student_id ON Placement_tests(student_id);
CREATE INDEX idx_placement_tests_subject_id ON Placement_tests(subject_id);

CREATE INDEX idx_recommendations_student_id ON Recommendations(student_id);
CREATE INDEX idx_recommendations_department_id ON Recommendations(recommended_department_id);

CREATE INDEX idx_subjects_good_at_student_id ON Subjects_good_at(student_id);
CREATE INDEX idx_subjects_good_at_subject_id ON Subjects_good_at(subject_id);

CREATE INDEX idx_course_subjects_course_id ON Course_Subjects(course_id);
CREATE INDEX idx_course_subjects_subject_id ON Course_Subjects(subject_id);

CREATE INDEX idx_enrollments_student_id ON Enrollments(student_id);
CREATE INDEX idx_enrollments_course_id ON Enrollments(course_id);

CREATE INDEX idx_assignments_student_id ON Assignments(student_id);
CREATE INDEX idx_assignments_subject_id ON Assignments(subject_id);
CREATE INDEX idx_assignments_course_id ON Assignments(course_id);

CREATE INDEX idx_submissions_assignment_id ON Submissions(assignment_id);
CREATE INDEX idx_submissions_student_id ON Submissions(student_id);

CREATE INDEX idx_exams_subject_id ON Exams(subject_id);

