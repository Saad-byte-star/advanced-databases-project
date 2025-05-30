    CREATE TABLE Students (
        id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(32) NOT NULL,
        email VARCHAR(64) NOT NULL,
        date_of_birth DATE NOT NULL,
        password VARCHAR(64) NOT NUll,
        registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE Departments (
        id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(64) NOT NULL
    );

    -- junction table
    CREATE TABLE Student_department (
        id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        student_id SMALLINT UNSIGNED  NOT NULL,
        department_id SMALLINT UNSIGNED  NOT NULL,
        FOREIGN KEY(student_id) REFERENCES Students(id),
        FOREIGN KEY(department_id) REFERENCES Departments(id)
    );

    CREATE TABLE Teachers (
        id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(32) NOT NULL,
        email VARCHAR(64) NOT NULL,
        category ENUM('Assistant Professor', 'Associate Professor', 'Professor')
    );
    
    CREATE TABLE Subjects (
        id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        subject_name VARCHAR(64) NOT NULL,
        subject_description TEXT NOT NULL,
        teacher_id SMALLINT UNSIGNED NOT NULL,
        FOREIGN KEY (teacher_id) REFERENCES Teachers(id)
    );

    CREATE TABLE Courses (
        id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        course_name VARCHAR(64) NOT NULL,
        course_description TEXT NOT NULL,
        department_id SMALLINT UNSIGNED NOT NULL,
        FOREIGN KEY (department_id) REFERENCES Departments(id)
    );

    CREATE TABLE Learning_styles (
        id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        student_id SMALLINT UNSIGNED NOT NULL,
        style ENUM('Visual', 'Auditory', 'Read/Write', 'Kinaesthetic'),
        FOREIGN KEY (student_id) REFERENCES Students(id)
    );

    CREATE TABLE Placement_tests (
        id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        student_id SMALLINT UNSIGNED NOT NULL,
        subject_id SMALLINT UNSIGNED NOT NULL,
        score FLOAT(3,3) NOT NULL,
        FOREIGN KEY (student_id) REFERENCES Students(id),
        FOREIGN KEY (subject_id) REFERENCES Subjects(id)
    );

    CREATE TABLE Recommendations (
        id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        student_id SMALLINT UNSIGNED NOT NULL,
        recommended_department_id SMALLINT UNSIGNED NOT NULL,
        report TEXT NOT NULL,
        FOREIGN KEY (student_id) REFERENCES Students(id),
        FOREIGN KEY (recommended_department_id) REFERENCES Departments(id)
    );

    CREATE TABLE Subjects_good_at (
        id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        student_id SMALLINT UNSIGNED NOT NULL,
        subject_id SMALLINT UNSIGNED NOT NULL,
        current_level ENUM('Beginner', 'Intermediate', 'Advanced'),
        FOREIGN KEY (student_id) REFERENCES Students(id),
        FOREIGN KEY (subject_id) REFERENCES Subjects(id)
    );

    -- a subject can be a part of multiple courses
    CREATE TABLE Course_Subjects (
        id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        course_id SMALLINT UNSIGNED NOT NULL,
        subject_id SMALLINT UNSIGNED NOT NULL,
        FOREIGN KEY (course_id) REFERENCES Courses(id),
        FOREIGN KEY (subject_id) REFERENCES Subjects(id)
    );

    CREATE TABLE Enrollments (
        id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        student_id SMALLINT UNSIGNED NOT NULL,
        course_id SMALLINT UNSIGNED NOT NULL,
        enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        completion_date DATE NOT NULL,
        current_status ENUM('enrolled', 'completed', 'dropped'),
        FOREIGN KEY (student_id) REFERENCES Students(id),
        FOREIGN KEY (course_id) REFERENCES Courses(id)
    );

    CREATE TABLE Assignments (
        id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        student_id SMALLINT UNSIGNED NOT NULL,
        subject_id SMALLINT UNSIGNED NOT NULL,
        course_id SMALLINT UNSIGNED NOT NULL,
        description TEXT NOT NULL,
        due_date DATETIME NOT NULL,
        FOREIGN KEY (student_id) REFERENCES Students(id),
        FOREIGN KEY (subject_id) REFERENCES Subjects(id),
        FOREIGN KEY (course_id) REFERENCES Courses(id)
    );

    CREATE TABLE Submissions (
        id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        assignment_id SMALLINT UNSIGNED NOT NULL,
        student_id SMALLINT UNSIGNED NOT NULL,
        submission_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        grade ENUM('A+', 'A-', 'B+', 'B-', 'C', 'C-', 'D', 'D-', 'F'),
        feedback TEXT NOT NULL,
        FOREIGN KEY (assignment_id) REFERENCES Assignments(id),
        FOREIGN KEY (student_id) REFERENCES Students(id)
    );

    CREATE TABLE Exams (
        id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        subject_id SMALLINT UNSIGNED NOT NULL,
        exam_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (subject_id) REFERENCES Subjects(id)
    );
