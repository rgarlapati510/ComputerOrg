;;=============================================================
;; CS 2110 - Spring 2021
;; Homework 5 - Array Merge
;;=============================================================
;; Name: Ruthvika Garlapati
;;=============================================================

;; Pseudocode (see PDF for explanation):
;;
;; x = 0;
;; y = 0;
;; z = 0;
;; while (x < LENGTH_X && y < LENGTH_Y) {
;;   if (ARR_X[x] <= ARR_Y[y]) {
;;     ARR_RES[z] = ARR_X[x];
;;     z++;
;;     x++;
;;   } else {
;;     ARR_RES[z] = ARR_Y[y];
;;     z++;
;;     y++;
;;   }
;; }
;; while(x < ARRX.length) {
;;   ARR_RES[z] = ARR_X[x];
;;   z++;
;;   x++;
;; }
;; while (y < ARRY.length) {
;;   ARR_RES[z] = ARR_Y[y];
;;   z++;
;;   y++;
;; }


;;R0 = ARR_X
;;
;;R1 = X
;;R2 = Y
;;R3 = Z
;;R4 = LENGTH_X
;;R5 = LENGTH_Y
;;

.orig x3000
AND R0, R0, #0 		; x = 0
AND R1, R1, #0 		; y = 0
AND R2, R2, #0 		; z = 0

LOOP1  				; start of first while statement	
LD R3, LENGTH_X 	; load Length_x into register
LD R4, LENGTH_Y 	; load Length_y into register
NOT R3, R3 			
ADD R3, R3, #1 		
ADD R3, R0, R3 		; x - length_x
NOT R4, R4 			
ADD R4, R4, #1
ADD R4, R1, R4 		; y - length_y
AND R4, R3, R4 		; R4 = x - length_x AND y - length_y
BRzp endLOOP1 		; end while loop if Length_X > x or if y > Length_Y
LD R6, ARR_X       
ADD R3, R0, R6 		; Arr_x[x]
LD R7, ARR_Y 		
ADD R4, R1, R7 		; Arr_y[y]
LDR R3, R3, #0 		
LDR R4, R4, #0
NOT R6, R4
ADD R6, R6, #1 		
ADD R6, R3, R6		; arr_x[x] - arrY[y]
BRp else 			; if Arr_x[x] > Arry_y[y], go to else statement
LD R5, ARR_RES
ADD R7, R2, R5
STR R3, R7, #0
ADD R2, R2, #1
ADD R0, R0, #1
BRnzp endIF	 		; end of the if block
else
	LD R5, ARR_RES
	ADD R7, R2, R5 	;
	STR R4, R7, #0 	; arr_res[z]
	ADD R2, R2, #1 	; z++
	ADD R1, R1, #1  ; y++
	endIF
	BRnzp LOOP1
endLOOP1

LOOP2 	
LD R3, LENGTH_X
NOT R3, R3
ADD R3, R3, #1
ADD R3, R0, R3 		; x - length_x
BRzp endLOOP2 		; end loop if x >= ARRX.length
LD R6, ARR_X
ADD R4, R0, R6
LDR R3, R4, #0 		;arrx[x]
LD R5, ARR_RES
ADD R7, R2, R5
STR R3, R7, #0 		;arrz[z]
ADD R2, R2, #1 		;z++
ADD R0, R0, #1 		;x++
BRnzp LOOP2
endLOOP2 			;end of second while loop

LOOP3 	
LD R4, LENGTH_Y
NOT R4, R4
ADD R4, R4, #1
ADD R4, R1, R4 		; y - length_y
BRzp endLOOP3 		; end loop if y >= ARRY.length
LD R7, ARR_Y
ADD R3, R1, R7
LDR R4, R3, #0 		;arry[y]
LD R5, ARR_RES
ADD R6, R2, R5
STR R4, R6, #0 		;arrz[z]
ADD R2, R2, #1 		;z++
ADD R1, R1, #1 		;y++
BRnzp LOOP3
endLOOP3

HALT

ARR_X      .fill x4000
ARR_Y      .fill x4100
ARR_RES    .fill x4200

LENGTH_X   .fill 5
LENGTH_Y   .fill 7
LENGTH_RES .fill 12

.end

.orig x4000
.fill 1
.fill 5
.fill 10
.fill 11
.fill 12
.end

.orig x4100
.fill 3
.fill 4
.fill 6
.fill 9
.fill 15
.fill 16
.fill 17
.end
