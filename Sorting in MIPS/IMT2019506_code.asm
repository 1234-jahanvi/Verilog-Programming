#Written by Harshith(IMT2017516)
#email: Harshith.Reddy@iiitb.org

#run in linux terminal by java -jar Mars4_5.jar nc filename.asm(take inputs from console)

#system calls by MARS simulator:
#http://courses.missouristate.edu/kenvollmar/mars/help/syscallhelp.html
.data
	next_line: .asciiz "\n"	
.text
#input: N= how many numbers to sort should be entered from terminal. 
#It is stored in $t1	
jal input_int 
move $t1,$t4			

#input: X=The Starting address of input numbers (each 32bits) should be entered from
# terminal in decimal format. It is stored in $t2
jal input_int
move $t2,$t4

#input:Y= The Starting address of output numbers(each 32bits) should be entered
# from terminal in decimal. It is stored in $t3
jal input_int
move $t3,$t4 

#input: The numbers to be sorted are now entered from terminal.
# They are stored in memory array whose starting address is given by $t2
move $t8,$t2
move $s7,$zero	#i = 0
loop1:  beq $s7,$t1,loop1end
	jal input_int
	sw $t4,0($t2)
	addi $t2,$t2,4
      	addi $s7,$s7,1
        j loop1      
loop1end: move $t2,$t8       
#############################################################
#Do not change any code above this line
#Occupied registers $t1,$t2,$t3. Don't use them in your sort function.
#############################################################
#function: should be written by students(sorting function)
#My code:

move $s4, $t3		# $s4 initialized to Y and then incremented by 4 in outer loop iterations as it's where the next number of the sorted order will be stored
move $s0, $zero		# $s0 stores outer loop counter i, initialized to 0
subi $t0,$t1,1		# $t0 = N-1

Loop1: beq $s0,$t0,End1		# Outer loop begins with a conditon i < N-1
       move $s3,$s0		# min_idx = i
       addi $s1,$s0,1		# j=i+1 before the inner loop starts
Loop2: beq $s1,$t1,End2		# Inner loop begins with a condition j < N
       sll $t4,$s1,2		# Calculating the memory location X+4*j where arr[j] is stored
       add $t4,$t4,$t2
       sll $t5,$s3,2		# Calculating the memory location X+4*(min_idx) where arr[min_idx] is stored
       add $t5,$t5,$t2
       lw $t6,0($t4)		# Loading arr[j] into $t6
       lw $t7,0($t5)		# Loading arr[min_idx] into $t7
       slt $t4, $t6, $t7   	# Checking if arr[j] < arr[min_index] and then if true $t4 =1 else $t4=0
       bne $t4,1, next2		# Checking if $t4 is equal to 1 (i.e. if arr[j] < arr[min_idx])
       move $s3,$s1		# If true then min_idx = j
next2: addi $s1,$s1,1		# Incrementing inner loop counter j by 1
       j Loop2 			# Jump to the Loop2 and check the inner loop condition
       #Inner loop ends
End2:  sll $t4,$s0,2		# Calculating the memory location X+4*i where arr[i] is stored
       add $t4,$t4,$t2		
       sll $t5,$s3,2		# Calculating the memory location X+4*(min_idx) where arr[min_idx) is stored
       add $t5,$t5,$t2
       #Swapping arr[i] and arr[min_idx]
       lw $t6,0($t5)		# Loading arr[min_idx] into $t6
       lw $t7,0($t4)		# Loading arr[i] into $t7
       sw $t6,0($t4)		# arr[i] = arr[min_idx]	
       sw $t7,0($t5)		# Storing $t7 (arr[i]) into arr[min_idx]
       
       sw $t6,0($s4)		# Storing the minimum element (i.e. the next number in the sorted sequence) at the location given by $s4
       add $s4,$s4,4		# Incrementing $s4 by 4 to store the next number of the sorted order
       addi $s0,$s0,1		# Incrementing outer loop counter i by 1
       j Loop1			# Jump to the Loop1 and check the outer loop condition	
       #Outer loop ends
End1:  sll $s0,$s0,2		#Calculating the address of the last element in the input array as this will be highest
       add $s0,$s0,$t2
       lw $t4, 0($s0)		#Loading it into $t4
       sw $t4,0($s4)		#Now storing it into destination array as the highest element i.e. at Y+4*(N-1)
            
#End
#############################################################
#You need not change any code below this line

#print sorted numbers
move $s7,$zero	#i = 0
loop: beq $s7,$t1,end
      lw $t4,0($t3)
      jal print_int
      jal print_line
      addi $t3,$t3,4
      addi $s7,$s7,1
      j loop 
#end
end:  li $v0,10
      syscall
#input from command line(takes input and stores it in $t6)
input_int: li $v0,5
	   syscall
	   move $t4,$v0
	   jr $ra
#print integer(prints the value of $t6 )
print_int: li $v0,1		#1 implie
	   move $a0,$t4
	   syscall
	   jr $ra
#print nextline
print_line:li $v0,4
	   la $a0,next_line
	   syscall
	   jr $ra

