PORTB = $6000   ; Port B of 6522
PORTA = $6001   ; Port A of 6522
DDRB =  $6002   ; Data Direction Register for Port B of 6522
DDRA =  $6003   ; Data Direction Register for Port A of 6522

    .org $8000          ; Start of ROM

reset:
        lda #%11111111  ; Set all pins on port B to output 
        sta DDRB
        
        lda #$50        ; Outputs 50 on B
        sta PORTB
loop:
    ror                 ; Shift bits right forever
    sta PORTB
    jmp loop

    .org $fffc          ; Reset vector
    .word reset
    .word $0000         ; Padding for EOF
