      ******************************************************************
      * CSCI3180 Principles of Programming Languages *
      * --- Declaration --- *
      * I declare that the assignment here submitted is original except for source
      * material explicitly acknowledged. I also acknowledge that I am aware of
      * University policy and regulations on honesty in academic work, and of the
      * disciplinary guidelines and procedures applicable to breaches of such policy
      * and regulations, as contained in the website
      * http://www.cuhk.edu.hk/policy/academichonesty/ *
      * Assignment 1
      * Name : Jiyeon Byun
      * Student ID : 1155086596
      * Email Addr : ivjiyeon@link.cuhk.edu.hk
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TA-RANKING.
       AUTHOR. JIYEON BYUN.
      *****************************************************************
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OPTIONAL INSTRUCTORFILE ASSIGN TO './instructors.txt'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS INST-FILE-STATUS.
           SELECT OPTIONAL CANDIDATEFILE ASSIGN TO './candidates.txt'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS CAND-FILE-STATUS.
           SELECT OPTIONAL OUTPUTFILE ASSIGN TO 'output.txt'
               ORGANIZATION IS BINARY SEQUENTIAL
               FILE STATUS IS OUTPUT-FILE-STATUS.
      *****************************************************************
       DATA DIVISION.
       FILE SECTION.
       FD INSTRUCTORFILE.
       01 INSTRUCTOR-DETAILS.
           05 COURSE-CODE          PIC X(5)    VALUES SPACES.
           05 REQUIRED-SKILLS      PIC X(15)
           OCCURS 3 TIMES VALUES SPACES.
           05 OPTIONAL-SKILLS      PIC X(15)
           OCCURS 5 TIMES VALUES SPACES.
       
       FD CANDIDATEFILE.
       01 CANDIDATE-DETAILS.
           05 CANDIDATE-ID         PIC X(11)   VALUES SPACES.
           05 CANDIDATE-SKILLS     PIC X(15)
           OCCURS 8 TIMES VALUES SPACES.
           05 PREFERED-COURSE      PIC X(15)
           OCCURS 3 VALUES SPACES.

       FD OUTPUTFILE.
       01 OUTPUT-DETAILS.
           05 COURSE-CODE-OUTPUT   PIC X(5).
           05 RANK-CANDIDATES.
              10 RANK1            PIC X(11).
              10 RANK2            PIC X(11).
              10 RANK3            PIC X(11).
           05 EOLC                 PIC X.

       WORKING-STORAGE SECTION.
       01 INSTRUCTORFILE-CHECKER   PIC 9       VALUES 1.
       01 CANDIDATEFILE-CHECKER    PIC 9       VALUES 1.
       01 OUTPUTFILE-CHECKER       PIC 9       VALUES 1.

       01 INSTRUCTOR-INFO.
           05 INST-FILE-STATUS     PIC 99.
       01 CANDIDATE-INFO.
           05 CAND-FILE-STATUS     PIC 99.     

       01 OUTPUT-INFO.
           05 OUTPUT-FILE-STATUS   PIC 99.
           05 OUT-END-OF-LINE      PIC 9       VALUES 0.

       01 SCORE-INDEX              PIC 99.
       01 SKILL-INDEX              PIC 9       VALUES ZERO.

       01 REQUIRED-SCORE           PIC 9       VALUES ZERO.
       01 SKILL-SCORE              PIC 9       VALUES ZERO.
       01 PREFF-SCORE              PIC 9V9     VALUES ZERO.
       01 TOTAL-SCORE              PIC 9V9     VALUES ZERO.
       
       01 RANK.
           05 RANK-CAND-ID         PIC X(11)
           OCCURS 3 TIMES VALUES ZERO.
           05 RANK-CAND-SCORE      PIC 9V9
           OCCURS 3 TIMES VALUES ZERO.
      *****************************************************************
       PROCEDURE DIVISION.

      *TRY OPENING THE INSTRUCTOR FILE
       OPENING-TRIAL-INST-FILE.
           OPEN INPUT INSTRUCTORFILE.
           IF INST-FILE-STATUS EQUAL 05 THEN
               MOVE 0 TO INSTRUCTORFILE-CHECKER
               DISPLAY 'non-existing file!'
           END-IF.
           IF INST-FILE-STATUS NOT EQUAL 00 THEN
               DISPLAY 'opening instructor file not successful'
           END-IF.
           CLOSE INSTRUCTORFILE.
       
      *TRY OPENING THE CANDIDATE FILE 
       OPENING-TRIAL-CAND-FILE.
           OPEN INPUT CANDIDATEFILE.
           IF CAND-FILE-STATUS EQUAL 05 THEN
               MOVE 0 TO CANDIDATEFILE-CHECKER
               DISPLAY 'non-existing file!'
           END-IF.
           IF CAND-FILE-STATUS NOT EQUAL 00 THEN
               DISPLAY 'opening candidate file not successful'
           END-IF. 
           CLOSE CANDIDATEFILE.

      *READ EACH INSTRUCTORS, REPEAT UNTIL EOF 
       READ-ONE-INST-PARAGRAPH.
           READ INSTRUCTORFILE
               AT END
                   EXIT PARAGRAPH
               NOT AT END
                   PERFORM RANKING-RESET-PARAGRAPH
                   PERFORM READ-ONE-CAND-PARAGRAPH
                   PERFORM RANK-ON-OUTPUT-PARAGRAPH
                   PERFORM READ-ONE-INST-PARAGRAPH
           END-READ.
      
      *READ EACH CANDIDATES, CALCULATE SCORE AND RANK THEM UNTIL EOF
       READ-ONE-CAND-PARAGRAPH.
           OPEN INPUT CANDIDATEFILE.
           READ CANDIDATEFILE
               AT END
                   EXIT PARAGRAPH
               NOT AT END
                   PERFORM REQ-SCORE-CALC-PARAGRAPH
                   IF REQUIRED-SCORE EQUAL 3 THEN
                       PERFORM TOTAL-SCORE-CALC-PARAGRAPH
                       PERFORM RANK-UPDATE-PARAGRAPH
                   END-IF
      
                   PERFORM READ-ONE-CAND-PARAGRAPH
           END-READ. 
           CLOSE CANDIDATEFILE.

      *RESET RANKING
       RANKING-RESET-PARAGRAPH.
           MOVE ZERO TO RANK-CAND-SCORE(1).
           MOVE ZERO TO RANK-CAND-SCORE(2).
           MOVE ZERO TO RANK-CAND-SCORE(3).
           MOVE '0000000000' TO RANK-CAND-ID(1).
           MOVE '0000000000' TO RANK-CAND-ID(2).
           MOVE '0000000000' TO RANK-CAND-ID(3). 

      *RESET REQUIRED SCORE AND CALCULATE REQUIRED SCORE  
       REQ-SCORE-CALC-PARAGRAPH.
           MOVE 1 TO SCORE-INDEX.
           MOVE 0 TO REQUIRED-SCORE.
           PERFORM SCORE-INDEX-INCR-PARAGRAPH.

      *THIS WILL REPEAT 3 TIMES (NUMBER OF REQUIRED SKILLS)
       SCORE-INDEX-INCR-PARAGRAPH.
           IF SCORE-INDEX LESS THAN 4 THEN
               MOVE 1 TO SKILL-INDEX
               PERFORM REQ-SKILLS-COMP-PARAGRAPH
               
               COMPUTE SCORE-INDEX = SCORE-INDEX + 1
               PERFORM SCORE-INDEX-INCR-PARAGRAPH
            END-IF.

      *THIS WILL REPEAT 8 TIMES (NUMBER OF CANDIDATE SKILLS) & COMPARE
       REQ-SKILLS-COMP-PARAGRAPH.
           IF SKILL-INDEX LESS THAN 9 THEN
               IF REQUIRED-SKILLS(SCORE-INDEX) 
                   EQUAL CANDIDATE-SKILLS(SKILL-INDEX)
                   COMPUTE REQUIRED-SCORE = REQUIRED-SCORE + 1
               END-IF

               COMPUTE SKILL-INDEX = SKILL-INDEX + 1
               PERFORM REQ-SKILLS-COMP-PARAGRAPH
           END-IF.

      *RESET SKILL SCORE AND CALCULATE SKILL SCORE 
       SKILL-SCORE-CALC-PARAGRAPH.
           MOVE 1 TO SKILL-INDEX.
           MOVE 0 TO SKILL-SCORE.
           PERFORM SKL-SCR-IDX-INCR-PARAGRAPH.

      *THIS WILL REPEAT 5 TIMES (NUMBER OF OPTIONAL SKILLS) 
       SKL-SCR-IDX-INCR-PARAGRAPH.
           IF SCORE-INDEX LESS THAN 6 THEN
               MOVE 1 TO SKILL-INDEX
               PERFORM OPT-SKILLS-COMP-PARAGRAPH

               COMPUTE SCORE-INDEX = SCORE-INDEX + 1
               PERFORM SKL-SCR-IDX-INCR-PARAGRAPH
           END-IF.

      *THIS WILL REPEAT 8 TIMES (NUMBER OF CANDIDATE SKILLS) & COMPARE
       OPT-SKILLS-COMP-PARAGRAPH.
           IF SKILL-INDEX LESS THAN 9 THEN
               IF OPTIONAL-SKILLS(SCORE-INDEX) 
                   EQUAL CANDIDATE-SKILLS(SKILL-INDEX)
                   COMPUTE SKILL-SCORE = SKILL-SCORE + 1
               END-IF

               COMPUTE SKILL-INDEX = SKILL-INDEX + 1
               PERFORM OPT-SKILLS-COMP-PARAGRAPH
           END-IF.

      *CALCULATE PREFERENCE SCORE 
       PREF-SCORE-CALC-PARAGRAPH.
           IF COURSE-CODE EQUAL PREFERED-COURSE(1) THEN
               MOVE 1.5 TO PREFF-SCORE
           END-IF.
           IF COURSE-CODE EQUAL PREFERED-COURSE(2) THEN
               MOVE 1.0 TO PREFF-SCORE
           END-IF.
           IF COURSE-CODE EQUAL PREFERED-COURSE(3) THEN
               MOVE 0.5 TO PREFF-SCORE
           END-IF.

      *CALCULATE TOTAL SCORE AND UPDATE RANK 
       TOTAL-SCORE-CALC-PARAGRAPH.
           MOVE 0.0 TO TOTAL-SCORE.
           PERFORM SKILL-SCORE-CALC-PARAGRAPH.
           PERFORM PREF-SCORE-CALC-PARAGRAPH.
           COMPUTE TOTAL-SCORE = 1 + SKILL-SCORE + PREFF-SCORE.

      *UPDATE RANK ACCORDING TO THE SCORE 
       RANK-UPDATE-PARAGRAPH.
           IF TOTAL-SCORE GREATER THAN RANK-CAND-SCORE(1) THEN
               MOVE RANK-CAND-SCORE(2) TO RANK-CAND-SCORE(3)
               MOVE RANK-CAND-ID(2) TO RANK-CAND-ID(3)
               MOVE RANK-CAND-SCORE(1) TO RANK-CAND-SCORE(2)
               MOVE RANK-CAND-ID(1) TO RANK-CAND-ID(2)
               MOVE TOTAL-SCORE TO RANK-CAND-SCORE(1)
               MOVE CANDIDATE-ID TO RANK-CAND-ID(1)
               EXIT PARAGRAPH
           END-IF.
       
           IF TOTAL-SCORE GREATER THAN RANK-CAND-SCORE(2) THEN
               MOVE RANK-CAND-SCORE(2) TO RANK-CAND-SCORE(3)
               MOVE RANK-CAND-ID(2) TO RANK-CAND-ID(3)
               MOVE TOTAL-SCORE TO RANK-CAND-SCORE(2)
               MOVE CANDIDATE-ID TO RANK-CAND-ID(2)
               EXIT PARAGRAPH
           END-IF.
           
           IF TOTAL-SCORE GREATER THAN RANK-CAND-SCORE(3) THEN
               MOVE TOTAL-SCORE TO RANK-CAND-SCORE(3)
               MOVE CANDIDATE-ID TO RANK-CAND-ID(3)
               EXIT PARAGRAPH
                
           END-IF.

      *COPY THE RESULT OF RANK TO OUTPUT FILE 
       RANK-ON-OUTPUT-PARAGRAPH.
           MOVE COURSE-CODE TO COURSE-CODE-OUTPUT.
           MOVE RANK-CAND-ID(1) TO RANK1.
           MOVE RANK-CAND-ID(2) TO RANK2.
           MOVE RANK-CAND-ID(3) TO RANK3.
           MOVE x'0a' to EOLC.
           WRITE OUTPUT-DETAILS.

       MAIN-PARAGRAPH.
           PERFORM OPENING-TRIAL-INST-FILE.
           PERFORM OPENING-TRIAL-CAND-FILE.

           OPEN INPUT INSTRUCTORFILE.
           OPEN OUTPUT OUTPUTFILE.
           PERFORM READ-ONE-INST-PARAGRAPH.

           CLOSE OUTPUTFILE.
           CLOSE INSTRUCTORFILE.
           

           STOP RUN.
       END PROGRAM TA-RANKING.
