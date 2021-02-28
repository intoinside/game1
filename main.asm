!TO "DISPLAYCHARPADBINARIES.PRG,CBM

; 10 SYS (2304)
*=$0801

    BYTE $0E, $08, $0A, $00, $9E, $20, $28, $32
    BYTE $33, $30, $34, $29, $00, $00, $00
IncAsm "routine.asm"
IncAsm "label.asm"

*=$0900
        jsr init_screen

        jsr init_sprites

        jsr init_map

        jsr init_char_color

        jmp scan_joystick

init_screen
        sei
        lda #$37
        sta $01
        lda #$18
        sta SCREEN_CTRL         ;Screen Multicolour mode enabled
        sta MEMORY_SETUP        ;Charset mode set to display custom char $2000-$2800
        lda #$00                ;Set colour black
        sta BORDER_COLOR        ;to border
        lda #$07
        sta EXTRA_BACKGROUND1   ;Char Multicolour 1
        lda #$01
        sta EXTRA_BACKGROUND2   ;Char Multicolour 2
        lda #$09
        sta EXTRA_BACKGROUND3   ;Char Multicolour 3
        lda #$03
        sta BACKGROUND_COLOR    ;Char Multicolour 3
        rts
;Draw main screen from matrix -
;NOTE max 256 chars per location ($0400-$04FF, $0500-$05ff,
;$0600,$06ff,$0700,$07e8)

init_map
        ldx #$00
drawscrn
        lda matrix,X        ;Get data from map
        sta $0400,X         ;Put data into SCREEN RAM
        lda matrix+$100,X   ;Fetch the next 256 bytes of data from binary
        sta $0500,X         ;Store the next 256 bytes to screen
        lda matrix+$200,X   ;... and so on
        sta $0600,X
        lda matrix+$2E8,X
        sta $06E8,X
        inx                 ;Increment accumulator until 256 bytes read
        bne drawscrn
        rts

;Draw attributes from 256 bytes attribs table and place these to SCREEN RAM
init_char_color
        ldx #$00
paintcols
        ldy SCREEN_RAM,X    ;Read screen position
        lda attribs,Y       ;Read attributes table
        sta $D800,X         ;Store to COLOUR RAM
        ldy SCREEN_RAM + $100,X         ;Read next 256 screen positions
        lda attribs,Y       ;Store to COLOUR RAM + $100
        sta $D900,X         ;... and so on
        ldy SCREEN_RAM + $200,X
        lda attribs,Y
        sta $DA00,X
        ldy $06E8,X
        lda ATTRIBS,Y
        sta $DAE8,X
        inx                 ;Increment accumulator until 256 bytes read
        bne paintcols
        rts

IncAsm "sprites.asm"


;If using a cross assembler use CORRECT pseudo command,
;offset for importing binary data
*=$2000
incbin "charset.bin"

*=$2800
matrix
incbin "map_1.bin"

*=$2C00
attribs
incbin "cols.bin"

*=$3000
incbin "frog.spt",1,2, true
incbin "fly.spt",1,2, true

