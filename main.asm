!TO "DISPLAYCHARPADBINARIES.PRG,CBM

; 10 SYS (2304)
*=$0801

    BYTE $0E, $08, $0A, $00, $9E, $20, $28, $32
    BYTE $33, $30, $34, $29, $00, $00, $00

IncAsm "label.asm"
IncAsm "sprites.asm"


*=$0900
    SEI
    LDA #$37
    STA $01
    LDA #$18
    STA SCREEN_CTRL         ;Screen Multicolour mode enabled
    STA MEMORY_SETUP        ;Charset mode set to display custom char $2000-$2800
    LDA #$00                ;Set colour black
    STA BORDER_COLOR        ;to border
    LDA #$07
    STA EXTRA_BACKGROUND1   ;Char Multicolour 1
    LDA #$01
    STA EXTRA_BACKGROUND2   ;Char Multicolour 2
    LDA #$09
    STA EXTRA_BACKGROUND3   ;Char Multicolour 3
    LDA #$03
    STA BACKGROUND_COLOR    ;Char Multicolour 3

; setup sprite
    lda #$03
    sta SPRITE_ENABLE
    sta SPRITE_MULTICOLOR   ;turn on the multicolor mode
    lda #$00
    sta SPRITE_EXTRA_COLOR1 ; multicolor1
    lda #$01
    sta SPRITE_EXTRA_COLOR2 ; multicolor2
    lda #$05
    sta SPRITE_0_COLOR      ; sprite 0 color
    lda #$05
    sta SPRITE_1_COLOR      ; sprite 0 color
    lda #$80
    sta SPRITE_0_X          ;set the horizontal position
    lda #$d2
    sta SPRITE_0_Y          ;set the vertical position 
    lda #$9F
    sta SPRITE_1_X          ;set the horizontal position
    lda #$d3
    sta SPRITE_1_Y          ;set the vertical position 
    jsr loadsprites


;Draw main screen from matrix -
;NOTE max 256 chars per location ($0400-$04FF, $0500-$05ff,
;$0600,$06ff,$0700,$07e8)
    LDX #$00
DRAWSCRN
    LDA MATRIX,X        ;Get data from map
    STA $0400,X         ;Put data into SCREEN RAM
    LDA MATRIX+$100,X   ;Fetch the next 256 bytes of data from binary
    STA $0500,X         ;Store the next 256 bytes to screen
    LDA MATRIX+$200,X   ;... and so on
    STA $0600,X
    LDA MATRIX+$2E8,X
    STA $06E8,X
    INX                 ;Increment accumulator until 256 bytes read
    BNE DRAWSCRN

;Draw attributes from 256 bytes attribs table and place these to SCREEN RAM
    LDX #$00
PAINTCOLS
    LDY SCREEN_RAM,X    ;Read screen position
    LDA ATTRIBS,Y       ;Read attributes table
    STA $D800,X         ;Store to COLOUR RAM
    LDY SCREEN_RAM + $100,X         ;Read next 256 screen positions
    LDA ATTRIBS,Y       ;Store to COLOUR RAM + $100
    STA $D900,X         ;... and so on
    LDY SCREEN_RAM + $200,X
    LDA ATTRIBS,Y
    STA $DA00,X
    LDY $06E8,X
    LDA ATTRIBS,Y
    STA $DAE8,X
    INX                 ;Increment accumulator until 256 bytes read
    BNE PAINTCOLS

    JMP *               ;Infinite loop

;If using a cross assembler use CORRECT pseudo command,
;offset for importing binary data
*=$2000
incbin "charset.bin"

*=$2800
MATRIX
incbin "map_1.bin"

*=$2C00
ATTRIBS
incbin "cols.bin"

*=$3000
incbin "frog.spt",1,2, true
