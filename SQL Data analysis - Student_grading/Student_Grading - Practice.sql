SELECT *
FROM students_grading_dataset;

ALTER TABLE students_grading_dataset
CHANGE COLUMN `Stress_Level (1-10)` Stress_level INT;

-- Find the average Midterm_Score of students in each Department.

SELECT Department, AVG(Midterm_Score) AS avg_mark
FROM students_grading_dataset
GROUP BY Department;

-- Count how many students belong to each Parent_Education_Level category.

SELECT Parent_Education_Level, COUNT(Student_ID) AS Student_count
FROM students_grading_dataset
WHERE Parent_Education_Level != ''
GROUP BY Parent_Education_Level;

-- Find the highest and lowest Final_Score in each Department.

SELECT Department, MAX(Final_Score) AS Highest, MIN(Final_Score) AS Lowest
FROM students_grading_dataset
GROUP BY Department;

-- Rank students based on Total_Score in descending order.

SELECT Total_Score, RANK() OVER(ORDER BY Total_Score DESC) AS std_rank
FROM students_grading_dataset;

-- Find students whose Participation_Score is higher than the average Participation_Score of all students.

SELECT First_Name
FROM students_grading_dataset
WHERE Participation_Score > (SELECT AVG(Participation_Score) FROM students_grading_dataset);

-- Find students who study less than 10 hours per week but still have a Total_Score above 80

SELECT First_Name, Total_Score, Study_Hours_per_Week
FROM students_grading_dataset
WHERE Study_Hours_per_Week < 10 AND Total_Score > 80;

-- Create a Grade Distribution Report showing how many students received each grade

SELECT Grade, COUNT(*) AS No_of_grade
FROM students_grading_dataset
GROUP BY Grade
ORDER BY 1 ;

-- Find students who have "Low" Family_Income_Level but scored above 90 in Total_Score.

SELECT First_Name, Total_Score, Family_Income_Level
FROM students_grading_dataset
WHERE Family_Income_Level = 'Low' AND Total_Score > 90;

-- Find the top 3 students from each Department based on Total_Score

SELECT *
FROM(SELECT First_Name, Department, Total_Score, RANK() OVER(PARTITION BY Department ORDER BY Total_Score DESC) AS std_rank
FROM students_grading_dataset) AS ranked_std
WHERE std_rank <=3;

-- Find the Top 5 Hardest-Working Students (Highest Study Hours per Week)

SELECT *
FROM students_grading_dataset
ORDER BY Study_Hours_per_Week DESC
LIMIT 5;

--  Find the Correlation Between Study Hours and Total Score

SELECT 
	CASE 
    WHEN Study_Hours_per_Week < 5 THEN 'Very low'
    WHEN Study_Hours_per_Week BETWEEN 5 AND 10 THEN 'Low'
	WHEN Study_Hours_per_Week BETWEEN 11 AND 20 THEN 'Moderate'
    WHEN Study_Hours_per_Week BETWEEN 21 AND 30 THEN 'High'
    ELSE 'Very high'
    END AS Study_category,
    AVG(Total_Score) AS avg_score
FROM students_grading_dataset
GROUP BY Study_category
ORDER BY avg_score DESC;

-- Find the Effect of Sleep on Student Performance

SELECT
CASE
	WHEN Sleep_Hours_per_Night < 4 THEN 'Very low sleep'
	WHEN Sleep_Hours_per_Night BETWEEN 4 AND 6 THEN 'Low sleep'
	WHEN Sleep_Hours_per_Night BETWEEN 6 AND 8 THEN 'Moderate'
    ELSE 'High sleep'
END AS sleep_category,
AVG(Total_Score) AS avg_total_score
FROM students_grading_dataset
GROUP BY sleep_category
ORDER BY avg_total_score DESC;

-- Identify Students Who Excel in Projects But Score Low in Exams

SELECT First_name, Projects_Score, Final_Score, Midterm_Score
FROM students_grading_dataset
WHERE Projects_Score > 80 AND (Midterm_Score < 60 OR Final_Score < 60)
ORDER BY Projects_Score DESC;

-- Rank Students Based on Their Performance in Each Department

SELECT First_Name, Department, Total_Score, RANK() OVER(PARTITION BY Department ORDER BY Total_Score DESC) AS std_rank
FROM students_grading_dataset;

-- Identify Students with Highest and Lowest Stress Levels in Each Department

SELECT  Department, MAX(Stress_Level) AS Max_stress, MIN(Stress_Level) AS Min_stress
FROM students_grading_dataset
GROUP BY Department;

-- Find the Relationship Between Quizzes and Assignments Scores

SELECT 
CASE
	WHEN Quizzes_Avg > 80 AND Assignments_Avg > 80 THEN 'Excellent in both'
    WHEN Quizzes_Avg > 80 THEN 'Excellent in Quizzes'
    WHEN Assignments_Avg > 80 THEN 'Excellent in Assignment'
    ELSE 'Need improvement'
END AS Performance_category,
COUNT(*) AS Std_count
FROM students_grading_dataset
GROUP BY Performance_category;

--  Find Students Who Scored Better in Final Exam Compared to Midterm

SELECT First_Name, Final_Score, Midterm_Score, (Final_Score - Midterm_Score) AS Score_improvement
FROM students_grading_dataset
WHERE Final_Score > Midterm_Score
ORDER BY Score_improvement DESC;

-- Identify Students Whose Final Score is at Least 20% Higher Than Midterm Score

SELECT First_Name, Final_Score, Midterm_Score, ROUND(((Final_Score - Midterm_Score) / Final_Score) * 100, 2) AS Impr_perc
FROM students_grading_dataset
WHERE ((Final_Score - Midterm_Score) / Final_Score) * 100 >= 20
ORDER BY Impr_perc;

-- Find Students Whose Total Score is Below Average in Their Department

SELECT First_Name, Total_Score, d.Avg_total, s.Department
FROM students_grading_dataset S
JOIN (SELECT Department, ROUND(AVG(Total_Score), 2) AS Avg_total FROM students_grading_dataset GROUP BY Department) d
ON s.Department = d.Department
WHERE s.Total_Score < d.Avg_total
ORDER BY s.Department;

-- Find the Department with the Highest Average Score

SELECT Department, ROUND(AVG(Total_Score), 2) AS Highest_avg_score
FROM students_grading_dataset
GROUP BY Department
ORDER BY Highest_avg_score
LIMIT 1;

-- Find the Most Common Grade for Each Department

SELECT Grade, Department, COUNT(*) AS No_of_grade
FROM students_grading_dataset
GROUP BY Grade, Department
ORDER BY 1;







