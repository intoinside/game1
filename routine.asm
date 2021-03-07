; Generic routine

wait_routine
VBLANKWAITLOW
        lda $d011
        bpl VBLANKWAITLOW
VBLANKWAITHIGH
        lda $d011
        bmi VBLANKWAITHIGH
        rts

generator_max   byte    $00
get_random_number
        lda $d012
        eor $dc04
        sbc $dc05
        cmp generator_max
        bcs get_random_number
        rts

;write_debug_current_frame_frog
;        lda current_frame_frog
;        cmp #0
;        beq current_frame_frog_not_0
;        lda #$31
;        sta $0440
;        lda #$00
;        sta $D840
;        rts
;current_frame_frog_not_0
;        lda #$30
;        sta $0440
;        rts

;write_debug_is_jumping
;        lda is_jumping
;        cmp #0
;        beq is_jumping_not_0
;        lda #$31
;        sta $0400
;        lda #$00
;        sta $D800
;        rts
;is_jumping_not_0
;        lda #$30
;        sta $0400
;        rts

;write_debug_is_falling
;        lda is_falling
;        cmp #0
;        beq is_falling_not_0
;        lda #$31
;        sta $0428
;        lda #$00
;        sta $D828
;        rts
;is_falling_not_0
;        lda #$30
;        sta $0428
;        rts

;write_debug_fly_position_on_map
;        lda fly_position_on_map
;        adc #$30
;        sta $042A
;        lda #$00
;        sta $D82A
;        rts

;write_debug_current_fly_frame
;        lda current_fly_frame
;        adc #$30
;        sta $042C
;        lda #$00
;        sta $D82C
;        rts

;write_debug_x_reg
;        txa
;        adc #$30
;        sta $0428
;        lda #$00
;        sta $D828
;        rts
