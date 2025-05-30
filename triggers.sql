-- CORRECTED TRIGGER VERSION
DELIMITER //
CREATE TRIGGER `add_subjects_good_at`
AFTER INSERT ON Placement_tests
FOR EACH ROW
BEGIN
    DECLARE total_subjects SMALLINT UNSIGNED;
    DECLARE total_subjects_recorded_in_placement_tests SMALLINT UNSIGNED;
    DECLARE highest_score_sub SMALLINT UNSIGNED;
    DECLARE highest_score FLOAT(3,3);
    DECLARE v_current_level VARCHAR(15);
    DECLARE existing_record_count SMALLINT UNSIGNED DEFAULT 0;

    -- Reading total number of subjects
    SELECT COUNT(*) INTO total_subjects FROM Subjects;

    -- Reading the number of subjects tests completed by this student
    SELECT COUNT(*) INTO total_subjects_recorded_in_placement_tests
    FROM Placement_tests WHERE student_id = NEW.student_id;

    -- Only proceed if student has completed ALL placement tests
    -- AND hasn't already been processed
    SELECT COUNT(*) INTO existing_record_count
    FROM Subjects_good_at WHERE student_id = NEW.student_id;

    IF total_subjects_recorded_in_placement_tests = total_subjects 
       AND existing_record_count = 0 THEN
    
        -- Reading highest score
        SELECT score INTO highest_score 
        FROM Placement_tests 
        WHERE student_id = NEW.student_id
        ORDER BY score DESC 
        LIMIT 1;

        -- Determine proficiency level based on highest score
        IF highest_score >= 0.850 THEN
            SET v_current_level = 'Advanced';
        ELSEIF highest_score >= 0.500 THEN
            SET v_current_level = 'Intermediate';
        ELSE
            SET v_current_level = 'Beginner';
        END IF;
        
        -- Get the subject with the highest score
        SELECT subject_id INTO highest_score_sub 
        FROM Placement_tests 
        WHERE student_id = NEW.student_id
        ORDER BY score DESC 
        LIMIT 1;

        -- Insert the student's best subject
        INSERT INTO Subjects_good_at (student_id, subject_id, current_level) 
        VALUES (NEW.student_id, highest_score_sub, v_current_level);
    
    END IF;
END//
DELIMITER ;

-- ALTERNATIVE: STORED PROCEDURE APPROACH (RECOMMENDED)
DELIMITER //
CREATE PROCEDURE ProcessStudentPlacementResults(IN p_student_id SMALLINT UNSIGNED)
BEGIN
    DECLARE total_subjects SMALLINT UNSIGNED;
    DECLARE total_tests_taken SMALLINT UNSIGNED;
    DECLARE highest_score_sub SMALLINT UNSIGNED;
    DECLARE highest_score FLOAT(3,3);
    DECLARE v_current_level VARCHAR(15);
    
    -- Check if student has taken all placement tests
    SELECT COUNT(*) INTO total_subjects FROM Subjects;
    SELECT COUNT(*) INTO total_tests_taken 
    FROM Placement_tests WHERE student_id = p_student_id;
    
    IF total_tests_taken = total_subjects THEN
        -- Get highest score and corresponding subject
        SELECT subject_id, score INTO highest_score_sub, highest_score
        FROM Placement_tests 
        WHERE student_id = p_student_id
        ORDER BY score DESC 
        LIMIT 1;
        
        -- Determine level
        CASE 
            WHEN highest_score >= 0.850 THEN SET v_current_level = 'Advanced';
            WHEN highest_score >= 0.500 THEN SET v_current_level = 'Intermediate';
            ELSE SET v_current_level = 'Beginner';
        END CASE;
        
        -- Insert or update the record
        INSERT INTO Subjects_good_at (student_id, subject_id, current_level) 
        VALUES (p_student_id, highest_score_sub, v_current_level)
        ON DUPLICATE KEY UPDATE 
            subject_id = VALUES(subject_id),
            current_level = VALUES(current_level);
    END IF;
END//
DELIMITER ;


--     ____________CHANGES TO BE  MADE_________________
--          "make the report more detailed communicate with the student, "            
--          "mention their name in reporting"
--          "for example: XYZ here is your test report"
--          "add messages (encouraging, or imporvements)"


-- Create a trigger that would insert into recommendations table
-- understand the below conditional
-- IF highest_score >= 0.85 AND highest_score <= 0.99 THEN
        --     SET v_current_level = 'Advanced';
        -- ELSEIF highest_score >= 0.50 AND highest_score < 0.85 THEN
        --     SET v_current_level = 'Intermediate';
        -- ELSEIF highest_score < 0.50 THEN
        --     SET v_current_level = 'Beginner';
        -- END IF;
