/*
∗ CSCI3180 Principles of Programming Languages
∗
∗--- Declaration ---
∗
∗ I declare that the assignment here submitted is original except for source
∗ material explicitly acknowledged. I also acknowledge that I am aware of
∗ University policy and regulations on honesty in academic work, and of the
∗ disciplinary guidelines and procedures applicable to breaches of such policy
∗ and regulations, as contained in the website
∗ http://www.cuhk.edu.hk/policy/academichonesty/
∗
∗ Assignment 1
∗ Name : Byun Jiyeon
∗ Student ID : 1155086596
∗ Email Addr : 1155086596@link.cuhk.edu.hk
*/
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#define CODESIZE 5
#define SKILLSIZE 15
#define REQSKILLSIZE 3
#define OPTSKILLSIZE 5

//make structure for instructors file
typedef struct instructors
{
	char code[CODESIZE];
	char reqSkills[REQSKILLSIZE][SKILLSIZE];
	char optSkills[OPTSKILLSIZE][SKILLSIZE];
} * Instructors;

#define IDSIZE 11
#define CANDSKILLSIZE 8
#define CANDPREFFSIZE 3

//make structrue for candidates file
typedef struct candidates
{
	char id[IDSIZE];
	char skills[CANDSKILLSIZE][SKILLSIZE];
	char preffc[CANDPREFFSIZE][CODESIZE];
} * Candidates;

#define TOPTHREE 3

//make structure for ranking
typedef struct ranks
{
	char id[TOPTHREE][IDSIZE];
	float score[TOPTHREE];
} * Ranks;

//open instructors file and print error if encountered
FILE *openInstructorsFile(FILE *instructorFile)
{
	//open candidates file with read only
	instructorFile = fopen("./instructors.txt", "r");

	//error is encountered
	if (errno != 0)
	{
		//print error message and exit
		perror("Opening instructors file gives error");
		exit(1);
	}

	return instructorFile;
}

//create instructor structure and allocate memory
Instructors createInstructor()
{
	//allocate memory
	Instructors instructor = (Instructors)malloc(sizeof(struct instructors));
	memset(instructor, 0, sizeof(instructor));

	return instructor;
}

//read one line of instructor file and store data in instructor structure accordingly
int readInstructorFile(FILE *instructorFile, Instructors instructor)
{
	int i = 0;
	//end of file, return
	if (feof(instructorFile))
		return 0;

	//read course code
	if (fgets(instructor->code, sizeof(instructor->code), instructorFile))
		fgetc(instructorFile);
	//nothing is in file, return
	else
		return 0;

	//read required skills
	for (i = 0; i < REQSKILLSIZE; i++)
	{
		fgets(instructor->reqSkills[i], sizeof(instructor->reqSkills[i]), instructorFile);
		fgetc(instructorFile);
	}

	//read optional skills
	for (i = 0; i < OPTSKILLSIZE; i++)
	{
		fgets(instructor->optSkills[i], sizeof(instructor->optSkills[i]), instructorFile);
		fgetc(instructorFile);
	}

	//read new line characters
	fgetc(instructorFile);
	fgetc(instructorFile);

	return 1;
}

//open candidates file and print error if encountered
FILE *openCandidatesFile(FILE *candidateFile)
{
	//open candidates file with read only
	candidateFile = fopen("./candidates.txt", "r");

	//error is encountered
	if (errno != 0)
	{
		//print error message and exit
		perror("Opening candidates file gives error");
		exit(1);
	}

	return candidateFile;
}

//create candidate structure and allocate memory
Candidates createCandidate()
{
	//allocate memory
	Candidates candidate = (Candidates)malloc(sizeof(struct candidates));
	memset(candidate, 0, sizeof(candidate));

	return candidate;
}

//read one line of candidate file and store data in candidate structure accordingly
int readCandidateFile(FILE *candidateFile, Candidates candidate)
{
	int i = 0;
	//end of file, return
	if (feof(candidateFile))
		return 0;

	//read course code
	if (fgets(candidate->id, sizeof(candidate->id), candidateFile))
		fgetc(candidateFile);
	//nothing is in file, return
	else
		return 0;

	//read candidate skills
	for (i = 0; i < CANDSKILLSIZE; i++)
	{
		fgets(candidate->skills[i], sizeof(candidate->skills[i]), candidateFile);
		fgetc(candidateFile);
	}

	//read optional skills
	for (i = 0; i < CANDPREFFSIZE; i++)
	{
		fgets(candidate->preffc[i], sizeof(candidate->preffc[i]), candidateFile);
		fgetc(candidateFile);
	}

	//read new line characters
	fgetc(candidateFile);
	fgetc(candidateFile);

	return 1;
}

// check if requirements of course is met
int reqSkillCaclc(Instructors instructor, Candidates candidate)
{
	int i = 0;
	int j = 0;
	int req = 0;

	//check one required skill
	for (i = 0; i < REQSKILLSIZE; i++)
		//with all candidate skills
		for (j = 0; j < CANDSKILLSIZE; j++)
			if (strcmp(instructor->reqSkills[i], candidate->skills[j]) == 0)
				req += 1;

	//candidate fulfilled all three required skills
	if (req == REQSKILLSIZE)
		return 1;
	//candidate did not fulfill required skills
	return 0;
}

