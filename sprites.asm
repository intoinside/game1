
init_sprites
        lda #$c0                ; Sprite 1 (frog frame 0)
        sta SPRITE_PTR
        lda #$c2                ; Sprite 2 (fly frame 0)
        sta SPRITE_PTR + 1

        lda #%00000011
        sta SPRITE_ENABLE
        sta SPRITE_MULTICOLOR   ;turn on the multicolor mode
        lda #$00
        sta SPRITE_EXTRA_COLOR1 ; multicolor1
        lda #$07
        sta SPRITE_EXTRA_COLOR2 ; multicolor2

        lda #$05
        sta SPRITE_0_COLOR      ; sprite 0 color
        lda #$0E
        sta SPRITE_1_COLOR      ; sprite 1 color

        lda #$80
        sta SPRITE_0_X          ;set the horizontal position
        lda #$d2
        sta SPRITE_0_Y          ;set the vertical position 
        lda #$4f
        sta SPRITE_1_X
        lda #$c0
        sta SPRITE_1_Y

        rts