-- Now in report that is of type text consider the mention the following :
    -- student's average score (no of subjects/ sum of all score in all subjects)
    -- student's best subject
    -- recommended departments(check scores in different subjects) to do this.
        -- FOR example if the student scored best in subjects "Computer Science", "Matematics", "Engineering Design" ,
        -- "physics" than recommed departments like physics, computer science, mathematics
        
-- Lastly remember that this report is a column in recommendations table, and this is a TEXT type, you will need to
-- concatinate TEXT to from a report
-- you have free hand to add anything meaning full you'd like to the report.


DELIMITER //
CREATE TRIGGER `generate_detailed_recommendations`
AFTER INSERT ON Placement_tests
FOR EACH ROW
BEGIN
    DECLARE total_subjects SMALLINT UNSIGNED;
    DECLARE total_tests_taken SMALLINT UNSIGNED;
    DECLARE student_name VARCHAR(32);
    DECLARE avg_score FLOAT(5,3);
    DECLARE highest_score FLOAT(3,3);
    DECLARE best_subject_name VARCHAR(64);
    DECLARE best_subject_id SMALLINT UNSIGNED;
    DECLARE v_current_level VARCHAR(15);
    DECLARE existing_recommendation_count SMALLINT UNSIGNED DEFAULT 0;
    DECLARE recommended_dept_id SMALLINT UNSIGNED;
    DECLARE detailed_report TEXT DEFAULT '';
    DECLARE encouragement_message TEXT DEFAULT '';
    DECLARE improvement_message TEXT DEFAULT '';
    DECLARE subject_performance_summary TEXT DEFAULT '';
    
    -- Get total number of subjects
    SELECT COUNT(*) INTO total_subjects FROM Subjects;
    
    -- Get number of tests taken by this student
    SELECT COUNT(*) INTO total_tests_taken 
    FROM Placement_tests WHERE student_id = NEW.student_id;
    
    -- Check if recommendation already exists
    SELECT COUNT(*) INTO existing_recommendation_count
    FROM Recommendations WHERE student_id = NEW.student_id;
    
    -- Only proceed if all tests are completed and no recommendation exists yet
    IF total_tests_taken = total_subjects AND existing_recommendation_count = 0 THEN

        -- Get student name
        SELECT name INTO student_name 
        FROM Students WHERE id = NEW.student_id;
        
        -- Calculate average score
        SELECT AVG(score) INTO avg_score 
        FROM Placement_tests WHERE student_id = NEW.student_id;
        
        -- Get highest score and best subject
        SELECT pt.score, pt.subject_id, s.subject_name 
        INTO highest_score, best_subject_id, best_subject_name
        FROM Placement_tests pt
        JOIN Subjects s ON pt.subject_id = s.id
        WHERE pt.student_id = NEW.student_id
        ORDER BY pt.score DESC 
        LIMIT 1;

        -- Determine current level
        IF highest_score >= 0.850 THEN
            SET v_current_level = 'Advanced';
        ELSEIF highest_score >= 0.500 THEN
            SET v_current_level = 'Intermediate';
        ELSE
            SET v_current_level = 'Beginner';
        END IF;
        
        -- Generate encouragement message based on performance
        IF avg_score >= 0.800 THEN
            SET encouragement_message = 'Exceptional work! Your outstanding performance across all subjects demonstrates your dedication and natural aptitude. You have shown mastery in multiple areas and are well-prepared for advanced academic challenges.';
        ELSEIF avg_score >= 0.650 THEN
            SET encouragement_message = 'Great job! Your solid performance shows good understanding and preparation. You have demonstrated competency across multiple subjects and show great potential for success.';
        ELSEIF avg_score >= 0.500 THEN
            SET encouragement_message = 'Good effort! You have shown a decent foundation in your studies. With continued focus and practice, you can definitely improve your performance and reach your academic goals.';
        ELSE
            SET encouragement_message = 'Thank you for completing the assessment. Everyone starts somewhere, and this is just the beginning of your learning journey. With dedication and proper guidance, you can achieve significant improvement.';
        END IF;
        
        -- Generate improvement suggestions
        IF avg_score < 0.600 THEN
            SET improvement_message = 'Areas for Improvement: Consider dedicating extra time to foundational concepts. Regular practice, seeking help from instructors, and forming study groups can significantly boost your performance. Remember, consistent effort leads to remarkable progress.';
        ELSEIF avg_score < 0.750 THEN
            SET improvement_message = 'Growth Opportunities: You have a solid foundation. Focus on strengthening your weaker areas while maintaining your strengths. Consider advanced practice materials and challenging yourself with more complex problems to reach the next level.';
        ELSE
            SET improvement_message = 'Excellence Path: Your strong performance indicates you are ready for advanced challenges. Consider exploring specialized topics, research opportunities, or leadership roles in your area of strength to further excel.';
        END IF;
        
        -- Generate subject performance summary with DISTINCT to avoid duplicates
        SELECT GROUP_CONCAT(
            subject_details
            ORDER BY score DESC SEPARATOR ', '
        ) INTO subject_performance_summary
        FROM (
            SELECT DISTINCT
                s.subject_name,
                pt.score,
                CONCAT(s.subject_name, ': ',
                    CASE 
                        WHEN pt.score >= 0.850 THEN 'Excellent'
                        WHEN pt.score >= 0.700 THEN 'Very Good'
                        WHEN pt.score >= 0.550 THEN 'Good'
                        WHEN pt.score >= 0.400 THEN 'Fair'
                        ELSE 'Needs Improvement'
                    END,
                    ' (', ROUND(pt.score * 100, 1), '%)'
                ) as subject_details
            FROM Placement_tests pt
            JOIN Subjects s ON pt.subject_id = s.id
            WHERE pt.student_id = NEW.student_id
            GROUP BY s.subject_name, pt.score
        ) AS unique_subjects;
        
        -- Determine recommended department based on best performing subjects
        -- Get department that matches the best subject areas using a derived table join
        SELECT d.id INTO recommended_dept_id
        FROM Departments d
        JOIN Courses c ON d.id = c.department_id
        JOIN Course_Subjects cs ON c.id = cs.course_id
        JOIN (
            SELECT subject_id
            FROM Placement_tests
            WHERE student_id = NEW.student_id
            ORDER BY score DESC
            LIMIT 3
        ) AS top_subjects ON cs.subject_id = top_subjects.subject_id
        GROUP BY d.id
        ORDER BY COUNT(*) DESC
        LIMIT 1;
        
        -- If no specific match found, assign based on highest score subject categories
        IF recommended_dept_id IS NULL THEN
            -- Default recommendation logic based on subject names
            IF best_subject_name LIKE '%Computer%' OR best_subject_name LIKE '%Programming%' OR best_subject_name LIKE '%Software%' THEN
                SELECT id INTO recommended_dept_id FROM Departments WHERE name LIKE '%Computer%' OR name LIKE '%IT%' LIMIT 1;
            ELSEIF best_subject_name LIKE '%Math%' OR best_subject_name LIKE '%Calculus%' OR best_subject_name LIKE '%Statistics%' THEN
                SELECT id INTO recommended_dept_id FROM Departments WHERE name LIKE '%Math%' OR name LIKE '%Statistics%' LIMIT 1;
            ELSEIF best_subject_name LIKE '%Physics%' OR best_subject_name LIKE '%Engineering%' THEN
                SELECT id INTO recommended_dept_id FROM Departments WHERE name LIKE '%Engineering%' OR name LIKE '%Physics%' LIMIT 1;
            ELSE
                -- Default to first department if no pattern match
                SELECT id INTO recommended_dept_id FROM Departments ORDER BY id LIMIT 1;
            END IF;
        END IF;
        
        -- Build the comprehensive report
        SET detailed_report = CONCAT(
            '=== PLACEMENT TEST REPORT ===\n\n',
            'Dear ', student_name, ',\n\n',
            'Here is your comprehensive placement test report based on your performance across all subjects.\n\n',
            
            '📊 PERFORMANCE SUMMARY:\n',
            '• Overall Average Score: ', ROUND(avg_score * 100, 1), '%\n',
            '• Performance Level: ', v_current_level, '\n',
            '• Best Subject: ', best_subject_name, ' (', ROUND(highest_score * 100, 1), '%)\n',
            '• Total Subjects Evaluated: ', total_subjects, '\n\n',
            
            '📈 DETAILED SUBJECT BREAKDOWN:\n',
            subject_performance_summary, '\n\n',
            
            '🎯 PERSONALIZED FEEDBACK:\n',
            encouragement_message, '\n\n',
            
            '💡 RECOMMENDATIONS FOR GROWTH:\n',
            improvement_message, '\n\n',
            
            '🎓 DEPARTMENT RECOMMENDATION:\n',
            'Based on your performance pattern and strengths, we recommend exploring programs in our recommended department. Your strong performance in ', best_subject_name, ' and overall academic profile suggest you would thrive in this field.\n\n',
            
            '🚀 NEXT STEPS:\n',
            '1. Meet with an academic advisor to discuss your results\n',
            '2. Explore course offerings in your recommended department\n',
            '3. Consider your personal interests alongside these recommendations\n',
            '4. Set specific goals for areas needing improvement\n\n',
            
            'Remember, ', student_name, ', these results are a starting point for your academic journey. Your dedication, effort, and passion will ultimately determine your success. We believe in your potential and are here to support your growth.\n\n',
            
            'Best wishes for your academic future!\n',
            'Academic Assessment Team\n',
            '================================'
        );
        
        -- Insert the detailed recommendation
        INSERT INTO Recommendations (student_id, recommended_department_id, report) 
        VALUES (NEW.student_id, recommended_dept_id, detailed_report);
        
    END IF;
END//
DELIMITER ;
