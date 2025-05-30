--academic information
CREATE VIEW student_academic_info AS
SELECT 
    Students.name AS `Student Name`,
    Departments.name AS `Department`,
    Learning_styles.style AS `Learning Style`,
    Subjects.subject_name AS `Strongest Subject`
FROM 
    Students

LEFT JOIN Student_department ON Students.id = Student_department.student_id
LEFT JOIN Departments ON Student_department.department_id = Departments.id
LEFT JOIN Learning_styles ON Students.id = Learning_styles.student_id
LEFT JOIN (
    SELECT 
        student_id, 
        subject_id, 
        MAX(score) AS max_score
    FROM 
        Placement_tests
    GROUP BY 
        student_id
) AS Best_Scores ON Students.id = Best_Scores.student_id
LEFT JOIN Subjects ON Best_Scores.subject_id = Subjects.id;

--assignment information
CREATE VIEW student_assignment_info AS
SELECT 
    Students.name AS `Student Name`,
    Subjects.subject_name AS `Subject`,
    Assignments.description AS `Assignment`,
    Courses.course_name AS `Assignment Course`,
    Submissions.submission_datetime AS `Submission Date`,
    Submissions.grade AS `Grade`,
    Submissions.feedback AS `Feedback`
FROM 
    Students
JOIN Assignments ON Students.id = Assignments.student_id
JOIN Subjects ON Assignments.subject_id = Subjects.id
JOIN Courses ON Assignments.course_id = Courses.id
JOIN Submissions ON Assignments.id = Submissions.assignment_id AND Students.id = Submissions.student_id;

CREATE VIEW student_exam_results AS
SELECT 
    Students.name AS `Student Name`,
    Departments.name AS `Department`,
    Subjects.subject_name AS `Subject`,
    Exams.score AS `Score`
FROM 
    Students
LEFT JOIN Student_department ON Students.id = Student_department.student_id
LEFT JOIN Departments ON Student_department.department_id = Departments.id
LEFT JOIN Exams ON Students.id = Exams.student_id
LEFT JOIN Subjects ON Exams.subject_id = Subjects.id;

-- view for assignment submissions
CREATE VIEW Assignment_Submissions_View AS
SELECT 
    Submissions.id AS submission_id,
    Submissions.assignment_id,
    Assignments.description AS assignment_description,
    Assignments.due_date AS assignment_due_date,
    Submissions.student_id,
    Students.name AS student_name,
    Submissions.submission_datetime,
    Submissions.grade,
    Submissions.feedback,
    Subjects.subject_name AS subject_name,
    Courses.course_name AS course_name
FROM 
    Submissions
JOIN 
    Assignments ON Submissions.assignment_id = Assignments.id
JOIN 
    Students ON Submissions.student_id = Students.id
JOIN 
    Subjects ON Assignments.subject_id = Subjects.id
JOIN 
    Courses ON Assignments.course_id = Courses.id;



CREATE VIEW Student_Recommendations_View AS
SELECT 
    Recommendations.id AS recommendation_id,
    Recommendations.student_id,
    Students.name AS student_name,
    Recommendations.recommended_department_id,
    Departments.name AS department_name,
    Recommendations.report AS recommendation_report
FROM 
    Recommendations
JOIN 
    Students ON Recommendations.student_id = Students.id
JOIN 
    Departments ON Recommendations.recommended_department_id = Departments.id;