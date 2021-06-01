;;=============================================================
;; CS 2110 - Fall 2020
;; Homework 5 - Palindrome
;;=============================================================
;; Name: Ruthvika Garlapati
;;=============================================================

;; Pseudocode (see PDF for explanation):
;;
;; string = "racecar";
;; len = 0;
;;
;; // to find the length of the string
;; while (string[len] != '\0') {
;;   len = len + 1;
;; }
;;
;; // to check whether the string is a palindrome
;; result = 1;
;; i = 0;
;; while (i < length) {
;;   if (string[i] != string[length - i - 1]) {
;;     result = 0;
;;     break;
;;   }
;;   i = i + 1;
;; }

.orig x3000
	LD R0, STRING 		; string = "racecar"
	AND R1, R1, #0 		; len = 0

LOOP1
ADD R2, R0, R1 			; string[position]
LDR R2, R2, #0 			; compare ascii
BRz endLOOP1 			; exit loop if string at last character is equal to '\0'
ADD R1, R1, #1  		; len++
BRnzp LOOP1 	
endLOOP1 				; end of first while loop

AND R4, R4, #0
ADD R4, R4, #1
AND R5, R5, #0
ADD R5, R5, #0 
AND R2, R2, #0 


LOOP2
NOT R6, R1
ADD R6, R6, #1
ADD R6, R5, R6
BRzp endLOOP2 			; exit while loop if i >= length				
ADD R7, R5, R0 			; string[i]
LDR R7, R7, #0 			; gives us value stored at string[i]
ADD R2, R5, #1			; i++
NOT R2, R2
ADD R2, R2, #1 			; negation of R8
ADD R2, R2, R1
ADD R2, R0, R2			
LDR R2, R2, #0  		; string[length - i - 1]
NOT R2, R2 
ADD R2, R2, #1
ADD R2, R2, R7
BRz endIF 			
AND R4, R4, #0 			; clear register
BRnzp endLOOP2 			
endIF
ADD R5, R5, #1
BRnzp LOOP2 			
endLOOP2 				; end of second while loop
ST R4, ANSWER 			; store answer from register
HALT


ANSWER .blkw 1
STRING .fill x4000
.end

.orig x4000
.stringz "racecar"
.end
