; fly sprite routine

fly_move_x  byte $4f,$51,$53,$55,$57,$59,$5a,$5c
;            byte $00,$00,$00,$00,$00,$00,$00,$00

fly_wait_for_position   byte $00
fly_wait_for_position2  byte $00
fly_position_on_map     byte $00
current_fly_frame       byte $00
fly_eaten_frame         byte $00
tmp_random_number       byte $00

; fly eaten by frog
start_fly_eat
        inc fly_eaten_frame
        rts

; perform fly eaten sprite
fly_eaten
        ldx fly_eaten_frame
        cpx #$01
        bcs fly_eaten_frame_impl
        rts
fly_eaten_frame_impl
        inc fly_eaten_frame
        cpx #$01
        beq fly_eaten_1
        cpx #$10
        beq fly_eaten_2
        cpx #$20
        beq fly_eaten_3
        cpx #$30
        beq fly_eaten_4
        cpx #$40
        bcs fly_eaten_hide_sprite
        rts
fly_eaten_1
        lda #$c3
        sta SPRITE_PTR + 1
        rts
fly_eaten_2
        lda #$c4
        sta SPRITE_PTR + 1
        rts
fly_eaten_3
        lda #$c5
        sta SPRITE_PTR + 1
        rts
fly_eaten_4
        lda #$c6
        sta SPRITE_PTR + 1
        rts
fly_eaten_hide_sprite
        ldx #$ff
        stx fly_eaten_frame
        lda #%00000001
        sta SPRITE_ENABLE
        rts

; setup fly position
fly_update_position
        lda fly_eaten_frame         ; if fly is going to be eaten
        cmp #$01                    ; stop fly sprite move
        bcc fly_wait_for_update_position
        rts
fly_wait_for_update_position
        ldx fly_wait_for_position
        inc fly_wait_for_position
        cpx #$ff
        bne fly_update_position_impl
        jmp fly_update_position_reset
fly_update_position_impl
        jsr get_random_number
        sta tmp_random_number
        lda SPRITE_1_X
        adc tmp_random_number
        sta SPRITE_1_X
        rts
fly_update_position_reset
        lda #00
        sta fly_wait_for_position
        rts

switch_sprite_fly
        lda fly_eaten_frame         ; if fly is going to be eaten
        cmp #$01                    ; stop fly sprite switch
        bcc switch_sprite_fly_impl
        rts
switch_sprite_fly_impl
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
