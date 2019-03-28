SUB paint (x AS UBYTE,y AS UBYTE, width AS UBYTE, height AS UBYTE, attribute AS UBYTE)
    ' Copyleft Britlion. Feel free to use as you will. Please attribute me if you use this, however!
 
    ASM
    ld      a,(IX+7)   ;ypos
    rrca
    rrca
    rrca               ; Multiply by 32
    ld      l,a        ; Pass TO L
    AND     3          ; Mask with 00000011
    add     a,88       ; 88 * 256 = 22528 - start of attributes. Change this IF you are working with a buffer OR somesuch.
    ld      h,a        ; Put it in the High BYTE
    ld      a,l        ; We get y value *32
    AND     224        ; Mask with 11100000
    ld      l,a        ; Put it in L
    ld      a,(IX+5)   ; xpos 
    add     a,l        ; Add it TO the Low BYTE
    ld      l,a        ; Put it back in L, AND we're done. HL=Address.
    
    push HL            ; SAVE address
    LD A, (IX+13)      ; attribute
    LD DE,32
    LD c,(IX+11)       ; height
    
    BLPaintHeightLoop: 
    LD b,(IX+9)        ; width
    
    BLPaintWidthLoop:
    LD (HL),a          ; paint a character
    INC L              ; Move TO the right (Note that we only would have TO inc H IF we are crossing from the right edge TO the left, AND we shouldn't be needing to do that)
    DJNZ BLPaintWidthLoop
    
    BLPaintWidthExitLoop:
    POP HL             ; recover our left edge
    DEC C
    JR Z, BLPaintHeightExitLoop
    
    ADD HL,DE          ; move 32 down
    PUSH HL            ; SAVE it again
    JP BLPaintHeightLoop
 
    BLPaintHeightExitLoop:
    
    END ASM
END SUB
