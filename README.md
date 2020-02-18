TA_Ranking_System

rank candidates for every courses to select appropriate TA in C and COBOL

In this System, course instructors will enter their requirements for TAs: 3 required skills, and 5 optional skills. Candidate TAs will enter their profiles: 8 skills, and their 1st, 2nd and 3rd preferred courses. The System keeps the course instructors’ requirements in a file: instructors.txt. Each line of the file represents the requirements of a course, containing the course ID, required skills, and optional skills. Also, the System keeps another file containing all the candidate TAs’ information: candidates.txt. Each line of the file records a candidate TA’s information, including the TA ID, skills, and preferred courses. Figures 1 and 2 give an example of the instructors.txt and candidates.txt files (spaces are explicitly displayed as ) respectively. Notice that skill names are padded by spaces so that each skill name takes exactly 15 characters. Some skill names may contain multiple words and have spaces between words, e.g. Shell script . Jimmy has designed the following policy regarding the matching score that measures how suitable a candidate is to be the TA of a course. The matching score of each pair of (course, TA) is computed as: (

score(course, T A) =

1 + skill score + pref erence score , if all the required skills are satisfied

0 , otherwise)

where

• skill score: number of optional skills satisfied by the TA

• preference score: TA’s preference to the course, according to the following table 1st preference 2nd preference 3rd preference preference score 1.5 1 0.5

The output.txt file should not output the matching scores of every TA for each course directly, but reports only the top 3 TAs for each course. Figure 3 is an example of the output.txt file. Note that, if less than k candidates satisfy the required skills specified by the course, the Rank-k TA for that course is filled with 0000000000 : Besides, pay attention to the cases that the instructors.txt file or the candidates.txt file is empty. If the instructors.txt file is empty, the output.txt file should be empty too; if the candidates.txt file is empty, the Rank-k TA for all the courses should be filled with 0000000000 .
