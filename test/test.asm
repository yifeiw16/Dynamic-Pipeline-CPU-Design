.data
A: .space 240
B: .space 240
C: .space 240
D: .space 240

.text
sll $0, $0, 0
exc: # exception
beq $30, $0, main
j exc

main:
lui $30, 0xffff # enable exception
addi $2, $0, 0 # a[i]
addi $3, $0, 1 # b[i]
addi $15, $0, 0 # c[i]
addi $16, $0, 0 # d[i]
addi $5, $0, 4 # counter
addi $6, $0, 0 # a[i-1]
addi $7, $0, 1 # b[i-1]
addi $10, $0, 0 # flag for i<20 || i<40
addi $11, $0, 240 # sum counts
addi $14, $0, 3

# addi $30, $0, 0

# Store 0 1 0 0 ($2,...,$16) in A B C D
lui $27, 0x0000
addu $27, $27, $0
sw $2, A($27)
lui $27, 0x0000
addu $27, $27, $0
sw $3, B($27)
lui $27, 0x0000
addu $27, $27, $0
sw $2, C($27)
lui $27, 0x0000
addu $27, $27, $0
sw $3, D($27)

# Loop
loop:
srl $12, $5, 2
add $6, $6, $12
lui $27, 0x0000
addu $27, $27, $5
sw $6, A($27)

mul $15, $14, $12
add $7, $7, $15
lui $27, 0x0000
addu $27, $27, $5
sw $7, B($27)

slti $10, $5, 80
bne $10, 1, c1

lui $27, 0x0000
addu $27, $27, $5
sw $6, C($27)

lui $27, 0x0000
addu $27, $27, $5
sw $7, D($27)

addi $15, $6, 0
addi $16, $7, 0
j endc

c1:
slti $10, $5, 160
addi $27, $0, 1
bne $10, $27, c2

add $15, $6, $7
lui $27, 0x0000
addu $27, $27, $5
sw $15, C($27)

mul $16, $15, $6
lui $27, 0x0000
addu $27, $27, $5
sw $16, D($27)
j endc

c2:
mul $15, $6, $7
lui $27, 0x0000
addu $27, $27, $5
sw $15, C($27)

mul $16, $15, $7
lui $27, 0x0000
addu $27, $27, $5
sw $16, D($27)

endc:
addi $5, $5, 4
bne $5, $11, loop
break
