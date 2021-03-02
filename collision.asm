; Collisions detection

CHECK_PLR_COLLISION
    lda $d01e
    and #%00000001                      ; Some HW detected collision with player sprite?
    beq CHECK_PLR_COLLISION_EXIT        ; No -> Exit.
    jsr SPR_COLL_DETECT                 ; Check which sprite collided with player.
    bne CHECK_PLR_SPRITE_01             ; If .X==$00 no collision detected (which is almost impossible...)
CHECK_PLR_COLLISION_EXIT
    rts
CHECK_PLR_SPRITE_01
    cpx #$01                            ; Check if sprite X is in "collision area"
    bne CHECK_PLR_SPRITE_02             ; No -> check next sprite
    inc $d020
;   Do something here...
    rts
CHECK_PLR_SPRITE_02
    cpx #$02
    bne CHECK_PLR_SPRITE_03
;   Do something here...
    rts
CHECK_PLR_SPRITE_03
    cpx #$03
    bne CHECK_PLR_SPRITE_04
;   Do something here...
    rts
CHECK_PLR_SPRITE_04
    cpx #$04
    bne CHECK_PLR_SPRITE_05
;   Do something here...
    rts
CHECK_PLR_SPRITE_05
    cpx #$05
    bne CHECK_PLR_SPRITE_06
;   Do something here...
    rts
CHECK_PLR_SPRITE_06
    cpx #$06
    bne CHECK_PLR_SPRITE_07
;   Do something here...
    rts
CHECK_PLR_SPRITE_07
    cpx #$07
    bne CHECK_PLR_SPRITE_EXIT
;   Do something here...
CHECK_PLR_SPRITE_EXIT
    rts

;---------------------------------------
; Sprite collided detect
; If .X<>$00 = Sprite collided with player
; Plr = spr $00
; From $01 enemies sprites.
;-------------------
SPR_COLL_DETECT
    inc $d020
    ldx #$07
SPR_COLL_LOOP
    lda SPRITE_0_Y,X                       ; Load Enemy Y position
    sec
    sbc SPRITE_0_Y                         ; Subtract Player Y position
    bpl CHECK_Y_NO_MINUS
    eor #$FF                            ; Invert result sign
CHECK_Y_NO_MINUS
    cmp #$15                            ; Check for enemy sprite distance Y
    bcs CHECK_PLR_NO_COLL
    lda SPRITE_0_X,X                       ; Load Enemy X position
    sec
    sbc SPRITE_0_X                         ; Subtract Player X position
    bpl CHECK_NO_MINUS
    eor #$FF                            ; Invert result sign
CHECK_NO_MINUS
    cmp #$17                            ; Check for enemy sprite distance X
    lda SPRITEMSB
    eor SPRITEMSB,X
    sbc #$00
    bcs CHECK_PLR_NO_COLL
    rts
CHECK_PLR_NO_COLL
    dex                                ; Goes to next sprite/enemy
    bne SPR_COLL_LOOP
    rts

;---------------------------------------
; Sprites data tables examples
;-------------------
SPRITEMSB
    BYTE $00, $00, $00, $00, $00, $00, $00, $00
;-------------------------------------------------------------------------------