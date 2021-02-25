; sprite routine

loadsprites
;sprite 0
        lda            #$C0     ; Sprite 0 - frog
        sta            $07f8

;sprite 1
        lda            #$C2     ; Sprite 2 - bee
        sta            $07fA

        rts

scan_joystick    
TODO remove wait, add sync with interrupt
        jsr wait_routine

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
        jmp do_pressed
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
        JMP scan_joystick
        
up_pressed
        LDY SPRITE_0_Y
        DEY
        STY SPRITE_0_Y
        JMP scan_joystick

do_pressed
        LDY SPRITE_0_Y
        INY
        STY SPRITE_0_Y
        JMP scan_joystick

TODO check reaching visible border
le_pressed
        LDX SPRITE_0_X
        CPX #0          ; maybe reached left boundary
        BEQ LEFT_CHECKMSBX
        DEX
        DEX
        STX SPRITE_0_X
        JMP scan_joystick

left_checkmsbx
        LDA SPRITE_MSBX
        CMP #0
        BEQ scan_joystick        ; left bounday reached
        DEC SPRITE_MSBX
        DEX
        DEX
        STX SPRITE_0_X
        JMP scan_joystick

TODO check reaching visible border
ri_pressed
        LDX SPRITE_0_X
        INX
        INX
        STX SPRITE_0_X
        CPX #254
        BNE scan_joystick
        LDA #1
        STA SPRITE_MSBX
        JMP scan_joystick
