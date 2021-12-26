addi x31,x0,0;
addi x1,x0,8 ;
add  x2,x0,x1;
addi x3,x0,7 ;
sub  x4,x2,x3;
addi x5,x0,15;
and  x6,x5,x4;
or   x7,x5,x4;
xor  x8,x5,x4;
addi x1,x0,1
addi x9,x0,8
addi x10,x0,0
addi x11,x0,1
loop:
sll  x11,x11,x1
addi x10,x10,1
blt  x10,x9,loop
lw   x12,0(x2)
sw   x11,0(x0)

