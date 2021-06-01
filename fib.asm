;;=======================================
;; CS 2110 - Spring 2020
;; HW6 - Recursive Fibonacci Sequence
;;=======================================
;; Name: Ruthvika Garlapati
;;=======================================

;; In this file, you must implement the 'fib' subroutine.

;; Little reminder from your friendly neighborhood 2110 TA staff: don't run
;; this directly by pressing 'RUN' in complx, since there is nothing put at
;; address x3000. Instead, load it and use 'Debug' -> 'Simulate
;; Subroutine Call' and choose the 'reverseLL' label.

.orig x3000
HALT

;; Pseudocode (see PDF for explanation):
;;
;; Arguments of Fibonacci number: integer n
;;
;; Pseudocode:
;; fib(int n) {
;;     if (n == 0) {
;;         return 0;
;;     } else if (n == 1) {
;;         return 1;
;;     } else {
;;         return fib(n - 1) + fib(n - 2);
;;     }
;; }

;; R0 = paramenter n
;; R1 = 0
;; R2 = 1
;; R3 = n - 2
;; R4 = n - 1
fib

;; YOUR CODE HERE

		ADD R6, R6, -4	 			;; allocate space
		STR R7, R6, 2 				;; save return address
		STR R5, R6, 1 				;; save old first pass
		ADD R5, R6, 0	 			;; room for 5 registers
		ADD R6, R6, -5

		STR R0, R5, -1 			 	;; save registers
		STR R1, R5, -2
		STR R2, R5, -3 
		STR R3, R5, -4 
		STR R4, R5, -5 

IF 		LDR R0, R5, 4 				;; R0 = parameter (n)
		BRnp ELSEIF 				;; if its not a 0, go to else if statement and then check there 		
 		AND R1, R1, 0 				;; R1 = 0
 		STR R1, R5, 0 				;; store return value of R1 = 0
BR ENDIF

ELSEIF  LDR R0, R5, 4
		ADD R0, R0, #-1 			;; R0 = R0 - 1 (test if R0 is 1, subtract 1 and see if its a 0)
		BRnp ELSE 					;; if it is not 1, got to else statement
		AND R1, R1, 0
		ADD R1, R1, 1
		STR R1, R5, 0  			 	;; store return value of R1 = 1		
BR ENDELSEIF

ELSE
 		LDR R0, R5, 4 				;; n
 		ADD R0, R0, #-1 			;; n - 1
 		ADD R6, R6, #-1 			;; making space
 		STR R0, R6, 0
 		JSR fib 					;; fib(n - 1)
 		LDR R0, R6, 0				;; R0 = return value of fib(n - 1)
 		ADD R6, R6, #2				;; pop/take away space

 		LDR R2, R5, 4 				;; n
 		ADD R2, R2, #-2 			;; n - 2
 		ADD R6, R6, #-1 			;; making space
 		STR R2, R6, 0
 		JSR fib 					;; fib(n - 2)
 		LDR R2, R6, 0				;; R0 = return value of fib(n - 2)
 		ADD R6, R6, #2				;; pop/take away space

 		ADD R3, R0, R2				;; fib(n - 1) + fib(n - 2)
 		STR R3, R5, 0				;; storing onto stack 
BR ENDELSE
ENDIF NOP
ENDELSEIF NOP
ENDELSE NOP

END 
 		LDR R3, R5, 0 
 		STR R3, R5, 3
 		LDR R0, R5, -1 				;; restore
 		LDR R1, R5, -2
 		LDR R2, R5, -3
 		LDR R3, R5, -4
 		LDR R4, R5, -5
 		ADD R6, R5, 0 				;; restore sp
 		LDR R5, R6, 1 				;; restore fp
 		LDR R7, R6, 2 				;; restore return address
 		ADD R6, R6, 3 				;; pop until return value
RET

;; used by the autograder
STACK .fill xF000
.end
