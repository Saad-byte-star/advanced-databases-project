import random

# Define the number of students and subjects
num_students = 50 
num_subjects = 10

# Define possible number of tests each student can take
test_counts = [3, 2, 5, 4]

# Placeholder for SQL statements
sql_statements = []

# Generate placement tests
for student_id in range(1, num_students + 1):
    
    num_tests = random.choice(test_counts)
    subjects = random.sample(range(1, num_subjects + 1), num_tests)
    for subject_id in subjects:
        score = round(random.uniform(0.0, 1.0), 3)
        sql_statements.append(f"INSERT INTO Placement_tests (student_id, subject_id, score) VALUES ({student_id}, {subject_id}, {score});")

# Print SQL statements
for statement in sql_statements:
    print(statement)
