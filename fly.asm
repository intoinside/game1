; fly sprite routine

fly_wait_for_position   byte $00
fly_position_on_map     byte $00
current_fly_frame       byte $00
fly_eaten_frame         byte $00
fly_direction           byte $00 ;00 means right, ff means left

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
        cpx #$0a
        beq fly_eaten_2
        cpx #$13
        beq fly_eaten_3
        cpx #$1c
        bcs fly_eaten_hide_sprite
        rts
fly_eaten_1
        lda #$c6
        sta SPRITE_PTR + 1
        rts
fly_eaten_2
        lda #$c7
        sta SPRITE_PTR + 1
        rts
fly_eaten_3
        lda #$c8
        sta SPRITE_PTR + 1
        lda #$0a
        jsr update_score
        rts

fly_eaten_hide_sprite
        ldx #$ff
        stx fly_eaten_frame
        lda SPRITE_ENABLE
        and #%11111101
        sta SPRITE_ENABLE
        rts

; setup fly position
fly_update_position
        lda fly_eaten_frame             ; if fly is going to be eaten
        cmp #$01                        ; stop fly sprite move
        bcc fly_wait_for_update_position
        rts
fly_wait_for_update_position            ; fly move allowed
        ldx fly_wait_for_position       ; look for delay
        inc fly_wait_for_position
        cpx #$01
        beq fly_update_position_impl    ; delay reached, moving fly
        rts
fly_update_position_impl                ; calculate distance to move
        ldx #00
        stx fly_wait_for_position
        lda #$03
        sta generator_max
        jsr get_random_number
        sta tmp_random_number
        inc tmp_random_number
        inc tmp_random_number           ; store distance in tmp_random_number

        lda #$30                        ; calculate a new random to
        sta generator_max               ; detect if is needed a new direction
        jsr get_random_number
        cmp #$06
        bcs fly_move                    ; no direction change, go to move
        lda fly_direction               ; check current direction
        cmp #$00
        beq switch_dir
        lda #$00
        sta fly_direction               
        jmp fly_move
; SURE there is a better way to do fly_direction handling
switch_dir 
        lda #$ff
        sta fly_direction
fly_move
        lda fly_direction               ; move fly based on direction
        cmp #$00
        beq fly_move_forward
        lda SPRITE_1_X
        jsr check_left_boundary
        sec
        sbc tmp_random_number
        bcs fly_move_done
        jsr toggle_hi_bit_fly
        jmp fly_move_done
fly_move_forward
        lda SPRITE_1_X
        jsr check_right_boundary
        sec
        adc tmp_random_number
        bcc fly_move_done
        jsr toggle_hi_bit_fly
fly_move_done
        sta SPRITE_1_X
        rts
fly_update_position_reset
        lda #00
        sta fly_wait_for_position
        rts

; check if new sprite x position (stored in a) is over the right border
; in this case, direction in switched
check_right_boundary
        ldx SPRITE_MSBX
        cpx #%00000010
        bne check_right_boundary_done
        cmp #$40
        bcc check_right_boundary_done
        ldx #$ff
        stx fly_direction
check_right_boundary_done
        rts

; check if new sprite x position (stored in a) is over the left border
; in this case, direction in switched
check_left_boundary
        ldx SPRITE_MSBX
        cpx #%00000010
        beq check_left_boundary_done
        cmp #$16
        bcs check_left_boundary_done
        ldx #$00
        stx fly_direction
check_left_boundary_done
        rts

toggle_hi_bit_fly
        tax
        lda SPRITE_MSBX
        eor #%00000010
        sta SPRITE_MSBX      ;updated most significant bit value
        txa
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
        lda fly_direction
        cmp #$00
        beq switch_sprite_fly_0_fw
        lda #$c4
        jmp update_sprite_frame_0
switch_sprite_fly_0_fw
        lda #$c2
update_sprite_frame_0
        sta SPRITE_PTR +1
        stx current_fly_frame
        rts
switch_sprite_fly_1
        lda fly_direction
        cmp #$00
        beq switch_sprite_fly_1_fw
        lda #$c5
        jmp update_sprite_frame_1
switch_sprite_fly_1_fw
        lda #$c3
update_sprite_frame_1
        sta SPRITE_PTR +1
        ldx #0
        stx current_fly_frame
        rts
