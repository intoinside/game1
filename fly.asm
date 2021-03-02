; fly sprite routine

fly_move_x  byte $4f,$51,$53;,$52,$53,$54,$55,$56
;            byte $00,$00,$00,$00,$00,$00,$00,$00

fly_wait_for_position   byte $00
fly_wait_for_position2  byte $00
fly_position_on_map     byte $00
current_fly_frame       byte    $00

fly_update_position
        ldx fly_wait_for_position
        inc fly_wait_for_position
        cpx #$ff
        bne fly_update_position_impl
        ldx #$00
        stx fly_wait_for_position
        rts


fly_update_position_impl
        ldx fly_position_on_map
        lda fly_move_x,x
        sta SPRITE_2_X
        sta SPRITE_3_X
        cpx #$02
        beq fly_update_position_reset
fly_update_position_done
        inc fly_position_on_map
        rts
fly_update_position_reset
        lda #00
        sta fly_position_on_map
        rts

switch_sprite_fly
        ldx current_fly_frame
        inx
        cpx #$04
        beq switch_sprite_fly_0
        cpx #$08
        beq switch_sprite_fly_1
        stx current_fly_frame
        rts
switch_sprite_fly_0
        lda #$c2     ; Sprite 1 (frog frame 0)
        sta SPRITE_PTR +1
        stx current_fly_frame
        rts
switch_sprite_fly_1
        lda #$c3     ; Sprite 1 (frog frame 1)
        sta SPRITE_PTR +1
        ldx #0
        stx current_fly_frame
        rts
