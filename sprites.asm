; sprite routine

init_sprites
        lda #$C0     ; Sprite 0 (frog frame 0)
        sta SPRITE_PTR
        lda #$C1     ; Sprite 1 (frog frame 1)
        sta SPRITE_PTR + 1
        lda #$C2     ; Sprite 2 (fly frame 0)
        sta SPRITE_PTR + 2
        lda #$C3     ; Sprite 3 (fly frame 1)
        sta SPRITE_PTR + 3
        lda #%00001111
        sta SPRITE_ENABLE
        sta SPRITE_MULTICOLOR   ;turn on the multicolor mode
        lda #$00
        sta SPRITE_EXTRA_COLOR1 ; multicolor1
        lda #$07
        sta SPRITE_EXTRA_COLOR2 ; multicolor2
        lda #$05
        sta SPRITE_0_COLOR      ; sprite 0 color
        sta SPRITE_1_COLOR      ; sprite 1 color
        lda #$0E
        sta SPRITE_2_COLOR      ; sprite 2 color
        sta SPRITE_3_COLOR      ; sprite 3 color
        lda #$80
        sta SPRITE_0_X          ;set the horizontal position
        sta SPRITE_1_X
        lda #$d2
        sta SPRITE_0_Y          ;set the vertical position 
        sta SPRITE_1_Y
        lda #$4F
        sta SPRITE_2_X
        sta SPRITE_3_X
        lda #$83
        sta SPRITE_2_Y
        sta SPRITE_3_Y

up_to_scan_joystick
        rts

up_pressed
        ldx is_jumping
        cpx #0
        bne up_to_scan_joystick
        ldx #1
        stx is_jumping
        jmp up_to_scan_joystick

TODO check reaching visible border
le_pressed
        jsr switch_sprite_frog
        ldx SPRITE_0_X
        cpx #0          ; maybe reached left boundary
        beq left_checkmsbx
        dex
        stx SPRITE_0_X
        stx SPRITE_1_X
        jmp up_to_scan_joystick

left_checkmsbx
        lda SPRITE_MSBX
        cmp #0
        beq up_to_scan_joystick        ; left bounday reached
        lda #0
        sta SPRITE_MSBX
        dex
        stx SPRITE_0_X
        stx SPRITE_1_X
        jmp up_to_scan_joystick

TODO check reaching visible border
ri_pressed
        jsr switch_sprite_frog
        ldx SPRITE_0_X
        inx
        stx SPRITE_0_X
        stx SPRITE_1_X
        cpx #255
        bne up_to_scan_joystick
        lda #%00000011
        sta SPRITE_MSBX
        jmp up_to_scan_joystick


switch_sprite_frog
        ldx current_frame_frog
        inx
        cpx #$0b
        beq switch_sprite_frog_0
        cpx #$16
        beq switch_sprite_frog_1
        stx current_frame_frog
        rts
switch_sprite_frog_0
        lda SPRITE_ENABLE
        and #%11111110
        ora #%00000010
        sta SPRITE_ENABLE
        stx current_frame_frog
        rts     
switch_sprite_frog_1
        lda SPRITE_ENABLE
        and #%11111101
        ora #%00000001
        sta SPRITE_ENABLE
        ldx #0
        stx current_frame_frog
        rts     

switch_sprite_fly
        ldx current_frame_fly
        inx
        cpx #$04
        beq switch_sprite_fly_0
        cpx #$08
        beq switch_sprite_fly_1
        stx current_frame_fly
        rts
switch_sprite_fly_0
        lda SPRITE_ENABLE
        and #%11110111
        ora #%00000100
        sta SPRITE_ENABLE
        stx current_frame_fly
        rts     
switch_sprite_fly_1
        lda SPRITE_ENABLE
        and #%11111011
        ora #%00001000
        sta SPRITE_ENABLE
        ldx #0
        stx current_frame_fly
        rts

perform_jump
        ldx is_falling
        cpx #1
        beq stop_jump
        ldx is_jumping
        cpx #0
        beq perform_no_jump
        ldy SPRITE_0_Y
        cpy #$c0
        bcc stop_jump
        dey
        sty SPRITE_0_Y
        sty SPRITE_1_Y
perform_no_jump
        rts
stop_jump
        ldx #0
        stx is_jumping
        ldx #1
        stx is_falling
        rts

perform_fall
        ldx is_jumping
        cpx #1
        beq perform_no_fall
        ldx is_falling
        cpx #0
        beq perform_no_fall
        ldy SPRITE_0_Y
        cpy #$d2
        bcs stop_fall
        iny
        sty SPRITE_0_Y
        sty SPRITE_1_Y
perform_no_fall        
        rts
stop_fall
        ldx #0
        stx is_falling
        rts

is_jumping          byte    $00
is_falling          byte    $00
current_frame_frog  byte    $00
current_frame_fly   byte    $00

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


