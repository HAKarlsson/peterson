# Author: Henrik Karlsson


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
    # Set `me` and `other`
    li    a2, 1
    sub   a1, a2, a0
    slli  a0, a0, 3  
    slli  a1, a1, 3

1:  auipc t0, %pcrel_hi(flag) # flag
    add   t1, t0, a0 # t1 -> flag[me]
    add   t2, t0, a1 # t2 -> flag[other]
2:  auipc t3, %pcrel_hi(turn) # t3 -> turn

    sd    a2, %pcrel_lo(1b)(t1) # flag[me] = true
    fence w,w
    sd    a0, %pcrel_lo(2b)(t3) # turn = me
# while(flag[other] && turn = me);
3:  fence
    ld    t0, %pcrel_lo(1b)(t2) # t0 = flag[other] 
    beqz  t0, 4f                # t0 == 0? -> exit
    ld    t1, %pcrel_lo(2b)(t3) # t1 = turn
    beq   t1, a0, 3b            # turn != me? -> exit
4:  ret

# lock(int thread)
# a0 = 0 \/ a0 = 1
.align 3
unlock:
# set flag[a0] = 0
1:  auipc t0, %pcrel_hi(flag)
    slli  t1, a0, 3
    add   t0, t0, t1
    sd    zero, %pcrel_lo(1b)(t0) # flag[me] = 0
    ret
