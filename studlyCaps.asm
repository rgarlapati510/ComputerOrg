;;=============================================================
;; CS 2110 - Fall 2021
;; Homework 5 - Studly Caps!
;;=============================================================
;; Name: Ruthvika Garlapati
;;=============================================================

;; Pseudocode (see PDF for explanation)
;;
;; string = "TWENTY 1 ten";
;; i = 0;
;; while (string[i] != 0) {
;;   if (i % 2 == 0) {
;;   // should be lowercase
;;     if ('A' <= string[i] <= 'Z') {
;;       string[i] = string[i] | 32;
;;     }
;;   } else {
;;   // should be uppercase
;;     if ('a' <= string[i] <= 'z') {
;;       string[i] = string[i] & ~32;
;;     }
;;   }
;;   i++;
;; }

.orig x3000
LD R1, STRING 		;String = "TWENTY 1 ten"
AND R0, R0, #0 		; i = 0

LOOP 				; enter while loop
ADD R2, R0, R1
LDR R3, R2, #0 		;string[i]
BRz endLOOP 		;exit loop if string[i] == 0

AND R4, R0, #1 		; find i % 2
BRnp else 			; if (i % 2) != 0, go to the else statement
LD R5, UPPERA 		
LD R6, UPPERZ
NOT R5, R5
ADD R5, R5, #1
ADD R5, R3, R5 		; string[i] - a
BRn endA 			; exit if string[i] - a is less than 0
NOT R6, R6			
ADD R6, R6, #1
ADD R6, R3, R6		;string[i] - z
BRp endB 			; exit if string[i] - z is greater than 0
AND R7, R7, #0
ADD R7, R7, #15
ADD R7, R7, #15
ADD R7, R7, #2
ADD R3, R3, R7
STR R3, R2, #0 		; string[i] | 32
BRnzp endE 		
else 				; else statement
	LD R5, LOWERA
	LD R6, LOWERZ
	NOT R5, R5
	ADD R5, R5, #1
	ADD R5, R3, R5  ; string[i] - a
	BRn endC 		; exit if string[i] - a less than 0
	NOT R6, R6
	ADD R6, R6, #1
	ADD R6, R3, R6  ; string[i] - z
	BRp endD 		; exit if string[i] - z is more than 0
	AND R7, R7, #0
	ADD R7, R7, #15
	ADD R7, R7, #15
	ADD R7, R7, #2
	NOT R7, R7
	AND R3, R3, R7 	; string[i] & ~32
	STR R3, R2, #0 
	endA
	endB
	endC
	endD
	endE
	ADD R0, R0, #1  ; increment i
	BRnzp LOOP
endLOOP				; end of while loop
HALT

UPPERA .fill x41    ;; A in ASCII
UPPERZ .fill x5A	;; Z in ASCII
LOWERA .fill x61	;; a in ASCII
LOWERZ .fill x7A	;; z in ASCII

STRING .fill x4000
.end

.orig x4000
.stringz "TWENTY ONE TEN"
.end
