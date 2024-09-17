// Computes the sum of n + (n - 1) + (n - 2) + ... + 1
// n is stored at address 14
// the sequence of sums computed is stored starting at address 15

// Intitial
/*0:*/  AND R0, R0, #0       // Clear R0
/*1:*/  AND R4, R4, #0       // Clear R4
/*2:*/  ADD R4, R4, #5       // Initialize R4 to be the address of the results array, relative to the instruction at line 
/*3:*/  LD  R1, #11          // Initialize R1 with N

// loop
/*4:*/  NOT R2, R1           // Negate the value in R1
/*5:*/  ADD R2, R2, #1       // Add 1 to the negated value
/*6:*/  ADD R3, R2, R1       // Add the original and negated values

/*7:*/  JSR #3               // Jump to subroutine to store the result

/*8:*/  ADD R1, R1, #-1      // Decrement R1
/*9:*/  BRp #-5              // Branch to loop if R1 is positive

// Store the result in memory
/*10:*/ STR R3, R4, #0
/*11:*/ ADD R4, R4, #1        
/*12:*/ RET

/*13:*/ HALT

/*14*/  000A
/*15:*/ 0000
