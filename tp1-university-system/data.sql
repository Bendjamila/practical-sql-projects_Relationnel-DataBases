
INSERT INTO departement
(departement_id, departement_name, building, budget, departement_head, creation_date)
VALUES
(1,"Computer Science","Building A",500000.00,"Ahmed Najjar","2000-09-01"),
(2,"Mathematics","Building B",350000.00,"Lina Hachemi","1995-08-15"),
(3,"Physics","Building C",400000.00,"Karim Abderrahmane","2005-01-10"),
(4,"Civil Engineering","Building D",600000.00,"Nour Bouali","2010-03-22");


INSERT INTO professor
(professor_id,last_name,first_name,email,phone,departement_id,hire_date,salary,specialization)
VALUES
(1,"Najjar","Ahmed","ahmed.najjar@univ.edu","0550-111-001",1,"2008-09-01",78000.00,"Artificial Intelligence"),
(2,"Khatib","Sara","sara.khatib@univ.edu","0550-111-002",1,"2010-03-15",75000.00,"Cyber Security"),
(3,"Ben Youssef","Mohamed","mohamed.ben@univ.edu","0550-111-003",1,"2015-01-10",72000.00,"Software Engineering"),
(4,"Hachemi","Lina","lina.hachemi@univ.edu","0550-111-004",2,"2012-09-20",69000.00,"Algebra"),
(5,"Abderrahmane","Karim","karim.abderrahmane@univ.edu","0550-111-005",3,"2016-11-05",66000.00,"Quantum Physics"),
(6,"Bouali","Nour","nour.bouali@univ.edu","0550-111-006",4,"2018-04-18",64000.00,"Structural Engineering");

INSERT INTO student
(student_id,student_number,last_name,first_name,date_of_birth,email,phone,address,departement_id,level,enrollment_date)
VALUES
(1,"S2001","Ali","Youssef","2003-05-12","youssef.ali@student.edu","0660-200-001","Algiers, Algeria",1,"L2","2023-09-01"),
(2,"S2002","Hassan","Meriem","2002-08-21","meriem.hassan@student.edu","0660-200-002","Oran, Algeria",1,"L3","2022-09-01"),
(3,"S2003","Abdallah","Khaled","2001-02-10","khaled.abdallah@student.edu","0660-200-003","Constantine, Algeria",2,"M1","2021-09-01"),
(4,"S2004","Said","Fatima","2003-11-30","fatima.said@student.edu","0660-200-004","Blida, Algeria",2,"L2","2023-09-01"),
(5,"S2005","Kacemi","Amine","2002-07-18","amine.kacemi@student.edu","0660-200-005","Annaba, Algeria",3,"L3","2022-09-01"),
(6,"S2006","Mourad","Huda","2001-12-05","huda.mourad@student.edu","0660-200-006","Setif, Algeria",3,"M1","2021-09-01"),
(7,"S2007","Cherif","Aya","2003-09-14","aya.cherif@student.edu","0660-200-007","Tlemcen, Algeria",4,"L2","2023-09-01"),
(8,"S2008","Mansour","Ibrahim","2002-04-25","ibrahim.mansour@student.edu","0660-200-008","Bejaia, Algeria",4,"L3","2022-09-01");

INSERT INTO courses
(course_id,course_code,course_name,description,credits,semester,departement_id,professor_id,max_capacity)
VALUES
(1,"CS201","Algorithms","Study of algorithms and complexity",6,1,1,1,30),
(2,"CS202","Databases","Relational database systems",5,2,1,2,25),
(3,"CS203","Web Development","Frontend and backend development",5,1,1,3,20),
(4,"MATH201","Advanced Algebra","Linear algebra and structures",6,2,2,4,30),
(5,"PHYS201","Modern Physics","Introduction to modern physics concepts",5,1,3,5,25),
(6,"CE201","Structural Analysis","Analysis of engineering structures",6,2,4,6,30),
(7,"CE202","Construction Materials","Properties of construction materials",5,1,4,6,20);

INSERT INTO enrollment
(enrollment_id,student_id,course_id,enrollment_date,academic_year,status)
VALUES
(1,1,1,"2024-09-01","2024-2025","In Progress"),
(2,1,2,"2024-09-01","2024-2025","In Progress"),
(3,2,1,"2023-09-01","2023-2024","Passed"),
(4,2,3,"2023-09-01","2023-2024","Passed"),
(5,3,4,"2022-09-01","2022-2023","Passed"),
(6,3,2,"2024-09-01","2024-2025","In Progress"),
(7,4,4,"2024-09-01","2024-2025","In Progress"),
(8,5,5,"2023-09-01","2023-2024","Passed"),
(9,5,1,"2023-09-01","2023-2024","Failed"),
(10,6,5,"2022-09-01","2022-2023","Passed"),
(11,6,6,"2024-09-01","2024-2025","In Progress"),
(12,7,6,"2024-09-01","2024-2025","In Progress"),
(13,7,7,"2023-09-01","2023-2024","Passed"),
(14,8,7,"2023-09-01","2023-2024","Passed"),
(15,8,3,"2024-09-01","2024-2025","In Progress"),
(16,4,2,"2023-09-01","2023-2024","Passed");



INSERT INTO grade
(grade_id,enrollment_id,evaluation_type,garde,coefficient,evaluation_date,comment)
VALUES
(1,3,"Exam",17.5,1.00,"2024-01-15","Very strong performance"),
(2,4,"Project",15.0,0.50,"2024-05-10","Good practical work"),
(3,5,"Exam",16.0,1.00,"2023-01-20","Excellent understanding"),
(4,8,"Lab",12.5,0.30,"2024-02-10","Satisfactory"),
(5,9,"Exam",10.0,1.00,"2024-01-18","Minimum passing level"),
(6,10,"Assignment",14.0,0.20,"2023-11-05","Good effort"),
(7,13,"Project",18.0,0.50,"2024-05-12","Outstanding project"),
(8,14,"Exam",16.5,1.00,"2024-01-22","Very good"),
(9,16,"Lab",13.0,0.30,"2024-03-01","Average work"),
(10,3,"Assignment",14.5,0.20,"2024-02-01","Well structured"),
(11,5,"Project",15.5,0.50,"2023-05-15","Solid project"),
(12,8,"Exam",11.0,1.00,"2024-01-30","Needs improvement");