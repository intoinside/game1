; Generic routine

wait_routine
VBLANKWAITLOW
        lda $d011
        bpl VBLANKWAITLOW
VBLANKWAITHIGH
        lda $d011
        bmi VBLANKWAITHIGH
        rts
