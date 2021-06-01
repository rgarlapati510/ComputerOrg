;;=============================================================
;; CS 2110 - Spring 2021
;; Homework 5 - Iterative GCD
;;=============================================================
;; Name: Ruthvika Garlapati
;;=============================================================

;; Pseudocode (see PDF for explanation):
;;
;; a = (argument 1);
;; b = (argument 2);
;; ANSWER = 0;
;;
;; while (a != b) {
;;   if (a > b) {
;;     a = a - b;
;;   } else {
;;     b = b - a;
;;   }
;; }
;; ANSWER = a;


.orig x3000
LD R1, A 					; a = argument 1
LD R2, B 					; b = argument 2

LOOP 	NOT R3, R2 			;
		ADD R3, R3, #1 		; R3 = -b 
		ADD R4, R1, R3 		; R4 = a - b
		BRz endLOOP 		; when/if (a != b), branch to end of while loop

		ADD R4, R4, #0		; ANSWER = 0
		BRnz else 			; if (a <= b) execute else
		ADD R1, R1, R3 		; a = a - b --> if statement
		BRnzp end 			; end of if body --> branch to end
	
		else 		
			NOT R5, R1 		
			ADD R5, R5, #1 	; R5 = -a
			ADD R2, R2, R5 	; b = b - a
		end 				; end of if else block
BRnzp LOOP 					; branch to end of the loop
endLOOP 					; end while loop
ST R1, ANSWER 				; store a into ANSWER

HALT

A .fill 20
B .fill 19

ANSWER .blkw 1

.end
