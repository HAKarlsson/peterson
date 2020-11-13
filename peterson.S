# Author: Henrik Karlsson
# Notes: 
# replace `fence` instructions with `fence.w.r`
# when they are implemented.


# Globally available functions
.globl lock
.globl unlock

# Our lock structure
.section .data
.align 3
# long flag[2]
flag:     .dword 0
          .dword 0
# long turn
turn:     .dword 0


.section .text
# lock(int thread)
# thread = 0 \/ thread = 1
# a0 = thread
.align 3
lock:
    li    t0, 1
    sub   a1, t0, a0
# a0 = me, a1 = other

# t3 = upper bits of flag
1:  auipc t3, %pcrel_hi(flag)

# Set the flag
# flag[me] = 1
    slli  t1, a0, 3  
    add   t1, t1, t3  
    sd    t0, %pcrel_lo(1b)(t1) 
    fence

# Get parts of flag[other] address
    slli  t1, a1, 3     
    add   t1, t1, t3   

# Get upper bits of turn address
2:  auipc t2, %pcrel_hi(turn)
# Get parts of turn = me
    sd    a1, %pcrel_lo(2b)(t2)

# Start of while loop
3:  fence
    ld    a2, %pcrel_lo(1b)(t1)  
    beqz  a2, 4f                # flag[other] = 1 ? 
    ld    a2, %pcrel_lo(2b)(t2) 
    beq   a2, a1, 3b            # turn = me ?
4:  ret

# lock(int thread)
# a0 = 0 \/ a0 = 1
.align 3
unlock:
# set flag[a0] = 0
1:  auipc t0, %pcrel_hi(flag)
    slli  t1, a0, 3
    add   t1, t1, t0
    sd    zero, %pcrel_lo(1b)(t1) # flag[me] = 0
    fence
    ret

