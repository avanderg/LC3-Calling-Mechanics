; CHAR_COUNT FUNCTION
;

.ORIG x3300
; *************** CHAR_COUNT SETUP *****************************
ADD R6, R6, #-1 ; Leave space for return value

ADD R6, R6, #-1 ; Push return address
STR R7, R6, #0

ADD R6, R6, #-1 ; Push dynamic link
STR R5, R6, #0

ADD R5, R6, #-1 ; Set new frame pointers

ADD R6, R6, #-1 ; Allocate space for locals (just return)

; *************** CHAR_COUNT CODE *****************************
;   if (*str == 0)
LDR R1, R5, #4 ; Pop the address of the value at the beginning of the string
LDR R1, R1, #0 ; Retrieve the value
BRz ZERO ; if it's zero, go to the zero ending
BRnp ELSE
ZERO STR R1, R5, #0 ; Store the value of R1 into the top of the frame pointer
     							  ; It's 0 in this case
Brnzp END
;      result = 0;



;   else {
;      if (*str == c)

ELSE LDR R2, R5, #5 ; Load the value of the character into R2
NOT R2, R2
ADD R2, R2, #1
ADD R2, R2, R1
BRz CHARACTER
BRnp ELSE2

CHARACTER AND R3, R3, #0
ADD R3, R3, #1
STR R3, R5, #0 ; Store 1 at result
BRnzp RECURSION


;         result = 1;



;      else
;         result = 0;

ELSE2 AND R3, R3, #0
STR R3, R5, #0 ; Store 0 in result
BRnzp RECURSION

;      result += charCount(str+1, c);

RECURSION LDR R1, R5, #5 ; Load the value of c
ADD R6, R6, #-1
STR R1, R6, #0 ; push c to the top of the stack

LDR R1, R5, #4 ; Location of 1st character
ADD R1, R1, #1 ; Pop value of 2nd character
ADD R6, R6, #-1
STR R1, R6, #0 ; push &word[1] to top of STACK

LD      R0, CHAR_COUNT ; Recursion call
JSRR    R0
LDR R1, R6, #0 ; Load the returned value
ADD R6, R6, #1 ; Pop return value
ADD R6, R6, #1 ; Pop args
LDR R2, R5, #0 ; Load the count for this recursion
ADD R1, R1, R2 ; Add them
STR R1, R5, #0 ; Store that in the result spot
BRnzp END


; *************** CHAR_COUNT RETURN *****************************

	; return result;

END LDR R0, R5, #0
STR R0, R5, #3 ; Store result into return value
ADD R6, R5, #1; Pop local variables
LDR R5, R6, #0 ; Pop dynamic link into R5
ADD R6, R6, #1
LDR R7, R6, #0 ; Pop return address into R7
ADD R6, R6, #1
RET ; return to caller

CHAR_COUNT .FILL   x3300
	.END
