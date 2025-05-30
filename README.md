# Personalized Learning System
## TODO 1:
### UPDATE RECOMMENDATIONS TABLE AND SUJECTS_GOOD_AT TABLES BASED ON THE PLACEMENT TEST RESULTS:
    1. A placement_test(placement test is a table) will be conducted, and based on the scores of the students in different subjects, a department.
    2. has to be recommended.
    3. placement test will be conducted for all the subjects.

#### Updating Subjects_good_at TABLE
    1. Query for the test results for the student.
    2. Get the highest score subject.
    3. Add this subject to the table. 
    4. Current_level will be updated on a condition as follows:
        if score >= 90 AND score <=100 -> Advanced
        if score >= 60 AND score <=90 -> Intermediate
        if score<=60 -> Beginner
    5. all of this has to be done by a trigger.
#### Updating  Recommendations TABLE
    1. 