// calculate skill score
int skillScoreCalc(Instructors instructor, Candidates candidate)
{
	int i = 0;
	int j = 0;
	int skillScore = 0;

	// check one optional skill
	for (i = 0; i < OPTSKILLSIZE; i++)
		//with all candidate skills
		for (j = 0; j < CANDSKILLSIZE; j++)
			if (strcmp(instructor->optSkills[i], candidate->skills[j]) == 0)
				skillScore += 1;

	return skillScore;
}

//calculate preference score
float prefScoreCalc(Instructors instructor, Candidates candidate)
{
	if (strcmp(candidate->preffc[0], instructor->code) == 0)
		return 1.5;
	else if (strcmp(candidate->preffc[1], instructor->code) == 0)
		return 1;
	else if (strcmp(candidate->preffc[2], instructor->code) == 0)
		return 0.5;
	return 0;
}

//calculate total score
float totalScoreCalc(Instructors instructor, Candidates candidate)
{
	float totalScore = 0;

	//skill score
	int skilScore = skillScoreCalc(instructor, candidate);

	//preferecne score
	int prefScore = prefScoreCalc(instructor, candidate);
	totalScore = 1 + skilScore + prefScore;

	return totalScore;
}

//create rank structure and allocate memory
Ranks createRanks()
{
	Ranks rank = (Ranks)malloc(sizeof(struct ranks));
	memset(rank, 0, sizeof(rank));

	return rank;
}

//reset rank structure
void resetRank(Ranks rank)
{
	int i = 0;
	memset(rank, 0, sizeof(rank));
	for (i = 0; i < TOPTHREE; i++)
	{
		strcpy(rank->id[i], "0000000000\0");
		rank->score[i] = 0;
	}
}

// compare candidates and rank according to total score
void checkRank(Ranks rank, float totalscore, Candidates candidate)
{
	int temp = 0;

	if (totalscore > rank->score[0])
		temp = 1;

	else if (totalscore >= rank->score[1])
		temp = 2;

	else if (totalscore >= rank->score[2])
		temp = 3;

	switch (temp)
	{
		// ranked 1. move others' rank by one
	case 1:
		rank->score[2] = rank->score[1];
		strcpy(rank->id[2], rank->id[1]);

		rank->score[1] = rank->score[0];
		strcpy(rank->id[1], rank->id[0]);

		rank->score[0] = totalscore;
		strcpy(rank->id[0], candidate->id);
		break;
		// ranked 2. move others' with lower and equal to rank 2 by one
	case 2:
		rank->score[2] = rank->score[1];
		strcpy(rank->id[2], rank->id[1]);

		rank->score[1] = totalscore;
		strcpy(rank->id[1], candidate->id);
		break;
		// ranked 3. update new candidate to rank 3
	case 3:
		rank->score[2] = totalscore;
		strcpy(rank->id[2], candidate->id);
		break;
		//not in rank
	default:
		break;
	}
}

// open ouput file and print error if encountered
FILE *openOutputFile(FILE *output)
{
	//open candidates file with write only
	output = fopen("./output.txt", "w");

	//error is encountered
	if (errno != 0)
	{
		//print error message and exit
		perror("Opening instructors file gives error");
		exit(1);
	}

	return output;
}

//write in output file
void writeOuput(FILE *output, Instructors instructor, Ranks rank)
{
	int i = 0;
	fprintf(output, "%s ", instructor->code);
	for (i = 0; i < TOPTHREE; i++)
	{
		fprintf(output, "%s ", rank->id[i]);
	}
	fprintf(output, "\n");
}

int main(void)
{
	//Opening two files
	FILE *candidateFile, *instructorFile, *outputFile;

	instructorFile = openInstructorsFile(instructorFile);
	candidateFile = openCandidatesFile(candidateFile);
	outputFile = openOutputFile(outputFile);

	//structure creation
	Instructors instructor = createInstructor();
	Candidates candidate = createCandidate();
	Ranks rank = createRanks();

	while (readInstructorFile(instructorFile, instructor))
	{
		// reset rank structure before new course rank calculation
		resetRank(rank);

		//set cursor to beginning of candidate file
		fseek(candidateFile, 0, SEEK_SET);

		while (readCandidateFile(candidateFile, candidate))
		{
			//if requirements not met, do not consider candidate
			if (reqSkillCaclc(instructor, candidate) == 0)
				continue;

			// calculate score and rank candidates
			float totalScore = totalScoreCalc(instructor, candidate);
			checkRank(rank, totalScore, candidate);
		}
		writeOuput(outputFile, instructor, rank);
	}

	// free the memory
	free(instructor);
	free(candidate);
	free(rank);

	// close files
	fclose(instructorFile);
	fclose(candidateFile);

	return 0;
}
