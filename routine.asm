; Generic routine

wait_routine
VBLANKWAITLOW
        lda $d011
        bpl VBLANKWAITLOW
VBLANKWAITHIGH
        lda $d011
        bmi VBLANKWAITHIGH
        rts

init_random_generator
        lda #$ff  ; maximum frequency value
        sta $d40e ; voice 3 frequency low byte
        sta $d40f ; voice 3 frequency high byte
        lda #$80  ; noise waveform, gate bit off
        sta $d412 ; voice 3 control register
        rts

get_random_number
        lda RND_GENERATOR ; get random value from 0-255
        cmp #$03
        bcs get_random_number
;        adc #$01
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
