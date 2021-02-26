; sprite routine

loadsprites
;sprite 0
        lda            #$C0     ; Sprite 0 - frog
        sta            $07f8

;sprite 1
        lda            #$C2     ; Sprite 2 - bee
        sta            $07fA

        rts

is_jumping  byte $00
is_falling  byte $00

scan_joystick    
TODO remove wait, add sync with interrupt
        jsr wait_routine

;        jsr write_debug_is_jumping
;        jsr write_debug_is_falling

        jsr perform_jump
        jsr perform_fall

TODO add support for multiple direction
djrr    lda $dc00     ; get input from port 2 only
djrrb   ldy #0        ; this routine reads and decodes the
        ldx #0        ; joystick/firebutton input data in
        lsr           ; the accumulator. this least significant
        bcs djr0      ; 5 bits contain the switch closure
        dey           ; information. if a switch is closed then it
        jmp up_pressed
djr0    lsr           ; produces a zero bit. if a switch is open then
        bcs djr1      ; it produces a one bit. The joystick dir-
        iny           ; ections are right, left, forward, backward
        jmp scan_joystick
djr1    lsr           ; bit3=right, bit2=left, bit1=backward,
        bcs djr2      ; bit0=forward and bit4=fire button.
        dex           ; at rts time dx and dy contain 2's compliment
        jmp le_pressed
djr2    lsr           ; direction numbers i.e. $ff=-1, $00=0, $01=1.
        bcs djr3      ; dx=1 (move right), dx=-1 (move left),
        inx           ; dx=0 (no x change). dy=-1 (move up screen),
        jmp ri_pressed
djr3    lsr           ; dy=0 (move down screen), dy=0 (no y change).
                      ; the forward joystick position corresponds
                      ; to move up the screen and the backward

                      ; position to move down screen.
                      ;
                      ; at rts time the carry flag contains the fire
                      ; button state. if c=1 then button not pressed.
                      ; if c=0 then pressed.

up_to_scan_joystick
        JMP scan_joystick

up_pressed
        ldx is_jumping
        cpx #0
        bne up_to_scan_joystick
        ldx #1
        stx is_jumping
        jmp scan_joystick

TODO check reaching visible border
le_pressed
        LDX SPRITE_0_X
        CPX #0          ; maybe reached left boundary
        BEQ LEFT_CHECKMSBX
        DEX
        DEX
        STX SPRITE_0_X
        jmp scan_joystick

left_checkmsbx
        LDA SPRITE_MSBX
        CMP #0
        BEQ up_to_scan_joystick        ; left bounday reached
        DEC SPRITE_MSBX
        DEX
        DEX
        STX SPRITE_0_X
        jmp scan_joystick

TODO check reaching visible border
ri_pressed
        LDX SPRITE_0_X
        INX
        INX
        STX SPRITE_0_X
        CPX #254
        BNE up_to_scan_joystick
        LDA #1
        STA SPRITE_MSBX
        jmp scan_joystick


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


;write_debug_is_jumping
;        lda is_jumping
;        cmp #0
;        beq is_jumping_not_0
;        lda #$31
;        sta $0590
;        rts
;is_jumping_not_0
;        lda #$30
;        sta $0590
;        rts

;write_debug_is_falling
;        lda is_falling
;        cmp #0
;        beq is_falling_not_0
;        lda #$31
;        sta $0600
;        rts
;is_falling_not_0
;        lda #$30
;        sta $0600
;        rts


