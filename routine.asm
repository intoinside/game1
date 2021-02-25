; Generic routine

wait_routine
        ldy #0
        ldx #0
loop 
        inx
        cpx #255
        bne loop

        iny
        cpy #8
        bne loop

        rts