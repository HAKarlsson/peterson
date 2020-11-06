
.globl lock
.globl unlock

.section .data
.align 3
flag:     .dword 0
          .dword 0
turn:     .dword 0


.section .text
# lock(int thread)
# a0 = 0 \/ a0 = 1
.align 3
lock:
    li    t0, 1
    sub   a1, t0, a0
# a1 = 1 - a0

# t3 = upper bits of flag
1:  auipc t3, %pcrel_hi(flag)

# flag[a0] = 1
    slli  t1, a0, 3  
    add   t1, t1, t3  
    sd    t0, %pcrel_lo(1b)(t1) 
    fence # must be here

# t1 = (upper bits of flag) + 8 * a1
    slli  t1, a1, 3     
    add   t1, t1, t3   

# t2 = upper bits of flag
2:  auipc t2, %pcrel_hi(turn)
# turn = a1
    sd    a1, %pcrel_lo(2b)(t2)
# Start of while loop
3:  fence # must be here
    ld    a2, %pcrel_lo(1b)(t1) 
    beqz  a2, 4f 
    ld    a2, %pcrel_lo(2b)(t2) 
    bne   a2, a1, 4f
    j     3b 
4:  ret

# lock(int thread)
# a0 = 0 \/ a0 = 1
.align 3
unlock:
# set flag[a0] = 0
1:  auipc t0, %pcrel_hi(flag)
    slli  t1, a0, 3
    add   t1, t1, t0
    sd    zero, %pcrel_lo(1b)(t1)
    fence # this can be removed
    ret

