/**
 * @file hw7.c
 * @author Ruthvika Garlapati
 * @brief structs, pointers, pointer arithmetic, arrays, strings, and macros
 * @date 2021-03-25
 */

// DO NOT MODIFY THE INCLUDE(S) LIST
#include <stdio.h>
#include "hw7.h"
#include "my_string.h"

// Global array of student structs
struct student class[MAX_CLASS_SIZE];

int size = 0;

/** addStudent
 *
 * @brief creates a new student struct and adds it to the array of student structs, "class"
 *
 *
 * @param "name" name of the student being created and added
 *               NOTE: if the length of name (including the null terminating character)
 *               is above MAX_NAME_SIZE, truncate name to MAX_NAME_SIZE
 * @param "age" age of the student being created and added
 * @param "gpa" gpa of the student being created and added
 * @param "id" id of the student being created and added
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) the length of "id" is less than MIN_ID_SIZE
 *         (2) a student with the name "name" already exits in the array "class"
 *         (3) adding the new student would cause the size of the array "class" to
 *             exceed MAX_CLASS_SIZE
 */
int addStudent(const char *name, int age, double gpa, const char *id) {
  UNUSED_PARAM(name);
  UNUSED_PARAM(age);
  UNUSED_PARAM(gpa);
  UNUSED_PARAM(id);
  int i = 0;
  while (i < size) {
  	if (my_strncmp(class[i].name, name, my_strlen(class[i].name)) == 0) {
  		return FAILURE;
  	}
  	i++;
  }
  if (my_strlen(id) < MIN_ID_SIZE) {
  	return FAILURE;
  }
  if (size + 1 > MAX_CLASS_SIZE) {
  	return FAILURE;
  }
  if (my_strlen(name) >= MAX_NAME_SIZE) {
  		my_strncpy(class[size].name, name, MAX_NAME_SIZE - 1);
  		class[size].name[MAX_NAME_SIZE - 1] = '\0';
  } else {
  	my_strncpy(class[size].name, name, my_strlen(name) + 1);
  }
  class[size].age = age;
  class[size].gpa = gpa;
  my_strncpy(class[size].id, id, my_strlen(id) + 1);
  size++;
  return SUCCESS;
}

/** updateStudentName
 *
 * @brief updates the name of an existing student in the array of student structs, "class"
 *
 * @param "s" student struct that exists in the array "class"
 * @param "name" new name of student "s"
 *               NOTE: if the length of name (including the null terminating character)
 *               is above MAX_NAME_SIZE, truncate name to MAX_NAME_SIZE
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) the student struct "s" can not be found in the array "class"
 */
int updateStudentName(struct student s, const char *name) {
  UNUSED_PARAM(s);
  UNUSED_PARAM(name);
  int pres = 0;
  int j = 0;
  for (int i = 0; i < size; i++) {
  	if (my_strncmp(class[i].name, s.name, my_strlen(class[i].name)) == 0) {
  		pres++;
  		j = i;
  		break;
  	}
  }
  if (pres == 0) {
  	return FAILURE;
  } else {
  	if (my_strlen(name) >= MAX_NAME_SIZE) {
  		my_strncpy(class[j].name, name, MAX_NAME_SIZE - 1);
  		class[j].name[MAX_NAME_SIZE - 1] = '\0';
  	} else {
  		my_strncpy(class[j].name, name, my_strlen(name) + 1);
  	}
  }
  return SUCCESS;
}

/** swapStudents
 *
 * @brief swaps the position of two student structs in the array of student structs, "class"
 *
 * @param "index1" index of the first student struct in the array "class"
 * @param "index2" index of the second student struct in the array "class"
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) "index1" and/or "index2" are negative numbers
 *         (2) "index1" and/or "index2" are out of bounds of the array "class"
 */
int swapStudents(int index1, int index2) {
  UNUSED_PARAM(index1);
  UNUSED_PARAM(index2);
  if (index1 < 0 || index2 < 0) {
  	return FAILURE;
  } 
  if (index1 >= size || index2 >= size) {
  	return FAILURE;
  }
  struct student temp = class[index1];
  class[index1] = class[index2];
  class[index2] = temp;
  return SUCCESS;
}

/** removeStudent
 *
 * @brief removes an existing student in the array of student structs, "class"
 *
 * @param "s" student struct that exists in the array "class"
 * @return FAILURE on failure, SUCCESS on success
 *         Failure if any of the following are true:
 *         (1) the student struct "s" can not be found in the array "class"
 */
int removeStudent(struct student s) {
  UNUSED_PARAM(s);
  int classLen = size;
  int pres = 0;
  int index = 0;
  for (int i = 0; i < size; i++) {
  	if (my_strncmp(class[i].name, s.name, my_strlen(class[i].name)) == 0) {
  		pres++;
  		index = i;
  		break;
  	}
  }
  if (pres == 0) {
  	return FAILURE;
  } else {
  	for (int i = index; i < classLen; i++) {
  		class[i] = class[i + 1];
  	}
  }
  size--;
  return SUCCESS;
}

/** compareStudentID
 *
 * @brief using ASCII, compares the last three characters (not including the NULL
 * terminating character) of two students' IDs
 *
 * @param "s1" student struct that exists in the array "class"
 * @param "s2" student struct that exists in the array "class"
 * @return negative number if s1 is less than s2, positive number if s1 is greater
 *         than s2, and 0 if s1 is equal to s2
 */
int compareStudentID(struct student s1, struct student s2) {
  UNUSED_PARAM(s1);
  UNUSED_PARAM(s2);
  int s1len = my_strlen(s1.id);
  int s2len = my_strlen(s2.id);
  const char *s1End = &s1.id[s1len - 3];
  const char *s2End = &s2.id[s2len - 3];
  return my_strncmp(s1End, s2End, 3); 
}

/** sortStudents
 *
 * @brief using the compareStudentID function, sort the students in the array of
 * student structs, "class," by the last three characters of their student IDs
 *
 * @param void
 * @return void
 */
void sortStudents(void) {
	int min_idx = 0;
	for (int i = 0; i < size - 1; i++) {
		min_idx = i;
		for (int j = i + 1; j < size; j++) {
			if (compareStudentID(class[j], class[min_idx]) < 0) {
				min_idx = j;
			}

		}
		swapStudents(min_idx, i);
	}

}

