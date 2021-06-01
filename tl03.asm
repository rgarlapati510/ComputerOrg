;; Timed Lab 3
;; Student Name:

;; Please read the PDF for full directions.
;; The pseudocode for the program you must implement is listed below; it is also listed in the PDF.
;; If there are any discrepancies between the PDF's pseudocode and the pseudocode below, notify a TA on Piazza quickly.
;; However, in the end, the pseudocode is just an example of a program that would fulfill the requirements specified in the PDF.

;; Pseudocode:
;;
;; ABS(x) {
;;     if (x < 0) {
;;         return -x;
;;     } else {
;;         return x;
;;     }
;; }
;;
;;
;;
;; POW3(x) {
;;     if (x == 0) {
;;         return 1;
;;     } else {
;;         return 3 * POW3(x - 1);
;;     }
;; }
;;
;;
;; MAP(array, length) {
;;     i = 0;
;;     while (i < length) {
;;         element = arr[i];
;;         if (i & 1 == 0) {
;;             result = ABS(element);
;;         } else {
;;             result = POW3(element);
;;         }
;;         arr[i] = result;
;;         i++;
;;     }
;; }

.orig x3000
HALT

STACK .fill xF000

; DO NOT MODIFY ABOVE

;_________________________________________________________________________________________
; START ABS SUBROUTINE
ABS
;start of stack
ADD R6, R6, -4  				; Allocate space
STR R7, R6, 2   				; Save return address
STR R5, R6, 1   				; Save old FP
ADD R5, R6, 0					; FP = SP

ADD R6, R6, -5  				; Make room for saved regs
STR R0, R5, -1  				; set up registers 
STR R1, R5, -2  		
STR R2, R5, -3  			
STR R3, R5, -4  			
STR R4, R5, -5  				


ABSIF
	LDR R0, R5, 4
	BRzp ELSE
	NOT R0, R0
	ADD R0, R0, 1
	STR R0, R5, 0
BR ENDIF

ELSE
	LDR R0, R5, 4
	STR R0, R5, 0
BR ENDELSE

ENDIF NOP
ENDELSE NOP

;stack teardown
LDR R0, R5, 0 
STR R0, R5, 3					; set return value
LDR R4, R5, -5 					; restore registers
LDR R3, R5, -4 				
LDR R2, R5, -3 				
LDR R1, R5, -2 					
LDR R0, R5, -1 					
ADD R6, R5, 0  					; pop off stack
LDR R7, R6, 2 					; R7 = ret address
LDR R5, R6, 1 					; FP = old FP
ADD R6, R6, 3  					; pop 3 words

RET
; END ABS SUBROUTINE
;;________________________________________________________________________________________


; START POW3 SUBROUTINE

POW3
;Stack build up
ADD R6, R6, -4  	
STR R7, R6, 2   		
STR R5, R6, 1   			
ADD R5, R6, 0				

ADD R6, R6, -5  				; set registers		
STR R0, R5, -1  	
STR R1, R5, -2  		
STR R2, R5, -3  				
STR R3, R5, -4  				
STR R4, R5, -5  				

POWIF
	LDR R0, R5, 4 				; retrieve local variable
	BRnp elseA 					; branch to else if x != 0
	ADD R0, R0, 1 				; store 1 into that variable
	STR R0, R5, 0 				; store this variable onto stack
BR endPOWIF

elseA
	LDR R0, R5, 4 			; x --> because R5 + 4 will give you x, you store n into R0 temporarily
	ADD R0, R0, -1 			; x - 1 --> subtract 1 to get x - 1
	ADD R6, R6, -1			; x - 1
	STR R0, R6, 0   		; make space on stack to store x - 1
	JSR POW3 				; POW3(x-1) recursive call
	LDR R0, R6, 0 			; R0 = rv
	ADD R6, R6, 2			; pop rv and arg1

	; 3 * POW3(x - 1)
	ADD R1, R0, R0 			; add R0 3x (same as multiplying by 3)
	ADD R1, R1, R0
	STR R1, R5, 0 			; store return value 
BR endelseA

endPOWIF NOP
endelseA NOP

;stack teardown
LDR R2, R5, 0 
STR R2, R5, 3					; set return value
LDR R4, R5, -5 					; restore registers
LDR R3, R5, -4 				
LDR R2, R5, -3 			
LDR R1, R5, -2 			
LDR R0, R5, -1 				
ADD R6, R5, 0  					; pop off stack
LDR R7, R6, 2 					; R7 = ret address
LDR R5, R6, 1 					; FP = old FP
ADD R6, R6, 3  					; pop

RET
; END POW3 SUBROUTINE
;;_________________________________________________________________________________________

; START MAP SUBROUTINE
MAP
; Stack buildup
ADD R6, R6, -4  				; Allocate space
STR R7, R6, 2   				; Save return address
STR R5, R6, 1   				; Save old FP
ADD R5, R6, 0					; FP = SP

ADD R6, R6, -6  				; make registers
STR R0, R5, -2  			
STR R1, R5, -3  		
STR R2, R5, -4  			
STR R3, R5, -5  		
STR R4, R5, -6  			


LDR R0, R5, 0					; load local variable into R0
AND R0, R0, 0 					; i = 0

while
	LDR R1, R5, 5 				; load length into R1
	NOT R1, R1 					; negate length
	ADD R1, R1, 1
	ADD R1, R0, R1 				; i - length
	BRzp endWhile 				; if i - length >= 0, branch out of loop

	LDR R2, R5, 4 				; load array local variable 
	ADD R3, R2, R0 				; find value at arr[i]
	LDR R4, R3, 0 				; load data at arr[i]

	MAPIF
		AND R1, R1, 0 			; if (i & 1)
		AND R1, R0, 1
		BRnp M_ELSE 			; exit loop if above statement != 0

		ADD R6, R6, -1 			; add room to stack
		STR R4, R6, 0 			; put 'element' on stack
		JSR ABS 				; recursive call to ABS on element 
		LDR R1, R6, 0 	
		
		ADD R6, R6, 2 
		STR R1, R5, -1 			; store rv on stack
	BR ENDMAPIF

	M_ELSE
		ADD R6, R6, -1 			; add room to stack
		STR R4, R6, 0 			; put 'element' on stack
		JSR POW3 				; recursive call on POW3
		LDR R1, R6, 0 
		
		ADD R6, R6, 2
		STR R1, R5, -1 			; store rv on stack
	BR ENDM_ELSE

	ENDMAPIF NOP
	ENDM_ELSE NOP

	LDR R1, R5, -1 				; set new register to result
	STR R1, R3, 0 				; arr[i] = result
	ADD R0, R0, 1 				; increment i
BR while

endWhile nop

;stack teardown
LDR R2, R5, #-1 
STR R2, R5, 3					; set return value
LDR R4, R5, -6 					; restore registers
LDR R3, R5, -5 					
LDR R2, R5, -4 				
LDR R1, R5, -3 				
LDR R0, R5, -2 					
ADD R6, R5, 0  					; pop off stack
LDR R7, R6, 2 					; R7 = ret address
LDR R5, R6, 1 					; FP = old FP
ADD R6, R6, 3  					; pop


RET
; END MAP SUBROUTINE
;_________________________________________________________________________________________



; ARRAY FOR TESTING
ARRAY .fill x4000
.end

.orig x4000
.fill -2
.fill 5
.fill 3
.fill 2
.fill -6
.fill 0
.end
