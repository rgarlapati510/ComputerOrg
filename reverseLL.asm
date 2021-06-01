;;=============================================================
;; CS 2110 - Spring 2020
;; Homework 6 - Reverse Linked List
;;=============================================================
;; Name: Ruthvika Garlapati
;;============================================================

;; In this file, you must implement the 'reverseLL' subroutine.

;; Little reminder from your friendly neighborhood 2110 TA staff: don't run
;; this directly by pressing 'RUN' in complx, since there is nothing put at
;; address x3000. Instead, load it and use 'Debug' -> 'Simulate
;; Subroutine Call' and choose the 'reverseLL' label.

.orig x3000
HALT

;; Pseudocode (see PDF for explanation):
;;
;; Arguments of reverseLL: Node head
;;
;; reverseLL(Node head) {
;;     // note that a NULL address is the same thing as the value 0
;;     if (head == NULL) {
;;         return NULL;
;;     }
;;     if (head.next == NULL) {
;;         return head;
;;     }
;;     Node tail = head.next;
;;     Node newHead = reverseLL(tail);
;;     tail.next = head;
;;     head.next = NULL;
;;     return newHead;
;; }
reverseLL

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

IF 		LDR R0, R5, 4
		BRnp ENDIF
		ADD R3, R0, 0				;; clear it 	
		BR END
ENDIF 	NOP

IF2		LDR R0, R5, 4 				;; check if head.next is null
		LDR R1, R0, 0
		BRnp ENDIF2
		LDR R3, R5, 4
		BR END
ENDIF2 NOP 							;; go to line before teardown to skip rest of method

LDR R0, R5, 4
LDR R1, R0, 0
ADD R4, R1, 0

ADD R6, R6, -1
STR R4, R6, 0

JSR reverseLL 						;; recursive call
LDR R3, R6, 0
ADD R6, R6, 2
STR R0, R4, 0
AND R1, R1, 0
STR R1, R0, 0

END NOP
STR R3, R5, 0

CLEANUP 
 		LDR R0, R5, -1
 		STR R0, R5, 3
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

;; The following is an example of a small linked list that starts at x4000.
;;
;; The first number (offset 0) contains the address of the next node in the
;; linked list, or zero if this is the final node.
;;
;; The second number (offset 1) contains the data of this node.
.orig x4000
.fill x4008
.fill 5
.end

.orig x4008
.fill x4010
.fill 12
.end

.orig x4010
.fill 0
.fill -7
.end
