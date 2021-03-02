; frog sprite routine

is_jumping          byte    $00
is_falling          byte    $00
current_frame_frog  byte    $00

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
        jmp up_to_scan_joystick

left_checkmsbx
        lda SPRITE_MSBX
        cmp #0
        beq up_to_scan_joystick        ; left bounday reached
        lda #0
        sta SPRITE_MSBX
        dex
        stx SPRITE_0_X
        jmp up_to_scan_joystick

TODO check reaching visible border
ri_pressed
        jsr switch_sprite_frog
        ldx SPRITE_0_X
        inx
        stx SPRITE_0_X
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
        lda #$c0     ; Sprite 0 (frog frame 0)
        sta SPRITE_PTR
        stx current_frame_frog
        rts
switch_sprite_frog_1
        lda #$c1     ; Sprite 0 (frog frame 1)
        sta SPRITE_PTR
        ldx #0
        stx current_frame_frog
        rts

; jump and fall routine
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
perform_no_fall        
        rts
stop_fall
        ldx #0
        stx is_falling
        rts
