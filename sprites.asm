
loadsprites
;sprite 0
        lda            #$C0     ; Sprite 0 location
        sta            $07f8

;sprite 1
        lda            #$C1     ; Sprite 1 location
        sta            $07f9

        rts