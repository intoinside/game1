
scan_joystick    
        lda $dc00     ; get input from port 2 only
djrrb
        ldy #0        ; this routine reads and decodes the
        ldx #0        ; joystick/firebutton input data in
        lsr           ; the accumulator. this least significant
        bcs djr0      ; 5 bits contain the switch closure
        dey           ; information. if a switch is closed then it
djr0    lsr           ; produces a zero bit. if a switch is open then
        bcs djr1      ; it produces a one bit. The joystick dir-
        iny           ; ections are right, left, forward, backward
djr1    lsr           ; bit3=right, bit2=left, bit1=backward,
        bcs djr2      ; bit0=forward and bit4=fire button.
        dex           ; at rts time dx and dy contain 2's compliment
djr2    lsr           ; direction numbers i.e. $ff=-1, $00=0, $01=1.
        bcs djr3      ; dx=1 (move right), dx=-1 (move left),
        inx           ; dx=0 (no x change). dy=-1 (move up screen),
djr3    lsr           ; dy=0 (move down screen), dy=0 (no y change).
        cpx #$01
        beq right
        cpx #$ff
        beq left
        jmp look_y_move
right
        jsr ri_pressed
        jmp look_y_move
left   
        jsr le_pressed
look_y_move
        cpy #$01
        beq down
        cpy #$ff
        beq up
        jmp joystick_done
up
        jsr up_pressed
        jmp joystick_done
down   
;        jsr le_pressed
joystick_done
        rts
